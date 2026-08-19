# Contributing

This repository holds carousel templates, one directory per template, each a single self-contained Typst file.

There is no shared library and no package to import.
A template is meant to be copied out and edited, so it must work on its own.
What holds the collection together is the contract below, and `tools/lint-templates.sh` enforces it.

## Layout

```text
templates/<family>/<variant>/
├── carousel.typ        # the template, self-contained
├── carousel.pdf        # built, committed
├── preview.webp        # the six slides in one sprite, for the gallery cards
└── slides/
    └── slide-1.svg …   # six, built, committed
```

A **family** is a visual system: what a slide is built out of.
A **variant** is one answer within that system.
Three variants of one family share the structure and the vocabulary, and differ in palette, type, and motif.

## The contract

### Fixed rules

These are not style preferences.
Each one protects legibility on a social feed, or the reader's ability to act on the deck.

- Page `21cm × 21cm`, margin `0cm`.
  This is the 1:1 canvas LinkedIn and Bluesky show without cropping.
  Pad inside slides with `inset:` or `block(width: …)`; never shrink the page.
- Six slides: a cover, four content slides, and a closing slide with the links.
- Body text 14 pt or larger.
  A slide has to read at about 250 px wide in a feed thumbnail.
  Cover headlines want 36 pt to 72 pt.
- No purple, lavender, violet, fuchsia, or magenta.
- Every visible URL is a clickable `#link()`.
  A bare URL in a PDF is dead text the reader has to retype.
- Fonts come from `fonts/` only.
  See `fonts/README.md` before reaching for a family that is not vendored.

### File skeleton

Every template follows this order, so a reader who knows one knows them all.

```typ
// <family>/<variant>: <one sentence on the visual angle>
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#…")   // page fill
#let paper = rgb("#…")    // light panel
#let ink = rgb("#…")      // body text
#let muted = rgb("#…")    // secondary text
#let hair = rgb("#…")     // rules and borders
#let accent = rgb("#…")   // the one accent
#let slab = rgb("#…")     // code background
#let slab-fg = rgb("#…")  // code foreground

#let display = "…"
#let body = "…"
#let mono = "…"

#set page(width: 21cm, height: 21cm, margin: 0cm, fill: ground)
#set text(font: body, fill: ink, size: 15.5pt)
#set raw(theme: none)
#show raw: set text(font: mono, ligatures: false)

// --- HELPERS ---

// --- SLIDES ---
```

All sixteen bindings are required, even when a template leans on only a few of them.
A reader adapting a template needs to find the same names in the same place every time, and the lint check enforces it.

### Shared helper names

Where a template implements one of these ideas, it uses this name and this signature.
The body is yours: that is where the visual identity lives.

```typ
#let url-link(url) = link("https://" + url, url)
#let kicker(txt, tint: accent) = …           // mono, upper case, tracked
#let chip(txt, tint: accent) = …             // small boxed label
#let code-slab(body, size: 13pt, tint: accent) = …
#let shot(path, width: 100%) = …             // framed screenshot
#let footer(n: none, total: 6) = …
#let slide(n: none, body) = …                // one page
```

A template needs no helper it does not use.
It must not rename one it does.

Two ways of writing `slide()` are both correct:

```typ
#let slide(n: none, body) = page(fill: ground)[…]                       // returns a page
#let slide(n: none, body) = { block(width: 100%, height: 100%)[…]; pagebreak(weak: true) }
```

The contract fixes the signature, not the mechanism.

### The placeholder subject

Every template announces the same fictional release, Acme Kit 2.1.0.
That is deliberate: the words are constant so the design is the only thing that changes between templates, which is what makes the gallery comparable.

`Acme` is a well-understood marker for a stand-in, so no reader mistakes it for a real project.
Links point at this repository, so no template ships a dead URL.
The `PROJECT` block is the only part a user has to rewrite to make the deck their own.

## Adding a variant

1. Pick the family it belongs to, and read the two variants already there.
   A new variant has to be recognisably the same system and clearly a different answer.
2. Create `templates/<family>/<variant>/carousel.typ` from the skeleton above.
3. State the visual angle in one sentence in the header comment before writing any slides.
   If you cannot state it, the slides will drift.
4. Build and check:

   ```bash
   bash tools/build.sh --png <family>/<variant>
   bash tools/lint-templates.sh <family>/<variant>
   ```

5. **Look at all six PNGs.**
   A clean compile only proves the page did not overflow.
   Content inside a fixed-height block draws straight over the footer and still exits 0, so read every slide: nothing clipped, nothing sitting on the footer rule, the cover legible small.
6. Add the entry to `docs/gallery.yml`.
   The `slug` is `<family>-<variant>`.
7. Commit the `.typ`, the `.pdf`, the `preview.webp`, and the six `.svg` files together.
   The site consumes the committed artefacts, so a template without them is invisible.

The build calls Typst through `quarto typst`, the copy [Quarto](https://quarto.org) already ships, and falls back to a standalone [Typst](https://typst.app) when there is no Quarto.
`preview.webp` alone also needs ImageMagick.

Commit the artefacts with the source.
The website builds a template only when its artefacts are missing outright: it cannot tell a stale one from a fresh one, because a clone stamps every file with the time it was checked out.

## Adding a family

A new family needs three variants to earn its place, and a system that none of the existing families already covers.
Open an issue describing the system first.

## Style

- British English throughout.
- One sentence per line in Markdown.
- No em dashes or en dashes.
- List items end with a full stop.
