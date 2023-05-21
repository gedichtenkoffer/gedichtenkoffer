document.addEventListener('DOMContentLoaded', () => {
    const buttons = document.getElementsByTagName('button');

    const registerServiceWorker = () => {
        if ('serviceWorker' in navigator) {
            const thisScript = document.getElementById('register');
            const param = thisScript.getAttribute('data-param');
            console.log('register service worker data params', param);

            fetch('/sw.js')
                .then(response => response.arrayBuffer())
                .then(buffer => crypto.subtle.digest('SHA-384', buffer))
                .then(hash => {
                    const hashArray = Array.from(new Uint8Array(hash));
                    const hexString = hashArray.map(b => ('0' + b.toString(16)).slice(-2)).join('');
                    const base64String = btoa(hexString.match(/\w{2}/g).map(a => String.fromCharCode(parseInt(a, 16))).join(''));
                    return base64String;
                })
                .then(base64Hash => {
                    if ('sha384-' + base64Hash === param) {
                        return navigator.serviceWorker.register('/sw.js');
                    } else {
                        console.log(`Expected ${param}, but got sha384-${base64Hash}`);
                        return Promise.reject(new Error('Service Worker integrity check failed'));
                    }
                })
                .then(reg => {
                    console.log('Service worker registered');
                    navigator.serviceWorker.addEventListener('message', e => {
                        if (e.data && e.data.command === 'progress') {
                            const progress = document.getElementById('sw');
                            const parts = e.data.message.split('/');
                            const loaded = Number(parts[0]);
                            const total = Number(parts[1]);
                            progress.value = (loaded / total) * 100;

                            // Hide the progress bar when progress is at 0%
                            progress.style.display = progress.value === 0 ? 'none' : '';
                        }
                    });

                    // remove event listeners
                    buttons.forEach(button => button.removeEventListener('click', registerServiceWorker));
                })
                .catch(err => console.log(err));

            buttons.forEach(button => button.addEventListener('click', registerServiceWorker));
        }
    }
});
