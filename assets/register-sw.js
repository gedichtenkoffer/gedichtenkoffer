document.addEventListener('DOMContentLoaded', function () {
    if ('serviceWorker' in navigator) {
        fetch('/sw_sri.json').then(resp => resp.json()).then(data => {
            const swIntegrity = data.sri;

            fetch('/sw.js')
            .then(response => response.arrayBuffer())
            .then(buffer => crypto.subtle.digest('SHA-384', buffer))
            .then(hash => {
                let hashArray = Array.from(new Uint8Array(hash)); 
                let hexString = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
                let base64String = btoa(hexString.match(/\w{2}/g).map(a => String.fromCharCode(parseInt(a, 16))).join(''));
                return base64String;
            })
            .then(base64Hash => {
                if (`sha384-${base64Hash}` === swIntegrity) {
                    return navigator.serviceWorker.register('/sw.js');
                } else {
                    console.log(`Expected ${swIntegrity}, but got sha384-${base64Hash}`);
                    return Promise.reject(new Error('Service Worker integrity check failed'));
                }
            })
            .then(reg => console.log('Service worker registered'))
            .catch(err => console.log(err));
        });
    }
});
