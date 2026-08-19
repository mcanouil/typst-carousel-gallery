// terminal/window: titled code windows floating on graphite, each slide a labelled panel.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#242a31") // page fill
#let paper = rgb("#2f363f") // light panel
#let ink = rgb("#e8ecf1") // body text
#let muted = rgb("#9aa5b1") // secondary text
#let hair = rgb("#3d4650") // rules and borders
#let accent = rgb("#f0a500") // the one accent
#let slab = rgb("#161b21") // code background
#let slab-fg = rgb("#e8ecf1") // code foreground

#let display = "IBM Plex Sans"
#let body = "IBM Plex Sans"
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
  tracking: 2pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  stroke: 1pt + tint,
  radius: 999pt,
  inset: (x: 8pt, y: 4pt),
  text(font: mono, size: 10pt, weight: 600, fill: tint, txt),
)

// A titled window: a name bar over a body. The whole deck is built from these,
// which is what makes a code panel and a prose panel read as the same object.
// The bar and the body are stacked rather than written as two blocks in a
// content sequence: block spacing would open a seam between them, and the
// rounded clip makes that seam read as a second bar.
#let window(title, fill-colour: paper, body) = block(
  width: 100%,
  radius: 6pt,
  clip: true,
  stroke: 1pt + hair,
  stack(
    dir: ttb,
    block(
      width: 100%,
      fill: hair,
      inset: (x: 0.5cm, y: 0.3cm),
      text(font: mono, size: 10.5pt, fill: muted)[#title],
    ),
    block(width: 100%, fill: fill-colour, inset: (x: 0.6cm, y: 0.5cm), body),
  ),
)

#let code-slab(body, size: 13pt, tint: accent) = window(
  "shell",
  fill-colour: slab,
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  radius: 6pt,
  stroke: 1pt + hair,
  image(path, width: width),
)

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.5cm,
  dy: -1cm,
  block(width: 18cm)[
    #grid(
      columns: (1fr, auto),
      text(font: mono, size: 9.5pt, fill: muted)[
        #url-link("github.com/mcanouil/typst-carousel-gallery")
      ],
      text(font: mono, size: 9.5pt, fill: muted)[
        #project #version #sym.dot.op #if n != none { [#n / #total] } #sym.dot.op #date
      ],
    )
  ],
)

#let heading-1(txt) = text(font: display, size: 31pt, weight: 600, fill: ink, txt)

#let slide(n: none, body) = page(fill: ground)[
  #place(top + left, dx: 1.5cm, dy: 1.5cm, block(width: 18cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #place(
    left + horizon,
    dx: 1.5cm,
    block(width: 18cm)[
      #kicker("Release")
      #v(0.5cm)
      #text(font: display, size: 66pt, weight: 600, fill: ink)[#project]
      #v(0.1cm)
      #text(font: mono, size: 28pt, weight: 600, fill: accent)[#version]
      #v(0.7cm)
      #block(width: 13cm, text(size: 16.5pt, fill: muted)[
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
  #window("scripts/")[
    #text(font: mono, size: 13pt, fill: muted)[
      build.sh#h(0.6cm)build-slides.sh#h(0.6cm)build-print.sh\
      render.sh#h(0.6cm)render-old.sh#h(0.6cm)FINAL-render.sh
    ]
  ]
  #v(0.55cm)
  #block(width: 16cm, text(size: 15.5pt, fill: muted)[
    They drift. The one that matters is always the one nobody ran. A build is a
    fact about a project, not a habit of the person who last shipped it.
  ])
]

// 03 The mechanic
#slide(n: 3)[
  #kicker("How it works")
  #v(0.4cm)
  #heading-1[One command, every target.]
  #v(0.55cm)
  #block(width: 16.5cm, text(size: 15pt, fill: muted)[
    Declare the targets once. #project reads them, builds only what changed, and
    writes each one where it belongs.
  ])
  #v(0.5cm)
  #window("acme.yml", fill-colour: slab)[
    #text(font: mono, size: 12.5pt, fill: slab-fg)[
      ```yaml
      targets:
        report:  {format: pdf,  profile: release}
        slides:  {format: html, profile: talk}
        archive: {format: docx, profile: release}
      ```
    ]
  ]
  #v(0.4cm)
  #code-slab(size: 13pt)[
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
    row-gutter: 0.45cm,
    ..(
      (
        "a report that ships monthly",
        "The same command in the same order, so the December build is the January build.",
      ),
      (
        "a paper and a talk from one source",
        "Two targets, one set of numbers. The slides cannot fall behind the manuscript.",
      ),
      (
        "a handover",
        "The build is in the repository, not in the head of whoever set it up.",
      ),
    ).map(item => window(item.at(0))[
      #text(size: 14.5pt, fill: muted)[#item.at(1)]
    ])
  )
]

// 05 What changed
#slide(n: 5)[
  #kicker("In " + version)
  #v(0.4cm)
  #heading-1[What changed.]
  #v(0.6cm)
  #window("CHANGELOG.md")[
    #grid(
      columns: (auto, 1fr),
      column-gutter: 0.5cm,
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
  ]
  #v(0.55cm)
  #block(width: 16.5cm, text(size: 14.5pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: accent)[
  #place(
    left + horizon,
    dx: 1.5cm,
    block(width: 18cm)[
      #text(font: mono, size: 10.5pt, weight: 600, fill: slab, tracking: 2pt)[#upper("Get it")]
      #v(0.5cm)
      #text(font: display, size: 44pt, weight: 600, fill: slab)[Install and build.]
      #v(0.7cm)
      #block(
        width: 100%,
        radius: 6pt,
        clip: true,
        stroke: 1pt + slab,
        stack(
          dir: ttb,
          block(
            width: 100%,
            fill: slab,
            inset: (x: 0.5cm, y: 0.3cm),
            text(font: mono, size: 10.5pt, fill: muted)[shell],
          ),
          block(
            width: 100%,
            fill: slab.lighten(6%),
            inset: (x: 0.6cm, y: 0.5cm),
            text(font: mono, size: 13.5pt, fill: slab-fg)[
              ```bash
              brew install acme-kit && acme init
              ```
            ],
          ),
        ),
      )
      #v(0.75cm)
      #text(size: 15pt, fill: slab)[
        Source, documentation, and every template in this gallery:
      ]
      #v(0.25cm)
      #text(font: mono, size: 13.5pt, weight: 600, fill: slab)[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #place(
    bottom + left,
    dx: 1.5cm,
    dy: -1cm,
    block(width: 18cm)[
      #grid(
        columns: (1fr, auto),
        text(font: mono, size: 9.5pt, fill: slab)[#date],
        text(font: mono, size: 9.5pt, fill: slab)[#project #version #sym.dot.op 6 / 6],
      )
    ],
  )
]
