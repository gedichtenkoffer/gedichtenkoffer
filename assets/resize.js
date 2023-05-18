window.addEventListener('resize', function () {
    var menu = document.getElementById('menu');
    var btn = document.getElementById('toggle');
    if (window.innerWidth >= 800) {
        menu.style.display = 'block';
        btn.style.display = 'none';
    } else {
        menu.style.display = 'none';
        btn.style.display = 'block';
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
