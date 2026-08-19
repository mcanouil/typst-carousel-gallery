// terminal/shell: the whole deck is one shell session, prompt by prompt, with a blinking block cursor.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#12161c") // page fill
#let paper = rgb("#1b212a") // light panel
#let ink = rgb("#dfe6ee") // body text
#let muted = rgb("#7d8a9a") // secondary text
#let hair = rgb("#2b3441") // rules and borders
#let accent = rgb("#38d39f") // the one accent
#let slab = rgb("#0b0e13") // code background
#let slab-fg = rgb("#dfe6ee") // code foreground

#let display = "JetBrains Mono"
#let body = "Inter"
#let mono = "JetBrains Mono"

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
  size: 11pt,
  weight: 700,
  fill: tint,
  tracking: 2pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  fill: tint.darken(62%),
  stroke: 0.7pt + tint.darken(25%),
  radius: 3pt,
  inset: (x: 7pt, y: 4pt),
  text(font: mono, size: 10.5pt, weight: 600, fill: tint, txt),
)

#let code-slab(body, size: 13pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  radius: 5pt,
  inset: (x: 0.7cm, y: 0.55cm),
  stroke: 1pt + hair,
  text(font: mono, size: size, fill: slab-fg, body),
)

#let shot(path, width: 100%) = block(
  clip: true,
  radius: 5pt,
  stroke: 1pt + hair,
  image(path, width: width),
)

// The block cursor that closes every command line.
#let cursor = box(width: 0.32cm, height: 0.5cm, fill: accent, baseline: 0.06cm)

// The window chrome: three dots and a title, the frame every slide sits inside.
#let chrome(title) = block(
  width: 100%,
  fill: paper,
  inset: (x: 0.55cm, y: 0.4cm),
  stroke: (bottom: 1pt + hair),
)[
  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.5cm,
    stack(
      dir: ltr,
      spacing: 0.22cm,
      ..(rgb("#ff5f57"), rgb("#febc2e"), rgb("#28c840")).map(dot => circle(
        radius: 0.16cm,
        fill: dot,
      ))
    ),
    text(font: mono, size: 11pt, fill: muted)[#title],
  )
]

// A shell prompt line: the path, the command, and the cursor when it is the
// last thing on the slide.
#let prompt(command, tail: false) = block(width: 100%)[
  // Escaped: a bare ~ is a non-breaking space in Typst markup.
  #text(font: mono, size: 15pt, fill: accent)[\~/acme-kit]
  #h(0.2cm)
  // Escaped: a bare $ opens math mode.
  #text(font: mono, size: 15pt, fill: muted)[\$]
  #h(0.2cm)
  #text(font: mono, size: 15pt, fill: ink)[#command]
  #if tail { [#h(0.15cm)#cursor] }
]

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.5cm,
  dy: -1cm,
  block(width: 18cm)[
    #grid(
      columns: (1fr, auto),
      text(font: mono, size: 9.5pt, fill: muted)[
        #url-link("github.com/mcanouil/typst-carousel-gallery")
      ],
      text(font: mono, size: 9.5pt, fill: muted)[
        #project #version #sym.dot.op #if n != none { [#n/#total] } #sym.dot.op #date
      ],
    )
  ],
)

#let heading-1(txt) = text(font: display, size: 30pt, weight: 700, fill: ink, txt)

#let slide(n: none, body) = page(fill: ground)[
  #place(top + left, chrome(project + " " + version + " -- zsh"))
  #place(top + left, dx: 1.5cm, dy: 2.7cm, block(width: 18cm, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#page(fill: ground)[
  #place(top + left, chrome("welcome -- zsh"))
  #place(
    left + horizon,
    dx: 1.5cm,
    block(width: 18cm)[
      #prompt("acme --version")
      #v(0.5cm)
      #text(font: display, size: 62pt, weight: 700, fill: ink)[#project]
      #v(0.1cm)
      #text(font: display, size: 30pt, weight: 700, fill: accent)[#version #cursor]
      #v(0.7cm)
      #block(width: 13.5cm, text(size: 17pt, fill: muted)[
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
  #code-slab(size: 13.5pt)[
    ```text
    $ ls scripts/
    build.sh  build-slides.sh  build-print.sh
    render.sh  render-old.sh   FINAL-render.sh
    ```
  ]
  #v(0.55cm)
  #block(width: 15.5cm, text(size: 16pt, fill: muted)[
    They drift. The one that matters is always the one nobody ran. A build is a
    fact about a project, not a habit of the person who last shipped it.
  ])
]

// 03 The mechanic
#slide(n: 3)[
  #kicker("How it works")
  #v(0.4cm)
  #heading-1[One command, every target.]
  #v(0.55cm)
  #block(width: 16cm, text(size: 15.5pt, fill: muted)[
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
  #prompt("acme build --profile release", tail: true)
]

// 04 Where it pays off
#slide(n: 4)[
  #kicker("Where it pays off")
  #v(0.4cm)
  #heading-1[Three places it earns its keep.]
  #v(0.65cm)
  #grid(
    columns: (1fr,),
    row-gutter: 0.55cm,
    ..(
      (
        "monthly",
        "The same command in the same order, so the December build is the January build.",
      ),
      (
        "one-source",
        "Two targets, one set of numbers. The slides cannot fall behind the manuscript.",
      ),
      (
        "handover",
        "The build is in the repository, not in the head of whoever set it up.",
      ),
    ).map(item => grid(
      columns: (3.6cm, 1fr),
      column-gutter: 0.5cm,
      chip(item.at(0)),
      text(size: 15pt, fill: muted)[#item.at(1)],
    ))
  )
]

// 05 What changed
#slide(n: 5)[
  #kicker("In " + version)
  #v(0.4cm)
  #heading-1[What changed.]
  #v(0.6cm)
  #code-slab(size: 13pt)[
    ```diff
    + profiles      one target set, several build shapes
    + incremental   rebuild only what moved
    ! paths         now resolve from the project root everywhere
    ```
  ]
  #v(0.6cm)
  #block(width: 16cm, text(size: 15.5pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
#page(fill: ground)[
  #place(top + left, chrome("install -- zsh"))
  #place(
    left + horizon,
    dx: 1.5cm,
    block(width: 18cm)[
      #kicker("Get it")
      #v(0.5cm)
      #text(font: display, size: 40pt, weight: 700, fill: ink)[Install and build.]
      #v(0.7cm)
      #code-slab(size: 14pt)[
        ```bash
        brew install acme-kit
        acme init
        ```
      ]
      #v(0.7cm)
      #text(size: 15.5pt, fill: muted)[
        Source, documentation, and every template in this gallery:
      ]
      #v(0.25cm)
      #text(font: mono, size: 14pt, fill: accent)[
        #link(repo-url)[github.com/mcanouil/typst-carousel-gallery] #cursor
      ]
    ],
  )
  #footer(n: 6)
]
