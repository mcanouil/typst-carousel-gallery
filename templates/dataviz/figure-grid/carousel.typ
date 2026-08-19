// dataviz/figure-grid: small multiples, a grid of captioned figures carrying each slide.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#f2f4f6") // page fill
#let paper = rgb("#ffffff") // light panel
#let ink = rgb("#111820") // body text
#let muted = rgb("#5d6b7a") // secondary text
#let hair = rgb("#d5dbe2") // rules and borders
#let accent = rgb("#1f6feb") // the one accent
#let slab = rgb("#111820") // code background
#let slab-fg = rgb("#eef2f6") // code foreground

#let display = "Public Sans"
#let body = "Public Sans"
#let mono = "Space Mono"

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
  tracking: 1.4pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  fill: tint.lighten(88%),
  radius: 3pt,
  inset: (x: 7pt, y: 4pt),
  text(font: mono, size: 10pt, weight: 700, fill: tint.darken(12%), txt),
)

#let code-slab(body, size: 12.5pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  radius: 4pt,
  inset: (x: 0.65cm, y: 0.55cm),
  stroke: (left: 3pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  radius: 4pt,
  stroke: 1pt + hair,
  image(path, width: width),
)

// The three chart shapes the deck uses. Each takes a series and a box, and
// draws inside it with rectangles or line segments. A shared `high` keeps two
// figures on one scale when they are meant to be compared.
#let bars(values, width, height, tint: accent, high: none) = {
  let high = if high == none { calc.max(..values) } else { high }
  let slot = width / values.len()
  block(width: width, height: height)[
    #for index in range(values.len()) {
      place(left + bottom, dx: index * slot, rect(
        width: slot * 0.68,
        height: values.at(index) / high * height,
        fill: tint,
        stroke: none,
      ))
    }
  ]
}

// `low` defaults to zero rather than to the smallest value, so a series that
// does not vary plots as a flat line partway up rather than flat on the
// baseline, where it reads as a broken chart.
#let sparkline(values, width, height, tint: accent, low: 0, high: none) = {
  let high = if high == none { calc.max(..values) } else { high }
  let span = calc.max(high - low, 1)
  let step = width / (values.len() - 1)
  let point(index) = (index * step, height - (values.at(index) - low) / span * height)
  block(width: width, height: height)[
    #for index in range(values.len() - 1) {
      let from = point(index)
      let to = point(index + 1)
      place(left + top, dx: from.at(0), dy: from.at(1), line(
        end: (to.at(0) - from.at(0), to.at(1) - from.at(1)),
        stroke: 2.2pt + tint,
      ))
    }
  ]
}

#let dots(values, width, height, tint: accent, high: none) = {
  let high = if high == none { calc.max(..values) } else { high }
  let step = width / (values.len() - 1)
  block(width: width, height: height)[
    #for index in range(values.len()) {
      place(
        left + bottom,
        dx: index * step - 0.09cm,
        dy: -(values.at(index) / high * height) + 0.09cm,
        circle(radius: 0.09cm, fill: tint, stroke: none),
      )
    }
  ]
}

