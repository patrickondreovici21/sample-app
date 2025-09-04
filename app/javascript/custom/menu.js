// Menu manipulation

// Add toggle listeners to listen for clicks.


function addToggleListener(selected_id, menu_id){
    let selected_element = document.querySelector(`#${selected_id}`);
    selected_element.addEventListener("click", function(even) {
        event.preventDefault();
        let menu = document.querySelector(`#${menu_id}`);
        menu.classList.toggle("hidden");
    });
}


document.addEventListener("turbo:load", function() {
    addToggleListener("hamburger", "mobile-menu");
    addToggleListener("account", "menu");
});