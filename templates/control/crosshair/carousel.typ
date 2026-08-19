// control/crosshair: chalk ground with crosshair marks pinning each idea, and state chips beside it.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#eeeae3") // page fill
#let paper = rgb("#ffffff") // light panel
#let ink = rgb("#20211f") // body text
#let muted = rgb("#6d6f6a") // secondary text
#let hair = rgb("#cdc9c1") // rules and borders
#let accent = rgb("#00736b") // the one accent
#let slab = rgb("#20211f") // code background
#let slab-fg = rgb("#eeeae3") // code foreground

#let display = "Inter"
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
  tracking: 1.8pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  stroke: 1.2pt + tint,
  inset: (x: 7pt, y: 3.5pt),
  text(font: mono, size: 10pt, weight: 700, fill: tint, txt),
)

#let code-slab(body, size: 12.5pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  inset: (x: 0.6cm, y: 0.5cm),
  stroke: (left: 3pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  stroke: 1.2pt + hair,
  image(path, width: width),
)

// One crosshair: a small open cross with a gap at its centre, the mark this
// deck pins every idea with.
#let crosshair(size: 0.42cm, tint: accent, thickness: 1.1pt) = block(
  width: size * 2,
  height: size * 2,
)[
  #place(left + horizon, line(end: (size * 0.62, 0cm), stroke: thickness + tint))
  #place(right + horizon, line(end: (-size * 0.62, 0cm), stroke: thickness + tint))
  #place(center + top, line(end: (0cm, size * 0.62), stroke: thickness + tint))
  #place(center + bottom, line(end: (0cm, -size * 0.62), stroke: thickness + tint))
  #place(center + horizon, circle(radius: size * 0.2, stroke: thickness + tint))
]

// The four corner marks that frame the working area of every slide.
#let corner-marks = {
  let mark(x, y) = place(top + left, dx: x, dy: y, crosshair(size: 0.32cm, tint: hair.darken(18%)))
  mark(1cm, 1cm)
  mark(19.36cm, 1cm)
  mark(1cm, 19.36cm)
  mark(19.36cm, 19.36cm)
}

// A pinned point: the crosshair, then the idea beside it.
#let pinned(title, detail) = grid(
  columns: (auto, 1fr),
  column-gutter: 0.5cm,
  align: horizon,
  crosshair(),
  block[
    #text(font: display, size: 16.5pt, weight: 700, fill: ink)[#title]
    #v(0.06cm)
    #text(size: 13.5pt, fill: muted)[#detail]
  ],
)

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 2.2cm,
  dy: -1.55cm,
  block(width: 16.6cm)[
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
  #corner-marks
  #place(top + left, dx: 2.2cm, dy: 2.2cm, block(width: 16.6cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #corner-marks
  #place(
    left + horizon,
    dx: 2.2cm,
    block(width: 16.6cm)[
      #kicker("Release")
      #v(0.5cm)
      #text(font: display, size: 66pt, weight: 700, fill: ink)[#project]
      #v(0.1cm)
      #grid(
        columns: (auto, auto),
        column-gutter: 0.45cm,
        align: horizon,
        crosshair(size: 0.5cm),
        text(font: mono, size: 26pt, weight: 700, fill: accent)[#version],
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
  #v(0.55cm)
  #block(width: 15cm, text(size: 15.5pt)[
    Every project grows its own build script, and then a second one for the
    slides, and a third for the print version. They drift. The one that matters
    is always the one nobody ran.
  ])
  #v(0.55cm)
  #grid(
    columns: (auto, auto, auto),
    column-gutter: 0.35cm,
    chip("stale"),
    chip("untested"),
    chip("never run"),
  )
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt + hair)
  #v(0.45cm)
  #block(width: 15cm, text(size: 15.5pt, fill: accent)[
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
    row-gutter: 0.6cm,
    pinned(
      "A report that ships monthly",
      "The same command in the same order, so the December build is the January build.",
    ),
    pinned(
      "A paper and a talk from one source",
      "Two targets, one set of numbers. The slides cannot fall behind the manuscript.",
    ),
    pinned(
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
    row-gutter: 0.55cm,
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
  #block(width: 15.5cm, text(size: 14pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: ink)[
  #{
    let mark(x, y) = place(top + left, dx: x, dy: y, crosshair(size: 0.32cm, tint: muted))
    mark(1cm, 1cm)
    mark(19.36cm, 1cm)
    mark(1cm, 19.36cm)
    mark(19.36cm, 19.36cm)
  }
  #place(
    left + horizon,
    dx: 2.2cm,
    block(width: 16.6cm)[
      #text(font: mono, size: 10.5pt, weight: 700, fill: accent.lighten(45%), tracking: 1.8pt)[
        #upper("Get it")
      ]
      #v(0.5cm)
      #text(font: display, size: 42pt, weight: 700, fill: ground)[Install and build.]
      #v(0.65cm)
      #block(
        width: 100%,
        fill: ground,
        inset: (x: 0.6cm, y: 0.5cm),
        stroke: (left: 3pt + accent),
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
      #text(font: mono, size: 13.5pt, weight: 700, fill: accent.lighten(45%))[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #place(
    bottom + left,
    dx: 2.2cm,
    dy: -1.55cm,
    block(width: 16.6cm)[
      #line(length: 100%, stroke: 1pt + muted)
      #v(0.28cm)
      #grid(
        columns: (1fr, auto),
        text(font: mono, size: 9pt, fill: hair)[#date],
        text(font: mono, size: 9pt, fill: hair)[#project #version #sym.dot.op 6 / 6],
      )
    ],
  )
]
