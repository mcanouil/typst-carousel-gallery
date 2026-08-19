// control/cascade: a stepped colour ladder runs down the page, one rung lit per slide.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#fcfcfa") // page fill
#let paper = rgb("#ffffff") // light panel
#let ink = rgb("#16202b") // body text
#let muted = rgb("#647184") // secondary text
#let hair = rgb("#dde3ea") // rules and borders
#let accent = rgb("#0f7ab8") // the one accent
#let slab = rgb("#16202b") // code background
#let slab-fg = rgb("#eef3f8") // code foreground

#let display = "Lato"
#let body = "Lato"
#let mono = "Fira Code"

#set page(width: 21cm, height: 21cm, margin: 0cm, fill: ground)
#set text(font: body, fill: ink, size: 15.5pt)
#set raw(theme: none)
// Ligatures off: a code font that draws `&&` or `!=` as one merged glyph is
// unreadable at slide sizes.
#show raw: set text(font: mono, ligatures: false)

// The ladder: six rungs, one per slide, running cool to warm. The lit rung is
// the slide you are on.
#let rungs = (
  rgb("#0f7ab8"),
  rgb("#1592a6"),
  rgb("#1ba37e"),
  rgb("#6aa832"),
  rgb("#d99a1b"),
  rgb("#d4622a"),
)

// --- HELPERS ---

#let url-link(url) = link("https://" + url, url)

#let kicker(txt, tint: accent) = text(
  font: mono,
  size: 10.5pt,
  weight: 600,
  fill: tint,
  tracking: 1.6pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  fill: tint.lighten(85%),
  radius: 2pt,
  inset: (x: 7pt, y: 4pt),
  text(font: mono, size: 10pt, weight: 600, fill: tint.darken(15%), txt),
)

#let code-slab(body, size: 12.5pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  radius: 3pt,
  inset: (x: 0.6cm, y: 0.5cm),
  stroke: (left: 4pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  radius: 3pt,
  stroke: 1pt + hair,
  image(path, width: width),
)

// The cascade down the right edge. Each rung steps a little further left, so
// the ladder falls as the deck advances.
#let cascade(active) = place(top + right, block(width: 3.2cm, height: 21cm)[
  #for index in range(rungs.len()) {
    let on = index + 1 == active
    place(
      right + top,
      dy: 3.4cm + index * 2.1cm,
      rect(
        width: if on { 3.2cm } else { 1.5cm + index * 0.18cm },
        height: 0.42cm,
        fill: if on { rungs.at(index) } else { rungs.at(index).lighten(72%) },
        stroke: none,
      ),
    )
  }
])

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.7cm,
  dy: -1.1cm,
  block(width: 14.4cm)[
    #line(length: 100%, stroke: 1pt + hair)
    #v(0.28cm)
    #grid(
      columns: (1fr, auto),
      text(font: mono, size: 9pt, fill: muted)[
        #url-link("github.com/mcanouil/typst-carousel-gallery")
      ],
      text(font: mono, size: 9pt, fill: muted)[
        #project #version #sym.dot.op #if n != none { [#n / #total] }
      ],
    )
  ],
)

#let heading-1(txt, tint: ink) = text(font: display, size: 32pt, weight: 900, fill: tint, txt)

#let slide(n: none, body) = page(fill: ground)[
  #cascade(n)
  #place(top + left, dx: 1.7cm, dy: 1.8cm, block(width: 14.4cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #cascade(1)
  #place(
    left + horizon,
    dx: 1.7cm,
    block(width: 14.4cm)[
      #kicker("Release")
      #v(0.5cm)
      #text(font: display, size: 64pt, weight: 900, fill: ink)[#project]
      #v(0.05cm)
      #text(font: mono, size: 26pt, weight: 600, fill: rungs.at(0))[#version]
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
  #kicker("The gap", tint: rungs.at(1))
  #v(0.4cm)
  #heading-1[Six scripts, four formats, one deadline.]
  #v(0.55cm)
  #block(width: 100%, text(size: 15.5pt)[
    Every project grows its own build script, and then a second one for the
    slides, and a third for the print version. They drift. The one that matters
    is always the one nobody ran.
  ])
  #v(0.55cm)
  #line(length: 100%, stroke: 3pt + rungs.at(1))
  #v(0.45cm)
  #block(width: 100%, text(size: 15.5pt, fill: muted)[
    A build is a fact about a project, not a habit of the person who last
    shipped it.
  ])
]

// 03 The mechanic
#slide(n: 3)[
  #kicker("How it works", tint: rungs.at(2))
  #v(0.4cm)
  #heading-1[One command, every target.]
  #v(0.5cm)
  #block(width: 100%, text(size: 15pt, fill: muted)[
    Declare the targets once. #project reads them, builds only what changed, and
    writes each one where it belongs.
  ])
  #v(0.45cm)
  #code-slab(tint: rungs.at(2))[
    ```yaml
    targets:
      report:  {format: pdf,  profile: release}
      slides:  {format: html, profile: talk}
      archive: {format: docx, profile: release}
    ```
  ]
  #v(0.35cm)
  #code-slab(tint: rungs.at(2))[
    ```bash
    acme build --profile release
    ```
  ]
]

// 04 Where it pays off
#slide(n: 4)[
  #kicker("Where it pays off", tint: rungs.at(3))
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
    ).map(item => block(width: 100%, stroke: (left: 4pt + rungs.at(3)), inset: (left: 0.5cm))[
      #text(font: display, size: 17pt, weight: 900, fill: ink)[#item.at(0)]
      #v(0.06cm)
      #text(size: 13.5pt, fill: muted)[#item.at(1)]
    ])
  )
]

// 05 What changed
#slide(n: 5)[
  #kicker("In " + version, tint: rungs.at(4))
  #v(0.4cm)
  #heading-1[What changed.]
  #v(0.6cm)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.45cm,
    row-gutter: 0.5cm,
    chip("new", tint: rungs.at(4)),
    text(size: 14pt)[
      Profiles. One target set, several build shapes, no duplicated
      configuration.
    ],
    chip("new", tint: rungs.at(4)),
    text(size: 14pt)[
      Incremental builds. Only the targets whose inputs moved are rebuilt.
    ],
    chip("fixed", tint: rungs.at(4)),
    text(size: 14pt)[
      Relative paths now resolve from the project root on every platform.
    ],
  )
  #v(0.6cm)
  #line(length: 100%, stroke: 3pt + rungs.at(4))
  #v(0.45cm)
  #block(width: 100%, text(size: 14pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: ground)[
  #cascade(6)
  #place(
    left + horizon,
    dx: 1.7cm,
    block(width: 14.4cm)[
      #kicker("Get it", tint: rungs.at(5))
      #v(0.5cm)
      #heading-1(tint: ink)[Install and build.]
      #v(0.65cm)
      #code-slab(size: 13.5pt, tint: rungs.at(5))[
        ```bash
        brew install acme-kit && acme init
        ```
      ]
      #v(0.7cm)
      #text(size: 15pt, fill: muted)[
        Source, documentation, and every template in this gallery:
      ]
      #v(0.2cm)
      #text(font: mono, size: 13.5pt, weight: 600, fill: rungs.at(5))[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #footer(n: 6)
]
