// poster/pulp: halftone dots, a starburst, and shouting display type.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#fff4d6") // page fill
#let paper = rgb("#fffdf6") // light panel
#let ink = rgb("#161210") // body text
#let muted = rgb("#6b5f4f") // secondary text
#let hair = rgb("#161210") // rules and borders
#let accent = rgb("#e23c1f") // the one accent
#let slab = rgb("#161210") // code background
#let slab-fg = rgb("#fff4d6") // code foreground

#let display = "Bangers"
#let body = "Comic Neue"
#let mono = "Space Mono"

#set page(width: 21cm, height: 21cm, margin: 0cm, fill: ground)
#set text(font: body, fill: ink, size: 16pt)
#set raw(theme: none)
// Ligatures off: a code font that draws `&&` or `!=` as one merged glyph is
// unreadable at slide sizes.
#show raw: set text(font: mono, ligatures: false)

// --- HELPERS ---

#let url-link(url) = link("https://" + url, url)

#let kicker(txt, tint: accent) = text(
  font: mono,
  size: 11pt,
  weight: 700,
  fill: tint,
  tracking: 1.6pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  fill: tint,
  stroke: 2pt + ink,
  inset: (x: 8pt, y: 4pt),
  text(font: mono, size: 10.5pt, weight: 700, fill: ground, txt),
)

#let code-slab(body, size: 13pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  inset: (x: 0.65cm, y: 0.55cm),
  stroke: 2.5pt + ink,
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  stroke: 2.5pt + ink,
  image(path, width: width),
)

// Halftone: a lattice of dots that grow towards one corner, the pulp print
// texture this deck is built on.
#let halftone(tint: accent, step: 0.62cm, alpha: 78%) = place(
  top + left,
  block(width: 21cm, height: 21cm)[
    #for column in range(34) {
      for row in range(34) {
        let scale = (column + row) / 66
        place(
          left + top,
          dx: column * step,
          dy: row * step,
          circle(radius: 0.02cm + scale * 0.13cm, fill: tint.transparentize(alpha), stroke: none),
        )
      }
    }
  ],
)

// The starburst behind the cover title.
#let burst(radius: 4.6cm, spikes: 16, inner: 0.62, tint: accent) = {
  let points = ()
  for index in range(spikes * 2) {
    let angle = 360deg / (spikes * 2) * index
    let length = if calc.rem(index, 2) == 0 { radius } else { radius * inner }
    points.push((length * calc.cos(angle), length * calc.sin(angle)))
  }
  polygon(fill: tint, stroke: 2.5pt + ink, ..points)
}

// A banner: the heavy outlined bar the headlines sit in.
#let banner(txt, tint: accent, size: 34pt) = block(
  width: 100%,
  fill: tint,
  stroke: 2.5pt + ink,
  inset: (x: 0.5cm, y: 0.3cm),
  text(font: display, size: size, fill: ground, tracking: 1pt)[#txt],
)

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.5cm,
  dy: -1.1cm,
  block(width: 18cm)[
    #line(length: 100%, stroke: 2.5pt + ink)
    #v(0.25cm)
    #grid(
      columns: (1fr, auto),
      text(font: mono, size: 9.5pt, fill: ink)[
        #url-link("github.com/mcanouil/typst-carousel-gallery")
      ],
      text(font: mono, size: 9.5pt, fill: ink)[
        #project #version #sym.dot.op #if n != none { [#n / #total] } #sym.dot.op #date
      ],
    )
  ],
)

#let heading-1(txt) = banner(txt)

#let slide(n: none, body) = page(fill: ground)[
  #halftone()
  #place(top + left, dx: 1.5cm, dy: 1.6cm, block(width: 18cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #halftone(alpha: 68%)
  // Offsets place the burst's centre, not its corner: the polygon's points run
  // in every direction from the origin, so a small dy clips the top spikes.
  #place(top + right, dx: -5.4cm, dy: 5.6cm, burst())
  #place(
    left + horizon,
    dx: 1.5cm,
    dy: 0.4cm,
    block(width: 12cm)[
      #kicker("Release")
      #v(0.35cm)
      #text(font: display, size: 78pt, fill: ink, tracking: 1pt)[#project]
      #v(0.1cm)
      #text(font: mono, size: 26pt, weight: 700, fill: accent)[#version]
      #v(0.5cm)
      #text(size: 17pt, fill: ink)[
        Build every report from one command, in whatever format the reader
        asked for.
      ]
    ],
  )
  #footer(n: 1)
]

