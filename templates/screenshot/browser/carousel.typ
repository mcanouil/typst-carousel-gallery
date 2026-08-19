// screenshot/browser: every slide sits inside a browser frame with a live address bar.
// Placeholder subject: Acme Kit 2.1.0. Replace the PROJECT block below.

#set document(title: "Acme Kit 2.1.0", author: "Your Name")
#set text(lang: "en")

// --- PROJECT (replace these) ---
#let project = "Acme Kit"
#let version = "2.1.0"
#let repo-url = "https://github.com/mcanouil/typst-carousel-gallery"
#let date = "2026-01-01"

// --- THEME ---
#let ground = rgb("#1c2128") // page fill
#let paper = rgb("#ffffff") // light panel
#let ink = rgb("#12161c") // body text
#let muted = rgb("#5c6773") // secondary text
#let hair = rgb("#dfe3e8") // rules and borders
#let accent = rgb("#0a7ea4") // the one accent
#let slab = rgb("#12161c") // code background
#let slab-fg = rgb("#eef2f6") // code foreground

#let display = "Space Grotesk"
#let body = "Inter"
#let mono = "JetBrains Mono"

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
  weight: 600,
  fill: tint,
  tracking: 1.8pt,
  upper(txt),
)

#let chip(txt, tint: accent) = box(
  fill: tint.lighten(88%),
  radius: 3pt,
  inset: (x: 7pt, y: 4pt),
  text(font: mono, size: 10pt, weight: 600, fill: tint.darken(10%), txt),
)

#let code-slab(body, size: 12.5pt, tint: accent) = block(
  width: 100%,
  fill: slab,
  radius: 4pt,
  inset: (x: 0.6cm, y: 0.5cm),
  stroke: (left: 3pt + tint),
  text(font: mono, size: size, fill: slab-fg, body),
)

// The framed shot. Replace the placeholder path with your own PNG, dropped
// beside this file and referenced as image("screenshot.png").
#let shot(path, width: 100%) = block(
  clip: true,
  radius: 3pt,
  stroke: 1pt + hair,
  image(path, width: width),
)

// The browser window every slide lives in: traffic lights, an address bar with
// a real link in it, and the page below.
// The window has no fixed height on purpose. A fixed height plus a body block
// set to `height: 100%` resolves the body against the whole frame, so the body
// overflows by the height of the title bar and the last thing on the slide is
// clipped, with no error. Letting the window size to its content also means a
// short slide gets a short window, which is what a browser does.
#let browser(address, body) = block(
  width: 17.6cm,
  radius: 7pt,
  clip: true,
  stroke: 1pt + ground.lighten(18%),
  stack(
    dir: ttb,
    block(width: 100%, fill: rgb("#e9edf1"), inset: (x: 0.4cm, y: 0.32cm))[
      #grid(
        columns: (auto, 1fr),
        column-gutter: 0.45cm,
        align: horizon,
        stack(
          dir: ltr,
          spacing: 0.2cm,
          ..(rgb("#f0645c"), rgb("#f3bd4c"), rgb("#63c363")).map(dot => circle(
            radius: 0.14cm,
            fill: dot,
          ))
        ),
        block(width: 100%, fill: paper, radius: 999pt, inset: (x: 0.35cm, y: 0.16cm))[
          #text(font: mono, size: 9.5pt, fill: muted)[
            #link("https://" + address)[#address]
          ]
        ],
      )
    ],
    block(width: 100%, fill: paper, inset: (x: 1cm, y: 0.9cm), body),
  ),
)

#let footer(n: none, total: 6) = place(
  bottom + left,
  dx: 1.7cm,
  dy: -0.85cm,
  block(width: 17.6cm)[
    #grid(
      columns: (1fr, auto),
      text(font: mono, size: 9pt, fill: hair.darken(45%))[
        #url-link("github.com/mcanouil/typst-carousel-gallery")
      ],
      text(font: mono, size: 9pt, fill: hair.darken(45%))[
        #project #version #sym.dot.op #if n != none { [#n / #total] } #sym.dot.op #date
      ],
    )
  ],
)

