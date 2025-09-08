function addToggleListener(selected_id, menu_id) {
    const selected_element = document.getElementById(selected_id);
    const menu = document.getElementById(menu_id);
  
    if (!selected_element || !menu) return;
  
    if (!selected_element.dataset.listenerAdded) {
      selected_element.addEventListener("click", (event) => {
        event.preventDefault();
        menu.classList.toggle("hidden");
      });
      selected_element.dataset.listenerAdded = "true";
    }
  
    menu.querySelectorAll("a").forEach(link => {
      if (!link.dataset.listenerAdded) {
        link.addEventListener("click", () => menu.classList.add("hidden"));
        link.dataset.listenerAdded = "true";
      }
    });
  }
  
  document.addEventListener("turbo:load", () => {
    addToggleListener("hamburger", "mobile-menu");
    addToggleListener("account", "menu");
  });
  