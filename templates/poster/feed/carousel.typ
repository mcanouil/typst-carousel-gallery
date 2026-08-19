// poster/feed: a full-bleed colour field per slide, one idea, set very large.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#0b0f14") // page fill
#let paper = rgb("#f4f7fa") // light panel
#let ink = rgb("#f4f7fa") // body text
#let muted = rgb("#9fb0c2") // secondary text
#let hair = rgb("#22303f") // rules and borders
#let accent = rgb("#ff5a3c") // the one accent
#let slab = rgb("#050709") // code background
#let slab-fg = rgb("#f4f7fa") // code foreground

#let display = "Space Grotesk"
#let body = "Inter"
#let mono = "IBM Plex Mono"

#set page(width: 21cm, height: 21cm, margin: 0cm, fill: ground)
#set text(font: body, fill: ink, size: 16pt)
#set raw(theme: none)
// Ligatures off: a code font that draws `&&` or `!=` as one merged glyph is
// unreadable at slide sizes.
#show raw: set text(font: mono, ligatures: false)

// One field colour per slide. The deck is read as a run of posters, so each
// slide gets its own ground rather than sharing one.
#let fields = (
  rgb("#0b0f14"),
  rgb("#14202b"),
  rgb("#0b0f14"),
  rgb("#1b2a1e"),
  rgb("#0b0f14"),
  rgb("#ff5a3c"),
)

// --- HELPERS ---

#let url-link(url) = link("https://" + url, url)

#let kicker(txt, tint: accent) = text(
  font: mono,
  size: 11pt,
  weight: 600,
  fill: tint,
  tracking: 2.4pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  stroke: 1.4pt + tint,
  inset: (x: 8pt, y: 4.5pt),
  text(font: mono, size: 10.5pt, weight: 600, fill: tint, txt),
)

#let code-slab(body, size: 13pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  inset: (x: 0.7cm, y: 0.6cm),
  stroke: (left: 4pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  stroke: 1.4pt + hair,
  image(path, width: width),
)

// The rule that opens every slide, the only chrome the deck carries.
#let opening-rule(tint: accent) = line(length: 4.2cm, stroke: 5pt + tint)

// The poster headline: very large, tight, and left aligned.
#let poster(txt, size: 52pt, tint: ink) = text(
  font: display,
  size: size,
  weight: 700,
  fill: tint,
  txt,
)

#let footer(n: none, total: 6, tint: muted) = place(
  bottom + left,
  dx: 1.8cm,
  dy: -1.2cm,
  block(width: 17.4cm)[
    #grid(
      columns: (1fr, auto),
      text(font: mono, size: 9.5pt, fill: tint)[
        #url-link("github.com/mcanouil/typst-carousel-gallery")
      ],
      text(font: mono, size: 9.5pt, fill: tint)[
        #project #version #sym.dot.op #if n != none { [#n / #total] } #sym.dot.op #date
      ],
    )
  ],
)

#let heading-1(txt) = poster(txt, size: 44pt)

#let slide(n: none, body) = page(fill: fields.at(n - 1))[
  #place(top + left, dx: 1.8cm, dy: 1.9cm, block(width: 17.4cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: fields.at(0))[
  #place(
    left + horizon,
    dx: 1.8cm,
    block(width: 17.4cm)[
      #opening-rule()
      #v(0.7cm)
      #poster(project, size: 76pt)
      #v(0.1cm)
      #text(font: mono, size: 28pt, weight: 600, fill: accent)[#version]
      #v(0.7cm)
      #block(width: 13cm, text(size: 17pt, fill: muted)[
        Build every report from one command, in whatever format the reader
        asked for.
      ])
    ],
  )
  #footer(n: 1)
]

// 02 The gap
#slide(n: 2)[
  #opening-rule()
  #v(0.7cm)
  #kicker("The gap")
  #v(0.45cm)
  #poster("Six scripts.\nFour formats.\nOne deadline.", size: 46pt)
  #v(0.8cm)
  #block(width: 14.5cm, text(size: 16pt, fill: muted)[
    They drift. The one that matters is always the one nobody ran. A build is a
    fact about a project, not a habit of the person who last shipped it.
  ])
]

// 03 The mechanic
#slide(n: 3)[
  #opening-rule()
  #v(0.7cm)
  #kicker("How it works")
  #v(0.45cm)
  #heading-1[One command,\ every target.]
  #v(0.6cm)
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
  #opening-rule(tint: rgb("#8fd14f"))
  #v(0.7cm)
  #kicker("Where it pays off", tint: rgb("#8fd14f"))
  #v(0.45cm)
  #heading-1[Three places it earns its keep.]
  #v(0.7cm)
  #grid(
    columns: (1fr,),
    row-gutter: 0.55cm,
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
    ).map(item => grid(
      columns: (4.4cm, 1fr),
      column-gutter: 0.5cm,
      text(font: display, size: 19pt, weight: 700, fill: rgb("#8fd14f"))[#item.at(0)],
      text(size: 14.5pt, fill: muted)[#item.at(1)],
    ))
  )
]

// 05 What changed
#slide(n: 5)[
  #opening-rule()
  #v(0.7cm)
  #kicker("In " + version)
  #v(0.45cm)
  #heading-1[What changed.]
  #v(0.7cm)
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
  #v(0.7cm)
  #block(width: 15.5cm, text(size: 14.5pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: fields.at(5))[
  #place(
    left + horizon,
    dx: 1.8cm,
    block(width: 17.4cm)[
      #line(length: 4.2cm, stroke: 5pt + ground)
      #v(0.7cm)
      #text(font: mono, size: 11pt, weight: 600, fill: ground, tracking: 2.4pt)[#upper("Get it")]
      #v(0.45cm)
      #poster("Install and build.", size: 50pt, tint: ground)
      #v(0.7cm)
      #block(
        width: 100%,
        fill: ground,
        inset: (x: 0.7cm, y: 0.6cm),
        text(font: mono, size: 14pt, fill: ink)[
          ```bash
          brew install acme-kit && acme init
          ```
        ],
      )
      #v(0.7cm)
      #text(font: mono, size: 14pt, weight: 600, fill: ground)[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
      ]
    ],
  )
  #footer(n: 6, tint: ground)
]