// 02 The gap
#slide(n: 2)[
  #kicker("The gap")
  #v(0.35cm)
  #heading-1[Six scripts! Four formats! One deadline!]
  #v(0.6cm)
  #block(width: 16cm, text(size: 16pt)[
    Every project grows its own build script, and then a second one for the
    slides, and a third for the print version. They drift. The one that matters
    is always the one nobody ran.
  ])
  #v(0.6cm)
  #block(
    width: 16cm,
    fill: paper,
    stroke: 2.5pt + ink,
    inset: 0.5cm,
    text(size: 16pt, weight: 700)[
      A build is a fact about a project, not a habit of the person who last
      shipped it.
    ],
  )
]

// 03 The mechanic
#slide(n: 3)[
  #kicker("How it works")
  #v(0.35cm)
  #heading-1[One command, every target.]
  #v(0.6cm)
  #block(width: 16.5cm, text(size: 15.5pt)[
    Declare the targets once. #project reads them, builds only what changed, and
    writes each one where it belongs.
  ])
  #v(0.5cm)
  #code-slab(size: 12.5pt)[
    ```yaml
    targets:
      report:  {format: pdf,  profile: release}
      slides:  {format: html, profile: talk}
      archive: {format: docx, profile: release}
    ```
  ]
  #v(0.4cm)
  #code-slab(size: 12.5pt)[
    ```bash
    acme build --profile release
    ```
  ]
]

// 04 Where it pays off
#slide(n: 4)[
  #kicker("Where it pays off")
  #v(0.35cm)
  #heading-1[Three places it earns its keep.]
  #v(0.6cm)
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 0.45cm,
    ..(
      (
        "Monthly",
        "The same command in the same order, so the December build is the January build.",
      ),
      (
        "One source",
        "Two targets, one set of numbers. The slides cannot fall behind the manuscript.",
      ),
      (
        "Handover",
        "The build is in the repository, not in the head of whoever set it up.",
      ),
    ).map(item => block(width: 100%, fill: paper, stroke: 2.5pt + ink, inset: 0.45cm)[
      #text(font: display, size: 24pt, fill: accent)[#item.at(0)]
      #v(0.15cm)
      #text(size: 13.5pt)[#item.at(1)]
    ])
  )
]

// 05 What changed
#slide(n: 5)[
  #kicker("In " + version)
  #v(0.35cm)
  #heading-1[What changed.]
  #v(0.6cm)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.5cm,
    row-gutter: 0.55cm,
    chip("new"),
    text(size: 15pt)[
      Profiles. One target set, several build shapes, no duplicated
      configuration.
    ],
    chip("new"),
    text(size: 15pt)[
      Incremental builds. Only the targets whose inputs moved are rebuilt.
    ],
    chip("fixed"),
    text(size: 15pt)[
      Relative paths now resolve from the project root on every platform.
    ],
  )
  #v(0.6cm)
  #line(length: 100%, stroke: 2.5pt + ink)
  #v(0.4cm)
  #block(width: 16.5cm, text(size: 15pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: accent)[
  #halftone(tint: ink, alpha: 82%)
  #place(
    left + horizon,
    dx: 1.5cm,
    block(width: 18cm)[
      #text(font: mono, size: 11pt, weight: 700, fill: ground, tracking: 1.6pt)[#upper("Get it")]
      #v(0.4cm)
      #text(font: display, size: 56pt, fill: ground, tracking: 1pt)[Install and build!]
      #v(0.6cm)
      #block(
        width: 100%,
        fill: ground,
        stroke: 2.5pt + ink,
        inset: (x: 0.65cm, y: 0.55cm),
        text(font: mono, size: 14pt, fill: ink)[
          ```bash
          brew install acme-kit && acme init
          ```
        ],
      )
      #v(0.65cm)
      #text(size: 16pt, weight: 700, fill: ground)[
        Source, documentation, and every template in this gallery:
      ]
      #v(0.2cm)
      #text(font: mono, size: 13.5pt, weight: 700, fill: ground)[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #place(
    bottom + left,
    dx: 1.5cm,
    dy: -1.1cm,
    block(width: 18cm)[
      #line(length: 100%, stroke: 2.5pt + ground)
      #v(0.25cm)
      #grid(
        columns: (1fr, auto),
        text(font: mono, size: 9.5pt, fill: ground)[#date],
        text(font: mono, size: 9.5pt, fill: ground)[#project #version #sym.dot.op 6 / 6],
      )
    ],
  )
]
