// app/javascript/application.js
import "@hotwired/turbo-rails";
import "./controllers";
import * as bootstrap from "bootstrap";

console.log("Bootstrap imported:", typeof bootstrap !== "undefined" ? "Yes" : "No");

document.addEventListener("turbo:load", () => {
  console.log("turbo:load event fired");

  // Navbar collapse
  const navbarCollapse = document.querySelector("#navbarNav");
  const toggler = document.querySelector(".navbar-toggler");

  if (navbarCollapse && toggler) {
    navbarCollapse.classList.remove("show");
    toggler.classList.add("collapsed");
    toggler.setAttribute("aria-expanded", "false");

    const newToggler = toggler.cloneNode(true);
    toggler.parentNode.replaceChild(newToggler, toggler);

    newToggler.addEventListener("click", () => {
      const isExpanded = navbarCollapse.classList.contains("show");
      if (isExpanded) {
        navbarCollapse.classList.remove("show");
        newToggler.classList.add("collapsed");
        newToggler.setAttribute("aria-expanded", "false");
      } else {
        navbarCollapse.classList.add("show");
        newToggler.classList.remove("collapsed");
        newToggler.setAttribute("aria-expanded", "true");
      }
      console.log("Navbar toggled - show:", navbarCollapse.classList.contains("show"));
    });
  }

  // Dropdowns
  const dropdownElements = document.querySelectorAll(".dropdown-toggle");
  console.log("Dropdown elements found:", dropdownElements.length);
  dropdownElements.forEach((dropdown, index) => {
    dropdown.removeAttribute("data-bs-toggle");

    const newDropdown = dropdown.cloneNode(true);
    dropdown.parentNode.replaceChild(newDropdown, dropdown);

    // Explicitly set placement to avoid Popper error
    const dropdownInstance = new bootstrap.Dropdown(newDropdown, {
      placement: "bottom-end" // Matches your "dropdown-menu-end" class
    });
    newDropdown.addEventListener("click", (e) => {
      e.preventDefault();
      dropdownInstance.toggle();
      console.log(`Dropdown ${index} toggled - show:`, newDropdown.nextElementSibling.classList.contains("show"));
    });
  });
});