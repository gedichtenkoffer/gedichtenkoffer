const staticCacheName = 'site-static-v1';

// install event
self.addEventListener('install', evt => {
    evt.waitUntil(
        fetch('/assets.json').then(resp => resp.json()).then(assets => {
            caches.open(staticCacheName).then(cache => {
                console.log('caching shell assets');
                let total = assets.length;
                let loaded = 0;
                // iterate over each asset
                return Promise.all(assets.map(asset => {
                    return fetch(asset).then(resp => {
                        loaded++;
                        self.clients.matchAll().then(clients => {
                            clients.forEach(client => {
                                // Send a message to each client.
                                client.postMessage({
                                    command: 'progress',
                                    message: `${loaded}/${total}`
                                });
                            });
                        });
                        if (!resp.ok) throw new Error(`HTTP error! status: ${resp.status}`);
                        return cache.put(asset, resp);
                    });
                }));
            }).catch(err => console.log(`Error caching assets: ${err}`));
        })
    );
});

// activate event
self.addEventListener('activate', evt => {
    evt.waitUntil(
        caches.keys().then(keys => {
            return Promise.all(keys
                .filter(key => key !== staticCacheName)
                .map(key => caches.delete(key))
            );
        })
    );
});

// fetch events
self.addEventListener('fetch', evt => {
    evt.respondWith(
        caches.match(evt.request).then(cacheRes => {
            return cacheRes || fetch(evt.request);
        })
    );
});
