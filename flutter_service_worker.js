'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.wasm": "b30610e80e12b939b74cfb288bcaf513",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm_heavy.js": "f5c1413d222bc68856296fc97ac9fec0",
"canvaskit/skwasm_heavy.wasm": "46d64dc4061f5462f6388b8a6cd5209b",
"canvaskit/canvaskit.js.symbols": "ddb50a837e8b7d415c6983676a2bb831",
"canvaskit/canvaskit.wasm": "99c6f86a693567ec56f929f5bfc62c8e",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "7c13222ba28a700e83355a2b9808af3a",
"canvaskit/chromium/canvaskit.wasm": "0124866b96fc9207c6da34971cc87e64",
"canvaskit/skwasm_heavy.js.symbols": "1c4519808f512cd07051118f1bde9156",
"canvaskit/skwasm.js": "37fdb662bbaa915adeee8461576d69d7",
"canvaskit/skwasm.js.symbols": "a350173d8cb4ffcaee12e61e4d35a5ea",
"version.json": "69346249e9faed573f709f5684f17740",
"index.html": "15a539952e81aba81e3c98cfc813d34d",
"/": "15a539952e81aba81e3c98cfc813d34d",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
".git/index": "b4a87ff94991c2d272130a44297d80df",
".git/COMMIT_EDITMSG": "8439beb8b1732c0a2985d22d90c57484",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/objects/e3/5daa9e8ff5bf92a431f78bb9d03d142365ccae": "3f512990108ecc1da9c6c314393a2a62",
".git/objects/6b/6a2a8cc811512187255720c9812d4e2b095e71": "68a6ce7a13792dd62ebe3a1c2fc2a6b5",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/70/8b40d72abf68c7cf8fd1dfd8c5d8932f1e754c": "0a9dbb62bdf811fda1276980bfd415d6",
".git/objects/f6/0a3e74a2aa48125dc3f74db8e224f05c632425": "ba54a0ff330e449e5f3866f020c5ad3f",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/22/dbda206851973a696c6fd7237d829bc4cc8d9a": "181730e886406c473e40a317b6790f9f",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/dd/3fc57839b9ed724ca2d52c181a4e767eecb081": "e1e39eb469a779ba2ec2c80604b4f594",
".git/objects/b9/40b9f5c4eae6ab2893c95b50c65980f9a6a6b3": "ef03e3303d47aaec0b4e875e5f3a0b0b",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/cd/a2e6bfc66366648fb38a8f5bfa70a4b04815cd": "77d0e0014aa4e02e08b0909c345bfcf8",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/bd/07199e06ede3249a5a92540f0b0e118080d98d": "7ae1287843478845b3732bf026e9fe37",
".git/objects/d7/7cfefdbe249b8bf90ce8244ed8fc1732fe8f73": "9c0876641083076714600718b0dab097",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/26/199aa2e03e4c88825fa78b981d93a729ae8e47": "115fa6f59b396bfd4aaca4c450dc4896",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/35/b9cc425ba889be8afbebb10e8f50811a8e9356": "ed1ced989bc251eefc65409d386e425b",
".git/objects/35/6836ce42dd8435172a59a4393f65e19ce5942e": "d338eeee71b53432ee7dbfb7acc8d195",
".git/objects/33/7319224649e9740f1b8040712f1d0a6a826272": "eb23bfb7da724fed0559b50d17a75d12",
".git/objects/0f/f6bba8388eae0437fddc00c0a4ad93157c8a33": "9a92df6a847cb0658d2720985aee6566",
".git/objects/b6/b8806f5f9d33389d53c2868e6ea1aca7445229": "b14016efdbcda10804235f3a45562bbf",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/7a/6c1911dddaea52e2dbffc15e45e428ec9a9915": "f1dee6885dc6f71f357a8e825bda0286",
".git/objects/b3/e2af84bd96759f27a79820372c4090aa54a085": "e9a28e587f8a7b972f0ae09060b6803f",
".git/objects/cb/7763852f2f6a61f6362bc75d9ee36a78adfc65": "35e6a3fc4e41a0597b5d25f66c5e6067",
".git/objects/31/29f7962f2746a78605f5a16874981e6687c373": "312b06f243a02c0291f55aca15330e8e",
".git/objects/25/6e99624917c28937b869c13907a16e1c63d61b": "155b8a17a86e6e7f0cd4b6193f730707",
".git/objects/f7/fce69f4149502b301aaf1cd588b7748f1c02f4": "67ddd9406208cbbbd0f1c50a06330ec5",
".git/objects/08/327d7c9a4198848a27b9c69173a4a3077fa558": "96012891357256376aec9802871d6801",
".git/objects/74/8eb3b3caa312febd22dcc855bca7fb38a6a8ea": "8ac796eaf27b1ff615807a137342209e",
".git/objects/74/b00893fe1c4aed9f01df714282492640ee09fe": "ad21fb845d7e9a284d89b80b9ef433d3",
".git/objects/e6/654a7681a00ce997660f6825f01600a428265b": "efdb8cb5599bd4edf4a4e443f73ea268",
".git/objects/f0/fe8b19221415aacba22e3c9a3c8e027a93b3d0": "b58771d4805e79ed33307f5f0f4d379e",
".git/objects/e9/d42c961a59c144504999f021326c438026abaf": "619333a3aad7f215129f509d9bfa1f7e",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/06/71b1bc222b845e486065a2f59c7ea3c7df50a6": "7599f4f29f02b4dd7d4b768bf7f58243",
".git/objects/91/43ebfb1a8bfc7929326ce2670cfc0baab443a3": "aac41004f345f2618538faad8a7ba18d",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/66/62448e186ef0a0efade8c46bbf524943036084": "e27e401417d512271d174bfde9cef57c",
".git/objects/9f/7ba6f68aac12b093c283a770d58c8a7da5261b": "6a350cac5c7f26290f97a6da8560c60c",
".git/objects/fd/6f20aaf49d357c14e0c52164139f97dabe7e6e": "5d7301db9934cf26ae6bf656c58415d4",
".git/objects/fd/ccbc86ee98c1c2ba6515b73b0068bd7233ecc9": "97e6563344da401b4f03ebfbadb03c32",
".git/objects/73/975503c32674f0119e7817d1081c84b1b0b48e": "41ee25a44966d030cf398ffbce15d340",
".git/objects/68/f2a58f8a654e7ae69b60ef248f5947efb44551": "558a509fb08e887f477fad7cc9be69e8",
".git/objects/ba/c9c4f68c698aaac3e5f05a881e0fde682986d9": "7de86169fc71f231be45fb51eaea5504",
".git/objects/ba/a5a11fdb325388675f196498325b5b4eee8619": "595d5273bfce84a173891daf8046b4f6",
".git/objects/8f/a56894599efa37c48047f6f2494fc6f8f2fe04": "850010a77ebc8041803193e24596411b",
".git/logs/HEAD": "76275e684e2f21ab68cc993bb92d017f",
".git/logs/refs/heads/gh-pages": "76275e684e2f21ab68cc993bb92d017f",
".git/logs/refs/remotes/origin/gh-pages": "232565dc56ab0e59ee05160bfcd761aa",
".git/refs/heads/gh-pages": "d89302b90155701d16c3cbe6c345aef2",
".git/refs/remotes/origin/gh-pages": "d89302b90155701d16c3cbe6c345aef2",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/config": "703e56c5f1525738d84f3e3d3d863599",
"main.dart.js": "003469fc1be9e466ba6938dbb66d7350",
"flutter_bootstrap.js": "7801093efdd13d24ff6e95a043f227a2",
"manifest.json": "ee6ad2b6d047ee851cab3173fbdeb5df",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/NOTICES": "8affbd7fc84df17f63da70a1a534dd45",
"assets/AssetManifest.bin": "23cd976618f9307bac72aae75577af7b",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "c2cbee04fbd1d5670209bf5d82317767",
"assets/assets/jjHi.png": "39c1abbbecfd6e38d098d14009d96e26",
"assets/assets/run.png": "3f5844cfedb1f94f8ab5a72042bcc3f6",
"assets/assets/profile_icon.png": "5405d77c51fb46a0cbf26cb96fe4da4d",
"assets/assets/JJ_Login.jpg": "3697e077ce48340133f352aedf51e31e",
"assets/assets/profile.jpg": "36dead74d8cbcdcba91ae2196944710d",
"assets/assets/walk.png": "dec716014697aee231a0f93254da4353",
"assets/fonts/MaterialIcons-Regular.otf": "172280888d0c603389c08dab3a0eb42a",
"assets/AssetManifest.json": "68ac6977f66b8409b9731c38de56f100",
"flutter.js": "baab3b6ad5e74e3f0d43d96274f5fba9",
"favicon.png": "5dcef449791fa27946b3d35ad8803796"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
