document.querySelectorAll('.toggle-submenu').forEach((a) => {
    a.addEventListener('click', (e) => {
        e.preventDefault();
        const submenu = e.target.nextElementSibling;
        if (submenu) {
            submenu.classList.toggle('show');
            e.target.classList.toggle('active');
        }
    });
});

document.querySelector('nav h2').addEventListener('click', () => {
    const menu = document.querySelector('nav ul');
    if (window.innerWidth <= 800) {
        menu.style.display = menu.style.display == 'block' ? 'none' : 'block';
    }
});
