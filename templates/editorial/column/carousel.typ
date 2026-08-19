// editorial/column: ivory magazine column, pilcrow marks and mini page previews.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#faf6ef") // page fill
#let paper = rgb("#ffffff") // light panel
#let ink = rgb("#1f1b17") // body text
#let muted = rgb("#6f6559") // secondary text
#let hair = rgb("#ddd2c2") // rules and borders
#let accent = rgb("#a63a1e") // the one accent
#let slab = rgb("#1f1b17") // code background
#let slab-fg = rgb("#f2ece1") // code foreground

#let display = "Libre Baskerville"
#let body = "Libre Baskerville"
#let mono = "JetBrains Mono"

#set page(width: 21cm, height: 21cm, margin: 0cm, fill: ground)
#set text(font: body, fill: ink, size: 14.5pt)
#set raw(theme: none)
// Ligatures off: a code font that draws `&&` or `!=` as one merged glyph is
// unreadable at slide sizes.
#show raw: set text(font: mono, ligatures: false)

// --- HELPERS ---

#let url-link(url) = link("https://" + url, url)

#let kicker(txt, tint: accent) = text(
  font: mono,
  size: 10.5pt,
  weight: 500,
  fill: tint,
  tracking: 1.8pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  stroke: 0.7pt + tint,
  radius: 1pt,
  inset: (x: 6pt, y: 3.5pt),
  text(font: mono, size: 10pt, fill: tint, txt),
)

#let code-slab(body, size: 12.5pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  inset: (x: 0.6cm, y: 0.5cm),
  stroke: (left: 2.5pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  stroke: 0.8pt + hair,
  image(path, width: width),
)

// The pilcrow that opens every paragraph in this deck.
#let pilcrow = text(font: display, size: 13pt, fill: accent, weight: 700)[¶]

#let para(txt) = block(width: 100%)[#pilcrow #h(3pt) #txt]

// A miniature of a printed page, the recurring motif: ruled lines standing in
// for text, with one band tinted to mark what the slide is talking about.
#let mini-page(label, lit: 0, height: 4.4cm) = block(
  width: 100%,
  height: height,
  fill: paper,
  stroke: 0.8pt + hair,
  inset: 0.4cm,
)[
  #text(font: mono, size: 8.5pt, fill: muted, tracking: 1pt)[#upper(label)]
  #v(0.22cm)
  #for row in range(7) {
    let width = if calc.rem(row, 3) == 2 { 62% } else { 100% }
    let colour = if row == lit { accent } else { hair }
    block(above: 0.16cm, line(length: width, stroke: 2pt + colour))
  }
]

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.7cm,
  dy: -1.15cm,
  block(width: 17.6cm)[
    #line(length: 100%, stroke: 0.5pt + hair)
    #v(0.28cm)
    #grid(
      columns: (1fr, auto),
      text(font: mono, size: 9pt, fill: muted)[
        #url-link("github.com/mcanouil/typst-carousel-gallery")
      ],
      text(font: mono, size: 9pt, fill: muted)[
        #project #version #sym.dot.op #if n != none { [#n of #total] } #sym.dot.op #date
      ],
    )
  ],
)

#let heading-1(txt) = text(font: display, size: 27pt, weight: 700, fill: ink, txt)

#let slide(n: none, body) = page(fill: ground)[
  #place(top + left, dx: 1.7cm, dy: 1.5cm, block(width: 17.6cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #place(
    left + horizon,
    dx: 1.7cm,
    block(width: 17.6cm)[
      #kicker("A release in six pages")
      #v(0.7cm)
      #line(length: 4cm, stroke: 2.5pt + accent)
      #v(0.6cm)
      #text(font: display, size: 58pt, weight: 700, fill: ink)[#project]
      #v(0.1cm)
      #text(font: display, size: 30pt, weight: 400, fill: accent)[#version]
      #v(0.7cm)
      #block(width: 12.5cm, text(size: 16pt, fill: muted)[
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
    columns: (1fr, 5.4cm),
    column-gutter: 0.9cm,
    block[
      #para[
        Every project grows its own build script, and then a second one for the
        slides, and a third for the print version. They drift. The one that
        matters is always the one nobody ran.
      ]
      #v(0.35cm)
      #para[
        A build is a fact about a project, not a habit of the person who last
        shipped it.
      ]
    ],
    mini-page("Before", lit: 4),
  )
]

// 03 The mechanic
#slide(n: 3)[
  #kicker("How it works")
  #v(0.4cm)
  #heading-1[One command, every target.]
  #v(0.55cm)
  #para[
    Declare the targets once. #project reads them, builds only what changed, and
    writes each one where it belongs.
  ]
  #v(0.5cm)
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
    columns: (1fr, 1fr, 1fr),
    column-gutter: 0.5cm,
    ..(
      ("Monthly", 1, "The same command in the same order, so the December build is the January build."),
      ("One source", 3, "Two targets, one set of numbers. The slides cannot fall behind the manuscript."),
      ("Handover", 5, "The build is in the repository, not in the head of whoever set it up."),
    ).map(item => block(width: 100%)[
      #mini-page(item.at(0), lit: item.at(1), height: 3.6cm)
      #v(0.3cm)
      #text(size: 12.5pt, fill: muted)[#item.at(2)]
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
    column-gutter: 0.5cm,
    row-gutter: 0.55cm,
    chip("New"),
    text(size: 14pt)[
      Profiles. One target set, several build shapes, no duplicated
      configuration.
    ],
    chip("New"),
    text(size: 14pt)[
      Incremental builds. Only the targets whose inputs moved are rebuilt.
    ],
    chip("Fixed"),
    text(size: 14pt)[
      Relative paths now resolve from the project root on every platform.
    ],
  )
  #v(0.6cm)
  #line(length: 100%, stroke: 0.5pt + hair)
  #v(0.4cm)
  #para[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ]
]

// 06 Ship
#page(fill: ink)[
  #place(
    left + horizon,
    dx: 1.7cm,
    block(width: 17.6cm)[
      #text(font: mono, size: 10.5pt, fill: ground, tracking: 1.8pt)[#upper("Get it")]
      #v(0.6cm)
      #line(length: 4cm, stroke: 2.5pt + accent)
      #v(0.6cm)
      #text(font: display, size: 34pt, weight: 700, fill: ground)[Install and build.]
      #v(0.7cm)
      #block(
        width: 100%,
        fill: ground,
        inset: (x: 0.6cm, y: 0.5cm),
        stroke: (left: 2.5pt + accent),
        text(font: mono, size: 13pt, fill: ink)[
          ```bash
          brew install acme-kit && acme init
          ```
        ],
      )
      #v(0.8cm)
      #text(size: 14pt, fill: hair)[
        Source, documentation, and every template in this gallery:
      ]
      #v(0.25cm)
      #text(font: mono, size: 13pt, fill: accent.lighten(25%))[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #place(
    bottom + left,
    dx: 1.7cm,
    dy: -1.15cm,
    block(width: 17.6cm)[
      #line(length: 100%, stroke: 0.5pt + muted)
      #v(0.28cm)
      #grid(
        columns: (1fr, auto),
        text(font: mono, size: 9pt, fill: hair)[#date],
        text(font: mono, size: 9pt, fill: hair)[
          #project #version #sym.dot.op 6 of 6
        ],
      )
    ],
  )
]
