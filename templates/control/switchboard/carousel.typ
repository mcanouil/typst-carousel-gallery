// control/switchboard: rows of switches, each slide a setting being turned on.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#191c22") // page fill
#let paper = rgb("#232830") // light panel
#let ink = rgb("#eceef2") // body text
#let muted = rgb("#8f97a3") // secondary text
#let hair = rgb("#343a44") // rules and borders
#let accent = rgb("#ffb02e") // the one accent
#let slab = rgb("#0e1116") // code background
#let slab-fg = rgb("#eceef2") // code foreground

#let display = "Fira Sans"
#let body = "Inter"
#let mono = "IBM Plex Mono"

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
  weight: 600,
  fill: tint,
  tracking: 1.8pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  fill: tint.darken(65%),
  stroke: 1pt + tint.darken(30%),
  radius: 2pt,
  inset: (x: 7pt, y: 4pt),
  text(font: mono, size: 10pt, weight: 600, fill: tint, txt),
)

#let code-slab(body, size: 12.5pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  radius: 4pt,
  inset: (x: 0.6cm, y: 0.5cm),
  stroke: (left: 3pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  radius: 4pt,
  stroke: 1pt + hair,
  image(path, width: width),
)

// The switch: a rounded track with the knob at one end. Everything in the deck
// is built from this one shape.
#let toggle(on: true, width: 1.7cm, height: 0.82cm) = block(
  width: width,
  height: height,
  fill: if on { accent } else { hair },
  radius: 999pt,
)[
  #place(
    if on { right + horizon } else { left + horizon },
    dx: if on { -0.09cm } else { 0.09cm },
    circle(radius: height / 2 - 0.09cm, fill: if on { ground } else { muted }),
  )
]

// One row of the switchboard: a switch, a name, and what it does.
#let switch-row(name, detail, on: true) = grid(
  columns: (auto, 1fr),
  column-gutter: 0.6cm,
  align: horizon,
  toggle(on: on),
  block[
    #text(font: display, size: 16pt, weight: 600, fill: if on { ink } else { muted })[#name]
    #v(0.06cm)
    #text(size: 13pt, fill: muted)[#detail]
  ],
)

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.6cm,
  dy: -1.1cm,
  block(width: 17.8cm)[
    #line(length: 100%, stroke: 1pt + hair)
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

#let heading-1(txt) = text(font: display, size: 31pt, weight: 700, fill: ink, txt)

#let slide(n: none, body) = page(fill: ground)[
  #place(top + left, dx: 1.6cm, dy: 1.7cm, block(width: 17.8cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #place(
    left + horizon,
    dx: 1.6cm,
    block(width: 17.8cm)[
      #kicker("Release")
      #v(0.5cm)
      #text(font: display, size: 66pt, weight: 700, fill: ink)[#project]
      #v(0.1cm)
      #grid(
        columns: (auto, auto),
        column-gutter: 0.6cm,
        align: horizon,
        text(font: mono, size: 26pt, weight: 600, fill: accent)[#version],
        toggle(on: true),
      )
      #v(0.6cm)
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
  #v(0.6cm)
  #grid(
    columns: (1fr,),
    row-gutter: 0.5cm,
    switch-row(
      "build.sh",
      "Runs the report. Someone edited it last March.",
      on: false,
    ),
    switch-row(
      "build-slides.sh",
      "Runs the slides. Nobody is sure it still works.",
      on: false,
    ),
    switch-row(
      "FINAL-render.sh",
      "The one that matters. The one nobody ran.",
      on: false,
    ),
  )
  #v(0.6cm)
  #block(width: 16cm, text(size: 14.5pt, fill: muted)[
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

// 04 Where it pays off
#slide(n: 4)[
  #kicker("Where it pays off")
  #v(0.4cm)
  #heading-1[Three places it earns its keep.]
  #v(0.65cm)
  #grid(
    columns: (1fr,),
    row-gutter: 0.55cm,
    switch-row(
      "A report that ships monthly",
      "The same command in the same order, so the December build is the January build.",
    ),
    switch-row(
      "A paper and a talk from one source",
      "Two targets, one set of numbers. The slides cannot fall behind the manuscript.",
    ),
    switch-row(
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
  #line(length: 100%, stroke: 1pt + hair)
  #v(0.45cm)
  #block(width: 16cm, text(size: 14pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: accent)[
  #place(
    left + horizon,
    dx: 1.6cm,
    block(width: 17.8cm)[
      #text(font: mono, size: 10.5pt, weight: 600, fill: ground, tracking: 1.8pt)[#upper("Get it")]
      #v(0.5cm)
      #text(font: display, size: 42pt, weight: 700, fill: ground)[Install and build.]
      #v(0.65cm)
      #block(
        width: 100%,
        fill: ground,
        radius: 4pt,
        inset: (x: 0.6cm, y: 0.5cm),
        text(font: mono, size: 13.5pt, fill: ink)[
          ```bash
          brew install acme-kit && acme init
          ```
        ],
      )
      #v(0.7cm)
      #text(size: 15pt, fill: ground)[
        Source, documentation, and every template in this gallery:
      ]
      #v(0.2cm)
      #text(font: mono, size: 13.5pt, weight: 600, fill: ground)[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #place(
    bottom + left,
    dx: 1.6cm,
    dy: -1.1cm,
    block(width: 17.8cm)[
      #line(length: 100%, stroke: 1pt + ground)
      #v(0.28cm)
      #grid(
        columns: (1fr, auto),
        text(font: mono, size: 9pt, fill: ground)[#date],
        text(font: mono, size: 9pt, fill: ground)[#project #version #sym.dot.op 6 / 6],
      )
    ],
  )
]
