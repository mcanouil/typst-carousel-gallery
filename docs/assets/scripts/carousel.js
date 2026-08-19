// Slide navigator for the template pages.
//
// The markup already holds all six slides. Without this script they stack and
// the deck is still readable, which is why the images are not injected here.
// Marking the container ready is what switches it to one slide at a time and
// reveals the controls.

(function () {
  "use strict";

  function setUpCarousel(carousel) {
    const slides = Array.from(carousel.querySelectorAll(".carousel-slide"));
    if (slides.length < 2) {
      return;
    }

    const status = carousel.querySelector(".carousel-status");
    const previous = carousel.querySelector(".carousel-previous");
    const next = carousel.querySelector(".carousel-next");
    if (!status || !previous || !next) {
      return;
    }

    const dots = document.createElement("div");
    dots.className = "carousel-dots";
    dots.setAttribute("role", "tablist");
    dots.setAttribute("aria-label", "Slides");

    const buttons = slides.map(function (_, index) {
      const dot = document.createElement("button");
      dot.type = "button";
      dot.className = "carousel-dot";
      dot.setAttribute("role", "tab");
      dot.setAttribute("aria-label", "Slide " + (index + 1));
      dot.addEventListener("click", function () {
        show(index);
      });
      dots.appendChild(dot);
      return dot;
    });

    carousel.appendChild(dots);

    let current = 0;

    function show(index) {
      current = (index + slides.length) % slides.length;
      slides.forEach(function (slide, position) {
        slide.classList.toggle("is-current", position === current);
      });
      buttons.forEach(function (dot, position) {
        const isCurrent = position === current;
        dot.classList.toggle("is-current", isCurrent);
        dot.setAttribute("aria-selected", isCurrent ? "true" : "false");
      });
      status.textContent = "Slide " + (current + 1) + " of " + slides.length;
    }

    previous.addEventListener("click", function () {
      show(current - 1);
    });
    next.addEventListener("click", function () {
      show(current + 1);
    });

    carousel.setAttribute("tabindex", "0");
    carousel.addEventListener("keydown", function (event) {
      if (event.key === "ArrowLeft") {
        event.preventDefault();
        show(current - 1);
      } else if (event.key === "ArrowRight") {
        event.preventDefault();
        show(current + 1);
      }
    });

    carousel.classList.add("is-ready");
    show(0);
  }

  document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".carousel").forEach(setUpCarousel);
  });
})();
