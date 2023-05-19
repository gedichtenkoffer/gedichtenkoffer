const staticCacheName = 'site-static-v1';

// install event
self.addEventListener('install', evt => {
    evt.waitUntil(
        fetch('/assets.json').then(resp => resp.json()).then(assets => {
            caches.open(staticCacheName).then(cache => {
                console.log('caching shell assets');
                cache.addAll(assets);
            });
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
