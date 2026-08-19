// dataviz/sparkline: a dark deck where a line chart, drawn from Typst primitives, carries the argument.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#0f1420") // page fill
#let paper = rgb("#182031") // light panel
#let ink = rgb("#e4e9f2") // body text
#let muted = rgb("#8792a8") // secondary text
#let hair = rgb("#26304a") // rules and borders
#let accent = rgb("#4ea8ff") // the one accent
#let slab = rgb("#080b12") // code background
#let slab-fg = rgb("#e4e9f2") // code foreground

#let display = "Space Grotesk"
#let body = "Inter"
#let mono = "Space Mono"

#set page(width: 21cm, height: 21cm, margin: 0cm, fill: ground)
#set text(font: body, fill: ink, size: 15pt)
#set raw(theme: none)
// Ligatures off: a code font that draws `&&` or `!=` as one merged glyph is
// unreadable at slide sizes.
#show raw: set text(font: mono, ligatures: false)

// The series the deck plots: build minutes per week, before and after.
#let before = (34, 31, 38, 36, 41, 37, 44, 40, 46, 43, 49, 47)
#let after = (34, 30, 26, 24, 19, 17, 14, 13, 11, 10, 9, 9)

// --- HELPERS ---

#let url-link(url) = link("https://" + url, url)

#let kicker(txt, tint: accent) = text(
  font: mono,
  size: 10.5pt,
  weight: 700,
  fill: tint,
  tracking: 1.6pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  fill: tint.darken(60%),
  radius: 2pt,
  inset: (x: 7pt, y: 4pt),
  text(font: mono, size: 10pt, weight: 700, fill: tint, txt),
)

#let code-slab(body, size: 12.5pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  radius: 3pt,
  inset: (x: 0.65cm, y: 0.55cm),
  stroke: (left: 3pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  radius: 3pt,
  stroke: 1pt + hair,
  image(path, width: width),
)

// A polyline over a series, drawn segment by segment. Typst has no chart
// primitive, so the scale is worked out here and the line is a run of
// `line()` calls inside one placed block.
// `low` and `high` fix the scale. Two series drawn on one chart MUST be given
// the same pair, or each is normalised to its own range and the comparison the
// chart appears to make is false.
#let plot-line(
  values,
  width,
  height,
  tint: accent,
  thickness: 2.6pt,
  dots: false,
  low: none,
  high: none,
) = {
  let low = if low == none { calc.min(..values) } else { low }
  let high = if high == none { calc.max(..values) } else { high }
  let span = calc.max(high - low, 1)
  let step = width / (values.len() - 1)
  let point(index) = (
    index * step,
    height - (values.at(index) - low) / span * height,
  )
  block(width: width, height: height)[
    #for index in range(values.len() - 1) {
      let from = point(index)
      let to = point(index + 1)
      place(
        left + top,
        dx: from.at(0),
        dy: from.at(1),
        line(end: (to.at(0) - from.at(0), to.at(1) - from.at(1)), stroke: thickness + tint),
      )
    }
    #if dots {
      for index in range(values.len()) {
        let at = point(index)
        place(left + top, dx: at.at(0) - 0.09cm, dy: at.at(1) - 0.09cm, circle(
          radius: 0.09cm,
          fill: tint,
          stroke: none,
        ))
      }
    }
  ]
}

// A chart panel: gridlines, an axis, and one or two series over them.
#let chart(width: 15.5cm, height: 6.6cm, body) = block(
  width: width,
  height: height,
  fill: paper,
  radius: 4pt,
  inset: 0.55cm,
)[
  #place(top + left, dx: 0.55cm, dy: 0.55cm, block(width: width - 1.1cm, height: height - 1.1cm)[
    #for row in range(1, 4) {
      place(
        left + top,
        dy: row * (height - 1.1cm) / 4,
        line(end: (width - 1.1cm, 0cm), stroke: 0.6pt + hair),
      )
    }
  ])
  #place(top + left, dx: 0.55cm, dy: 0.55cm, body)
]

