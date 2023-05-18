window.addEventListener('resize', function () {
    const menu = document.getElementById('menu');
    if (window.innerWidth >= 800) {
        menu.style.display = 'block';
    } else if (window.innerWidth < 800 && menu.style.display !== 'block') {
        menu.style.display = 'none';
    }
});

document.getElementById('toggle').addEventListener('click', function () {
    var menu = document.getElementById('menu');
    if (menu.style.display === 'block') {
        menu.style.display = 'none';
    } else {
        menu.style.display = 'block';
    }
});
