---
---

const name = {{ site.git_hash | jsonify }};

const assets = {{ '/' | source_path | assets | jsonify }};

// Install event
self.addEventListener('install', (evt) => {
    evt.waitUntil(
        caches.open(name).then((cache) => {
            console.log('caching shell assets');

            // Iterate over each asset
            return Promise.all(assets.map((asset) => fetch(asset)
                .then((resp) => self.clients.matchAll().then(() => {
                        if (!resp.ok) throw new Error(`HTTP error! status: ${resp.status}`);
                        return cache.put(asset, resp);
                    })
                    .catch(() => fetch(asset.replace(/_/g, " ")).then((resp) => {
                        if (!resp.ok) throw new Error(`HTTP error! status: ${resp.status}`);
                        return cache.put(asset, resp);
                    }).catch(e => console.log(`Failed to download ${asset}`)))
                )
            ));
        })
    );

    // Forces the waiting service worker to become the active service worker
    self.skipWaiting();
});

// Activate event
self.addEventListener('activate', (evt) => {
    evt.waitUntil(
        caches.keys().then((keys) => Promise.all(keys
            .filter((key) => key !== name)
            .map((key) => caches.delete(key))
        ))
    );

    // Makes the service worker take control of the page immediately
    self.clients.claim();
});

// Fetch events
self.addEventListener('fetch', (evt) => evt.respondWith(
    caches.match(evt.request).then((cacheRes) => {
        return cacheRes || fetch(evt.request);
    })
));
