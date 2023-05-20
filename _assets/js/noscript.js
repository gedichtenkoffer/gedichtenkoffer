document.addEventListener('DOMContentLoaded', function () {
    var noscriptElements = document.querySelectorAll('.noscript');
    var screenWidth = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;

    for (var i = 0; i < noscriptElements.length; i++) {
        if (noscriptElements[i].id !== 'toggle' && (screenWidth >= 800 || noscriptElements[i].id !== 'menu')) {
            noscriptElements[i].style.display = 'block';
        }
    }
});
