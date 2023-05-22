document.querySelectorAll('a.toggle-submenu').forEach((a) => {
    a.addEventListener('click', (e) => {
        e.preventDefault();
        let submenu = e.target.nextElementSibling;
        if (submenu) {
            submenu.classList.toggle('show');
            e.target.classList.toggle('active');
        }
    });
});
