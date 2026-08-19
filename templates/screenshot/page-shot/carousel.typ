// screenshot/page-shot: a document band across the top, framed page shots as the evidence.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#f7f5f0") // page fill
#let paper = rgb("#ffffff") // light panel
#let ink = rgb("#1d1f24") // body text
#let muted = rgb("#6b6f78") // secondary text
#let hair = rgb("#d9d5cc") // rules and borders
#let accent = rgb("#1d5c9e") // the one accent
#let slab = rgb("#1d1f24") // code background
#let slab-fg = rgb("#f7f5f0") // code foreground

#let display = "Source Serif 4"
#let body = "Source Sans 3"
#let mono = "JetBrains Mono"

#set page(width: 21cm, height: 21cm, margin: 0cm, fill: ground)
#set text(font: body, fill: ink, size: 15pt)
#set raw(theme: none)
// Ligatures off: a code font that draws `&&` or `!=` as one merged glyph is
// unreadable at slide sizes.
#show raw: set text(font: mono, ligatures: false)

// --- HELPERS ---

#let url-link(url) = link("https://" + url, url)

#let kicker(txt, tint: accent) = text(
  font: mono,
  size: 10pt,
  weight: 600,
  fill: tint,
  tracking: 1.8pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  fill: tint.lighten(88%),
  stroke: 0.7pt + tint.lighten(45%),
  radius: 2pt,
  inset: (x: 7pt, y: 4pt),
  text(font: mono, size: 10pt, weight: 600, fill: tint, txt),
)

#let code-slab(body, size: 12.5pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  radius: 2pt,
  inset: (x: 0.65cm, y: 0.55cm),
  stroke: (left: 3pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

// The framed shot. Replace the placeholder path with your own PNG, dropped
// beside this file and referenced as image("screenshot.png").
#let shot(path, width: 100%) = block(
  clip: true,
  radius: 2pt,
  stroke: 1pt + hair.darken(8%),
  image(path, width: width),
)

// A shot with a caption under it, the deck's evidence unit.
#let page-shot(path, caption, width: 100%) = block(width: width)[
  #shot(path)
  #v(0.22cm)
  #text(font: mono, size: 9.5pt, fill: muted)[#caption]
]

// The band across the top: the section, a label, and the slide number, set in a
// tinted strip so every slide is filed.
#let band(section, label, n) = place(top + left, block(
  width: 21cm,
  fill: accent,
  inset: (x: 1.7cm, y: 0.42cm),
)[
  #grid(
    columns: (auto, 1fr, auto),
    column-gutter: 0.6cm,
    text(font: mono, size: 9.5pt, weight: 600, fill: ground, tracking: 1.4pt)[#upper(section)],
    text(font: mono, size: 9.5pt, fill: ground.transparentize(25%))[#label],
    text(font: mono, size: 9.5pt, fill: ground)[#n / 6],
  )
])

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.7cm,
  dy: -1.15cm,
  block(width: 17.6cm)[
    #line(length: 100%, stroke: 0.8pt + hair)
    #v(0.28cm)
    #grid(
      columns: (1fr, auto),
      text(font: mono, size: 9pt, fill: muted)[
        #url-link("github.com/mcanouil/typst-carousel-gallery")
      ],
      text(font: mono, size: 9pt, fill: muted)[#project #version #sym.dot.op #date],
    )
  ],
)

#let heading-1(txt) = text(font: display, size: 32pt, weight: 700, fill: ink, txt)

#let slide(n: none, section: "", label: "", body) = page(fill: ground)[
  #band(section, label, n)
  #place(top + left, dx: 1.7cm, dy: 2.6cm, block(width: 17.6cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #band("Release", project + " " + version, 1)
  // Top-anchored rather than centred: a centred hero and a shot pinned to the
  // foot of the page overlap, and Typst reports nothing when they do.
  #place(
    top + left,
    dx: 1.7cm,
    dy: 2.8cm,
    block(width: 17.6cm)[
      #kicker("Release")
      #v(0.5cm)
      #text(font: display, size: 66pt, weight: 700, fill: ink)[#project]
      #v(0.05cm)
      #text(font: mono, size: 26pt, weight: 600, fill: accent)[#version]
      #v(0.55cm)
      #block(width: 8.6cm, text(size: 16pt, fill: muted)[
        Build every report from one command, in whatever format the reader
        asked for.
      ])
    ],
  )
  #place(bottom + right, dx: -1.7cm, dy: -2.5cm, page-shot(
    "/assets/placeholder-shot.svg",
    "The report, built from the release profile.",
    width: 8.6cm,
  ))
  #footer(n: 1)
]