// One figure in the grid: a titled panel with the chart inside and a caption
// underneath, so every figure reads the same way.
#let figure-cell(title, caption, chart) = block(
  width: 100%,
  fill: paper,
  radius: 4pt,
  inset: 0.4cm,
  stroke: 1pt + hair,
)[
  #text(font: mono, size: 9pt, fill: muted, tracking: 1pt)[#upper(title)]
  #v(0.25cm)
  #chart
  #v(0.25cm)
  #text(size: 11.5pt, fill: muted)[#caption]
]

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.5cm,
  dy: -1.1cm,
  block(width: 18cm)[
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

#let heading-1(txt) = text(font: display, size: 30pt, weight: 700, fill: ink, txt)

#let slide(n: none, body) = page(fill: ground)[
  #place(top + left, dx: 1.5cm, dy: 1.6cm, block(width: 18cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #place(
    left + horizon,
    dx: 1.5cm,
    // Raised clear of the figure row placed at the foot of the slide.
    dy: -3.4cm,
    block(width: 18cm)[
      #kicker("Release")
      #v(0.5cm)
      #text(font: display, size: 64pt, weight: 700, fill: ink)[#project]
      #v(0.1cm)
      #text(font: mono, size: 26pt, weight: 700, fill: accent)[#version]
      #v(0.55cm)
      #block(width: 12.5cm, text(size: 16pt, fill: muted)[
        Build every report from one command, in whatever format the reader
        asked for.
      ])
    ],
  )
  #place(bottom + left, dx: 1.5cm, dy: -2.6cm, block(width: 18cm)[
    #grid(
      columns: (1fr, 1fr, 1fr),
      column-gutter: 0.5cm,
      figure-cell("targets", "Three formats from one file.", bars(
        (3, 5, 4),
        4.6cm,
        1.5cm,
        high: 6,
      )),
      figure-cell("build time", "Down, week on week.", sparkline(
        (34, 26, 19, 14, 11, 9),
        4.6cm,
        1.5cm,
      )),
      figure-cell("rebuilds", "Only what moved.", dots((5, 2, 3, 1, 1, 0), 4.6cm, 1.5cm, high: 6)),
    )
  ])
  #footer(n: 1)
]

// 02 The gap
#slide(n: 2)[
  #kicker("The gap")
  #v(0.4cm)
  #heading-1[Six scripts, four formats, one deadline.]
  #v(0.5cm)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 0.5cm,
    figure-cell(
      "scripts, by year",
      "One more every time a format is added.",
      bars((1, 2, 3, 4, 6), 7.6cm, 3.2cm, tint: rgb("#e5534b"), high: 6),
    ),
    block(width: 100%)[
      #text(size: 15pt)[
        Every project grows its own build script, and then a second one for the
        slides, and a third for the print version.
      ]
      #v(0.3cm)
      #text(size: 15pt, fill: accent)[
        A build is a fact about a project, not a habit of the person who last
        shipped it.
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
    column-gutter: 0.5cm,
    figure-cell(
      "monthly",
      "The same command in the same order, so the December build is the January build.",
      bars((4, 4, 4, 4, 4, 4), 5cm, 2.4cm, high: 6),
    ),
    figure-cell(
      "one source",
      "Two targets, one set of numbers. The slides cannot fall behind the manuscript.",
      sparkline((2, 2, 2, 2, 2, 2), 5cm, 2.4cm, high: 6),
    ),
    figure-cell(
      "handover",
      "The build is in the repository, not in the head of whoever set it up.",
      dots((1, 2, 3, 4, 5, 6), 5cm, 2.4cm, high: 6),
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
#page(fill: slab)[
  #place(
    left + horizon,
    dx: 1.5cm,
    dy: -0.8cm,
    block(width: 18cm)[
      #text(font: mono, size: 10.5pt, weight: 700, fill: accent.lighten(30%), tracking: 1.4pt)[
        #upper("Get it")
      ]
      #v(0.5cm)
      #text(font: display, size: 42pt, weight: 700, fill: ground)[Install and build.]
      #v(0.6cm)
      #block(
        width: 100%,
        fill: ground,
        radius: 4pt,
        inset: (x: 0.65cm, y: 0.55cm),
        stroke: (left: 3pt + accent),
        text(font: mono, size: 13pt, fill: ink)[
          ```bash
          brew install acme-kit && acme init
          ```
        ],
      )
      #v(0.6cm)
      #text(size: 14.5pt, fill: hair)[
        Source, documentation, and every template in this gallery:
      ]
      #v(0.2cm)
      #text(font: mono, size: 13pt, weight: 700, fill: accent.lighten(30%))[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #place(
    bottom + left,
    dx: 1.5cm,
    dy: -1.1cm,
    block(width: 18cm)[
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
