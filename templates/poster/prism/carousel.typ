// poster/prism: an oversized rotated letter behind the type, one hue per slide.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#fbf6f2") // page fill
#let paper = rgb("#ffffff") // light panel
#let ink = rgb("#241a1a") // body text
#let muted = rgb("#7a6a66") // secondary text
#let hair = rgb("#e4d8d0") // rules and borders
#let accent = rgb("#c02b1e") // the one accent
#let slab = rgb("#241a1a") // code background
#let slab-fg = rgb("#fbf6f2") // code foreground

#let display = "Fraunces"
#let body = "Work Sans"
#let mono = "Fira Code"

#set page(width: 21cm, height: 21cm, margin: 0cm, fill: ground)
#set text(font: body, fill: ink, size: 15.5pt)
#set raw(theme: none)
// Ligatures off: a code font that draws `&&` or `!=` as one merged glyph is
// unreadable at slide sizes.
#show raw: set text(font: mono, ligatures: false)

// The prism: one hue per slide, split from the accent the way a prism splits
// light. The deck walks the band from slide to slide.
#let spectrum = (
  rgb("#c02b1e"),
  rgb("#d0621b"),
  rgb("#c98c12"),
  rgb("#6f8f2a"),
  rgb("#1f7f76"),
  rgb("#1c5fa8"),
)

// --- HELPERS ---

#let url-link(url) = link("https://" + url, url)

#let kicker(txt, tint: accent) = text(
  font: mono,
  size: 10.5pt,
  weight: 600,
  fill: tint,
  tracking: 2pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  fill: tint,
  inset: (x: 7pt, y: 4pt),
  text(font: mono, size: 10pt, weight: 600, fill: ground, txt),
)

#let code-slab(body, size: 12.5pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  inset: (x: 0.65cm, y: 0.55cm),
  stroke: (left: 5pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  stroke: 1pt + hair,
  image(path, width: width),
)

// The ghost letter: an enormous rotated glyph, sitting behind the type.
#let ghost(character, tint: accent) = place(
  right + horizon,
  dx: 3.4cm,
  dy: 0.6cm,
  rotate(-14deg, text(
    font: display,
    size: 300pt,
    weight: 900,
    fill: tint.transparentize(88%),
    character,
  )),
)

// The spectrum band along the bottom edge, with the current slide's hue full
// height and the rest reduced.
#let band(active) = place(bottom + left, block(width: 21cm, height: 0.55cm)[
  #for index in range(spectrum.len()) {
    place(
      left + bottom,
      dx: index * 3.5cm,
      rect(
        width: 3.5cm,
        height: if index + 1 == active { 0.55cm } else { 0.2cm },
        fill: spectrum.at(index),
        stroke: none,
      ),
    )
  }
])

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.7cm,
  dy: -1.5cm,
  block(width: 17.6cm)[
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

#let heading-1(txt, tint: ink) = text(font: display, size: 34pt, weight: 800, fill: tint, txt)

#let slide(n: none, letter, body) = page(fill: ground)[
  #ghost(letter, tint: spectrum.at(n - 1))
  #place(top + left, dx: 1.7cm, dy: 1.8cm, block(width: 15.4cm, body))
  #band(n)
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #ghost("A", tint: spectrum.at(0))
  #place(
    left + horizon,
    dx: 1.7cm,
    block(width: 15.4cm)[
      #kicker("Release")
      #v(0.5cm)
      #text(font: display, size: 68pt, weight: 900, fill: ink)[#project]
      #v(0.05cm)
      #text(font: mono, size: 26pt, weight: 600, fill: accent)[#version]
      #v(0.6cm)
      #block(width: 12.5cm, text(size: 16pt, fill: muted)[
        Build every report from one command, in whatever format the reader
        asked for.
      ])
    ],
  )
  #band(1)
  #footer(n: 1)
]

