window.addEventListener('DOMContentLoaded', function (event) {
    if (navigator.share) {
        document.getElementById('share').style.display = 'block';
        document.getElementById('share').addEventListener('click', shareCurrentPage);
    }
});

function shareCurrentPage() {
    navigator.share({
        title: document.title,
        url: window.location.href
    }).catch(console.log);
}
