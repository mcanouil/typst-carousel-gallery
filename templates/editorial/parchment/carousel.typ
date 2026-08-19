// editorial/parchment: warm parchment and a quiet serif, over an oversized ghost numeral.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#f2e9d5") // page fill
#let paper = rgb("#fbf6e9") // light panel
#let ink = rgb("#2c2417") // body text
#let muted = rgb("#7c6f56") // secondary text
#let hair = rgb("#d5c6a4") // rules and borders
#let accent = rgb("#1f6b4e") // the one accent
#let slab = rgb("#2c2417") // code background
#let slab-fg = rgb("#f2e9d5") // code foreground

#let display = "EB Garamond"
#let body = "Lato"
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
  size: 10pt,
  weight: 500,
  fill: tint,
  tracking: 2.2pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  fill: tint,
  radius: 1pt,
  inset: (x: 6pt, y: 3.5pt),
  text(font: mono, size: 9.5pt, weight: 600, fill: paper, txt),
)

#let code-slab(body, size: 12.5pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  inset: (x: 0.65cm, y: 0.52cm),
  stroke: (left: 3pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  stroke: 1pt + hair,
  image(path, width: width),
)

// The ghost: an enormous slide numeral set in the display serif, sunk into the
// parchment. It is the only ornament in the deck.
//
// It sits on the vertical centre rather than the bottom of the page, because a
// glyph anchored to the bottom edge runs straight through the footer rule and
// Typst reports nothing: only the page overflowing is an error.
#let ghost(character) = place(
  right + horizon,
  dx: 1.3cm,
  dy: -0.6cm,
  text(font: display, size: 175pt, weight: 700, fill: hair.darken(6%), character),
)

#let rule = line(length: 100%, stroke: 0.7pt + hair.darken(12%))

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 2cm,
  dy: -1.2cm,
  block(width: 17cm)[
    #rule
    #v(0.3cm)
    #grid(
      columns: (1fr, auto),
      text(font: mono, size: 9pt, fill: muted)[
        #url-link("github.com/mcanouil/typst-carousel-gallery")
      ],
      text(font: mono, size: 9pt, fill: muted)[
        #project #version #sym.dot.op #if n != none { [#n / #total] }
      ],
    )
  ],
)

#let heading-1(txt) = text(font: display, size: 36pt, weight: 700, fill: ink, txt)

#let slide(n: none, body) = page(fill: ground)[
  #if n != none { ghost(str(n)) }
  #place(top + left, dx: 2cm, dy: 1.7cm, block(width: 17cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #place(
    right + horizon,
    dx: 1.6cm,
    dy: -0.6cm,
    text(font: display, size: 210pt, weight: 700, fill: hair.darken(4%))[A],
  )
  #place(
    left + horizon,
    dx: 2cm,
    block(width: 17cm)[
      #kicker("Release")
      #v(0.6cm)
      #text(font: display, size: 82pt, weight: 700, fill: ink)[#project]
      #v(-0.2cm)
      #text(font: display, size: 34pt, weight: 400, fill: accent)[Version #version]
      #v(0.6cm)
      #block(width: 12cm, text(size: 17pt, fill: muted)[
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
  #v(0.45cm)
  #heading-1[Six scripts, four formats, one deadline.]
  #v(0.5cm)
  #rule
  #v(0.5cm)
  #block(width: 13.5cm)[
    #text(size: 16pt)[
      Every project grows its own build script, and then a second one for the
      slides, and a third for the print version. They drift. The one that
      matters is always the one nobody ran.
    ]
    #v(0.45cm)
    #text(size: 16pt, fill: muted, style: "italic")[
      A build is a fact about a project, not a habit of the person who last
      shipped it.
    ]
  ]
]

// 03 The mechanic
#slide(n: 3)[
  #kicker("How it works")
  #v(0.45cm)
  #heading-1[One command, every target.]
  #v(0.5cm)
  #rule
  #v(0.5cm)
  #block(width: 14.5cm, text(size: 15.5pt, fill: muted)[
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
  #v(0.45cm)
  #heading-1[Three places it earns its keep.]
  #v(0.5cm)
  #rule
  #v(0.6cm)
  #block(width: 14cm)[
    #grid(
      columns: (1fr,),
      row-gutter: 0.75cm,
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
        #text(font: display, size: 21pt, weight: 700, fill: accent)[#item.at(0)]
        #v(0.1cm)
        #text(size: 14.5pt, fill: muted)[#item.at(1)]
      ])
    )
  ]
]

// 05 What changed
#slide(n: 5)[
  #kicker("In " + version)
  #v(0.45cm)
  #heading-1[What changed.]
  #v(0.5cm)
  #rule
  #v(0.6cm)
  #block(width: 14cm)[
    #grid(
      columns: (auto, 1fr),
      column-gutter: 0.5cm,
      row-gutter: 0.55cm,
      chip("New"),
      text(size: 14.5pt)[
        Profiles. One target set, several build shapes, no duplicated
        configuration.
      ],
      chip("New"),
      text(size: 14.5pt)[
        Incremental builds. Only the targets whose inputs moved are rebuilt.
      ],
      chip("Fixed"),
      text(size: 14.5pt)[
        Relative paths now resolve from the project root on every platform.
      ],
    )
    #v(0.6cm)
    #text(size: 14.5pt, fill: muted, style: "italic")[
      Upgrading is a version bump. Existing target files keep working unchanged.
    ]
  ]
]

// 06 Ship
#page(fill: ink)[
  #place(
    right + horizon,
    dx: 1.6cm,
    dy: -0.6cm,
    text(font: display, size: 210pt, weight: 700, fill: ink.lighten(9%))[6],
  )
  #place(
    left + horizon,
    dx: 2cm,
    block(width: 17cm)[
      #text(font: mono, size: 10pt, fill: accent.lighten(35%), tracking: 2.2pt)[#upper("Get it")]
      #v(0.6cm)
      #text(font: display, size: 46pt, weight: 700, fill: ground)[Install and build.]
      #v(0.7cm)
      #block(
        width: 100%,
        fill: ground,
        inset: (x: 0.65cm, y: 0.52cm),
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
    dx: 2cm,
    dy: -1.2cm,
    block(width: 17cm)[
      #line(length: 100%, stroke: 0.7pt + muted)
      #v(0.3cm)
      #grid(
        columns: (1fr, auto),
        text(font: mono, size: 9pt, fill: hair)[#date],
        text(font: mono, size: 9pt, fill: hair)[#project #version #sym.dot.op 6 / 6],
      )
    ],
  )
]
