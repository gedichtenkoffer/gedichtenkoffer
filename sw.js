---
---

const name = {{ site.git_hash | jsonify }};

const assets = {{ '/' | source_path | assets | jsonify }};

// Install event
self.addEventListener('install', (evt) => {
    evt.waitUntil(
        caches.open(name).then((cache) => {
            console.log('caching shell assets');
            const total = assets.length;
            let loaded = 0;

            // Iterate over each asset
            return Promise.all(assets.map((asset) => {
                return fetch(asset).then((resp) => {
                    loaded++;
                    return self.clients.matchAll().then((clients) => {
                        clients.forEach((client) => {
                            // Send a message to each client
                            client.postMessage({
                                command: 'progress',
                                message: `${loaded}/${total}`
                            });
                        });
                        if (!resp.ok) throw new Error(`HTTP error! status: ${resp.status}`);
                        return cache.put(asset, resp);
                    });
                });
            }));
        })
    );

    // Forces the waiting service worker to become the active service worker
    self.skipWaiting();
});

// Activate event
self.addEventListener('activate', (evt) => {
    evt.waitUntil(
        caches.keys().then((keys) => {
            return Promise.all(keys
                .filter((key) => key !== name)
                .map((key) => caches.delete(key))
            );
        })
    );

    // Makes the service worker take control of the page immediately
    self.clients.claim();
});

// Fetch events
self.addEventListener('fetch', (evt) => {
    evt.respondWith(
        caches.match(evt.request).then((cacheRes) => {
            return cacheRes || fetch(evt.request);
        })
    );
});
