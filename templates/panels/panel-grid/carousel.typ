// panels/panel-grid: numbered panels laid on a dotted ground, two or three to a slide.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#101418") // page fill
#let paper = rgb("#1a2027") // light panel
#let ink = rgb("#e9edf2") // body text
#let muted = rgb("#8b97a5") // secondary text
#let hair = rgb("#2b333d") // rules and borders
#let accent = rgb("#5ad1a5") // the one accent
#let slab = rgb("#070a0d") // code background
#let slab-fg = rgb("#e9edf2") // code foreground

#let display = "Space Grotesk"
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
  stroke: 1pt + tint,
  radius: 2pt,
  inset: (x: 7pt, y: 4pt),
  text(font: mono, size: 10pt, weight: 600, fill: tint, txt),
)

#let code-slab(body, size: 12.5pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  radius: 3pt,
  inset: (x: 0.6cm, y: 0.5cm),
  stroke: (left: 3pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  radius: 3pt,
  stroke: 1pt + hair,
  image(path, width: width),
)

// The dotted ground: a 0.6 cm lattice of small dots behind every slide.
#let dot-grid = place(top + left, block(width: 21cm, height: 21cm)[
  #for column in range(1, 35) {
    for row in range(1, 35) {
      place(
        left + top,
        dx: column * 0.6cm,
        dy: row * 0.6cm,
        circle(radius: 0.035cm, fill: hair, stroke: none),
      )
    }
  }
])

// One numbered panel. The number sits in a corner tab, so a grid of panels
// still reads in order.
#let panel(number, title, body) = block(
  width: 100%,
  height: 100%,
  fill: paper,
  radius: 4pt,
  inset: 0.55cm,
  stroke: 1pt + hair,
)[
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.4cm,
    align: horizon,
    box(fill: accent, radius: 2pt, inset: (x: 6pt, y: 3pt), text(
      font: mono,
      size: 10pt,
      weight: 700,
      fill: ground,
    )[#number]),
    text(font: display, size: 15.5pt, weight: 700, fill: ink)[#title],
  )
  #v(0.3cm)
  #body
]

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.6cm,
  dy: -1.1cm,
  block(width: 17.8cm)[
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

#let heading-1(txt) = text(font: display, size: 30pt, weight: 700, fill: ink, txt)

#let slide(n: none, body) = page(fill: ground)[
  #dot-grid
  #place(top + left, dx: 1.6cm, dy: 1.7cm, block(width: 17.8cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #dot-grid
  #place(
    left + horizon,
    dx: 1.6cm,
    block(width: 17.8cm)[
      #kicker("Release")
      #v(0.5cm)
      #text(font: display, size: 66pt, weight: 700, fill: ink)[#project]
      #v(0.1cm)
      #text(font: mono, size: 26pt, weight: 600, fill: accent)[#version]
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
  #v(0.55cm)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 0.5cm,
    rows: (5.6cm,),
    panel("01", "They multiply")[
      #text(size: 14pt, fill: muted)[
        Every project grows its own build script, and then a second one for the
        slides, and a third for the print version.
      ]
    ],
    panel("02", "They drift")[
      #text(size: 14pt, fill: muted)[
        The one that matters is always the one nobody ran. A build is a fact
        about a project, not a habit of the person who last shipped it.
      ]
    ],
  )
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
  #v(0.55cm)
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 0.45cm,
    rows: (6.2cm,),
    panel("01", "Monthly")[
      #text(size: 13pt, fill: muted)[
        The same command in the same order, so the December build is the January
        build.
      ]
    ],
    panel("02", "One source")[
      #text(size: 13pt, fill: muted)[
        Two targets, one set of numbers. The slides cannot fall behind the
        manuscript.
      ]
    ],
    panel("03", "Handover")[
      #text(size: 13pt, fill: muted)[
        The build is in the repository, not in the head of whoever set it up.
      ]
    ],
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
        radius: 3pt,
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
      #grid(
        columns: (1fr, auto),
        text(font: mono, size: 9pt, fill: ground)[#date],
        text(font: mono, size: 9pt, fill: ground)[#project #version #sym.dot.op 6 / 6],
      )
    ],
  )
]
