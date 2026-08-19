// screenshot/film-strip: shots run along a perforated strip, captioned like contact prints.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#efece6") // page fill
#let paper = rgb("#fdfcfa") // light panel
#let ink = rgb("#1b1a18") // body text
#let muted = rgb("#6a6862") // secondary text
#let hair = rgb("#c8c4bb") // rules and borders
#let accent = rgb("#b5451f") // the one accent
#let slab = rgb("#1b1a18") // code background
#let slab-fg = rgb("#efece6") // code foreground

#let display = "Archivo"
#let body = "Lato"
#let mono = "Fira Code"

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
  size: 10pt,
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

// The framed shot. Replace the placeholder path with your own PNG, dropped
// beside this file and referenced as image("screenshot.png").
#let shot(path, width: 100%) = block(
  clip: true,
  stroke: 1pt + ink,
  image(path, width: width),
)

// The perforations along the top and bottom of a strip, the motif this variant
// is named for.
#let perforations(width, count) = block(width: width, height: 0.34cm)[
  #for index in range(count) {
    place(
      left + horizon,
      dx: 0.22cm + index * (width - 0.44cm) / (count - 1),
      rect(width: 0.24cm, height: 0.18cm, fill: ground, radius: 1pt, stroke: none),
    )
  }
]

// One strip: a black band with perforations, holding one or more shots.
#let strip(width: 17.6cm, count: 12, body) = block(
  width: width,
  fill: ink,
  inset: (x: 0.35cm, y: 0cm),
)[
  #perforations(width - 0.7cm, count)
  #body
  #perforations(width - 0.7cm, count)
]

// A shot inside a strip, with its caption printed on the black.
#let frame(path, caption, width: 100%) = block(width: width)[
  #shot(path)
  #v(0.14cm)
  #text(font: mono, size: 8.5pt, fill: ground.darken(28%))[#caption]
  #v(0.1cm)
]

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.7cm,
  dy: -1.15cm,
  block(width: 17.6cm)[
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
  #place(top + left, dx: 1.7cm, dy: 1.7cm, block(width: 17.6cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #place(
    top + left,
    dx: 1.7cm,
    dy: 0.9cm,
    block(width: 17.6cm)[
      #kicker("Release")
      #v(0.45cm)
      #text(font: display, size: 64pt, weight: 700, fill: ink)[#project]
      #v(0.05cm)
      #text(font: mono, size: 25pt, weight: 600, fill: accent)[#version]
      #v(0.5cm)
      #block(width: 12.5cm, text(size: 16pt, fill: muted)[
        Build every report from one command, in whatever format the reader
        asked for.
      ])
    ],
  )
  #place(bottom + left, dx: 1.7cm, dy: -2.0cm, strip()[
    #grid(
      columns: (1fr, 1fr, 1fr),
      column-gutter: 0.3cm,
      frame("/assets/placeholder-shot.svg", "report.pdf"),
      frame("/assets/placeholder-shot.svg", "slides.html"),
      frame("/assets/placeholder-shot.svg", "archive.docx"),
    )
  ])
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
  #line(length: 100%, stroke: 1pt + hair)
  #v(0.4cm)
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

// 04 The evidence
#slide(n: 4)[
  #kicker("Where it pays off")
  #v(0.4cm)
  #heading-1[One source, every frame.]
  #v(0.55cm)
  #strip(count: 10)[
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 0.3cm,
      frame("/assets/placeholder-shot.svg", "December. Built from the release profile."),
      frame("/assets/placeholder-shot.svg", "January. The same command, the same order."),
    )
  ]
  #v(0.5cm)
  #block(width: 16cm, text(size: 14pt, fill: muted)[
    The slides cannot fall behind the manuscript, and a handover carries the
    build with it, because neither is made by hand.
  ])
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
  #v(0.4cm)
  #block(width: 16cm, text(size: 14pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: ink)[
  #place(
    top + left,
    dx: 1.7cm,
    dy: 2.8cm,
    block(width: 17.6cm)[
      #text(font: mono, size: 10pt, weight: 600, fill: accent.lighten(35%), tracking: 1.8pt)[
        #upper("Get it")
      ]
      #v(0.45cm)
      #text(font: display, size: 42pt, weight: 700, fill: ground)[Install and build.]
      #v(0.6cm)
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
      #v(0.6cm)
      #text(size: 15pt, fill: hair)[
        Source, documentation, and every template in this gallery:
      ]
      #v(0.2cm)
      #text(font: mono, size: 13.5pt, weight: 600, fill: accent.lighten(35%))[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #place(
    bottom + left,
    dx: 1.7cm,
    dy: -1.15cm,
    block(width: 17.6cm)[
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
