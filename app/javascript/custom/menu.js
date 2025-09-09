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
  
  function handleSearch(){
    const input = document.getElementById("user-search-input");
    const resultsContainer = document.getElementById("search-results");

    if (!input || !resultsContainer) return;

    let timeout = null;

    input.addEventListener("input", () => {
        clearTimeout(timeout);
        timeout = setTimeout(() => {
            const query = input.value.trim();
            if (query === "") {
                resultsContainer.innerHTML = "";
                resultsContainer.classList.add("hidden");
                return;
            }

            fetch(`/users/search.json?query=${encodeURIComponent(query)}`)
                .then((response) => response.json())
                .then((data) => {
                    resultsContainer.innerHTML = data.length
                        ? data
                            .map((user) =>
                                `<a href="/users/${user.id}" class="block px-2 py-1 hover:bg-gray-100 text-black">${user.name}</a>`
                            ).join("")
                        : "<p class='px-2 py-1 text-black'>No results</p>";

                    resultsContainer.classList.remove("hidden");
                })
                .catch((err) => console.error("Search error:", err));
        }, 300);
    });

    // hide when clicking outside
    document.addEventListener("click", (e) => {
        if (!resultsContainer.contains(e.target) && e.target !== input) {
        resultsContainer.classList.add("hidden");
        }
    });
  }

  document.addEventListener("turbo:load", () => {
    addToggleListener("hamburger", "mobile-menu");
    addToggleListener("account", "menu");
    handleSearch();
  });
  
