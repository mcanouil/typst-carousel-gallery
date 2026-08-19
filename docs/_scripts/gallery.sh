#!/usr/bin/env bash
#
# Gallery Pre-render Step
# Stages the built carousel artefacts into docs/assets/ and generates one viewer
# page per template from docs/gallery.yml.
#
# @license MIT License
# @copyright 2026 Mickaël Canouil
# @author Mickaël Canouil
#
# Everything this script writes is ignored by Git and removed by post-render.sh.
# The source of truth is templates/<family>/<variant>/, whose PDF and SVG files
# are committed, so a render needs no Typst. A template whose .typ is newer than
# its PDF is rebuilt first, which only happens while authoring.
#
# gallery.yml and slide-alt.yml are read with a flat parser rather than a YAML
# library, because the render must not depend on one being installed. Both files
# say so, and both are restricted to single-line scalars for that reason.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS_DIR="$(dirname "${SCRIPT_DIR}")"
ROOT_DIR="$(dirname "${DOCS_DIR}")"

CATALOGUE="${DOCS_DIR}/gallery.yml"
ALT_FILE="${DOCS_DIR}/slide-alt.yml"
TEMPLATES_DIR="${ROOT_DIR}/templates"
PAGES_DIR="${DOCS_DIR}/templates"
SLIDES_DIR="${DOCS_DIR}/assets/slides"
PDF_DIR="${DOCS_DIR}/assets/pdf"
TYP_DIR="${DOCS_DIR}/assets/typ"
PREVIEW_DIR="${DOCS_DIR}/assets/previews"

SLIDE_COUNT=6

if [[ ! -f ${CATALOGUE} ]]; then
	printf '[gallery] No gallery.yml; nothing to stage\n'
	exit 0
fi

# Read the value of `key` from the entry whose slug is `slug`. Entries are
# separated by the `- slug:` line that opens each one.
entry_value() {
	local slug="$1" key="$2"
	awk -v slug="${slug}" -v key="${key}" '
		$0 ~ /^- slug: / { current = $3 }
		current == slug && $1 == key ":" {
			sub(/^[[:space:]]*[^:]+:[[:space:]]*/, "")
			gsub(/^"|"$/, "")
			print
			exit
		}
	' "${CATALOGUE}"
}

alt_for_slide() {
	local number="$1"
	awk -v number="${number}" '
		$0 ~ /^- slide: / { current = $3 }
		current == number && $1 == "alt:" {
			sub(/^[[:space:]]*alt:[[:space:]]*/, "")
			gsub(/^"|"$/, "")
			print
			exit
		}
	' "${ALT_FILE}"
}

# Escape the characters that would break out of an HTML attribute.
html_escape() {
	printf '%s' "$1" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' -e 's/"/\&quot;/g'
}

rm -rf "${PAGES_DIR}" "${SLIDES_DIR}" "${PDF_DIR}" "${TYP_DIR}" "${PREVIEW_DIR}"
mkdir -p "${PAGES_DIR}" "${SLIDES_DIR}" "${PDF_DIR}" "${TYP_DIR}" "${PREVIEW_DIR}"

staged=0