// 02 The gap
#slide(n: 2, "?")[
  #kicker("The gap", tint: spectrum.at(1))
  #v(0.4cm)
  #heading-1[Six scripts, four formats, one deadline.]
  #v(0.55cm)
  #block(width: 100%, text(size: 15.5pt)[
    Every project grows its own build script, and then a second one for the
    slides, and a third for the print version. They drift. The one that matters
    is always the one nobody ran.
  ])
  #v(0.5cm)
  #line(length: 100%, stroke: 4pt + spectrum.at(1))
  #v(0.45cm)
  #block(width: 100%, text(size: 15.5pt, fill: muted)[
    A build is a fact about a project, not a habit of the person who last
    shipped it.
  ])
]

// 03 The mechanic
#slide(n: 3, "1")[
  #kicker("How it works", tint: spectrum.at(2))
  #v(0.4cm)
  #heading-1[One command, every target.]
  #v(0.5cm)
  #block(width: 100%, text(size: 15pt, fill: muted)[
    Declare the targets once. #project reads them, builds only what changed, and
    writes each one where it belongs.
  ])
  #v(0.45cm)
  #code-slab(tint: spectrum.at(2))[
    ```yaml
    targets:
      report:  {format: pdf,  profile: release}
      slides:  {format: html, profile: talk}
      archive: {format: docx, profile: release}
    ```
  ]
  #v(0.35cm)
  #code-slab(tint: spectrum.at(2))[
    ```bash
    acme build --profile release
    ```
  ]
]

// 04 Where it pays off
#slide(n: 4, "3")[
  #kicker("Where it pays off", tint: spectrum.at(3))
  #v(0.4cm)
  #heading-1[Three places it earns its keep.]
  #v(0.6cm)
  #grid(
    columns: (1fr,),
    row-gutter: 0.6cm,
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
    ).map(item => block(width: 100%)[
      #text(font: display, size: 18pt, weight: 800, fill: spectrum.at(3))[#item.at(0)]
      #v(0.06cm)
      #text(size: 13.5pt, fill: muted)[#item.at(1)]
    ])
  )
]

// 05 What changed
#slide(n: 5, "+")[
  #kicker("In " + version, tint: spectrum.at(4))
  #v(0.4cm)
  #heading-1[What changed.]
  #v(0.6cm)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.45cm,
    row-gutter: 0.5cm,
    chip("new", tint: spectrum.at(4)),
    text(size: 14pt)[
      Profiles. One target set, several build shapes, no duplicated
      configuration.
    ],
    chip("new", tint: spectrum.at(4)),
    text(size: 14pt)[
      Incremental builds. Only the targets whose inputs moved are rebuilt.
    ],
    chip("fixed", tint: spectrum.at(4)),
    text(size: 14pt)[
      Relative paths now resolve from the project root on every platform.
    ],
  )
  #v(0.6cm)
  #line(length: 100%, stroke: 4pt + spectrum.at(4))
  #v(0.45cm)
  #block(width: 100%, text(size: 14pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: slab)[
  #place(
    right + horizon,
    dx: 3.4cm,
    dy: 0.6cm,
    rotate(-14deg, text(
      font: display,
      size: 300pt,
      weight: 900,
      fill: spectrum.at(5).transparentize(80%),
    )[!]),
  )
  #place(
    left + horizon,
    dx: 1.7cm,
    block(width: 15.4cm)[
      #text(font: mono, size: 10.5pt, weight: 600, fill: spectrum.at(5).lighten(35%), tracking: 2pt)[
        #upper("Get it")
      ]
      #v(0.5cm)
      #heading-1(tint: ground)[Install and build.]
      #v(0.65cm)
      #block(
        width: 100%,
        fill: ground,
        inset: (x: 0.65cm, y: 0.55cm),
        stroke: (left: 5pt + spectrum.at(5)),
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
      #text(font: mono, size: 13.5pt, weight: 600, fill: spectrum.at(5).lighten(35%))[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #band(6)
  #place(
    bottom + left,
    dx: 1.7cm,
    dy: -1.5cm,
    block(width: 17.6cm)[
      #grid(
        columns: (1fr, auto),
        text(font: mono, size: 9pt, fill: hair)[#date],
        text(font: mono, size: 9pt, fill: hair)[#project #version #sym.dot.op 6 / 6],
      )
    ],
  )
]
