# Fonts

Every font a template uses lives here.
Nothing comes from the system, so a clone renders the same output on any machine, and continuous integration needs no font installation step.

## How the build uses them

`tools/build.sh` passes:

```bash
typst compile --font-path fonts --ignore-system-fonts --ignore-embedded-fonts …
```

`--ignore-system-fonts` and `--ignore-embedded-fonts` make this directory the only source of type.
A font that is not here cannot be found by accident.

Typst reports a missing family as a **warning**, not an error, and still exits 0.
`tools/build.sh` therefore treats any Typst warning as a failure.
Without that check a misspelt family name produces a deck set in a fallback face and a green build.

## What is here

`fonts.tsv` is the manifest: family name, the directory it comes from in [google/fonts](https://github.com/google/fonts), and the files to fetch.
`tools/fetch-fonts.sh` reads it.
The fonts are committed, so that script only runs when a family is added or refreshed.

Variable fonts carry the whole weight axis in one file.
Typst reads the axis and honours `weight:` across its full range, so one file replaces a set of static weights.
Static families list only the weights a template names.
No italics are vendored, because no template uses one.

| Family | Files | Kind | Used by |
| --- | --- | --- | --- |
| Archivo | 1 | Variable, `wdth` and `wght` | `technical/blueprint`, `technical/graph-paper`, `panels/ledger`, `screenshot/film-strip` |
| Bangers | 1 | Static | `poster/pulp` |
| Comic Neue | 2 | Static | `poster/pulp` |
| EB Garamond | 1 | Variable, `wght` | `editorial/parchment` |
| Fira Code | 1 | Variable, `wght` | `technical/diagnostic`, `control/cascade`, `poster/prism`, `screenshot/film-strip` |
| Fira Sans | 3 | Static | `control/switchboard` |
| Fraunces | 1 | Variable, `SOFT`, `WONK`, `opsz`, `wght` | `poster/prism` |
| IBM Plex Mono | 3 | Static | `editorial/parchment`, `technical/graph-paper`, `panels/panel-grid`, `control/switchboard`, `poster/feed` |
| IBM Plex Sans | 1 | Variable, `wdth` and `wght` | `terminal/window`, `technical/graph-paper` |
| Inter | 1 | Variable, `opsz` and `wght` | `terminal/shell`, `technical/blueprint`, `technical/diagnostic`, `dataviz/sparkline`, `panels/panel-grid`, `control/crosshair`, `poster/feed`, `screenshot/browser` |
| JetBrains Mono | 1 | Variable, `wght` | `editorial/drop-cap`, `editorial/column`, `terminal/shell`, `terminal/mono`, `technical/blueprint`, `control/crosshair`, `screenshot/page-shot`, `screenshot/browser` |
| Lato | 3 | Static | `editorial/parchment`, `control/cascade`, `screenshot/film-strip` |
| Libre Baskerville | 1 | Variable, `wght` | `editorial/column` |
| Public Sans | 1 | Variable, `wght` | `dataviz/ridgeline`, `dataviz/figure-grid` |
| Sora | 1 | Variable, `wght` | `dataviz/ridgeline` |
| Source Sans 3 | 1 | Variable, `wght` | `editorial/drop-cap`, `screenshot/page-shot` |
| Source Serif 4 | 1 | Variable, `opsz` and `wght` | `editorial/drop-cap`, `screenshot/page-shot` |
| Space Grotesk | 1 | Variable, `wght` | `dataviz/sparkline`, `panels/panel-grid`, `poster/feed`, `screenshot/browser` |
| Space Mono | 2 | Static | `dataviz/sparkline`, `dataviz/ridgeline`, `dataviz/figure-grid`, `panels/ledger`, `poster/pulp` |
| Work Sans | 1 | Variable, `wght` | `panels/card-stack`, `poster/prism` |

## Licences

Every family here is under the SIL Open Font License 1.1, which allows redistribution inside a repository as long as the licence text travels with the files.
`LICENCES/` holds one verbatim copy per family, fetched from the same upstream directory as the font.

Two fonts the design corpus originally used are **not** here and must never be added.
Georgia and Baskerville are proprietary system faces that cannot be redistributed.
The open substitutes are Source Serif 4 and Libre Baskerville.

## Adding a family

1. Confirm the licence at the upstream source.
   Only the SIL Open Font License or Apache 2.0 are acceptable.
2. Add a row to `fonts.tsv`.
3. Run `bash tools/fetch-fonts.sh "<Family>"`.
4. Add the family to the table above, naming the templates that use it.
5. Commit the font files and the licence together.

Ship only the weights a template names.
A family that needs Regular and Bold gets two files, not a nine-weight set.
Prefer the variable file where the family offers one.