while IFS= read -r slug; do
	family="${slug%%-*}"
	variant="${slug#*-}"
	template_dir="${TEMPLATES_DIR}/${family}/${variant}"
	source_typ="${template_dir}/carousel.typ"
	source_pdf="${template_dir}/carousel.pdf"

	if [[ ! -f ${source_typ} ]]; then
		printf '[gallery] gallery.yml lists %s, but %s does not exist\n' "${slug}" "${source_typ}" >&2
		exit 1
	fi

	# Build only what is genuinely absent.
	#
	# This used to rebuild when carousel.typ was newer than carousel.pdf, which
	# is wrong anywhere the tree came from a fresh clone: a checkout stamps every
	# file with the time it was written, in no useful order, so the source is as
	# likely to look newer than the artefact as not. That fired on CI and failed
	# the render. Modification times say nothing about a checkout, so the only
	# question worth asking here is whether the file exists.
	#
	# Keeping the committed artefacts current is the author's job, and
	# tools/lint-templates.sh is what checks it.
	if [[ ! -f ${source_pdf} || ! -f "${template_dir}/preview.webp" ]]; then
		printf '[gallery] %s has no built artefacts, building\n' "${slug}"
		bash "${ROOT_DIR}/tools/build.sh" "${family}/${variant}"
	fi

	mkdir -p "${SLIDES_DIR}/${slug}"
	cp "${template_dir}"/slides/slide-*.svg "${SLIDES_DIR}/${slug}/"
	cp "${source_pdf}" "${PDF_DIR}/${slug}.pdf"
	cp "${source_typ}" "${TYP_DIR}/${slug}.typ"
	cp "${template_dir}/preview.webp" "${PREVIEW_DIR}/${slug}.webp"

	title="$(entry_value "${slug}" title)"
	angle="$(entry_value "${slug}" angle)"
	fonts="$(entry_value "${slug}" fonts)"
	palette="$(entry_value "${slug}" palette)"
	description="$(entry_value "${slug}" description)"

	{
		printf -- '---\n'
		printf 'title: "%s"\n' "${title}"
		printf 'subtitle: "%s"\n' "${angle}"
		printf 'description: "%s"\n' "${angle}"
		printf 'toc: false\n'
		printf -- '---\n\n'

		printf '::: {.carousel data-slides="%d"}\n' "${SLIDE_COUNT}"
		printf '::: {.carousel-stage}\n'
		for slide in $(seq 1 "${SLIDE_COUNT}"); do
			printf '<img class="carousel-slide" src="/assets/slides/%s/slide-%d.svg" alt="%s" loading="lazy">\n' \
				"${slug}" "${slide}" "$(html_escape "$(alt_for_slide "${slide}")")"
		done
		printf ':::\n'

		# The controls are hidden until carousel.js marks the container ready, so
		# a page with no JavaScript shows all six slides stacked instead of a set
		# of buttons that do nothing.
		printf '::: {.carousel-controls}\n'
		printf '<button type="button" class="carousel-previous" aria-label="Previous slide">&#8249;</button>\n'
		printf '<p class="carousel-status" aria-live="polite" aria-atomic="true">Slide 1 of %d</p>\n' "${SLIDE_COUNT}"
		printf '<button type="button" class="carousel-next" aria-label="Next slide">&#8250;</button>\n'
		printf ':::\n'
		printf ':::\n\n'

		# One raw HTML block, not a div fence with Markdown links inside it.
		# Pandoc wraps loose links in a paragraph, which would leave the flex row
		# with two children, a bare button and a <p> holding both links, and the
		# button would align against the paragraph box rather than against the
		# links. Writing the three controls as siblings makes them flex items.
		printf '```{=html}\n'
		printf '<div class="carousel-actions">\n'
		printf '<button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#source-%s">View source</button>\n' "${slug}"
		printf '<a class="btn btn-sm btn-outline-secondary" href="/assets/typ/%s.typ" download="carousel.typ">Download the Typst file</a>\n' "${slug}"
		printf '<a class="btn btn-sm btn-outline-secondary" href="/assets/pdf/%s.pdf" download="%s.pdf">Download the PDF</a>\n' "${slug}" "${slug}"
		printf '</div>\n'
		printf '```\n\n'

		printf '## About this template\n\n'
		printf '%s\n\n' "${description}"
		printf '| | |\n|---|---|\n'
		printf '| Fonts | %s |\n' "${fonts}"
		printf '| Palette | %s |\n' "${palette}"
		# shellcheck disable=SC2016 # The backticks are Markdown code spans, not command substitution.
		printf '| Source | `templates/%s/%s/carousel.typ` |\n\n' "${family}" "${variant}"
		# shellcheck disable=SC2016 # As above.
		printf 'Replace the `PROJECT` block at the top of the file with your own project, version, repository, and date.\n'
		printf 'Everything else is layout you can keep or rework.\n'
		printf 'The [reference](../reference.qmd) explains the parts every template shares.\n\n'

		# A hand-written Bootstrap modal. Quarto bundles Bootstrap's JavaScript
		# with the HTML format, and attaches its own copy button to every code
		# block on the page, including one inside a modal.
		printf '::: {#source-%s .modal .fade tabindex="-1" aria-labelledby="source-%s-title" aria-hidden="true"}\n' "${slug}" "${slug}"
		printf '::: {.modal-dialog .modal-lg .modal-dialog-scrollable}\n'
		printf '::: {.modal-content}\n'
		printf '::: {.modal-header}\n'
		printf '<h2 class="modal-title fs-5" id="source-%s-title">carousel.typ</h2>\n' "${slug}"
		printf '<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>\n'
		printf ':::\n'
		printf '::: {.modal-body}\n'
		printf '```typst\n'
		cat "${source_typ}"
		printf '```\n'
		printf ':::\n'
		printf ':::\n'
		printf ':::\n'
		printf ':::\n'
	} >"${PAGES_DIR}/${slug}.qmd"

	staged=$((staged + 1))
done < <(sed -n 's/^- slug: //p' "${CATALOGUE}")

printf '[gallery] staged %d template(s) into docs/assets and docs/templates\n' "${staged}"
