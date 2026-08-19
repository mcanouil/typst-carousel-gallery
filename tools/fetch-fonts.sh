#!/usr/bin/env bash
# fetch-fonts.sh [family …]
# Download the vendored fonts listed in fonts/fonts.tsv from github.com/google/fonts.
#
# The fonts are committed to this repository, so this script is only needed to
# add a family or to refresh one. A normal build never runs it.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
fonts_dir="${repo_root}/fonts"
manifest="${fonts_dir}/fonts.tsv"
licences_dir="${fonts_dir}/LICENCES"
base_url="https://raw.githubusercontent.com/google/fonts/main/ofl"

if [[ ! -f ${manifest} ]]; then
	echo "error: missing ${manifest}" >&2
	exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
	echo "error: curl not on PATH" >&2
	exit 127
fi

# Percent-encode the characters google/fonts uses in variable font names.
url_escape() {
	local s="$1"
	s="${s//\[/%5B}"
	s="${s//\]/%5D}"
	printf '%s' "${s}"
}

fetch() {
	local url="$1" dest="$2" code
	code=$(curl -sS -L -o "${dest}" -w '%{http_code}' "${url}")
	if [[ ${code} != "200" ]]; then
		rm -f "${dest}"
		echo "error: HTTP ${code} for ${url}" >&2
		return 1
	fi
}

wanted=("$@")

want_family() {
	local family="$1" w
	if [[ ${#wanted[@]} -eq 0 ]]; then
		return 0
	fi
	for w in "${wanted[@]}"; do
		if [[ ${w} == "${family}" ]]; then
			return 0
		fi
	done
	return 1
}

mkdir -p "${licences_dir}"
count=0

while IFS=$'\t' read -r family source files; do
	case "${family}" in
	'' | '#'*) continue ;;
	esac

	want_family "${family}" || continue

	family_dir="${fonts_dir}/${family}"
	mkdir -p "${family_dir}"

	IFS=';' read -r -a file_list <<<"${files}"
	for file in "${file_list[@]}"; do
		echo "fetching ${family}/${file}"
		fetch "${base_url}/${source}/$(url_escape "${file}")" "${family_dir}/${file}"
		count=$((count + 1))
	done

	echo "fetching licence for ${family}"
	fetch "${base_url}/${source}/OFL.txt" "${licences_dir}/${family}.txt"
done <"${manifest}"

if [[ ${count} -eq 0 ]]; then
	echo "error: no family matched ${wanted[*]}" >&2
	exit 1
fi

echo "fetched ${count} font files into ${fonts_dir}"
