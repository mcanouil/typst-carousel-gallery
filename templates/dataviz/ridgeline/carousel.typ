// dataviz/ridgeline: stacked density bands run under every slide, the page motif and the chart at once.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#fdfaf5") // page fill
#let paper = rgb("#ffffff") // light panel
#let ink = rgb("#1e2b2b") // body text
#let muted = rgb("#5f7373") // secondary text
#let hair = rgb("#dfe6e2") // rules and borders
#let accent = rgb("#0e7c86") // the one accent
#let slab = rgb("#12201f") // code background
#let slab-fg = rgb("#eef5f2") // code foreground

#let display = "Sora"
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
  fill: tint.lighten(86%),
  radius: 999pt,
  inset: (x: 9pt, y: 4.5pt),
  text(font: mono, size: 10pt, weight: 700, fill: tint.darken(10%), txt),
)

#let code-slab(body, size: 12.5pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  radius: 6pt,
  inset: (x: 0.65cm, y: 0.55cm),
  stroke: (left: 4pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  radius: 6pt,
  stroke: 1pt + hair,
  image(path, width: width),
)

// One density band: a smooth hump drawn as a run of vertical bars, so the
// shape needs no path primitive and no external package.
#let band(width: 21cm, height: 2.6cm, centre: 0.5, spread: 0.22, tint: accent) = {
  let steps = 130
  block(width: width, height: height)[
    #for step in range(steps) {
      let position = step / (steps - 1)
      let offset = (position - centre) / spread
      let value = calc.exp(-0.5 * offset * offset)
      let bar = value * height
      place(
        left + bottom,
        dx: position * width,
        rect(width: width / steps + 0.5pt, height: bar, fill: tint, stroke: none),
      )
    }
  ]
}

// The stack of bands the deck is named for. Later bands are drawn over earlier
// ones, which is what gives a ridgeline its overlapping profile.
#let ridges(dy: 0cm, opacity: 100%) = place(bottom + left, dy: dy, block(width: 21cm)[
  #for entry in (
    (0.18, 0.16, accent.lighten(72%)),
    (0.42, 0.19, accent.lighten(55%)),
    (0.68, 0.15, accent.lighten(38%)),
    (0.86, 0.12, accent.lighten(20%)),
  ) {
    place(bottom + left, band(
      centre: entry.at(0),
      spread: entry.at(1),
      tint: entry.at(2).transparentize(100% - opacity),
    ))
  }
])

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.7cm,
  // Above the bands, not on them. The ridges fill the bottom 2.6 cm, and a
  // footer set over them is unreadable against the darkest band.
  dy: -3.1cm,
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

#let heading-1(txt) = text(font: display, size: 31pt, weight: 700, fill: ink, txt)

#let slide(n: none, body) = page(fill: ground)[
  #ridges(dy: 0cm, opacity: 55%)
  #place(top + left, dx: 1.7cm, dy: 1.7cm, block(width: 17.6cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #ridges()
  #place(
    top + left,
    dx: 1.7cm,
    dy: 3.4cm,
    block(width: 17.6cm)[
      #kicker("Release")
      #v(0.5cm)
      #text(font: display, size: 64pt, weight: 700, fill: ink)[#project]
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
  #v(0.55cm)
  #block(width: 15cm, text(size: 15.5pt)[
    Every project grows its own build script, and then a second one for the
    slides, and a third for the print version. They drift. The one that matters
    is always the one nobody ran.
  ])
  #v(0.5cm)
  #block(
    width: 15cm,
    fill: paper,
    radius: 6pt,
    inset: 0.5cm,
    stroke: 1pt + hair,
    text(size: 15pt, fill: accent)[
      A build is a fact about a project, not a habit of the person who last
      shipped it.
    ],
  )
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
  #v(0.55cm)
  #grid(
    columns: (1fr,),
    row-gutter: 0.4cm,
    ..(
      (
        accent.lighten(55%),
        "A report that ships monthly",
        "The same command in the same order, so the December build is the January build.",
      ),
      (
        accent.lighten(38%),
        "A paper and a talk from one source",
        "Two targets, one set of numbers. The slides cannot fall behind the manuscript.",
      ),
      (
        accent.lighten(20%),
        "A handover",
        "The build is in the repository, not in the head of whoever set it up.",
      ),
    ).map(item => block(width: 100%, fill: paper, radius: 6pt, inset: 0.42cm, stroke: 1pt + hair)[
      #grid(
        columns: (auto, 1fr),
        column-gutter: 0.45cm,
        align: horizon,
        band(width: 2.4cm, height: 0.95cm, tint: item.at(0)),
        block[
          #text(font: display, size: 15.5pt, weight: 700, fill: ink)[#item.at(1)]
          #v(0.06cm)
          #text(size: 12.5pt, fill: muted)[#item.at(2)]
        ],
      )
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
  #v(0.6cm)
  #line(length: 15.5cm, stroke: 1pt + hair)
  #v(0.45cm)
  #block(width: 15.5cm, text(size: 14pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: slab)[
  #place(bottom + left, block(width: 21cm)[
    #for entry in (
      (0.18, 0.16, accent.darken(30%)),
      (0.42, 0.19, accent.darken(15%)),
      (0.68, 0.15, accent),
      (0.86, 0.12, accent.lighten(20%)),
    ) {
      place(bottom + left, band(centre: entry.at(0), spread: entry.at(1), tint: entry.at(2)))
    }
  ])
  #place(
    top + left,
    dx: 1.7cm,
    dy: 3.2cm,
    block(width: 17.6cm)[
      #text(font: mono, size: 10.5pt, weight: 700, fill: accent.lighten(45%), tracking: 1.4pt)[
        #upper("Get it")
      ]
      #v(0.5cm)
      #text(font: display, size: 40pt, weight: 700, fill: ground)[Install and build.]
      #v(0.6cm)
      #block(
        width: 100%,
        fill: ground,
        radius: 6pt,
        inset: (x: 0.65cm, y: 0.55cm),
        stroke: (left: 4pt + accent),
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
      #text(font: mono, size: 13pt, weight: 700, fill: accent.lighten(45%))[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #place(
    bottom + left,
    dx: 1.7cm,
    dy: -1.1cm,
    block(width: 17.6cm)[
      #grid(
        columns: (1fr, auto),
        text(font: mono, size: 9pt, fill: ground)[#date],
        text(font: mono, size: 9pt, fill: ground)[#project #version #sym.dot.op 6 / 6],
      )
    ],
  )
]
