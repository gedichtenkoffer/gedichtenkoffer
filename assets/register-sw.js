document.addEventListener('DOMContentLoaded', function () {
    var buttons = document.getElementsByTagName('button');

    var registerServiceWorker = function () {
        if ('serviceWorker' in navigator) {
            fetch('/sw_sri.json').then(function (resp) {
                return resp.json();
            }).then(function (data) {
                var swIntegrity = data.sri;

                fetch('/sw.js')
                    .then(function (response) {
                        return response.arrayBuffer();
                    })
                    .then(function (buffer) {
                        return crypto.subtle.digest('SHA-384', buffer);
                    })
                    .then(function (hash) {
                        var hashArray = Array.from(new Uint8Array(hash));
                        var hexString = hashArray.map(function (b) {
                            return ('0' + b.toString(16)).slice(-2);
                        }).join('');
                        var base64String = btoa(hexString.match(/\w{2}/g).map(function (a) {
                            return String.fromCharCode(parseInt(a, 16));
                        }).join(''));
                        return base64String;
                    })
                    .then(function (base64Hash) {
                        if ('sha384-' + base64Hash === swIntegrity) {
                            return navigator.serviceWorker.register('/sw.js');
                        } else {
                            console.log('Expected ' + swIntegrity + ', but got sha384-' + base64Hash);
                            return Promise.reject(new Error('Service Worker integrity check failed'));
                        }
                    })
                    .then(function (reg) {
                        console.log('Service worker registered');
                        navigator.serviceWorker.addEventListener('message', function (e) {
                            if (e.data && e.data.command === 'progress') {
                                var progress = document.getElementById('progress');
                                var parts = e.data.message.split('/');
                                var loaded = Number(parts[0]);
                                var total = Number(parts[1]);
                                progress.value = (loaded / total) * 100;
                            }
                        });
                        // remove event listeners
                        for (var i = 0; i < buttons.length; i++) {
                            buttons[i].removeEventListener('click', registerServiceWorker);
                        }
                    })
                    .catch(function (err) {
                        return console.log(err);
                    });
            });
        }
    };

    for (var i = 0; i < buttons.length; i++) {
        buttons[i].addEventListener('click', registerServiceWorker);
    }
});