// 02 The gap
#slide(n: 2, section: "The gap", label: "before")[
  #heading-1[Six scripts, four formats, one deadline.]
  #v(0.5cm)
  #block(width: 15.5cm, text(size: 15.5pt)[
    Every project grows its own build script, and then a second one for the
    slides, and a third for the print version. They drift. The one that matters
    is always the one nobody ran.
  ])
  #v(0.5cm)
  #line(length: 100%, stroke: 0.8pt + hair)
  #v(0.4cm)
  #block(width: 15.5cm, text(size: 15.5pt, fill: accent)[
    A build is a fact about a project, not a habit of the person who last
    shipped it.
  ])
]

// 03 The mechanic
#slide(n: 3, section: "How it works", label: "acme.yml")[
  #heading-1[One command, every target.]
  #v(0.45cm)
  #block(width: 16cm, text(size: 15pt, fill: muted)[
    Declare the targets once. #project reads them, builds only what changed, and
    writes each one where it belongs.
  ])
  #v(0.45cm)
  #code-slab[
    ```yaml
    targets:
      report:  {format: pdf,  profile: release}
      slides:  {format: html, profile: talk}
      archive: {format: docx, profile: release}
    ```
  ]
  #v(0.35cm)
  #code-slab[
    ```bash
    acme build --profile release
    ```
  ]
]

// 04 The evidence
#slide(n: 4, section: "The output", label: "two targets, one source")[
  #heading-1[The same numbers, twice.]
  #v(0.5cm)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 0.6cm,
    page-shot("/assets/placeholder-shot.svg", "report.pdf, release profile."),
    page-shot("/assets/placeholder-shot.svg", "slides.html, talk profile."),
  )
  #v(0.45cm)
  #block(width: 16cm, text(size: 14pt, fill: muted)[
    Two targets, one set of numbers. The slides cannot fall behind the
    manuscript, because neither is built by hand.
  ])
]

// 05 What changed
#slide(n: 5, section: "In " + version, label: "changelog")[
  #heading-1[What changed.]
  #v(0.55cm)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.45cm,
    row-gutter: 0.5cm,
    chip("new"),
    text(size: 14pt)[
      Profiles. One target set, several build shapes, no duplicated
      configuration.
    ],
    chip("new"),
    text(size: 14pt)[
      Incremental builds. Only the targets whose inputs moved are rebuilt.
    ],
    chip("fixed"),
    text(size: 14pt)[
      Relative paths now resolve from the project root on every platform.
    ],
  )
  #v(0.55cm)
  #line(length: 100%, stroke: 0.8pt + hair)
  #v(0.4cm)
  #block(width: 16cm, text(size: 14pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: slab)[
  #place(top + left, block(width: 21cm, fill: accent, inset: (x: 1.7cm, y: 0.42cm))[
    #grid(
      columns: (auto, 1fr, auto),
      column-gutter: 0.6cm,
      text(font: mono, size: 9.5pt, weight: 600, fill: ground, tracking: 1.4pt)[#upper("Get it")],
      text(font: mono, size: 9.5pt, fill: ground.transparentize(25%))[install],
      text(font: mono, size: 9.5pt, fill: ground)[6 / 6],
    )
  ])
  #place(
    left + horizon,
    dx: 1.7cm,
    block(width: 17.6cm)[
      #text(font: mono, size: 10pt, weight: 600, fill: accent.lighten(45%), tracking: 1.8pt)[
        #upper("Get it")
      ]
      #v(0.5cm)
      #text(font: display, size: 42pt, weight: 700, fill: ground)[Install and build.]
      #v(0.65cm)
      #block(
        width: 100%,
        fill: ground,
        radius: 2pt,
        inset: (x: 0.65cm, y: 0.55cm),
        stroke: (left: 3pt + accent),
        text(font: mono, size: 13.5pt, fill: ink)[
          ```bash
          brew install acme-kit && acme init
          ```
        ],
      )
      #v(0.7cm)
      #text(size: 15pt, fill: hair)[
        Source, documentation, and every template in this gallery:
      ]
      #v(0.2cm)
      #text(font: mono, size: 13.5pt, weight: 600, fill: accent.lighten(45%))[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #place(
    bottom + left,
    dx: 1.7cm,
    dy: -1.15cm,
    block(width: 17.6cm)[
      #line(length: 100%, stroke: 0.8pt + muted)
      #v(0.28cm)
      #grid(
        columns: (1fr, auto),
        text(font: mono, size: 9pt, fill: hair)[#date],
        text(font: mono, size: 9pt, fill: hair)[#project #version],
      )
    ],
  )
]
