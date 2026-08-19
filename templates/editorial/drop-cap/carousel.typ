// editorial/drop-cap: bone paper and gold rules, a serif column opening on a drop cap.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#f6f1e7") // page fill
#let paper = rgb("#fffdf7") // light panel
#let ink = rgb("#221d16") // body text
#let muted = rgb("#7a6f5d") // secondary text
#let hair = rgb("#d9cdb5") // rules and borders
#let accent = rgb("#b5830a") // the one accent
#let slab = rgb("#221d16") // code background
#let slab-fg = rgb("#f0e7d5") // code foreground

#let display = "Source Serif 4"
#let body = "Source Sans 3"
#let mono = "JetBrains Mono"

#set page(width: 21cm, height: 21cm, margin: 0cm, fill: ground)
#set text(font: body, fill: ink, size: 15.5pt)
#set raw(theme: none)
// Ligatures off: a code font that draws `&&` or `!=` as one merged glyph is
// unreadable at slide sizes.
#show raw: set text(font: mono, ligatures: false)

// --- HELPERS ---

#let url-link(url) = link("https://" + url, url)

#let kicker(txt, tint: accent) = text(
  font: mono,
  size: 11pt,
  weight: 600,
  fill: tint,
  tracking: 2pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  fill: tint.lighten(82%),
  stroke: 0.6pt + tint.lighten(40%),
  radius: 2pt,
  inset: (x: 7pt, y: 4pt),
  text(font: mono, size: 10.5pt, weight: 600, fill: tint.darken(20%), txt),
)

#let code-slab(body, size: 13pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  radius: 3pt,
  inset: (x: 0.7cm, y: 0.55cm),
  stroke: (left: 3pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  radius: 2pt,
  stroke: 1pt + hair,
  image(path, width: width),
)

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.9cm,
  dy: -1.25cm,
  block(width: 17.2cm)[
    #line(length: 100%, stroke: 0.6pt + hair)
    #v(0.32cm)
    #grid(
      columns: (1fr, auto),
      text(font: mono, size: 9.5pt, fill: muted)[
        #url-link("github.com/mcanouil/typst-carousel-gallery")
      ],
      text(font: mono, size: 9.5pt, fill: muted)[
        #project #sym.dot.op v#version #sym.dot.op #if n != none { [#n / #total] }
      ],
    )
  ],
)

// A gold rule with a small square at its left end, the recurring editorial mark.
#let rule = block(width: 100%)[
  #place(left + horizon, rect(width: 0.34cm, height: 0.34cm, fill: accent))
  #line(start: (0.62cm, 0pt), length: 100% - 0.62cm, stroke: 0.8pt + hair)
]

// The drop cap: an oversized serif initial set beside the paragraph it opens.
#let drop-cap(letter, body) = grid(
  columns: (1.9cm, 1fr),
  gutter: 0.28cm,
  text(font: display, size: 62pt, weight: 700, fill: accent, baseline: 8pt, letter),
  text(size: 16pt, fill: ink, body),
)

#let heading-1(txt) = text(font: display, size: 34pt, weight: 700, fill: ink, txt)

#let slide(n: none, body) = page(fill: ground)[
  #place(top + left, dx: 1.9cm, dy: 1.6cm, block(width: 17.2cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #place(top + left, dx: 1.9cm, dy: 1.9cm, rect(width: 1.1cm, height: 0.16cm, fill: accent))
  #place(
    left + horizon,
    dx: 1.9cm,
    block(width: 17.2cm)[
      #kicker("Release")
      #v(0.5cm)
      #text(font: display, size: 76pt, weight: 700, fill: ink)[#project]
      #v(-0.35cm)
      #text(font: display, size: 40pt, weight: 400, fill: accent)[#version]
      #v(0.5cm)
      #block(width: 13cm, text(size: 19pt, fill: muted)[
        Build every report from one command, in whatever format the reader asked for.
      ])
    ],
  )
  #footer(n: 1)
]

