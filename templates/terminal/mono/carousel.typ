// terminal/mono: monospace as the body voice, on paper, with syntax colour carrying the hierarchy.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#f4f1ea") // page fill
#let paper = rgb("#ffffff") // light panel
#let ink = rgb("#20242b") // body text
#let muted = rgb("#6b7280") // secondary text
#let hair = rgb("#d8d3c7") // rules and borders
#let accent = rgb("#c2410c") // the one accent
#let slab = rgb("#20242b") // code background
#let slab-fg = rgb("#f4f1ea") // code foreground

#let display = "Archivo"
#let body = "IBM Plex Mono"
#let mono = "IBM Plex Mono"

#set page(width: 21cm, height: 21cm, margin: 0cm, fill: ground)
#set text(font: body, fill: ink, size: 14pt)
#set raw(theme: none)
// Ligatures off: a code font that draws `&&` or `!=` as one merged glyph is
// unreadable at slide sizes.
#show raw: set text(font: mono, ligatures: false)

// A second and third hue, used only to colour the token strip. The body stays
// on ink, and accent stays the single emphasis colour.
#let token-blue = rgb("#1d4ed8")
#let token-green = rgb("#15803d")

// --- HELPERS ---

#let url-link(url) = link("https://" + url, url)

#let kicker(txt, tint: accent) = text(
  font: mono,
  size: 11pt,
  weight: 600,
  fill: tint,
  tracking: 1.6pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  fill: tint,
  inset: (x: 6pt, y: 3.5pt),
  text(font: mono, size: 10pt, weight: 600, fill: ground, txt),
)

#let code-slab(body, size: 12.5pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  inset: (x: 0.65cm, y: 0.5cm),
  stroke: (left: 4pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  stroke: 1pt + hair,
  image(path, width: width),
)

// The token strip: a row of coloured cells along the top edge, the same three
// hues in the same order on every slide, so the deck reads as one listing.
#let token-strip = place(
  top + left,
  block(width: 21cm, height: 0.5cm)[
    #stack(
      dir: ltr,
      ..(
        (accent, 5.2cm),
        (token-blue, 3.1cm),
        (token-green, 4.6cm),
        // muted rather than ink: an ink cell disappears into the dark closing
        // slide and reads as a gap in the strip.
        (muted, 2.4cm),
        (hair, 5.7cm),
      ).map(cell => rect(width: cell.at(1), height: 0.5cm, fill: cell.at(0), stroke: none))
    )
  ],
)

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.6cm,
  dy: -1.1cm,
  block(width: 17.8cm)[
    #line(length: 100%, stroke: 1pt + hair)
    #v(0.3cm)
    #grid(
      columns: (1fr, auto),
      text(size: 9.5pt, fill: muted)[
        #url-link("github.com/mcanouil/typst-carousel-gallery")
      ],
      text(size: 9.5pt, fill: muted)[
        #project #version #sym.dot.op #if n != none { [#n/#total] }
      ],
    )
  ],
)

#let heading-1(txt) = text(font: display, size: 32pt, weight: 700, fill: ink, txt)

#let slide(n: none, body) = page(fill: ground)[
  #token-strip
  #place(top + left, dx: 1.6cm, dy: 1.8cm, block(width: 17.8cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #token-strip
  #place(
    left + horizon,
    dx: 1.6cm,
    block(width: 17.8cm)[
      #kicker("Release")
      #v(0.55cm)
      #text(font: display, size: 68pt, weight: 700, fill: ink)[#project]
      #v(0.15cm)
      #text(size: 26pt, weight: 600, fill: accent)[#version]
      #v(0.65cm)
      #block(width: 13cm, text(size: 15pt, fill: muted)[
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
  #heading-1[Six scripts, four formats,\ one deadline.]
  #v(0.6cm)
  #block(width: 15.5cm, text(size: 14.5pt)[
    Every project grows its own build script, and then a second one for the
    slides, and a third for the print version. They drift. The one that matters
    is always the one nobody ran.
  ])
  #v(0.5cm)
  #line(length: 100%, stroke: 1pt + hair)
  #v(0.5cm)
  #block(width: 15.5cm, text(size: 14.5pt, fill: accent)[
    A build is a fact about a project, not a habit of the person who last
    shipped it.
  ])
]

// 03 The mechanic
#slide(n: 3)[
  #kicker("How it works")
  #v(0.4cm)
  #heading-1[One command, every target.]
  #v(0.55cm)
  #block(width: 16cm, text(size: 14.5pt, fill: muted)[
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
  #code-slab(tint: token-green)[
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
    ..(
      (
        accent,
        "monthly",
        "The same command in the same order, so the December build is the January build.",
      ),
      (
        token-blue,
        "one source",
        "Two targets, one set of numbers. The slides cannot fall behind the manuscript.",
      ),
      (
        token-green,
        "handover",
        "The build is in the repository, not in the head of whoever set it up.",
      ),
    ).map(item => block(width: 100%, stroke: (left: 4pt + item.at(0)), inset: (left: 0.5cm))[
      #text(size: 15pt, weight: 600, fill: item.at(0))[#item.at(1)]
      #v(0.1cm)
      #text(size: 13.5pt, fill: muted)[#item.at(2)]
    ])
  )
]

// 05 What changed
#slide(n: 5)[
  #kicker("In " + version)
  #v(0.4cm)
  #heading-1[What changed.]
  #v(0.65cm)
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.5cm,
    row-gutter: 0.5cm,
    chip("new"),
    text(size: 13.5pt)[
      Profiles. One target set, several build shapes, no duplicated
      configuration.
    ],
    chip("new"),
    text(size: 13.5pt)[
      Incremental builds. Only the targets whose inputs moved are rebuilt.
    ],
    chip("fixed", tint: token-blue),
    text(size: 13.5pt)[
      Relative paths now resolve from the project root on every platform.
    ],
  )
  #v(0.65cm)
  #line(length: 100%, stroke: 1pt + hair)
  #v(0.45cm)
  #block(width: 16cm, text(size: 13.5pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: slab)[
  #token-strip
  #place(
    left + horizon,
    dx: 1.6cm,
    block(width: 17.8cm)[
      #text(size: 11pt, weight: 600, fill: accent.lighten(20%), tracking: 1.6pt)[#upper("Get it")]
      #v(0.55cm)
      #text(font: display, size: 42pt, weight: 700, fill: ground)[Install and build.]
      #v(0.7cm)
      #block(
        width: 100%,
        fill: ground,
        inset: (x: 0.65cm, y: 0.5cm),
        stroke: (left: 4pt + accent),
        text(size: 14pt, fill: ink)[
          ```bash
          brew install acme-kit && acme init
          ```
        ],
      )
      #v(0.75cm)
      #text(size: 14pt, fill: hair)[
        Source, documentation, and every template in this gallery:
      ]
      #v(0.25cm)
      #text(size: 13.5pt, fill: accent.lighten(20%))[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #place(
    bottom + left,
    dx: 1.6cm,
    dy: -1.1cm,
    block(width: 17.8cm)[
      #line(length: 100%, stroke: 1pt + muted)
      #v(0.3cm)
      #grid(
        columns: (1fr, auto),
        text(size: 9.5pt, fill: hair)[#date],
        text(size: 9.5pt, fill: hair)[#project #version #sym.dot.op 6/6],
      )
    ],
  )
]
