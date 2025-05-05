'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "714ee8906cb71e0da93548ff505d2120",
"assets/AssetManifest.bin.json": "53c45cc23e15bc24ee9c8b94b29cddfa",
"assets/AssetManifest.json": "91473d067134d65b0f01965d01405b82",
"assets/assets/backgroundheader.png": "b319ba41bcfeb14ab7829206f1bf12bf",
"assets/assets/background_dark.png": "388c7e70df343cb079ba2709426b3c21",
"assets/assets/background_dark2.png": "73a2e180313d3efd964ecf17a16562d8",
"assets/assets/background_light.png": "fd5947e7c1d87ca24d51dc3b53dd07e5",
"assets/assets/background_light2.png": "5bdc8b514336ed7138b797918d4181d1",
"assets/assets/Calendar.png": "abdd930cf15c3ff5ed65be1966791c10",
"assets/assets/coreai/1.png": "44c24bbef4f63091dad107c0badbb84c",
"assets/assets/coreai/2.png": "2a09c8795a40186c9ffe2ca79d7e8ba6",
"assets/assets/coreai/3.png": "1aca20907607d013bcce1a8fdce51220",
"assets/assets/coreai/4.png": "f4afddec871f1661ef79906e80572b9f",
"assets/assets/coreai/5.png": "bcd0c537780c0e64cffdff14d3b5193a",
"assets/assets/coreai/6.png": "dc08512d2d5edc438a149ad6cb0f2119",
"assets/assets/coreai/7.png": "990e905cd65f441a617b793fff9a0b1e",
"assets/assets/coreai/8.png": "88cadae91489ea8f31db933f563129f8",
"assets/assets/coreai/color_and_logos.png": "e23f2e25fbb240b01828c1d24d82c105",
"assets/assets/coreai/color_exploration.png": "a3dce0cb6d57b8b973cb1f8006ed7ab6",
"assets/assets/coreai/device1.png": "5d7d77ee4e03e30afac487daa1ca32bf",
"assets/assets/coreai/device2.png": "8e4d3cf99ccfe2fe079e61b3bd2f9c45",
"assets/assets/coreai/device3.png": "e5c7aaf8c533eba804d9abf8d2e6f9ff",
"assets/assets/coreai/device4.png": "f3580a299c5abe41ce3ebebaceaeac15",
"assets/assets/coreai/device5.png": "35aab5a2accc03d821bf7467ec954f83",
"assets/assets/coreai/dev_handoff1.png": "8366f9dc821395e96d6cfd888e76ac2d",
"assets/assets/coreai/dev_handoff2.png": "3b2f30e33461c66b2acfef8ad8459243",
"assets/assets/coreai/dev_handoff3.png": "f1f69931757137a08bca46fe05366263",
"assets/assets/coreai/dev_handoff4.png": "0757493816ad6e3b0a608a4e7ff6fd28",
"assets/assets/coreai/flow1.png": "df98e5d9e8529c3a1ff8363d77ab675b",
"assets/assets/coreai/flow2.png": "9eec47f8317b4f0644b94c9cc49ac815",
"assets/assets/coreai/hifi1.png": "d21668e934d37136fbc0e3e45fb58a5e",
"assets/assets/coreai/hifi2.png": "2ee06f3d8fff3d0c37f059a232cc29e1",
"assets/assets/coreai/hifi3.png": "f83b3f216d46a5959d52b249c35c6b4c",
"assets/assets/coreai/hifi4.png": "b8c4f6d439b17ea216264a18a1b7f9f4",
"assets/assets/coreai/hifi5.png": "93ab64aee52359506e0595ca56ec2d25",
"assets/assets/coreai/hueristic1.png": "79b8ef87afd7baa195347f6264900466",
"assets/assets/coreai/hueristic2.png": "c040e9dac4721530b9f393aa64a881f4",
"assets/assets/coreai/hueristic_analysis.png": "4e1f074ecbc6e89f40f0d33cac54c175",
"assets/assets/coreai/mood_board.png": "de03dbc91bddb1a69436b6fc7125bf9a",
"assets/assets/empathy_mapping.png": "2bbd38b7bb3736684dba26bce739f38c",
"assets/assets/Feed.png": "c78b30e6dc9fc7f5c7cec8fcf8231965",
"assets/assets/fonts/Eyad%2520Al-Samman%2520-%2520Ghibli-Bold.otf": "70a63aaa66685e53286d4f3b1a220089",
"assets/assets/fonts/Eyad%2520Al-Samman%2520-%2520Ghibli.otf": "f7dc030ad60ba1de1447cfb26012dc63",
"assets/assets/fonts/Montserrat-Bold.ttf": "d3085f686df272f9e1a267cc69b2d24f",
"assets/assets/fonts/Montserrat-Regular.ttf": "07689d4eaaa3d530d58826b5d7f84735",
"assets/assets/fonts/PressStart2P-Regular.ttf": "f98cd910425bf727bd54ce767a9b6884",
"assets/assets/fonts/SuperMario256.ttf": "6c02f15fdbc9dd7c482b52b06d8e0a6c",
"assets/assets/google_fonts": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/ideation_sketches.png": "fca22c0d743070e42606904f41b19ae2",
"assets/assets/LinkedIn_brik.png": "885e6025d239ea4d2625da3bfed63e5a",
"assets/assets/linkedIn_drawn.png": "10e0f7430ec0fd7cc2626e5d3688440d",
"assets/assets/linkedIn_pixel.png": "793fd7cfdb259f5bc753e9edbcdd6094",
"assets/assets/linked_in_main.png": "f93ed37f90d10ecffaf035207b30116c",
"assets/assets/linked_in_nes.png": "93ba7a14ff6a147f90f76a3e6924e093",
"assets/assets/Mat.png": "d3ef1158a08def9118c7547ca63f2f37",
"assets/assets/media_content_members.png": "5ae55bf11901210a50811ab4fa193b58",
"assets/assets/menu.png": "246bb8b49e4b972dae2a9aae02d92782",
"assets/assets/menublank.png": "ccd83a9a023535969bdbae5434c4e6fb",
"assets/assets/moments/devices/1.png": "7ed1208c90d006fe1d0d0ad00190b2e6",
"assets/assets/moments/devices/10.png": "a239559b994e082eb8c5b1d2068e33e0",
"assets/assets/moments/devices/11.png": "70015272d3c6467b1a8d18a46eb46fdf",
"assets/assets/moments/devices/2.png": "efe1874767d6e02283f7217bcdcac11c",
"assets/assets/moments/devices/3.png": "cb3b19879bd0195e15eb8df878d62d29",
"assets/assets/moments/devices/4.png": "7f9ecf80e6031d870ea81ab572c0ed21",
"assets/assets/moments/devices/5.png": "263f51b56bad1d3fd265120c69f9e3b9",
"assets/assets/moments/devices/6.png": "963cabb29cea8ec568f46c638bbc1b57",
"assets/assets/moments/devices/7.png": "01083e30788d934a533a73e2d07c4cf7",
"assets/assets/moments/devices/8.png": "b75efa6325fd4b5ef8251451533ea92e",
"assets/assets/moments/devices/9.png": "5b61b6fac266d0f7d600ba28f9ae0347",
"assets/assets/moments/devices/hero.png": "f032404cb60b86ff988254aa7b618353",
"assets/assets/moments/dev_handoff/1.png": "f1d48671e1292914ef9be23e6795f0a4",
"assets/assets/moments/dev_handoff/10.png": "f94969aa9f88f580583e9793eca63f9d",
"assets/assets/moments/dev_handoff/11.png": "002fee43caf923f788813d5e514e803e",
"assets/assets/moments/dev_handoff/12.png": "6a514aedd79b9f56a4f7409cd62b861c",
"assets/assets/moments/dev_handoff/13.png": "2256d42594b65cd7b5d7b1163469a491",
"assets/assets/moments/dev_handoff/2.png": "9433178308c6fadb0aa317408c49a54b",
"assets/assets/moments/dev_handoff/3.png": "1998064ad0781b4e49c866008aa4ca1d",
"assets/assets/moments/dev_handoff/4.png": "23872ec990545940cbe159f4afd94b9b",
"assets/assets/moments/dev_handoff/5.png": "ecd60533fd147bbd9f8c940c8538466c",
"assets/assets/moments/dev_handoff/6.png": "8846d51ae2658a85bfebf3312aaab3f6",
"assets/assets/moments/dev_handoff/7.png": "9de35bb13522416457cafa7dc11b8429",
"assets/assets/moments/dev_handoff/8.png": "df99b9da18848c3f523ddb3631ff9135",
"assets/assets/moments/dev_handoff/9.png": "9505a21e75506c77cf491359b1175899",
"assets/assets/moments/hero.png": "cdee5724ac34ce614f86d644442d9211",
"assets/assets/mood_board.png": "7e783f656e9e9f044aab4ea5606a7646",
"assets/assets/nes_land_day.png": "86c67e1b255201f698fc676073b8f58f",
"assets/assets/nes_land_night.png": "13bba9adfe7cca5e63d77a04c5cce638",
"assets/assets/pdx_day.png": "7f628b7bf9393d935db7dcee94895a2d",
"assets/assets/pdx_night.png": "c79e9d6c4fc37dfa5c92abee8eb11f54",
"assets/assets/persona_eric.png": "d56c2540ea4ef7a299324af1c3615b5e",
"assets/assets/persona_michelle.png": "8a9bce06c6f735d61e2a0be41d0c34c8",
"assets/assets/Photos.png": "58d11148b8bb625b196c1e0f79f85b1f",
"assets/assets/plannie/Billing.png": "aad65f0ca420370cdc590588eef05972",
"assets/assets/plannie/device1.png": "1bab1a9d8c40e9013cce436903bd2d56",
"assets/assets/plannie/device2.png": "a57cabe242f50d9d02bae580e1957332",
"assets/assets/plannie/device3.png": "1b8ed8a2250c1473ef364277c69539d8",
"assets/assets/plannie/device4.png": "2f3734d4ceea704a508c4483eb35bd57",
"assets/assets/plannie/Events.png": "3aa3e99d84f071cb0b6a0f873653ea39",
"assets/assets/plannie/planner.png": "c6da1eeebc124d76d79167d8e373cac7",
"assets/assets/plannie/Portfolio.png": "306c57708870895c67ad80054018c826",
"assets/assets/portfolio_selection.png": "28f57be5842115704c70ef78175bcf44",
"assets/assets/portfolio_selection2.png": "124ecaf27fbd1c8732579b5f582de124",
"assets/assets/profile_picNES.png": "2afd6ebed2620e3ec042f3eaba79dfc4",
"assets/assets/profile_picREG.png": "683dca38df137e0eecae80775a03adb8",
"assets/assets/project_header.png": "8fe2ce2d90a2cb513ece869dd6ffea2d",
"assets/assets/redesign_images.png": "5794f5fde1846b1bded8028d33fb355e",
"assets/assets/Resume.pdf": "80b7ea04ffdd111bcea072411fdadd5b",
"assets/assets/Schedule.png": "d19c3a65531809661f48b8fcb7194e0d",
"assets/assets/site_map.png": "5e9d310a183d0f5ff9ccc0a9450454f7",
"assets/assets/social_content_gym_members.png": "90dca3eb78dc208437b305e3d9613414",
"assets/assets/style_guide1.png": "150a692a77ba6e31bdca5645891f362d",
"assets/assets/style_guide_athelete_dark.png": "e79d818911653122d47a27567ea9a08b",
"assets/assets/style_guide_ninja_dark.png": "b4a729a1758b4d1fe483ea50dcf436d0",
"assets/assets/style_guide_ninja_light.png": "df07d9d21f968d0561c78601e571bd4e",
"assets/assets/switch_modal.png": "c9652a9cdac534bada1f78a327e46300",
"assets/assets/tapin_header.png": "24b8b3cc4ae4dba98a4dc65a03f32614",
"assets/assets/tapin_logo.png": "9b91fd14b714ed9947e91e7199e74252",
"assets/assets/Timer.png": "99b6e68ea4cf5afe3bed7b34af5b105b",
"assets/assets/tvmodal.png": "41db37627e605995a46a5a747a6b108b",
"assets/assets/user_flows.png": "7e43ecd2234f710c1faf3991c08de3ac",
"assets/assets/wire_frame1.png": "345cdbbbd83704df491274566d52e43a",
"assets/assets/wire_frame2.png": "e14642ffbe95be1d3a04701d49a56ae8",
"assets/assets/wire_frame3.png": "a862676804a958f6e0986d6f53cc3a51",
"assets/assets/wire_frame4.png": "3bd17f57179e7c2ce74f59c38cf83253",
"assets/FontManifest.json": "a82d63039e8094bcc09f3d53c4af2c0d",
"assets/fonts/MaterialIcons-Regular.otf": "31e89ac8678373bcf7e34e0f5268b248",
"assets/NOTICES": "6b935cae95e7be925bd8f3f6f625ba30",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/easy_stepper/assets/loading_black.json": "d412b17ec906f03090996d68abab4eca",
"assets/packages/easy_stepper/assets/loading_white.json": "92623d18291ed579cf8bfe3f5fc74213",
"assets/packages/nes_ui/assets/checkered_pattern.png": "7f3e9d7ae73d37c7329ee95d1d54f531",
"assets/packages/nes_ui/google_fonts/OFL.txt": "5096248a0ad125929b038a264f57b570",
"assets/packages/nes_ui/google_fonts/PressStart2P-Regular.ttf": "f98cd910425bf727bd54ce767a9b6884",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "13ff9ae0ec38ed5ef9b5319596ccab3e",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter.png": "5dcef449791fa27946b3d35ad8803796",
"flutter_bootstrap.js": "7f293a416793cda825bbf2c876412b36",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "ca42a21897abf2725eb2691883ff5bf6",
"/": "ca42a21897abf2725eb2691883ff5bf6",
"main.dart.js": "a7b8409c82d657e6a2ff9ee78477340e",
"manifest.json": "9583ebe54188295a4768ae1aa040030b",
"version.json": "cc1fa9cce5af273c0909d105387fee89"};
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
