---
---

document.addEventListener('DOMContentLoaded', () => {
    const buttons = document.getElementsByTagName('button');

    const registerServiceWorker = () => {
        if ('serviceWorker' in navigator) {
            const swIntegrity = {{ '/sw.js' | source_path | read | process_content | minify: 'js' | sri_hash | jsonify }};

            fetch('/sw.js')
                .then((response) => {
                    return response.arrayBuffer();
                })
                .then((buffer) => {
                    return crypto.subtle.digest('SHA-384', buffer);
                })
                .then((hash) => {
                    const hashArray = Array.from(new Uint8Array(hash));
                    const hexString = hashArray.map((b) => {
                        return ('0' + b.toString(16)).slice(-2);
                    }).join('');
                    const base64String = btoa(hexString.match(/\w{2}/g).map((a) => {
                        return String.fromCharCode(parseInt(a, 16));
                    }).join(''));
                    return base64String;
                })
                .then((base64Hash) => {
                    if ('sha384-' + base64Hash === swIntegrity) {
                        return navigator.serviceWorker.register('/sw.js');
                    } else {
                        console.log('Expected ' + swIntegrity + ', but got sha384-' + base64Hash);
                        return Promise.reject(new Error('Service Worker integrity check failed'));
                    }
                })
                .then(() => {
                    console.log('Service worker registered');
                    navigator.serviceWorker.addEventListener('message', (e) => {
                        if (e.data && e.data.command === 'progress') {
                            const progress = document.getElementById('sw-progress');
                            const parts = e.data.message.split('/');
                            const loaded = Number(parts[0]);
                            const total = Number(parts[1]);
                            progress.value = (loaded / total) * 100;
                        }

                        // Hide the progress bar when progress is at 0%
                        if (value === 0) {
                            progress.style.display = 'none';
                        } else {
                            progress.style.display = '';
                        }
                    });
                    // remove event listeners
                    for (let i = 0; i < buttons.length; i++) {
                        buttons[i].removeEventListener('click', registerServiceWorker);
                    }
                })
                .catch((err) => {
                    return console.log(err);
                });
        }
    };

    for (let i = 0; i < buttons.length; i++) {
        buttons[i].addEventListener('click', registerServiceWorker);
    }
});
