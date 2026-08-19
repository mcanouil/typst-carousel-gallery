// panels/ledger: ruled accounting rows on parchment, each point an entry with a stamped total.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#f5efe1") // page fill
#let paper = rgb("#fbf7ee") // light panel
#let ink = rgb("#2a2419") // body text
#let muted = rgb("#7b7159") // secondary text
#let hair = rgb("#cfc3a5") // rules and borders
#let accent = rgb("#9a2f2f") // the one accent
#let slab = rgb("#2a2419") // code background
#let slab-fg = rgb("#f5efe1") // code foreground

#let display = "Archivo"
#let body = "Space Mono"
#let mono = "Space Mono"

#set page(width: 21cm, height: 21cm, margin: 0cm, fill: ground)
#set text(font: body, fill: ink, size: 13.5pt)
#set raw(theme: none)
// Ligatures off: a code font that draws `&&` or `!=` as one merged glyph is
// unreadable at slide sizes.
#show raw: set text(font: mono, ligatures: false)

// --- HELPERS ---

#let url-link(url) = link("https://" + url, url)

#let kicker(txt, tint: accent) = text(
  font: mono,
  size: 10pt,
  weight: 700,
  fill: tint,
  tracking: 1.8pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  stroke: 1.2pt + tint,
  inset: (x: 6pt, y: 3pt),
  text(font: mono, size: 9.5pt, weight: 700, fill: tint, txt),
)

#let code-slab(body, size: 12pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  inset: (x: 0.6cm, y: 0.5cm),
  stroke: (left: 4pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  stroke: 1pt + hair,
  image(path, width: width),
)

// The ruled page: horizontal rules every 0.9 cm, plus the two vertical column
// rules an accounting sheet has.
#let ruled = place(top + left, block(width: 21cm, height: 21cm)[
  #for row in range(2, 22) {
    place(left + top, dy: row * 0.9cm, line(end: (21cm, 0cm), stroke: 0.5pt + hair))
  }
  #place(left + top, dx: 2.2cm, line(end: (0cm, 21cm), stroke: 1pt + accent.lighten(55%)))
  #place(left + top, dx: 2.45cm, line(end: (0cm, 21cm), stroke: 1pt + accent.lighten(55%)))
])

// One ledger entry: a row number in the left column, the entry beside it.
#let entry(number, title, body) = grid(
  columns: (1.3cm, 1fr),
  column-gutter: 0.55cm,
  text(font: mono, size: 12pt, fill: accent)[#number],
  block[
    #text(font: display, size: 16pt, weight: 700, fill: ink)[#title]
    #v(0.06cm)
    #text(size: 12.5pt, fill: muted)[#body]
  ],
)

// The stamp: a rotated boxed word, the deck's one piece of theatre.
#let stamp(txt) = rotate(-8deg, box(
  stroke: 2.5pt + accent,
  inset: (x: 0.35cm, y: 0.2cm),
  text(font: display, size: 17pt, weight: 700, fill: accent, tracking: 2pt)[#upper(txt)],
))

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 2.75cm,
  dy: -1.1cm,
  block(width: 16.5cm)[
    #line(length: 100%, stroke: 1.2pt + ink)
    #v(0.25cm)
    #grid(
      columns: (1fr, auto),
      text(font: mono, size: 8.5pt, fill: muted)[
        #url-link("github.com/mcanouil/typst-carousel-gallery")
      ],
      text(font: mono, size: 8.5pt, fill: muted)[
        #project #version #sym.dot.op #if n != none { [#n / #total] } #sym.dot.op #date
      ],
    )
  ],
)

#let heading-1(txt) = text(font: display, size: 30pt, weight: 700, fill: ink, txt)

#let slide(n: none, body) = page(fill: ground)[
  #ruled
  #place(top + left, dx: 2.75cm, dy: 1.9cm, block(width: 16.5cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #ruled
  #place(top + right, dx: -1.6cm, dy: 3.2cm, stamp("Released"))
  #place(
    left + horizon,
    dx: 2.75cm,
    block(width: 16.5cm)[
      #kicker("Entry 01")
      #v(0.5cm)
      #text(font: display, size: 62pt, weight: 700, fill: ink)[#project]
      #v(0.1cm)
      #text(font: mono, size: 24pt, weight: 700, fill: accent)[#version]
      #v(0.55cm)
      #block(width: 12.5cm, text(size: 14pt, fill: muted)[
        Build every report from one command, in whatever format the reader
        asked for.
      ])
    ],
  )
  #footer(n: 1)
]

// 02 The gap
#slide(n: 2)[
  #kicker("The gap")
  #v(0.4cm)
  #heading-1[Six scripts, four formats, one deadline.]
  #v(0.55cm)
  #grid(
    columns: (1fr,),
    row-gutter: 0.5cm,
    entry(
      "001",
      "They multiply",
      "Every project grows its own build script, then a second for the slides, then a third for print.",
    ),
    entry(
      "002",
      "They drift",
      "The one that matters is always the one nobody ran.",
    ),
    entry(
      "003",
      "The balance",
      "A build is a fact about a project, not a habit of the person who last shipped it.",
    ),
  )
]

// 03 The mechanic
#slide(n: 3)[
  #kicker("How it works")
  #v(0.4cm)
  #heading-1[One command, every target.]
  #v(0.5cm)
  #block(width: 15.5cm, text(size: 13.5pt, fill: muted)[
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

// 04 Where it pays off
#slide(n: 4)[
  #kicker("Where it pays off")
  #v(0.4cm)
  #heading-1[Three places it earns its keep.]
  #v(0.6cm)
  #grid(
    columns: (1fr,),
    row-gutter: 0.55cm,
    entry(
      "011",
      "A report that ships monthly",
      "The same command in the same order, so the December build is the January build.",
    ),
    entry(
      "012",
      "A paper and a talk from one source",
      "Two targets, one set of numbers. The slides cannot fall behind the manuscript.",
    ),
    entry(
      "013",
      "A handover",
      "The build is in the repository, not in the head of whoever set it up.",
    ),
  )
]

// 05 What changed
#slide(n: 5)[
  #kicker("In " + version)
  #v(0.4cm)
  #heading-1[What changed.]
  #v(0.6cm)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.45cm,
    row-gutter: 0.5cm,
    chip("new"),
    text(size: 13pt)[
      Profiles. One target set, several build shapes, no duplicated
      configuration.
    ],
    chip("new"),
    text(size: 13pt)[
      Incremental builds. Only the targets whose inputs moved are rebuilt.
    ],
    chip("fixed"),
    text(size: 13pt)[
      Relative paths now resolve from the project root on every platform.
    ],
  )
  #v(0.6cm)
  #line(length: 100%, stroke: 1.2pt + ink)
  #v(0.4cm)
  #block(width: 15.5cm, text(size: 13pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: ground)[
  #ruled
  #place(top + right, dx: -1.6cm, dy: 3.2cm, stamp("Paid"))
  #place(
    left + horizon,
    dx: 2.75cm,
    block(width: 16.5cm)[
      #kicker("Get it")
      #v(0.5cm)
      #text(font: display, size: 42pt, weight: 700, fill: ink)[Install and build.]
      #v(0.65cm)
      #code-slab(size: 13pt)[
        ```bash
        brew install acme-kit && acme init
        ```
      ]
      #v(0.7cm)
      #text(size: 13.5pt, fill: muted)[
        Source, documentation, and every template in this gallery:
      ]
      #v(0.2cm)
      #text(font: mono, size: 12.5pt, weight: 700, fill: accent)[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #footer(n: 6)
]
