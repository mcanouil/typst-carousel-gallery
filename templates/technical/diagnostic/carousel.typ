// technical/diagnostic: crop marks at the corners and a stage strip counting the frames.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#eceae5") // page fill
#let paper = rgb("#ffffff") // light panel
#let ink = rgb("#1a1c1e") // body text
#let muted = rgb("#6a6f75") // secondary text
#let hair = rgb("#c9c7c1") // rules and borders
#let accent = rgb("#0f766e") // the one accent
#let slab = rgb("#1a1c1e") // code background
#let slab-fg = rgb("#eceae5") // code foreground

#let display = "Inter"
#let body = "Inter"
#let mono = "Fira Code"

#set page(width: 21cm, height: 21cm, margin: 0cm, fill: ground)
#set text(font: body, fill: ink, size: 15pt)
#set raw(theme: none)
// Ligatures off: Fira Code draws `&&` as one merged glyph that reads as a pair
// of digits at slide sizes.
#show raw: set text(font: mono, ligatures: false)

#let stages = ("read", "plan", "build", "write", "check", "ship")

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
  fill: tint,
  inset: (x: 7pt, y: 4pt),
  text(font: mono, size: 10pt, weight: 600, fill: ground, txt),
)

#let code-slab(body, size: 12.5pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  inset: (x: 0.65cm, y: 0.55cm),
  stroke: (left: 3pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  stroke: 0.9pt + hair,
  image(path, width: width),
)

// One corner mark. The four together frame the page the way a proof sheet does.
#let crop-mark(x, y, flip-x, flip-y) = place(top + left, dx: x, dy: y, {
  place(left + top, line(end: (flip-x * 0.7cm, 0cm), stroke: 1.2pt + ink))
  place(left + top, line(end: (0cm, flip-y * 0.7cm), stroke: 1.2pt + ink))
})

#let crop-marks = {
  crop-mark(0.9cm, 0.9cm, 1, 1)
  crop-mark(20.1cm, 0.9cm, -1, 1)
  crop-mark(0.9cm, 20.1cm, 1, -1)
  crop-mark(20.1cm, 20.1cm, -1, -1)
}

// The stage strip: the six frames of the deck, with the current one filled.
// It is the deck's own progress bar, named rather than numbered.
#let stage-strip(active) = place(
  top + left,
  dx: 1.6cm,
  dy: 1.6cm,
  block(width: 17.8cm)[
    #grid(
      columns: (1fr,) * stages.len(),
      column-gutter: 0.18cm,
      ..stages
        .enumerate()
        .map(entry => {
          let index = entry.at(0)
          let name = entry.at(1)
          let on = index + 1 == active
          block(width: 100%)[
            #rect(width: 100%, height: 0.16cm, fill: if on { accent } else { hair }, stroke: none)
            #v(0.14cm)
            #text(
              font: mono,
              size: 8.5pt,
              tracking: 0.8pt,
              fill: if on { accent } else { muted },
            )[#upper(name)]
          ]
        })
    )
  ],
)

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.6cm,
  dy: -1.5cm,
  block(width: 17.8cm)[
    #line(length: 100%, stroke: 0.8pt + hair)
    #v(0.28cm)
    #grid(
      columns: (1fr, auto),
      text(font: mono, size: 9pt, fill: muted)[
        #url-link("github.com/mcanouil/typst-carousel-gallery")
      ],
      text(font: mono, size: 9pt, fill: muted)[
        FRAME #if n != none { [#n / #total] } #sym.dot.op #project #version #sym.dot.op #date
      ],
    )
  ],
)

#let heading-1(txt) = text(font: display, size: 31pt, weight: 700, fill: ink, txt)

#let slide(n: none, body) = page(fill: ground)[
  #crop-marks
  #if n != none { stage-strip(n) }
  #place(top + left, dx: 1.6cm, dy: 3.7cm, block(width: 17.8cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #crop-marks
  #stage-strip(1)
  #place(
    left + horizon,
    dx: 1.6cm,
    dy: 0.4cm,
    block(width: 17.8cm)[
      #kicker("Release")
      #v(0.5cm)
      #text(font: display, size: 66pt, weight: 700, fill: ink)[#project]
      #v(0.1cm)
      #text(font: mono, size: 27pt, weight: 600, fill: accent)[#version]
      #v(0.65cm)
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
  #block(width: 15.5cm, text(size: 15.5pt)[
    Every project grows its own build script, and then a second one for the
    slides, and a third for the print version. They drift. The one that matters
    is always the one nobody ran.
  ])
  #v(0.5cm)
  #line(length: 100%, stroke: 0.8pt + hair)
  #v(0.45cm)
  #block(width: 15.5cm, text(size: 15.5pt, fill: accent)[
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
  #block(width: 16cm, text(size: 15pt, fill: muted)[
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
  #v(0.4cm)
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
  #v(0.6cm)
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 0.5cm,
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
    ).map(item => block(width: 100%, fill: paper, inset: 0.45cm, stroke: 0.9pt + hair)[
      #text(font: display, size: 15pt, weight: 700, fill: accent)[#item.at(0)]
      #v(0.15cm)
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
  #v(0.6cm)
  #line(length: 100%, stroke: 0.8pt + hair)
  #v(0.45cm)
  #block(width: 16cm, text(size: 14pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: slab)[
  // The same four marks as every other slide, drawn in the light ink this
  // ground needs.
  #{
    let mark(x, y, flip-x, flip-y) = place(top + left, dx: x, dy: y, {
      place(left + top, line(end: (flip-x * 0.7cm, 0cm), stroke: 1.2pt + ground))
      place(left + top, line(end: (0cm, flip-y * 0.7cm), stroke: 1.2pt + ground))
    })
    mark(0.9cm, 0.9cm, 1, 1)
    mark(20.1cm, 0.9cm, -1, 1)
    mark(0.9cm, 20.1cm, 1, -1)
    mark(20.1cm, 20.1cm, -1, -1)
  }
  #place(
    left + horizon,
    dx: 1.6cm,
    block(width: 17.8cm)[
      #text(font: mono, size: 10.5pt, weight: 600, fill: accent.lighten(35%), tracking: 1.8pt)[
        #upper("Ship")
      ]
      #v(0.5cm)
      #text(font: display, size: 42pt, weight: 700, fill: ground)[Install and build.]
      #v(0.7cm)
      #block(
        width: 100%,
        fill: ground,
        inset: (x: 0.65cm, y: 0.55cm),
        stroke: (left: 3pt + accent),
        text(font: mono, size: 13.5pt, fill: ink)[
          ```bash
          brew install acme-kit && acme init
          ```
        ],
      )
      #v(0.75cm)
      #text(size: 15pt, fill: hair)[
        Source, documentation, and every template in this gallery:
      ]
      #v(0.25cm)
      #text(font: mono, size: 13.5pt, fill: accent.lighten(35%))[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #place(
    bottom + left,
    dx: 1.6cm,
    dy: -1.5cm,
    block(width: 17.8cm)[
      #line(length: 100%, stroke: 0.8pt + muted)
      #v(0.28cm)
      #grid(
        columns: (1fr, auto),
        text(font: mono, size: 9pt, fill: hair)[#date],
        text(font: mono, size: 9pt, fill: hair)[
          FRAME 6 / 6 #sym.dot.op #project #version
        ],
      )
    ],
  )
]
