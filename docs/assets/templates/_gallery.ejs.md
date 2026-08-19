<%
// One card per template. The cover is a sprite sheet of all six slides, staged
// by _scripts/gallery.sh, so the card can flip through the deck on hover
// without loading six full SVGs.
//
// The sprite path is relative, not root-absolute. Quarto rewrites `src` and
// `href` to sit right for the page's depth, but it does not touch a url() in a
// style attribute, and the site is published under a path rather than at a
// domain root, so a leading slash would 404 in production while working in a
// local preview. This listing only appears on the site's index page, so a
// path relative to that page is correct.
%>

```{=html}
<div class="gallery-grid">
<% for (const item of items) { %>
  <a class="gallery-card" href="<%= item.href %>">
    <span class="gallery-cover" role="img" aria-label="The six slides of the <%= item.title %> template."
          style="background-image: url(assets/previews/<%= item.slug %>.webp)"></span>
    <span class="gallery-name"><%= item.variant %></span>
    <span class="gallery-angle"><%= item.angle %></span>
    <span class="gallery-meta"><%= item.fonts %></span>
    <span class="gallery-meta"><%= item.palette %></span>
  </a>
<% } %>
</div>
```
