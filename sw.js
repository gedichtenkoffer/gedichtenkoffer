---
---

{% capture latest_commit_hash %}
  {% assign latest_commit = site.git_log | first %}
  {% if latest_commit %}
    {{ latest_commit.sha }}
  {% else %}
    Gedichtenkoffer-v1
  {% endif %}
{% endcapture %}

var name = {{ latest_commit_hash | jsonify }}

var assets = {{ '/' | source_path | assets | jsonify }};

// install event
self.addEventListener('install', function (evt) {
    evt.waitUntil(
        caches.open(name).then(function (cache) {
            console.log('caching shell assets');
            var total = assets.length;
            var loaded = 0;
            // iterate over each asset
            return Promise.all(assets.map(function (asset) {
                return fetch(asset).then(function (resp) {
                    loaded++;
                    return self.clients.matchAll().then(function (clients) {
                        clients.forEach(function (client) {
                            // Send a message to each client.
                            client.postMessage({
                                command: 'progress',
                                message: loaded + '/' + total
                            });
                        });
                        if (!resp.ok) throw new Error('HTTP error! status: ' + resp.status);
                        return cache.put(asset, resp);
                    });
                });
            }));
        }));

    // Forces the waiting service worker to become the active service worker.
    self.skipWaiting();
});

// activate event
self.addEventListener('activate', function (evt) {
    evt.waitUntil(
        caches.keys().then(function (keys) {
            return Promise.all(keys
                .filter(function (key) {
                    return key !== name;
                })
                .map(function (key) {
                    return caches.delete(key);
                })
            );
        })
    );

    // Makes the service worker take control of the page immediately.
    clients.claim();
});

// fetch events
self.addEventListener('fetch', function (evt) {
    evt.respondWith(
        caches.match(evt.request).then(function (cacheRes) {
            return cacheRes || fetch(evt.request);
        })
    );
});
