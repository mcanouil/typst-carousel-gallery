#!/usr/bin/env bash
# lint-templates.sh [<family>/<variant> | <family> …]
# Check every template against the contract in CONTRIBUTING.md.
#
# With no argument, every template is checked.
# Exits 1 if any check fails.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
templates_root="${repo_root}/templates"
catalogue="${repo_root}/docs/gallery.yml"

SLIDE_COUNT=6

REQUIRED_LETS=(project version repo-url date ground paper ink muted hair accent slab slab-fg display body mono)

targets=()
for arg in "$@"; do
	targets+=("${arg%/}")
done

failures=0
current=""

fail() {
	echo "  FAIL  ${current}: $1" >&2
	failures=$((failures + 1))
}

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

# Hue of a #rrggbb colour, 0-359, or -1 when the colour is neutral enough that
# hue carries no meaning.
#
# The banned band is 250-340: violet sits at 258, purple and magenta near 300,
# pink near 330. Indigo at 239 and blue at 217 pass, and so do crimson and rose
# at 348, which wrap past red rather than into pink.
hue_of() {
	local hex="${1#\#}"
	# The hex is decoded here because the awk on macOS has no strtonum().
	local red green blue
	red=$((16#${hex:0:2}))
	green=$((16#${hex:2:2}))
	blue=$((16#${hex:4:2}))
	awk -v red="${red}" -v green="${green}" -v blue="${blue}" 'BEGIN {
		r = red / 255
		g = green / 255
		b = blue / 255
		max = (r > g ? (r > b ? r : b) : (g > b ? g : b))
		min = (r < g ? (r < b ? r : b) : (g < b ? g : b))
		d = max - min
		if (d < 0.08 || max < 0.12) { print -1; exit }
		if (max == r) { h = 60 * (((g - b) / d) % 6) }
		else if (max == g) { h = 60 * (((b - r) / d) + 2) }
		else { h = 60 * (((r - g) / d) + 4) }
		if (h < 0) { h += 360 }
		printf "%d\n", h
	}'
}

check_geometry() {
	local src="$1"
	if ! grep -q '#set page(width: 21cm, height: 21cm, margin: 0cm' "${src}"; then
		fail "missing the '#set page(width: 21cm, height: 21cm, margin: 0cm' line"
	fi
}

check_document() {
	local src="$1"
	if ! grep -q '#set document(title:.*author:' "${src}"; then
		fail "missing '#set document(title: …, author: …)'"
	fi
}

check_lets() {
	local src="$1" name
	for name in "${REQUIRED_LETS[@]}"; do
		if ! grep -qE "^#let ${name} +=" "${src}"; then
			fail "missing binding '#let ${name} = …'"
		fi
	done
}

check_colours() {
	local src="$1" hex hue
	while IFS= read -r hex; do
		hue=$(hue_of "${hex}")
		if [[ ${hue} -ge 250 && ${hue} -le 340 ]]; then
			fail "purple-ish colour ${hex} (hue ${hue})"
		fi
	done < <(grep -oE 'rgb\("#[0-9a-fA-F]{6}"\)' "${src}" | grep -oE '#[0-9a-fA-F]{6}' | sort -u)
}

# Every visible URL must be clickable. A link() call whose URL sits on the next
# source line is legal, so a line also passes when the line above opens one.
check_links() {
	local src="$1" line number previous=""
	while IFS= read -r number; do
		line=$(sed -n "${number}p" "${src}")
		previous=$(sed -n "$((number - 1))p" "${src}")
		if [[ ${line} == *"link("* || ${previous} == *"link("* ]]; then
			continue
		fi
		# A URL bound to a `#let …-url` constant is fed to #link() elsewhere.
		if [[ ${line} =~ ^#let\ [a-z-]*url\ += ]]; then
			continue
		fi
		# An explicit, reviewable exemption for a URL this check cannot follow:
		# one passed to a helper that wraps it in #link() itself. The comment
		# has to name why, so a suppression is never silent.
		if [[ ${previous} == *"lint-ok: url"* ]]; then
			continue
		fi
		fail "bare URL on line ${number}, wrap it in #link() or url-link()"
	done < <(grep -nE 'https?://|[a-z0-9.-]+\.(dev|app|io|com|fr|org)/' "${src}" | grep -v '^[0-9]*:[[:space:]]*//' | cut -d: -f1)
}

check_fonts() {
	local src="$1" family
	while IFS= read -r family; do
		if ! printf '%s\n' "${available_fonts}" | grep -qxF "${family}"; then
			fail "font '${family}' is not vendored in fonts/"
		fi
	done < <(grep -E '^#let (display|body|mono) +=' "${src}" | grep -oE '"[^"]+"' | tr -d '"' | sort -u)
}

check_slides() {
	local dir="$1" count
	if [[ ! -d "${dir}/slides" ]]; then
		fail "no slides/ directory, run tools/build.sh first"
		return
	fi
	count=$(find "${dir}/slides" -name 'slide-*.svg' | wc -l | tr -d ' ')
	if [[ ${count} -ne ${SLIDE_COUNT} ]]; then
		fail "${count} built slides, expected ${SLIDE_COUNT}"
	fi
	if [[ ! -f "${dir}/carousel.pdf" ]]; then
		fail "no carousel.pdf, run tools/build.sh"
	fi
	# The gallery cards need it, and the website will not build one for itself.
	if [[ ! -f "${dir}/preview.webp" ]]; then
		fail "no preview.webp, run tools/build.sh"
	fi
}

check_catalogue() {
	local slug="${1//\//-}"
	if [[ ! -f ${catalogue} ]]; then
		return
	fi
	if ! grep -qE "^ *- slug: ${slug}\$" "${catalogue}"; then
		fail "not listed in docs/gallery.yml as 'slug: ${slug}'"
	fi
}

check_orphan_entries() {
	local slug dir
	[[ -f ${catalogue} ]] || return 0
	while IFS= read -r slug; do
		dir="${templates_root}/${slug%%-*}/${slug#*-}"
		if [[ ! -d ${dir} ]]; then
			echo "  FAIL  docs/gallery.yml: entry '${slug}' has no template directory" >&2
			failures=$((failures + 1))
		fi
	done < <(grep -oE '^ *- slug: .+$' "${catalogue}" | sed 's/.*slug: //')
}

if ! command -v typst >/dev/null 2>&1; then
	echo "error: typst not on PATH (brew install typst)" >&2
	exit 127
fi

available_fonts=$(typst fonts --font-path "${repo_root}/fonts" --ignore-system-fonts --ignore-embedded-fonts)

while IFS= read -r dir; do
	[[ -n ${dir} ]] || continue
	current="${dir#"${templates_root}"/}"
	src="${dir}/carousel.typ"

	if [[ ! -f ${src} ]]; then
		fail "missing carousel.typ"
		continue
	fi

	check_geometry "${src}"
	check_document "${src}"
	check_lets "${src}"
	check_colours "${src}"
	check_links "${src}"
	check_fonts "${src}"
	check_slides "${dir}"
	check_catalogue "${current}"

	echo "checked: ${current}"
done < <(resolve_targets)

if [[ ${#targets[@]} -eq 0 ]]; then
	current="catalogue"
	check_orphan_entries
fi

if [[ ${failures} -gt 0 ]]; then
	echo "${failures} check(s) failed" >&2
	exit 1
fi

echo "all checks passed"
