// technical/blueprint: a drawing board in deep blue, with a grid, tick marks, and a title block.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#0d2a45") // page fill
#let paper = rgb("#12395c") // light panel
#let ink = rgb("#e6f1fa") // body text
#let muted = rgb("#7fa4c4") // secondary text
#let hair = rgb("#1d4468") // rules and borders
#let accent = rgb("#54d1f5") // the one accent
#let slab = rgb("#071c2f") // code background
#let slab-fg = rgb("#d8ecf8") // code foreground

#let display = "Archivo"
#let body = "Inter"
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
  size: 10.5pt,
  weight: 700,
  fill: tint,
  tracking: 2.4pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  stroke: 0.8pt + tint,
  inset: (x: 7pt, y: 4pt),
  text(font: mono, size: 10pt, weight: 600, fill: tint, txt),
)

#let code-slab(body, size: 13pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  inset: (x: 0.65cm, y: 0.55cm),
  stroke: 0.8pt + tint,
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  stroke: 0.8pt + hair,
  image(path, width: width),
)

// The board: a 1 cm grid with a heavier line every 5 cm, drawn behind
// everything else.
#let board-grid = place(top + left, block(width: 21cm, height: 21cm)[
  #for step in range(1, 21) {
    let weight = if calc.rem(step, 5) == 0 { 0.8pt } else { 0.35pt }
    place(left + top, dx: step * 1cm, line(end: (0cm, 21cm), stroke: weight + hair))
    place(left + top, dy: step * 1cm, line(end: (21cm, 0cm), stroke: weight + hair))
  }
])

// Tick marks along the top edge, the ruler this family is built on.
#let ticks = place(top + left, block(width: 21cm)[
  #for step in range(1, 42) {
    let length = if calc.rem(step, 5) == 0 { 0.34cm } else { 0.18cm }
    place(left + top, dx: step * 0.5cm, line(end: (0cm, length), stroke: 0.8pt + accent))
  }
])

// The drawing title block, bottom right, carrying the sheet number.
#let title-block(sheet) = place(
  bottom + right,
  dx: -1.2cm,
  dy: -1.2cm,
  block(stroke: 0.8pt + accent, inset: 0pt)[
    #grid(
      columns: (2.9cm, 2.9cm, 2.2cm),
      ..(
        ("PROJECT", project),
        ("REV", version),
        ("SHEET", sheet),
      ).map(cell => block(
        width: 100%,
        inset: (x: 0.28cm, y: 0.24cm),
        stroke: 0.8pt + accent,
      )[
        #text(font: mono, size: 7.5pt, fill: muted, tracking: 1pt)[#cell.at(0)]
        #v(0.08cm)
        #text(font: mono, size: 10.5pt, fill: ink)[#cell.at(1)]
      ])
    )
  ],
)

// Set above the title block rather than beside it: the two share the bottom
// edge, and a footer long enough to carry the date runs straight into the
// block's first cell.
#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.2cm,
  dy: -3.05cm,
  text(font: mono, size: 9.5pt, fill: muted)[
    #url-link("github.com/mcanouil/typst-carousel-gallery") #sym.dot.op #date
  ],
)

#let heading-1(txt) = text(font: display, size: 32pt, weight: 700, fill: ink, txt)

#let slide(n: none, body) = page(fill: ground)[
  #board-grid
  #ticks
  #place(top + left, dx: 1.2cm, dy: 2.1cm, block(width: 15.4cm, body))
  #title-block(str(n) + " / 6")
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #board-grid
  #ticks
  #place(
    left + horizon,
    dx: 1.2cm,
    dy: -0.8cm,
    block(width: 16cm)[
      #kicker("Release drawing")
      #v(0.55cm)
      #text(font: display, size: 68pt, weight: 700, fill: ink)[#project]
      #v(0.1cm)
      #text(font: mono, size: 28pt, weight: 700, fill: accent)[REV #version]
      #v(0.65cm)
      #block(width: 12.5cm, text(size: 16pt, fill: muted)[
        Build every report from one command, in whatever format the reader
        asked for.
      ])
    ],
  )
  #title-block("1 / 6")
  #footer(n: 1)
]

