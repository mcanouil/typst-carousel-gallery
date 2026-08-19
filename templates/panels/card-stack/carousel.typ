// panels/card-stack: tabbed cards on navy, each slide one card pulled from the stack.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#132033") // page fill
#let paper = rgb("#f7f9fb") // light panel
#let ink = rgb("#132033") // body text
#let muted = rgb("#63758c") // secondary text
#let hair = rgb("#dde4ec") // rules and borders
#let accent = rgb("#ff8a3d") // the one accent
#let slab = rgb("#0b1524") // code background
#let slab-fg = rgb("#e7eef7") // code foreground

#let display = "Work Sans"
#let body = "Work Sans"
#let mono = "Fira Code"

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
  weight: 600,
  fill: tint,
  tracking: 1.6pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  fill: tint,
  radius: 3pt,
  inset: (x: 7pt, y: 4pt),
  text(font: mono, size: 10pt, weight: 600, fill: ground, txt),
)

#let code-slab(body, size: 12.5pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  radius: 5pt,
  inset: (x: 0.6cm, y: 0.5cm),
  stroke: (left: 3pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  radius: 5pt,
  stroke: 1pt + hair,
  image(path, width: width),
)

// The number set beside a label, the stack's own counter.
#let count(value, label) = block[
  #text(font: display, size: 30pt, weight: 700, fill: accent)[#value]
  #v(-0.1cm)
  #text(font: mono, size: 9.5pt, fill: muted, tracking: 1pt)[#upper(label)]
]

// One card, with a tab standing proud of its top edge. The two cards behind it
// are what makes the deck read as a stack rather than a set of panels.
#let card(tab, body) = {
  place(top + left, dx: 2.4cm, dy: 2.15cm, rect(
    width: 16.2cm,
    height: 1cm,
    fill: paper.darken(22%),
    radius: (top: 8pt),
  ))
  place(top + left, dx: 2.1cm, dy: 2.5cm, rect(
    width: 16.8cm,
    height: 1cm,
    fill: paper.darken(10%),
    radius: (top: 8pt),
  ))
  place(top + left, dx: 1.8cm, dy: 2.3cm, block(
    width: 17.4cm,
    fill: accent,
    radius: (top: 6pt),
    inset: (x: 0.45cm, y: 0.22cm),
    text(font: mono, size: 10.5pt, weight: 600, fill: ground)[#upper(tab)],
  ))
  place(top + left, dx: 1.8cm, dy: 3.15cm, block(
    width: 17.4cm,
    height: 14.6cm,
    fill: paper,
    radius: (top-right: 8pt, bottom: 8pt),
    inset: 0.9cm,
    body,
  ))
}

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.8cm,
  dy: -0.75cm,
  block(width: 17.4cm)[
    #grid(
      columns: (1fr, auto),
      text(font: mono, size: 9pt, fill: paper.darken(35%))[
        #url-link("github.com/mcanouil/typst-carousel-gallery")
      ],
      text(font: mono, size: 9pt, fill: paper.darken(35%))[
        #project #version #sym.dot.op #if n != none { [#n / #total] } #sym.dot.op #date
      ],
    )
  ],
)

#let heading-1(txt) = text(font: display, size: 29pt, weight: 700, fill: ink, txt)

#let slide(n: none, tab, body) = page(fill: ground)[
  #card(tab, body)
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #place(top + left, dx: 2.4cm, dy: 4.6cm, rect(
    width: 16.2cm,
    height: 12cm,
    fill: paper.darken(22%),
    radius: 8pt,
  ))
  #place(top + left, dx: 2.1cm, dy: 5.0cm, rect(
    width: 16.8cm,
    height: 12cm,
    fill: paper.darken(10%),
    radius: 8pt,
  ))
  #place(top + left, dx: 1.8cm, dy: 5.4cm, block(
    width: 17.4cm,
    height: 12cm,
    fill: paper,
    radius: 8pt,
    inset: 0.9cm,
  )[
    #kicker("Release")
    #v(0.4cm)
    #text(font: display, size: 58pt, weight: 700, fill: ink)[#project]
    #v(0cm)
    #text(font: mono, size: 24pt, weight: 600, fill: accent)[#version]
    #v(0.45cm)
    #block(width: 13cm, text(size: 15pt, fill: muted)[
      Build every report from one command, in whatever format the reader asked
      for.
    ])
  ])
  #footer(n: 1)
]

// 02 The gap
#slide(n: 2, "The gap")[
  #heading-1[Six scripts, four formats, one deadline.]
  #v(0.5cm)
  #block(width: 100%, text(size: 15pt)[
    Every project grows its own build script, and then a second one for the
    slides, and a third for the print version. They drift. The one that matters
    is always the one nobody ran.
  ])
  #v(0.6cm)
  #grid(
    columns: (1fr, 1fr, 1fr),
    count("6", "build scripts"),
    count("4", "output formats"),
    count("1", "that got run"),
  )
  #v(0.6cm)
  #line(length: 100%, stroke: 1pt + hair)
  #v(0.4cm)
  #text(size: 15pt, fill: muted)[
    A build is a fact about a project, not a habit of the person who last
    shipped it.
  ]
]

// 03 The mechanic
#slide(n: 3, "How it works")[
  #heading-1[One command, every target.]
  #v(0.45cm)
  #text(size: 14.5pt, fill: muted)[
    Declare the targets once. #project reads them, builds only what changed, and
    writes each one where it belongs.
  ]
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
#slide(n: 4, "Where it pays off")[
  #heading-1[Three places it earns its keep.]
  #v(0.6cm)
  #grid(
    columns: (1fr,),
    row-gutter: 0.55cm,
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
      #text(font: display, size: 16.5pt, weight: 700, fill: ink)[#item.at(0)]
      #v(0.08cm)
      #text(size: 13.5pt, fill: muted)[#item.at(1)]
    ])
  )
]

// 05 What changed
#slide(n: 5, "In " + version)[
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
  #text(size: 14pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ]
]

// 06 Ship
#slide(n: 6, "Get it")[
  #heading-1[Install and build.]
  #v(0.6cm)
  #code-slab(size: 14pt)[
    ```bash
    brew install acme-kit && acme init
    ```
  ]
  #v(0.7cm)
  #text(size: 14.5pt, fill: muted)[
    Source, documentation, and every template in this gallery:
  ]
  #v(0.2cm)
  #text(font: mono, size: 13pt, weight: 600, fill: accent.darken(18%))[
    #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
  ]
  #v(0.8cm)
  #grid(
    columns: (1fr, 1fr, 1fr),
    count("1", "command"),
    count("3", "targets"),
    count("0", "drift"),
  )
]
