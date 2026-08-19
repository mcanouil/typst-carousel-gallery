# Icons

`icon.svg` is this project's own mark: one square slide with three pagination dots below it.
The square is the shape every template in the gallery renders to, and the dots are what a carousel puts under a deck you can page through.
The middle dot is solid and the outer two are at 55 percent, so the mark reads as a position in a deck rather than three separate marks.

The geometry is snapped to a 32 by 32 grid.
The slide covers 5 to 27 across and 2 to 24 down, and the dots have a radius of 2 at a centre line of 28.
That puts the whole mark between 2 and 30, which is centred in the square, and it makes each dot 12.5 percent of the viewBox across.
Nothing here is thinner than that, because a favicon is 16 pixels wide and a thin part disappears at that size.

## Colours

The mark takes one colour from `../../_brand.yml`, and it changes with the colour scheme.
`blue`, `#1d5c9e`, is the light value, and it sits on the `g` element as a presentation attribute.
`sky`, `#63a6e8`, is the dark value, and a `prefers-color-scheme` rule inside the SVG replaces the attribute with it.

Measured against the grounds of the same palette, `#1d5c9e` on `bone` `#fbfaf8` is about 6.7 to 1, and `#63a6e8` on `ink` `#12181f` is about 6.9 to 1.
Both are above the 4.5 to 1 that a non-text mark of this size is held to.

## Rasters

The rasters are flattened onto `#12181f`, the `ink` this site is painted with in dark mode, so the mark has to come out in the dark colour.
`rsvg-convert` renders a file with no colour scheme at all, which leaves the `prefers-color-scheme` rule inactive and the light presentation attribute in force.
A user stylesheet passed with `--stylesheet` outranks a presentation attribute, so one line of CSS is what forces the dark value for the raster step.

Tools: `rsvg-convert` (librsvg) for the vector to raster step, `magick` (ImageMagick 7) for padding, flattening, and `.ico` assembly.
Neither is a build dependency; the commands are run by hand when the master changes.

Run from this directory.

```bash
printf '.mark { fill: #63a6e8; }\n' > /tmp/icon-dark.css

for size in 32 144 154 410; do
  rsvg-convert -w "${size}" --stylesheet /tmp/icon-dark.css icon.svg -o "/tmp/icon-${size}.png"
done

magick /tmp/icon-32.png -background '#12181f' -gravity center -extent 32x32 -flatten -strip /tmp/icon-32-flat.png
magick /tmp/icon-32-flat.png -define icon:format=png ../../favicon.ico
magick /tmp/icon-144.png -background '#12181f' -gravity center -extent 180x180 -flatten -strip apple-touch-icon.png
magick /tmp/icon-154.png -background '#12181f' -gravity center -extent 192x192 -flatten -strip icon-192.png
magick /tmp/icon-410.png -background '#12181f' -gravity center -extent 512x512 -flatten -strip icon-512.png
```

The viewBox is square, so `rsvg-convert -w` alone gives a square render and `-extent` only adds the padding around it.
The intermediate sizes put the mark at 80 percent of the final square, which is the 10 percent padding the Apple touch icon wants.
The favicon takes the full square instead, since it is only 32 pixels to begin with.

| File                   | Size    | Purpose                                                    |
| ---------------------- | ------- | ---------------------------------------------------------- |
| `icon.svg`             | vector  | `extensions.atelier.icon`, and the source for the rest     |
| `../../favicon.ico`    | 32x32   | `website.favicon`, for clients that ignore the SVG         |
| `apple-touch-icon.png` | 180x180 | `extensions.atelier.apple-touch-icon`, opaque, 10% padding |
| `icon-192.png`         | 192x192 | `../../site.webmanifest`                                   |
| `icon-512.png`         | 512x512 | `../../site.webmanifest`                                   |

There is no maskable icon: this is a documentation site, not an installable application.

## Manifest colours

`../../site.webmanifest` sets both `theme_color` and `background_color` to `#12181f`, the same `ink` the rasters sit on, and JSON takes no comment to say why.

`background_color` paints the splash screen behind the icon before the first frame renders, so matching the ground the icon was flattened onto is what stops a light rim appearing around it.
`theme_color` is the arguable one, because a manifest carries a single value and cannot vary by colour scheme.
The per-scheme `theme-color` meta tags do that job for the browser chrome, emitted by the atelier filter from the brand: `#fbfaf8` in light and `#12181f` in dark.
The manifest is left dark for coherence with the icon rather than matching either scheme.
