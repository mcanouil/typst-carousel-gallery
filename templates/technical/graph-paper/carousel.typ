// technical/graph-paper: warm graph paper with a measured gutter, a ruler, and registration marks.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#fbf8f2") // page fill
#let paper = rgb("#ffffff") // light panel
#let ink = rgb("#242019") // body text
#let muted = rgb("#6f665a") // secondary text
#let hair = rgb("#e2d9c8") // rules and borders
#let accent = rgb("#c85a26") // the one accent
#let slab = rgb("#242019") // code background
#let slab-fg = rgb("#f4ede0") // code foreground

#let display = "Archivo"
#let body = "IBM Plex Sans"
#let mono = "IBM Plex Mono"

#set page(width: 21cm, height: 21cm, margin: 0cm, fill: ground)
#set text(font: body, fill: ink, size: 15pt)
#set raw(theme: none)
// Ligatures off: a code font that draws `&&` or `!=` as one merged glyph is
// unreadable at slide sizes.
#show raw: set text(font: mono, ligatures: false)

// The gutter every slide is measured from. The ruler counts it in centimetres,
// so changing it here moves the whole layout together.
#let gutter = 2.6cm

// --- HELPERS ---

#let url-link(url) = link("https://" + url, url)

#let kicker(txt, tint: accent) = text(
  font: mono,
  size: 10.5pt,
  weight: 600,
  fill: tint,
  tracking: 1.8pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  fill: tint.lighten(84%),
  stroke: 0.7pt + tint.lighten(35%),
  inset: (x: 7pt, y: 4pt),
  text(font: mono, size: 10pt, weight: 600, fill: tint.darken(12%), txt),
)

#let code-slab(body, size: 12.5pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  inset: (x: 0.65cm, y: 0.55cm),
  stroke: (left: 4pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  stroke: 0.8pt + hair,
  image(path, width: width),
)

// Graph paper: a fine 0.5 cm grid, with every fourth line darker.
#let graph-paper = place(top + left, block(width: 21cm, height: 21cm)[
  #for step in range(1, 42) {
    let weight = if calc.rem(step, 4) == 0 { 0.5pt } else { 0.25pt }
    place(left + top, dx: step * 0.5cm, line(end: (0cm, 21cm), stroke: weight + hair))
    place(left + top, dy: step * 0.5cm, line(end: (21cm, 0cm), stroke: weight + hair))
  }
])

// The ruler down the left edge, numbered every 2 cm. It is what makes the
// gutter read as a measurement rather than a margin.
#let ruler = place(top + left, block(width: gutter, height: 21cm)[
  #place(left + top, dx: gutter - 0.5cm, line(end: (0cm, 21cm), stroke: 1.2pt + accent))
  #for step in range(1, 21) {
    let length = if calc.rem(step, 2) == 0 { 0.34cm } else { 0.18cm }
    place(
      left + top,
      dx: gutter - 0.5cm - length,
      dy: step * 1cm,
      line(end: (length, 0cm), stroke: 0.9pt + accent),
    )
    if calc.rem(step, 2) == 0 {
      place(
        left + top,
        dx: 0.5cm,
        dy: step * 1cm - 0.11cm,
        text(font: mono, size: 8pt, fill: muted)[#step],
      )
    }
  }
])

// Registration marks at the two outer corners, the printer's alignment cross.
#let registration = {
  let mark(x, y) = place(top + left, dx: x, dy: y, {
    place(left + top, dy: 0.3cm, line(end: (0.6cm, 0cm), stroke: 0.7pt + accent))
    place(left + top, dx: 0.3cm, line(end: (0cm, 0.6cm), stroke: 0.7pt + accent))
    place(left + top, circle(radius: 0.22cm, stroke: 0.7pt + accent))
  })
  mark(19.6cm, 0.8cm)
  mark(19.6cm, 19.6cm)
}

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: gutter,
  dy: -1.2cm,
  block(width: 21cm - gutter - 1.6cm)[
    #line(length: 100%, stroke: 0.8pt + hair.darken(10%))
    #v(0.28cm)
    #grid(
      columns: (1fr, auto),
      text(font: mono, size: 9pt, fill: muted)[
        #url-link("github.com/mcanouil/typst-carousel-gallery")
      ],
      text(font: mono, size: 9pt, fill: muted)[
        #project #version #sym.dot.op #if n != none { [#n / #total] } #sym.dot.op #date
      ],
    )
  ],
)

