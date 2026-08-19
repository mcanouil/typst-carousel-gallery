#!/usr/bin/env bash
# build.sh [--png] [<family>/<variant> | <family> …]
# Compile carousel templates to PDF and per-slide SVG with Typst.
#
# With no template argument, every template is built.
# A family name alone builds every variant in that family.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
templates_root="${repo_root}/templates"

SLIDE_COUNT=6

want_png=false
targets=()

while [[ $# -gt 0 ]]; do
	case "$1" in
	--png)
		want_png=true
		shift
		;;
	-h | --help)
		sed -n '2,6p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
		exit 0
		;;
	-*)
		echo "error: unknown option $1" >&2
		exit 2
		;;
	*)
		targets+=("${1%/}")
		shift
		;;
	esac
done

# Quarto ships Typst, so `quarto typst` is preferred over a separate install:
# it is the same binary and the same version, and it is already there on any
# machine that can render the website, including the CI runner, which has no
# standalone typst on PATH. A standalone typst is the fallback for anyone who
# has that and not Quarto.
TYPST=()
if command -v quarto >/dev/null 2>&1; then
	TYPST=(quarto typst)
elif command -v typst >/dev/null 2>&1; then
	TYPST=(typst)
else
	echo "error: neither quarto nor typst on PATH (brew install quarto)" >&2
	exit 127
fi

# Only the card sprite needs it; everything else is Typst alone.
if ! command -v magick >/dev/null 2>&1; then
	echo "error: magick not on PATH (brew install imagemagick), needed for the card previews" >&2
	exit 127
fi

# Resolve the targets to a list of <family>/<variant> paths.
resolve_targets() {
	local target dir
	if [[ ${#targets[@]} -eq 0 ]]; then
		find "${templates_root}" -mindepth 2 -maxdepth 2 -type d | sort
		return
	fi
	for target in "${targets[@]}"; do
		dir="${templates_root}/${target}"
		if [[ ! -d ${dir} ]]; then
			echo "error: no such template or family: ${target}" >&2
			return 1
		fi
		if [[ -f "${dir}/carousel.typ" ]]; then
			printf '%s\n' "${dir}"
		else
			find "${dir}" -mindepth 1 -maxdepth 1 -type d | sort
		fi
	done
}

# Typst reports a missing font family as a warning and still exits 0, so a
# silent fallback would otherwise pass the build. Any warning fails here.
run_typst() {
	local log status
	log="$(mktemp)"
	set +e
	"${TYPST[@]}" compile \
		--root "${repo_root}" \
		--font-path "${repo_root}/fonts" \
		--ignore-system-fonts \
		--ignore-embedded-fonts \
		"$@" 2>"${log}"
	status=$?
	set -e
	if [[ ${status} -ne 0 ]] || grep -q 'warning:' "${log}"; then
		cat "${log}" >&2
		rm -f "${log}"
		return 1
	fi
	rm -f "${log}"
}

build_one() {
	local dir="$1"
	local slug="${dir#"${templates_root}"/}"
	local src="${dir}/carousel.typ"
	local slides="${dir}/slides"

	if [[ ! -f ${src} ]]; then
		echo "error: missing ${src}" >&2
		return 1
	fi

	rm -rf "${slides}"
	mkdir -p "${slides}"

	run_typst "${src}" "${dir}/carousel.pdf"
	run_typst --format svg "${src}" "${slides}/slide-{p}.svg"
	if [[ ${want_png} == true ]]; then
		run_typst --format png --ppi 144 "${src}" "${slides}/slide-{p}.png"
	fi

	local count
	count=$(find "${slides}" -name 'slide-*.svg' | wc -l | tr -d ' ')
	if [[ ${count} -ne ${SLIDE_COUNT} ]]; then
		echo "error: ${slug} produced ${count} slides, expected ${SLIDE_COUNT}" >&2
		return 1
	fi

	build_preview "${dir}" || return 1

	echo "built: ${slug} (${count} slides)"
}

# The sprite sheet the gallery cards animate on hover: the six slides in one
# row, as a single small raster.
#
# This is the one part of the build that is not Typst. The slides themselves
# stay vector, and the sprite exists only so the website can flip through a deck
# in a 240 px card without loading six full SVGs, which would put 19 MB on the
# home page. At this size the type is illegible by design; the card shows the
# shape of a deck, not its words.
build_preview() {
	local dir="$1"
	local src="${dir}/carousel.typ"
	local frames="${dir}/.frames"

	rm -rf "${frames}"
	mkdir -p "${frames}"
	# 58 dpi over a 21 cm page gives 480 px, twice the card's display width.
	run_typst --format png --ppi 58 "${src}" "${frames}/frame-{p}.png" || {
		rm -rf "${frames}"
		return 1
	}

	local list=()
	local index
	for index in $(seq 1 "${SLIDE_COUNT}"); do
		list+=("${frames}/frame-${index}.png")
	done

	magick "${list[@]}" +append -quality 82 -define webp:method=6 "${dir}/preview.webp"
	rm -rf "${frames}"
}

failures=0
while IFS= read -r dir; do
	[[ -n ${dir} ]] || continue
	if ! build_one "${dir}"; then
		failures=$((failures + 1))
	fi
done < <(resolve_targets)

if [[ ${failures} -gt 0 ]]; then
	echo "${failures} template(s) failed to build" >&2
	exit 1
fi