// 02 The gap
#slide(n: 2)[
  #kicker("The gap")
  #v(0.4cm)
  #heading-1[Six scripts, four formats, one deadline.]
  #v(0.55cm)
  #block(width: 15cm, text(size: 15.5pt)[
    Every project grows its own build script, and then a second one for the
    slides, and a third for the print version. They drift. The one that matters
    is always the one nobody ran.
  ])
  #v(0.5cm)
  #line(length: 15cm, stroke: 0.8pt + accent)
  #v(0.45cm)
  #block(width: 15cm, text(size: 15.5pt, fill: muted)[
    A build is a fact about a project, not a habit of the person who last
    shipped it.
  ])
]

// 03 The mechanic
#slide(n: 3)[
  #kicker("How it works")
  #v(0.4cm)
  #heading-1[One command, every target.]
  #v(0.5cm)
  #block(width: 15cm, text(size: 15pt, fill: muted)[
    Declare the targets once. #project reads them, builds only what changed, and
    writes each one where it belongs.
  ])
  #v(0.5cm)
  #code-slab(size: 12.5pt)[
    ```yaml
    targets:
      report:  {format: pdf,  profile: release}
      slides:  {format: html, profile: talk}
      archive: {format: docx, profile: release}
    ```
  ]
  #v(0.4cm)
  #code-slab(size: 12.5pt)[
    ```bash
    acme build --profile release
    ```
  ]
]

// 04 Where it pays off
#slide(n: 4)[
  #kicker("Where it pays off")
  #v(0.4cm)
  #heading-1[Three places it earns its keep.]
  #v(0.6cm)
  #grid(
    columns: (1fr,),
    row-gutter: 0.5cm,
    ..(
      (
        "01",
        "A report that ships monthly",
        "The same command in the same order, so the December build is the January build.",
      ),
      (
        "02",
        "A paper and a talk from one source",
        "Two targets, one set of numbers. The slides cannot fall behind the manuscript.",
      ),
      (
        "03",
        "A handover",
        "The build is in the repository, not in the head of whoever set it up.",
      ),
    ).map(item => grid(
      columns: (1.5cm, 1fr),
      column-gutter: 0.35cm,
      text(font: mono, size: 17pt, weight: 700, fill: accent)[#item.at(0)],
      block[
        #text(font: display, size: 16.5pt, weight: 700, fill: ink)[#item.at(1)]
        #v(0.08cm)
        #text(size: 13.5pt, fill: muted)[#item.at(2)]
      ],
    ))
  )
]

// 05 What changed
#slide(n: 5)[
  #kicker("Revision " + version)
  #v(0.4cm)
  #heading-1[What changed.]
  #v(0.6cm)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.45cm,
    row-gutter: 0.5cm,
    chip("NEW"),
    text(size: 14pt)[
      Profiles. One target set, several build shapes, no duplicated
      configuration.
    ],
    chip("NEW"),
    text(size: 14pt)[
      Incremental builds. Only the targets whose inputs moved are rebuilt.
    ],
    chip("FIX"),
    text(size: 14pt)[
      Relative paths now resolve from the project root on every platform.
    ],
  )
  #v(0.6cm)
  #line(length: 15cm, stroke: 0.8pt + accent)
  #v(0.45cm)
  #block(width: 15cm, text(size: 14pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: slab)[
  #board-grid
  #ticks
  #place(
    left + horizon,
    dx: 1.2cm,
    dy: -0.8cm,
    block(width: 16cm)[
      #kicker("Issued for use")
      #v(0.5cm)
      #text(font: display, size: 42pt, weight: 700, fill: ink)[Install and build.]
      #v(0.7cm)
      #code-slab(size: 13.5pt)[
        ```bash
        brew install acme-kit && acme init
        ```
      ]
      #v(0.7cm)
      #text(size: 15pt, fill: muted)[
        Source, documentation, and every template in this gallery:
      ]
      #v(0.25cm)
      #text(font: mono, size: 13.5pt, fill: accent)[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #title-block("6 / 6")
  #footer(n: 6)
]