// The sparkline that runs in the footer of every slide, a compressed reminder
// of the same series.
#let spark = plot-line(after, 3.2cm, 0.5cm, tint: accent.darken(15%), thickness: 1.4pt)

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.6cm,
  dy: -1.2cm,
  block(width: 17.8cm)[
    #line(length: 100%, stroke: 0.8pt + hair)
    #v(0.3cm)
    #grid(
      columns: (auto, 1fr, auto),
      column-gutter: 0.6cm,
      align: horizon,
      spark,
      text(font: mono, size: 9pt, fill: muted)[
        #url-link("github.com/mcanouil/typst-carousel-gallery")
      ],
      text(font: mono, size: 9pt, fill: muted)[
        #project #version #sym.dot.op #if n != none { [#n / #total] }
      ],
    )
  ],
)

#let heading-1(txt) = text(font: display, size: 32pt, weight: 700, fill: ink, txt)

#let slide(n: none, body) = page(fill: ground)[
  #place(top + left, dx: 1.6cm, dy: 1.7cm, block(width: 17.8cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #place(top + left, dy: 2.4cm, plot-line(after, 21cm, 7cm, tint: hair, thickness: 2pt))
  #place(
    left + horizon,
    dx: 1.6cm,
    dy: 0.6cm,
    block(width: 17.8cm)[
      #kicker("Release")
      #v(0.5cm)
      #text(font: display, size: 68pt, weight: 700, fill: ink)[#project]
      #v(0.1cm)
      #text(font: mono, size: 26pt, weight: 700, fill: accent)[#version]
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
  #v(0.5cm)
  #chart(height: 6.2cm)[
    #plot-line(before, 14.4cm, 5.1cm, tint: rgb("#f2704a"))
  ]
  #v(0.4cm)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.5cm,
    chip("before"),
    text(size: 14.5pt, fill: muted)[
      Build minutes per week, climbing. They drift, and the one that matters is
      always the one nobody ran.
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

// 04 The result
#slide(n: 4)[
  #kicker("Where it pays off")
  #v(0.4cm)
  #heading-1[Three places it earns its keep.]
  #v(0.5cm)
  // One scale for both series, so the fall is real rather than an artefact of
  // normalising each line to its own range.
  #chart(height: 5.4cm)[
    #plot-line(before, 14.4cm, 4.3cm, tint: hair.lighten(12%), thickness: 2pt, low: 0, high: 50)
    #place(top + left, plot-line(after, 14.4cm, 4.3cm, dots: true, low: 0, high: 50))
  ]
  #v(0.4cm)
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 0.5cm,
    ..(
      ("Monthly", "December's build is January's build."),
      ("One source", "The slides cannot fall behind the manuscript."),
      ("Handover", "The build is in the repository, not in a head."),
    ).map(item => block(width: 100%)[
      #text(font: display, size: 14.5pt, weight: 700, fill: accent)[#item.at(0)]
      #v(0.08cm)
      #text(size: 12.5pt, fill: muted)[#item.at(1)]
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
  #v(0.65cm)
  #line(length: 100%, stroke: 0.8pt + hair)
  #v(0.45cm)
  #block(width: 16cm, text(size: 14pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: accent)[
  #place(top + left, dy: 12cm, plot-line(after, 21cm, 7cm, tint: ground.lighten(8%), thickness: 2.4pt))
  #place(
    left + horizon,
    dx: 1.6cm,
    dy: -1.4cm,
    block(width: 17.8cm)[
      #text(font: mono, size: 10.5pt, weight: 700, fill: ground, tracking: 1.6pt)[#upper("Get it")]
      #v(0.5cm)
      #text(font: display, size: 42pt, weight: 700, fill: ground)[Install and build.]
      #v(0.6cm)
      #block(
        width: 100%,
        fill: ground,
        radius: 3pt,
        inset: (x: 0.65cm, y: 0.55cm),
        text(font: mono, size: 13.5pt, fill: ink)[
          ```bash
          brew install acme-kit && acme init
          ```
        ],
      )
      #v(0.6cm)
      #text(font: mono, size: 13.5pt, weight: 700, fill: ground)[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #place(
    bottom + left,
    dx: 1.6cm,
    dy: -1.2cm,
    block(width: 17.8cm)[
      #grid(
        columns: (1fr, auto),
        text(font: mono, size: 9pt, fill: ground)[#date],
        text(font: mono, size: 9pt, fill: ground)[#project #version #sym.dot.op 6 / 6],
      )
    ],
  )
]
