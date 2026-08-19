# Typst Carousel Gallery

Twenty-four square carousel templates for social media, written in [Typst](https://typst.app).
Each one is a single self-contained file that compiles to a six-slide deck, 21 by 21 centimetres, the canvas LinkedIn and Bluesky show without cropping.

**[Browse the gallery](https://m.canouil.dev/typst-carousel-gallery)**

## Using one

There is no package to install and nothing to import.
Copy the file, replace the project block at the top, and rewrite the slides.

```bash
curl -O https://raw.githubusercontent.com/mcanouil/typst-carousel-gallery/main/templates/editorial/drop-cap/carousel.typ
typst compile carousel.typ carousel.pdf
```

That one is [`templates/editorial/drop-cap/`](templates/editorial/drop-cap).
Every template's page on the site has a download link for the same file, a slide-by-slide viewer, and the full source with a copy button.

[Using a template](https://m.canouil.dev/typst-carousel-gallery/get-started.html) walks through it, and the [reference](https://m.canouil.dev/typst-carousel-gallery/reference.html) lists what every template shares.

The only part you have to change is the block at the top:

```typst
// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"
```

Swapping the eight colours under `// --- THEME ---` moves a deck onto a different palette without touching a slide.

## What is here

Every template sits in [`templates/`](templates), one directory per variant:

```text
templates/<family>/<variant>/
├── carousel.typ        # the template
├── carousel.pdf        # built, committed
├── preview.webp        # the six slides in one sprite, for the gallery cards
└── slides/
    └── slide-1.svg …   # six, built, committed
```

Around them:

| Path | What it holds |
| --- | --- |
| [`fonts/`](fonts) | Every font a template uses, vendored. |
| [`tools/`](tools) | [`build.sh`](tools/build.sh), [`lint-templates.sh`](tools/lint-templates.sh), [`fetch-fonts.sh`](tools/fetch-fonts.sh). |
| [`docs/`](docs) | The gallery website, and [`gallery.yml`](docs/gallery.yml), its catalogue. |
| [`assets/`](assets) | The placeholder screenshot the `screenshot` family frames. |

Eight families, three variants each.
A family is a visual system: what a slide is built out of.
A variant is one answer within that system.

| Family | The system |
| --- | --- |
| [`editorial`](templates/editorial) | Paper, a serif, and a single column. |
| [`terminal`](templates/terminal) | Shell chrome and monospace as the leading voice. |
| [`technical`](templates/technical) | Grids, rules, and measurement marks. |
| [`dataviz`](templates/dataviz) | A chart carries the slide. |
| [`panels`](templates/panels) | Content divided into cards or ruled rows. |
| [`control`](templates/control) | A user interface metaphor: switches, states, crosshairs. |
| [`poster`](templates/poster) | Display type and one large motif. |
| [`screenshot`](templates/screenshot) | Framed product shots as the evidence. |

All twenty-four announce the same fictional release, Acme Kit 2.1.0.
The words are held constant on purpose: the only thing that changes from one template to the next is the design, which is what makes them comparable.

## Fonts

Every font is committed under [`fonts/`](fonts) and passed with `--font-path`, so a clone renders the same output on any machine and continuous integration needs no font installation.
All are under the SIL Open Font License, and the licence text travels with the files in [`fonts/LICENCES/`](fonts/LICENCES).
[`fonts/README.md`](fonts/README.md) lists every family, where it came from, and which templates use it; [`fonts/fonts.tsv`](fonts/fonts.tsv) is the manifest [`fetch-fonts.sh`](tools/fetch-fonts.sh) reads.

Typst reports a missing family as a warning and still exits 0, so [`build.sh`](tools/build.sh) treats any Typst warning as a failure.
Without that check, a misspelt font name gives you a deck set in the wrong face and a green build.

## Building

```bash
bash tools/build.sh                              # all 24, PDF and SVG
bash tools/build.sh --png editorial/drop-cap     # one, with rasters to look at
bash tools/lint-templates.sh                     # check the shared contract
```

The build calls Typst through `quarto typst`, which is the same binary Quarto already ships, so a machine that can render the website needs nothing else installed.
A standalone `typst` is used instead when there is no Quarto.

Typst does everything except one step.
The build also writes `preview.webp` per template, the six slides side by side in one small raster, and that needs ImageMagick.
The gallery cards flip through it on hover: six full SVGs on every card would put 19 MB on the home page, where the whole set of sprites is 1.5 MB.

The website never builds a template for itself unless its artefacts are missing outright.
It cannot tell a stale artefact from a fresh one, because a clone stamps every file with the time it was checked out, so keeping the committed PDF, slides, and sprite current is the author's job.
[`lint-templates.sh`](tools/lint-templates.sh) is what checks that they are all there.

The lint checks the page geometry, the required bindings, the colours, that every visible URL is a clickable `#link()`, that every font is vendored, and that [`gallery.yml`](docs/gallery.yml) and the directories agree.

It cannot check that a slide looks right.
A clean compile only proves the page did not overflow: content inside a fixed-height block draws straight over the footer and still exits 0.
Read the six PNGs.

## Contributing

[CONTRIBUTING.md](CONTRIBUTING.md) carries the contract every template obeys: the file skeleton, the shared helper names, and the fixed rules.
It is short, and [`lint-templates.sh`](tools/lint-templates.sh) enforces most of it.

[CHANGELOG.md](CHANGELOG.md) records what each release changed.

## Licence

[MIT](LICENSE), except the fonts under [`fonts/`](fonts), which keep their own SIL Open Font License.
Each licence sits beside the family it covers, in [`fonts/LICENCES/`](fonts/LICENCES).

Cite this repository with [CITATION.cff](CITATION.cff).