#let heading-1(txt) = text(font: display, size: 29pt, weight: 700, fill: ink, txt)

#let slide(n: none, address: "acme.example/docs", body) = page(fill: ground)[
  #place(left + horizon, dx: 1.7cm, dy: -0.4cm, browser(address, body))
  #footer(n: n)
]

// --- SLIDES ---

// 01 Cover
#slide(n: 1, address: "acme.example")[
  #kicker("Release")
  #v(0.6cm)
  #text(font: display, size: 52pt, weight: 700, fill: ink)[#project]
  #v(0.05cm)
  #text(font: mono, size: 25pt, weight: 600, fill: accent)[#version]
  #v(0.6cm)
  #block(width: 12cm, text(size: 16pt, fill: muted)[
    Build every report from one command, in whatever format the reader asked
    for.
  ])
  #v(0.7cm)
  #shot("/assets/placeholder-shot.svg", width: 7.4cm)
]

// 02 The gap
#slide(n: 2, address: "acme.example/why")[
  #kicker("The gap")
  #v(0.4cm)
  #heading-1[Six scripts, four formats, one deadline.]
  #v(0.55cm)
  #block(width: 14.5cm, text(size: 15pt)[
    Every project grows its own build script, and then a second one for the
    slides, and a third for the print version. They drift. The one that matters
    is always the one nobody ran.
  ])
  #v(0.5cm)
  #line(length: 100%, stroke: 1pt + hair)
  #v(0.4cm)
  #block(width: 14.5cm, text(size: 15pt, fill: accent)[
    A build is a fact about a project, not a habit of the person who last
    shipped it.
  ])
]

// 03 The mechanic
#slide(n: 3, address: "acme.example/docs/targets")[
  #kicker("How it works")
  #v(0.4cm)
  #heading-1[One command, every target.]
  #v(0.5cm)
  #block(width: 15cm, text(size: 14.5pt, fill: muted)[
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
#slide(n: 4, address: "acme.example/gallery")[
  #kicker("Where it pays off")
  #v(0.4cm)
  #heading-1[Three places it earns its keep.]
  #v(0.5cm)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 0.6cm,
    shot("/assets/placeholder-shot.svg"),
    block[
      #grid(
        columns: (1fr,),
        row-gutter: 0.4cm,
        ..(
          ("Monthly", "December's build is January's build."),
          ("One source", "The slides cannot fall behind the manuscript."),
          ("Handover", "The build is in the repository, not in a head."),
        ).map(item => block(width: 100%)[
          #text(font: display, size: 15pt, weight: 700, fill: accent)[#item.at(0)]
          #v(0.05cm)
          #text(size: 13pt, fill: muted)[#item.at(1)]
        ])
      )
    ],
  )
]

// 05 What changed
#slide(n: 5, address: "acme.example/changelog")[
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
  #block(width: 15cm, text(size: 14pt, fill: muted)[
    Upgrading is a version bump. Existing target files keep working unchanged.
  ])
]

// 06 Ship
// lint-ok: url — the address is wrapped in #link() inside browser().
#slide(n: 6, address: "github.com/mcanouil/typst-carousel-gallery")[
  #kicker("Get it")
  #v(0.4cm)
  #heading-1[Install and build.]
  #v(0.65cm)
  #code-slab(size: 13.5pt)[
    ```bash
    brew install acme-kit && acme init
    ```
  ]
  #v(0.7cm)
  #text(size: 15pt, fill: muted)[
    Source, documentation, and every template in this gallery:
  ]
  #v(0.2cm)
  #text(font: mono, size: 13.5pt, weight: 600, fill: accent)[
    #link(repo-url)[github.com/mcanouil/typst-carousel-gallery]
  ]
]
