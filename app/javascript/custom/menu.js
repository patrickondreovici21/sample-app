// Menu manipulation

// Add toggle listeners to listen for clicks.


function addToggleListener(selected_id, menu_id, toogle_class){
    let selected_element = document.querySelector(`#${selected_id}`);
    selected_element.addEventListener("click", function(even) {
        event.preventDefault();
        let menu = document.querySelector(`#${menu_id}`);
        menu.classList.toggle(toogle_class);
    });
}


document.addEventListener("turbo:load", function() {
    addToggleListener("hamburger", "navbar-menu", "collapse");
    addToggleListener("account", "dropdown-menu", "active");
});