// 02 The gap
#slide(n: 2)[
  #kicker("The gap")
  #v(0.45cm)
  #heading-1[Six scripts, four formats, one deadline.]
  #v(0.5cm)
  #rule
  #v(0.6cm)
  #drop-cap("E")[
    Every project grows its own build script, and then a second one for the
    slides, and a third for the print version. They drift. The one that
    matters is always the one nobody ran.
  ]
  #v(0.5cm)
  #block(width: 15cm, text(size: 16pt, fill: muted)[
    A build is a fact about a project, not a habit of the person who last
    shipped it.
  ])
]

// 03 The mechanic
#slide(n: 3)[
  #kicker("How it works")
  #v(0.45cm)
  #heading-1[One command, every target.]
  #v(0.5cm)
  #rule
  #v(0.6cm)
  #block(width: 15.6cm, text(size: 16pt, fill: muted)[
    Declare the targets once. #project reads them, builds only what changed,
    and writes each one where it belongs.
  ])
  #v(0.55cm)
  #code-slab(size: 13.5pt)[
    ```yaml
    targets:
      report:  {format: pdf,  profile: release}
      slides:  {format: html, profile: talk}
      archive: {format: docx, profile: release}
    ```
  ]
  #v(0.4cm)
  #code-slab(size: 13.5pt)[
    ```bash
    acme build --profile release
    ```
  ]
]

// 04 Where it pays off
#slide(n: 4)[
  #kicker("Where it pays off")
  #v(0.45cm)
  #heading-1[Three places it earns its keep.]
  #v(0.5cm)
  #rule
  #v(0.7cm)
  #grid(
    columns: (1fr,),
    row-gutter: 0.85cm,
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
      #text(font: display, size: 19pt, weight: 700, fill: ink)[#item.at(0)]
      #v(0.14cm)
      #text(size: 15pt, fill: muted)[#item.at(1)]
    ])
  )
]

// 05 What is in this release
#slide(n: 5)[
  #kicker("In " + version)
  #v(0.45cm)
  #heading-1[What changed.]
  #v(0.5cm)
  #rule
  #v(0.65cm)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.55cm,
    row-gutter: 0.5cm,
    chip("New"),
    text(size: 16pt)[
      Profiles. One target set, several build shapes, no duplicated
      configuration.
    ],
    chip("New"),
    text(size: 16pt)[
      Incremental builds. Only the targets whose inputs moved are rebuilt.
    ],
    chip("Fixed"),
    text(size: 16pt)[
      Relative paths now resolve from the project root on every platform.
    ],
  )
  #v(0.7cm)
  #block(width: 15cm, text(size: 15pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working
    unchanged.
  ])
]

// 06 Ship
#page(fill: ink)[
  #place(top + left, dx: 1.9cm, dy: 1.9cm, rect(width: 1.1cm, height: 0.16cm, fill: accent))
  #place(
    left + horizon,
    dx: 1.9cm,
    block(width: 17.2cm)[
      #text(font: mono, size: 11pt, weight: 600, fill: accent, tracking: 2pt)[#upper("Get it")]
      #v(0.5cm)
      #text(font: display, size: 44pt, weight: 700, fill: ground)[Install and build.]
      #v(0.65cm)
      #block(
        width: 100%,
        fill: ground.darken(4%),
        radius: 3pt,
        inset: (x: 0.7cm, y: 0.55cm),
        stroke: (left: 3pt + accent),
        text(font: mono, size: 14pt, fill: ink)[
          ```bash
          brew install acme-kit && acme init
          ```
        ],
      )
      #v(0.75cm)
      #text(size: 16pt, fill: ground.darken(18%))[
        Source, documentation, and every template in this gallery:
      ]
      #v(0.2cm)
      #text(font: mono, size: 14pt, fill: accent)[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #place(
    bottom + left,
    dx: 1.9cm,
    dy: -1.25cm,
    block(width: 17.2cm)[
      #line(length: 100%, stroke: 0.6pt + muted.darken(20%))
      #v(0.32cm)
      #grid(
        columns: (1fr, auto),
        text(font: mono, size: 9.5pt, fill: muted.lighten(20%))[#date],
        text(font: mono, size: 9.5pt, fill: muted.lighten(20%))[
          #project #sym.dot.op v#version #sym.dot.op 6 / 6
        ],
      )
    ],
  )
]
