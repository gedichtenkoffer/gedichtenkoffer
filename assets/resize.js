window.addEventListener('resize', function () {
    const menu = document.getElementById('menu');
    const btn = document.getElementById('toggle');
    if (window.innerWidth >= 800) {
        menu.style.display = 'block';
        btn.style.display = 'none';
    } else {
        menu.style.display = 'none';
        btn.style.display = 'block';
    }
});

document.getElementById('toggle').addEventListener('click', function () {
    const btn = document.getElementById('toggle');
    const menu = document.getElementById('menu');
    menu.style.display = 'block';
    btn.style.display = 'none';
});