#let heading-1(txt) = text(font: display, size: 32pt, weight: 700, fill: ink, txt)

#let slide(n: none, body) = page(fill: ground)[
  #graph-paper
  #ruler
  #registration
  #place(top + left, dx: gutter, dy: 1.9cm, block(width: 21cm - gutter - 1.6cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #graph-paper
  #ruler
  #registration
  #place(
    left + horizon,
    dx: gutter,
    block(width: 21cm - gutter - 1.6cm)[
      #kicker("Release")
      #v(0.5cm)
      #text(font: display, size: 66pt, weight: 700, fill: ink)[#project]
      #v(0.1cm)
      #text(font: mono, size: 27pt, weight: 600, fill: accent)[#version]
      #v(0.65cm)
      #block(width: 12cm, text(size: 16pt, fill: muted)[
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
  #block(width: 14.5cm, text(size: 15.5pt)[
    Every project grows its own build script, and then a second one for the
    slides, and a third for the print version. They drift. The one that matters
    is always the one nobody ran.
  ])
  #v(0.5cm)
  #line(length: 14.5cm, stroke: 2pt + accent)
  #v(0.45cm)
  #block(width: 14.5cm, text(size: 15.5pt, fill: muted)[
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
  #block(width: 15.5cm, text(size: 15pt, fill: muted)[
    Declare the targets once. #project reads them, builds only what changed, and
    writes each one where it belongs.
  ])
  #v(0.5cm)
  #code-slab[
    ```yaml
    targets:
      report:  {format: pdf,  profile: release}
      slides:  {format: html, profile: talk}
      archive: {format: docx, profile: release}
    ```
  ]
  #v(0.4cm)
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
    ..(
      (
        "A report that ships monthly",
        "The same command in the same order, so the December build is the January build.",
      ),
      (
        "A paper and a talk from one source",
        "Two targets, one set of numbers. The slides cannot fall behind the manuscript.",
      ),
      (
        "A handover",
        "The build is in the repository, not in the head of whoever set it up.",
      ),
    ).map(item => block(width: 100%, inset: (left: 0.5cm), stroke: (left: 2pt + accent))[
      #text(font: display, size: 17pt, weight: 700, fill: ink)[#item.at(0)]
      #v(0.08cm)
      #text(size: 13.5pt, fill: muted)[#item.at(1)]
    ])
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
  #v(0.6cm)
  #line(length: 14.5cm, stroke: 2pt + accent)
  #v(0.45cm)
  #block(width: 14.5cm, text(size: 14pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: ink)[
  #place(
    left + horizon,
    dx: gutter,
    block(width: 21cm - gutter - 1.6cm)[
      #text(font: mono, size: 10.5pt, weight: 600, fill: accent.lighten(30%), tracking: 1.8pt)[
        #upper("Get it")
      ]
      #v(0.5cm)
      #text(font: display, size: 42pt, weight: 700, fill: ground)[Install and build.]
      #v(0.7cm)
      #block(
        width: 100%,
        fill: ground,
        inset: (x: 0.65cm, y: 0.55cm),
        stroke: (left: 4pt + accent),
        text(font: mono, size: 13.5pt, fill: ink)[
          ```bash
          brew install acme-kit && acme init
          ```
        ],
      )
      #v(0.75cm)
      #text(size: 15pt, fill: hair)[
        Source, documentation, and every template in this gallery:
      ]
      #v(0.25cm)
      #text(font: mono, size: 13.5pt, fill: accent.lighten(30%))[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #place(
    bottom + left,
    dx: gutter,
    dy: -1.2cm,
    block(width: 21cm - gutter - 1.6cm)[
      #line(length: 100%, stroke: 0.8pt + muted)
      #v(0.28cm)
      #grid(
        columns: (1fr, auto),
        text(font: mono, size: 9pt, fill: hair)[#date],
        text(font: mono, size: 9pt, fill: hair)[#project #version #sym.dot.op 6 / 6],
      )
    ],
  )
]
