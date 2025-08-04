'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "64b95260a01f81838cddddd0dc029c66",
"assets/AssetManifest.bin.json": "d9ccf84b958fcd223900078c2045d094",
"assets/AssetManifest.json": "0a52e2848a7318a6d888b20d969aff58",
"assets/assets/1_stoic.png": "8b550b1e49c4dfd77304c2a255a16748",
"assets/assets/1_stoic_spine.png": "d512ef50c5995e6c8d46de6b8b8bedb2",
"assets/assets/2_moon.png": "ac6eb0034f698b4074134bc0f790512a",
"assets/assets/2_moon_spine.png": "36cd89524c87d753cd92b629194c4408",
"assets/assets/3_dog.png": "45e649b3780471d2dba2f94b143ee1ae",
"assets/assets/3_dog_spine.png": "80c826eff732a6fcf49ede6bc289f733",
"assets/assets/4_bird.png": "7504541f7eef618d7ee8a933d54c00bf",
"assets/assets/4_bird_spine.png": "e883ffd3bb0e64af68fcedc4bcdeb822",
"assets/assets/about/beard.png": "56923db35c3956781aaba05a579b8760",
"assets/assets/about/bjj.png": "b2bc4c29b4c193a77d8109d58b528cf6",
"assets/assets/about/brownbelt.png": "d29b4ee727ef28fd5fc4109a6812c85d",
"assets/assets/about/fam1.png": "118970c383a47deb3bbd4501ae35c31a",
"assets/assets/about/fam2.png": "574c9cb8c4dc6dd82f35c49c6adaf993",
"assets/assets/about/house1.png": "f23073ff7e707e9074b886acc8ec6a49",
"assets/assets/about/lackamas.png": "cf826868d529466e724f71be43b75a74",
"assets/assets/about/sauvies.png": "ebf8fbf8564b737618a01569694c2e62",
"assets/assets/about/sauvies2.png": "13d28fc2ca8c5b54e76e0deecff1b7d9",
"assets/assets/about/sunset.png": "e3c0e143cadaeea26f67e0e4324d6af9",
"assets/assets/about/wedding.png": "a08f1c5b5d1a8ad143ac9efe38646d52",
"assets/assets/AssetManifest.bin": "569ac2245f5958610ecda55462936818",
"assets/assets/AssetManifest.bin.json": "3577372abf69a52038d9d48f11be0073",
"assets/assets/AssetManifest.json": "385ec0c8bb2b58cc829a66cda1eef485",
"assets/assets/athlete_dark.png": "7d368c6579d77a379c02be7d0b326b68",
"assets/assets/avatars/avatar1.png": "d7dae6bf9a1a5e2c6902f61dbb2bca2c",
"assets/assets/avatars/avatar2.png": "fb7adc0ea81058e4b0b14e0ec076deb0",
"assets/assets/avatars/avatar3.png": "3b64f25d39c1db1370792572bb3f6fdd",
"assets/assets/avatars/avatar4.png": "d13050b961e488c9945cd7cc6e517c2d",
"assets/assets/avatars/avatar5.png": "606ffb2b4b8d9121be476a6d711c446c",
"assets/assets/avatars/avatar6.png": "acd78457e76c1677b157d574676cba67",
"assets/assets/backgroundheader.png": "b319ba41bcfeb14ab7829206f1bf12bf",
"assets/assets/background_dark.png": "388c7e70df343cb079ba2709426b3c21",
"assets/assets/background_dark2.png": "73a2e180313d3efd964ecf17a16562d8",
"assets/assets/background_light.png": "fd5947e7c1d87ca24d51dc3b53dd07e5",
"assets/assets/background_light2.png": "5bdc8b514336ed7138b797918d4181d1",
"assets/assets/BiBi.png": "0d255d1d617f3018d078a6ea148f0620",
"assets/assets/Calendar.png": "abdd930cf15c3ff5ed65be1966791c10",
"assets/assets/carousels/tapin/add_images.png": "56aae21b6c5c7d547ed1b4504b385a7b",
"assets/assets/carousels/tapin/add_socials.png": "4001d6fb2d52db81ed1dfbea71a853fc",
"assets/assets/carousels/tapin/add_youtube.png": "59d8eb6b9577a6ae4e1312d5b69e04e4",
"assets/assets/carousels/tapin/alert1.png": "b614e163647a853708455be949ede49b",
"assets/assets/carousels/tapin/alert2.png": "4a3ab54f6b9fc2953237eac55ed4a7d4",
"assets/assets/carousels/tapin/belt_selection.png": "e98e188feb78fb263700f150ca22b931",
"assets/assets/carousels/tapin/channel1.png": "8c43c21d7cfb9cf248a117c5cdc0c5c6",
"assets/assets/carousels/tapin/create_event2.png": "0c922d872280a1791518478c809bff85",
"assets/assets/carousels/tapin/create_event3.png": "e33c826e319493c0f0616d7d38b4686d",
"assets/assets/carousels/tapin/date_picker.png": "2f048dbdb266255a5965a5d8a4060630",
"assets/assets/carousels/tapin/drawer1.png": "9976f8ae5ea2ff8793673f1ab5570cfa",
"assets/assets/carousels/tapin/drawer2.png": "7dc7e5c7c9c94be98d2c50865389d084",
"assets/assets/carousels/tapin/event_details1.png": "a447ac088b7b9b24419a3dfed9c41dbd",
"assets/assets/carousels/tapin/event_planner.png": "bd8df335d61379ecc7b617d3d50ca0d4",
"assets/assets/carousels/tapin/gym_home2.png": "285edf3df84ec8422e6ae2e79b3a5060",
"assets/assets/carousels/tapin/image_view1.png": "e55f88d4b697a954343fdeeb41bfa221",
"assets/assets/carousels/tapin/library_view.png": "2477e2d6b42c377c175772204940acba",
"assets/assets/carousels/tapin/main_screen1.png": "9b0c37b8b645344dca9cf665c6854b56",
"assets/assets/carousels/tapin/main_screen2.png": "37c85f9f25c313878f1ae5e394b33118",
"assets/assets/carousels/tapin/main_screen3.png": "4a03fec02910f23818245be54b9156fe",
"assets/assets/carousels/tapin/mat_create1.png": "a89edcc34f162900aae5d665992db705",
"assets/assets/carousels/tapin/mat_create2.png": "5bb4f9f405bb86568aef46aaef08b8ab",
"assets/assets/carousels/tapin/members_view.png": "908575ddb18909538e0713049652aaef",
"assets/assets/carousels/tapin/menu1.png": "096ef780998e2ab44e733bce5ac23f19",
"assets/assets/carousels/tapin/notifications1.png": "d430c22b8d453e7911db002b99b9c790",
"assets/assets/carousels/tapin/private_dm1.png": "2f75ff86c957a89b427bf3c6628dbea0",
"assets/assets/carousels/tapin/profile1.png": "7c3cd1256942678b8ec0f568e1482fa5",
"assets/assets/carousels/tapin/profile2.png": "453e4509413a050aecd76f5760180ae3",
"assets/assets/carousels/tapin/reply.png": "c8dfd1f96f05a927c7eaea3e9d6e7289",
"assets/assets/carousels/tapin/schedule1.png": "92c99f5ff3e3e28b9ec60063d0102d8a",
"assets/assets/carousels/tapin/schedule2.png": "9c53d8bca6effbd046c811d482e1dd11",
"assets/assets/carousels/tapin/schedule3.png": "6bd7c2b7c98701c3020e7a3e6959f349",
"assets/assets/carousels/tapin/schedule4.png": "8b6b23677731a26e7fdf88527113e427",
"assets/assets/carousels/tapin/select_photo.png": "4e4b89b257ec5185c4922375ebfb2b64",
"assets/assets/carousels/tapin/settings1.png": "b3131cacc34362157cd65c0638c35c76",
"assets/assets/carousels/tapin/stats1.png": "9b70626622e44ddff8a78a24b3039ccd",
"assets/assets/carousels/tapin/team_channel1.png": "c074e743bdcd7aa9eb5442542eaa0e9a",
"assets/assets/carousels/tapin/team_channel2.png": "d467502761370e5df35eb927b54fa3f7",
"assets/assets/carousels/tapin/team_dropdown.png": "a9dc1594db92f23b512dd484b6530ca0",
"assets/assets/carousels/tapin/team_page1.png": "90ae439425316b7f13d3b5b57eea2f6f",
"assets/assets/carousels/tapin/thread1.png": "50763783ded8983398987679deff58e9",
"assets/assets/carousels/tapin/timer.png": "156cc6943f7e73174488d89db546ba20",
"assets/assets/carousels/tapin/upcoming1.png": "07f7eb2aed900c9010e7b7a916a8e0a3",
"assets/assets/chrome_dark.png": "30cbefdab4c5144b9839432a1cef4abc",
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
"assets/assets/coreai_card.png": "c4e94a2569315ed74310881985afda16",
"assets/assets/cover_1.png": "d77735fdc4e8374c6eea61e9f97c7c19",
"assets/assets/cover_2.png": "b7d77bfb352197a4569962720a0f201a",
"assets/assets/cover_3.png": "f4fbdf4fabba7c4dfe9d7c12953b7d79",
"assets/assets/empathy_mapping.png": "2bbd38b7bb3736684dba26bce739f38c",
"assets/assets/favicon.png": "7e03912ce901751f292c31e6d03914d7",
"assets/assets/Feed.png": "c78b30e6dc9fc7f5c7cec8fcf8231965",
"assets/assets/folder_backcover.png": "735751dbc85859cc2dce93692dd1095e",
"assets/assets/folder_frontcover.png": "e0f3b70c04bdf2ac1d1b0630f1502fcd",
"assets/assets/FontManifest.json": "e2fe4312b772f3c467fe6e8802ecb79c",
"assets/assets/fonts/actionj.ttf": "966fa0e7a1322981c3d26104178faa32",
"assets/assets/fonts/Bandica.otf": "26761ffe9effe4350a84185ac7309879",
"assets/assets/fonts/Bangers.ttf": "36cfbe58588c147ce392e4802c9f7dbf",
"assets/assets/fonts/BlackItalic.otf": "647ad7b734271f858d61a94283fd0502",
"assets/assets/fonts/CHLORINR.ttf": "f7bf0ceda99d84458d49ecded76b5203",
"assets/assets/fonts/cocogoose-gradient.ttf": "bb860f1fea6b2a7dd53745700d2351f1",
"assets/assets/fonts/cocogoose-outlined.ttf": "268915079637fad95d3c86a160bdb750",
"assets/assets/fonts/coolvetica.ttf": "9f8f94da505b64eaf9df93eb2e3161d2",
"assets/assets/fonts/DisplayBold.otf": "644563f48ab5fe8e9082b64b2729b068",
"assets/assets/fonts/eroded-personal-use-regular.ttf": "d36b1ee903895dbf2ea76d8099c82f07",
"assets/assets/fonts/exprswy.ttf": "bc06d0c87bd9b04dcc9ae035c45ea4fa",
"assets/assets/fonts/Eyad%2520Al-Samman%2520-%2520Ghibli-Bold.otf": "70a63aaa66685e53286d4f3b1a220089",
"assets/assets/fonts/Eyad%2520Al-Samman%2520-%2520Ghibli.otf": "f7dc030ad60ba1de1447cfb26012dc63",
"assets/assets/fonts/ghasan.ttf": "59a393707b6a5c48f0c71e14fc46ec27",
"assets/assets/fonts/HeavyItalic.otf": "d70a8b7adbe065dd69b16459ffab4231",
"assets/assets/fonts/KOMIKAX_.ttf": "58182d5fa2499a9cacb719bbf2025f7b",
"assets/assets/fonts/LightItalic.otf": "bee8986f3bf3e269e81e7b64996e423c",
"assets/assets/fonts/Medium.otf": "51fd7406327f2b1dbc8e708e6a9da9a5",
"assets/assets/fonts/Montserrat-Bold.ttf": "d3085f686df272f9e1a267cc69b2d24f",
"assets/assets/fonts/Montserrat-Regular.ttf": "07689d4eaaa3d530d58826b5d7f84735",
"assets/assets/fonts/MotterTekturaNormal.ttf": "3bb930b30d756b779818d5a9435363b6",
"assets/assets/fonts/PassionOne-Black.ttf": "b53a174f69515cb04532e762ee81b1c9",
"assets/assets/fonts/PassionOne-Bold.ttf": "7b5a88f5f66f6fd860af11a53acefb27",
"assets/assets/fonts/PassionOne-Regular.ttf": "65f5f07f122bd8ffc6d51140b92525c5",
"assets/assets/fonts/PressStart2P-Regular.ttf": "f98cd910425bf727bd54ce767a9b6884",
"assets/assets/fonts/Regular.otf": "aaeac71d99a345145a126a8c9dd2615f",
"assets/assets/fonts/SedgwickAveDisplay-Regular.ttf": "7abdb18957f079a8f1af9978d829fbac",
"assets/assets/fonts/SemiBold.otf": "fce0a93d0980a16d75a2f71173c80838",
"assets/assets/fonts/stamped.ttf": "c574c0a1a146ed5de61f4fc7c6b497b8",
"assets/assets/fonts/SuperMario256.ttf": "6c02f15fdbc9dd7c482b52b06d8e0a6c",
"assets/assets/fonts/ThinItalic.otf": "9d5ed420ac3a432eb716c670ce00b662",
"assets/assets/fonts/UltraLightItalic.otf": "fa570fc4ded697c72608eae4e3675959",
"assets/assets/gameboy.png": "d51f8d21caf7ab4665bdf662354bcbf0",
"assets/assets/game_changer.png": "bce9f88fa80ff71e2414ba205e30f5b7",
"assets/assets/google_fonts": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/graciebook.png": "16ed348469e6162435bf1005ed9351ad",
"assets/assets/icons/addmessage.png": "a43e7132caab243f0c921aa7f45bfcb3",
"assets/assets/icons/circle_linkedin.png": "d1650fb1bc9f67e77f5d84db0bb31f2e",
"assets/assets/icons/contact.png": "51d9170d45cb6fb1d6b9ec64d1de3eae",
"assets/assets/icons/hand_drag.png": "6549638f123bdc92a49351566c649fbe",
"assets/assets/icons/liked_shaka.png": "25ec39682c6b10ed6e795bdbc01f35e5",
"assets/assets/icons/linkeddark.png": "3ffebd5dc0e9aee59852c151dfaeb319",
"assets/assets/icons/linkedin_circle.png": "230cd84194d80db6673b10ba337e1a74",
"assets/assets/icons/resume.png": "33372fd0a15ed4bdb96a90ab0f439f06",
"assets/assets/icons/svg/addbasicon.svg": "73c0621737b695fdda155f582fb43930",
"assets/assets/icons/svg/add_circle_line.svg": "11854ff6698cd32599980eb88fac33be",
"assets/assets/icons/svg/arrowup.svg": "f957caf361cb6c5719c280c5497da318",
"assets/assets/icons/svg/arrow_left_circle_fill.svg": "8031533f139f788849944988b97309cd",
"assets/assets/icons/svg/arrow_left_circle_line.svg": "5f6116366b8e78fed3bd780b9bc65f49",
"assets/assets/icons/svg/basiconedit.svg": "daa27bc4ab1d94b9fcf5913d42babb98",
"assets/assets/icons/svg/board_line.svg": "03b1fdbdda55441b8463b44f51ac939c",
"assets/assets/icons/svg/campground_line.svg": "adc6999a7dbb27c6c1ec99dd068fb44f",
"assets/assets/icons/svg/chartbasicon.svg": "144bdb5f840dc8be94d43c2e4417aa3c",
"assets/assets/icons/svg/chart_bar_2_line.svg": "0b83fc06bdd2fe7046009cdd4713a5a7",
"assets/assets/icons/svg/chart_bar_line.svg": "2b02e579c3fe245a5a5f00fd1587835e",
"assets/assets/icons/svg/commentbasicon.svg": "5503a9f9f61d6dd1bccaaf079ef29f4c",
"assets/assets/icons/svg/comment_2_line.svg": "69d82f2b5bf1b7f0573bb4308c92428a",
"assets/assets/icons/svg/components_line.svg": "9feaa2fddfa764bc76000c241cbc600f",
"assets/assets/icons/svg/computerbasicon.svg": "d029807ea12305dc2eb95f442f7a1d1e",
"assets/assets/icons/svg/contactbasicon.svg": "ea685b628da6eab1cb9a2ff2c3732270",
"assets/assets/icons/svg/contacts_3_line.svg": "c9a1a5e9af95b341718eb26400ce2db6",
"assets/assets/icons/svg/crescent_moon.svg": "35a35380875109475b534ae9a26f69ca",
"assets/assets/icons/svg/dashboard.svg": "87cec4c6f0e56358b2766559ecebca2b",
"assets/assets/icons/svg/display_line.svg": "f305c63ecbf4de7057938afe52fe29d1",
"assets/assets/icons/svg/documents_fill.svg": "71063dd1d90b65f0b4a6ac9a773948a3",
"assets/assets/icons/svg/document_line.svg": "89c610c884e65104c651263b0aa87c89",
"assets/assets/icons/svg/earth_latitude_fill.svg": "0e9674328d89ff0168556ae662daf379",
"assets/assets/icons/svg/editbasicon.svg": "ea4d6de68c7825f74cdff02accdee6ee",
"assets/assets/icons/svg/emailbasicon.svg": "86bb7ef2405d4c3a1a31ef12e66dfbeb",
"assets/assets/icons/svg/flash.svg": "b489202a01f03223fd65929dc03e4827",
"assets/assets/icons/svg/font_size_line.svg": "2d8e966540319ad34632ae32592bdb11",
"assets/assets/icons/svg/full_moon_line.svg": "d13cd4e31fb0a3d7bf60b116b35a87de",
"assets/assets/icons/svg/heart.svg": "70076b04cfaf024e950947ef64a36d42",
"assets/assets/icons/svg/home_3_line.svg": "3d8e7f21563b1b154efa57afa656e132",
"assets/assets/icons/svg/housebasicon.svg": "00576cb9a2ae5372f25e339d2e276479",
"assets/assets/icons/svg/IDcard_line.svg": "6f6d1fb004c1f644e5177d67aeab4096",
"assets/assets/icons/svg/left_fill.svg": "e785443f508a80b6be8de762dea76d98",
"assets/assets/icons/svg/left_small_line.svg": "5cd783c1ed09c5347f74c801a8ff4d06",
"assets/assets/icons/svg/linkedbasicon.svg": "0a4355d69c385e4e5d982000d6f33d64",
"assets/assets/icons/svg/linkedin_fill.svg": "fefff7c24a772f3ec17cf53ef3a4d5ef",
"assets/assets/icons/svg/linkedin_line.svg": "9c7d6ab2120edb3a47a9634f0510410c",
"assets/assets/icons/svg/magnet.svg": "3bb3b1937d3d7408720cf004a4951b0e",
"assets/assets/icons/svg/menu_fill.svg": "cd6d0815479ac3d9bebe9657bc7f60ca",
"assets/assets/icons/svg/menu_line.svg": "fcb2a3d2ed5f559076a42c5dba20889d",
"assets/assets/icons/svg/movie_line.svg": "f4a7bd94d2cda09ef53acf18c1b12b38",
"assets/assets/icons/svg/mushroom_line.svg": "093c2e489ae7ea20611d4fccc1766ff3",
"assets/assets/icons/svg/nintendo_switch_line.svg": "a5ef422f8ae97bf75d1be4593aa7a596",
"assets/assets/icons/svg/palette_2_line.svg": "8e9e010f71b4852a1c99808db1c0afde",
"assets/assets/icons/svg/palette_3_line.svg": "e5027b6c8ab13e8e857360f8c6093719",
"assets/assets/icons/svg/palette_line.svg": "1a7932f4283a1641355d855afd2b609b",
"assets/assets/icons/svg/pencil.svg": "e0ed2a6a3428e4b094a34f9615a32447",
"assets/assets/icons/svg/pencil3.svg": "635bd9c3310240c6de4c1356b05405fd",
"assets/assets/icons/svg/personbasicon.svg": "60024bacb97c010b9b7fd9b3f8d7024c",
"assets/assets/icons/svg/phonebasicon.svg": "1af07a9871e3311b289d27723315ed61",
"assets/assets/icons/svg/presentation_1_line.svg": "14303773b8cab586dbd9ab740e3bcc1f",
"assets/assets/icons/svg/reactsmile.svg": "e6f7554d174abc76b6c56d59a0c8b6b5",
"assets/assets/icons/svg/resumebasicon.svg": "be9255121b5ea44df18cec2f9bd482ca",
"assets/assets/icons/svg/rocket_line.svg": "d65a0070f29fe7450d92368e09e78531",
"assets/assets/icons/svg/section_line.svg": "71c9b5db8927d4d243c7745a2da537ed",
"assets/assets/icons/svg/settingsbasicon.svg": "03559006bd828d0f430f1efc13d72e16",
"assets/assets/icons/svg/settings_3_line.svg": "372f4ac2e21884590c9cf01b39fc02ea",
"assets/assets/icons/svg/shadow_line.svg": "513b14de1d403a1001f58ebdce8e5564",
"assets/assets/icons/svg/shakayellow.svg": "7124aa85a8c643051aaf9f37b25b9a64",
"assets/assets/icons/svg/sound.svg": "931eef948c14855353b9ed6c6da9f0d4",
"assets/assets/icons/svg/sun_fog_line.svg": "f7aa084b965f9bc099ec394794e9bbe6",
"assets/assets/icons/svg/tree_4_line.svg": "dc597b3cf05f3620fdec25184e2b048e",
"assets/assets/icons/svg/UFO_2_line.svg": "6b55a7ee8c211fd3522c3d49152c06d6",
"assets/assets/icons/svg/umbrella_2_line.svg": "6f186bf071581b6ca9376ac31daf1eff",
"assets/assets/icons/svg/unlikedshaka.svg": "a198fbdc52dab6c55cd3b965eb64c903",
"assets/assets/icons/svg/updown.svg": "814ac98af73adf7fdb4d09eeb7701005",
"assets/assets/icons/svg/user_4_line.svg": "b576f449eec3448c2d283982a8ee16a2",
"assets/assets/icons/svg/vibrate.svg": "b5fe747376a0395be69f239ea756ce43",
"assets/assets/icons/svg/world_fill.svg": "069e1588b2d64d893f6bc511a37ce3c9",
"assets/assets/icons/unliked_shaka.png": "7a21d1213aab0d21ea7bcd068ce5597f",
"assets/assets/ideation_sketches.png": "fca22c0d743070e42606904f41b19ae2",
"assets/assets/iPhone13_beige.png": "de3a10051ca2b39f0c555f0a937195a2",
"assets/assets/iphone14_black.png": "1716d976ce3a8d9b64a676a4ec617a5d",
"assets/assets/iphone_screen.png": "26817c4b3f3c71be14f95c487d03a46c",
"assets/assets/jeffjitsulogo.png": "ff1c5ae3695e061da9fc8a5d14d67739",
"assets/assets/jeffjitsulogo2.png": "f4429cbf1be4a1a79e2baf5e7595b33c",
"assets/assets/jeffjitsulogo3.png": "86d0d188b61323fb72836a838f548894",
"assets/assets/jeffjitsulogo4.png": "885d086aee2838fe129667a51b9b4a5c",
"assets/assets/Life%2520Of%2520Bibi.png": "5b4641267995511a24306b08e0003963",
"assets/assets/LinkedIn_brik.png": "885e6025d239ea4d2625da3bfed63e5a",
"assets/assets/linkedIn_drawn.png": "10e0f7430ec0fd7cc2626e5d3688440d",
"assets/assets/linkedIn_pixel.png": "793fd7cfdb259f5bc753e9edbcdd6094",
"assets/assets/linked_in_main.png": "f93ed37f90d10ecffaf035207b30116c",
"assets/assets/linked_in_nes.png": "93ba7a14ff6a147f90f76a3e6924e093",
"assets/assets/macbook.png": "89d91772ea4c448846f48228f25c7894",
"assets/assets/macbook13.png": "5ebda692ca0eef9424c834911c3d005b",
"assets/assets/macbook_screen.png": "36f806699a5706aec61f50e38c8ab2be",
"assets/assets/Mat.png": "d3ef1158a08def9118c7547ca63f2f37",
"assets/assets/media_content_members.png": "5ae55bf11901210a50811ab4fa193b58",
"assets/assets/med_desktop1.png": "403e237eb6cc5ca5b81dc4cd6a3240c2",
"assets/assets/med_wireframe1%25201.svg": "1cfa1eb44b434b5a76bbc418ea624fd7",
"assets/assets/med_wireframe1.png": "df248aa670adafc9878c30883a7c201c",
"assets/assets/med_wireframe1.svg": "1cfa1eb44b434b5a76bbc418ea624fd7",
"assets/assets/med_wireframe1.webp": "c2177ac4d4a09eabd3507e5db08fbf91",
"assets/assets/med_wireframe2.svg": "9e46224e6fa791169e4f0f7b7848618c",
"assets/assets/med_wireframe2.webp": "dd0bc575a19f06a02bf4e1821c53ba6f",
"assets/assets/menu.png": "246bb8b49e4b972dae2a9aae02d92782",
"assets/assets/menublank.png": "ccd83a9a023535969bdbae5434c4e6fb",
"assets/assets/me_avatar.png": "70f8dd3f60eb70d4a242e6e423d98ed2",
"assets/assets/mobile/airholes.png": "7adb2489ec676a1fb213d6158a6e12e5",
"assets/assets/mobile/airx.png": "50e17b6a0bd337d91ed23a3f93cc4d4d",
"assets/assets/mobile/burger.png": "7a266c2404b824b25d41de69c4d68954",
"assets/assets/mobile/buttons.png": "dcd5b61475a7e3e5d334e8902c11503e",
"assets/assets/mobile/direction_pad.png": "05724c0416495e6a6cdc881e57e6f5a4",
"assets/assets/mobile/drawer.png": "a50a8e9950710000507178a70549dc2a",
"assets/assets/mobile/drawer_background.png": "abd23182f53998987b0c1855a0f96668",
"assets/assets/mobile/gameboy_body.png": "e8f9fb2a3c0c5d1d7ada220c17ef2f78",
"assets/assets/mobile/jeffjitsu.png": "edc0fc6c610978d96f06ac0323a2278d",
"assets/assets/mobile/landscape_mobile.png": "309ce255262559adc706c24056522027",
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
"assets/assets/moments/user_flow.png": "90e83f3e152721c76c0a4e7721b1e4ed",
"assets/assets/moments/user_flow2.png": "c8abde4e92b2b450db7a2831a65b2058",
"assets/assets/moments_back.png": "4bf385c97f174f04118ffaabf0803d30",
"assets/assets/moments_card.png": "5ceb029b4945a714ae79cd154411222c",
"assets/assets/moments_front.png": "8568a26ac2b481f1a757ed293aac8fbb",
"assets/assets/mood_board.png": "7e783f656e9e9f044aab4ea5606a7646",
"assets/assets/moon_pacha.png": "52e09fdd964fc10f577bacac22bc83e9",
"assets/assets/nes_land_day.png": "86c67e1b255201f698fc676073b8f58f",
"assets/assets/nes_land_night.png": "13bba9adfe7cca5e63d77a04c5cce638",
"assets/assets/ninja_dark.png": "a7422e4a6c1030e8deaf9a35f8204f57",
"assets/assets/ninja_light.png": "a09f977d23c1fb99050421e26ef5ab9d",
"assets/assets/NOTICES": "dea3a659eb8b62dd443e5d952e639590",
"assets/assets/pacha_back.png": "4f77dc67fae400f93227535a2fda8bbf",
"assets/assets/pacha_front.png": "c168fb24ea1d79b3b72ab50992e2431c",
"assets/assets/pages.png": "65414f5ddaa18d72711e44b57ef61e6e",
"assets/assets/paper.png": "1c96d847e6d7df72c9944a58978f1ab3",
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
"assets/assets/plannie_card.png": "76db382ed7859845eb249bc539ccd2a9",
"assets/assets/portfolio_selection.png": "28f57be5842115704c70ef78175bcf44",
"assets/assets/portfolio_selection2.png": "124ecaf27fbd1c8732579b5f582de124",
"assets/assets/profile_picNES.png": "2afd6ebed2620e3ec042f3eaba79dfc4",
"assets/assets/profile_picREG.png": "683dca38df137e0eecae80775a03adb8",
"assets/assets/project_header.png": "8fe2ce2d90a2cb513ece869dd6ffea2d",
"assets/assets/redesign_images.png": "5794f5fde1846b1bded8028d33fb355e",
"assets/assets/Resume.pdf": "80b7ea04ffdd111bcea072411fdadd5b",
"assets/assets/ronin_back.png": "147bed6e19063a181d2d0de3f32996df",
"assets/assets/ronin_bjj.png": "e82e0cb040d252600541e1bb832ae2ae",
"assets/assets/ronin_front.png": "f913a7c7193527b4b0baa7cf5d9095b2",
"assets/assets/Schedule.png": "d19c3a65531809661f48b8fcb7194e0d",
"assets/assets/Screenshot%25202025-07-06%2520114303.png": "52a370bf0a5e1f1ba1e25d0a141a6777",
"assets/assets/site_map.png": "5e9d310a183d0f5ff9ccc0a9450454f7",
"assets/assets/social_content_gym_members.png": "90dca3eb78dc208437b305e3d9613414",
"assets/assets/style_guide1.png": "150a692a77ba6e31bdca5645891f362d",
"assets/assets/style_guide_athelete_dark.png": "e79d818911653122d47a27567ea9a08b",
"assets/assets/style_guide_ninja_dark.png": "b4a729a1758b4d1fe483ea50dcf436d0",
"assets/assets/style_guide_ninja_light.png": "df07d9d21f968d0561c78601e571bd4e",
"assets/assets/Survey.png": "a406feeadc81007cb98141e67d941e19",
"assets/assets/switch_large.png": "640604f766b9b8254686b192751d3f68",
"assets/assets/switch_med.png": "82b6ee51a9d286a3e3f6c8e891ba614d",
"assets/assets/switch_modal.png": "c9652a9cdac534bada1f78a327e46300",
"assets/assets/switch_small.png": "5d6bbf7a559a65bd14e0176abf58583e",
"assets/assets/tapin/design_principles.svg": "a4234330dcd02e881cfb4f0acd1f16fa",
"assets/assets/tapin/paper.png": "1c96d847e6d7df72c9944a58978f1ab3",
"assets/assets/tapin/penrose_triangle.svg": "a550bb603108b0c174a99181f3bf226f",
"assets/assets/tapin/process_overview.svg": "f6ac81aaf5188424315f659bbabc04e1",
"assets/assets/tapin/tapin_back.png": "bf5659dc30a869069cfd424fd82e7dea",
"assets/assets/tapin/tapin_front.png": "c69741c5148e15b51947b1c1f2935bb0",
"assets/assets/tapin/uxpyramid.png": "967b9af8bfc39303543cbb839ececf80",
"assets/assets/tapin/uxpyramid.svg": "8b7ea9db3f3a011f6fa44f133c770d98",
"assets/assets/tapin/ux_pyramid.png": "20c628a4a9c349423f80597d49d09009",
"assets/assets/tapin/ux_pyramid.svg": "1d7691677fbdbdc7a97cc437e080b3ba",
"assets/assets/tapin/wireframe1.png": "8c7f8750233e87176735cc204b664cd1",
"assets/assets/tapin/wireframe2.png": "1d882e5629be1ca5c51228c4318f422c",
"assets/assets/tapin/wireframe3.png": "fa4ff19fc849c4a96d28875818c8532c",
"assets/assets/tapin_card.png": "1f16f698d0e4f30f9922dcda1aa171d1",
"assets/assets/tapin_cover.png": "90ab5bee10956457e619864fc03ccc4c",
"assets/assets/tapin_header.png": "24b8b3cc4ae4dba98a4dc65a03f32614",
"assets/assets/tapin_logo.png": "9b91fd14b714ed9947e91e7199e74252",
"assets/assets/tapin_spine.png": "4b41453f1e480b6eac5f28607cb2da53",
"assets/assets/Timer.png": "99b6e68ea4cf5afe3bed7b34af5b105b",
"assets/assets/tvmodal.png": "41db37627e605995a46a5a747a6b108b",
"assets/assets/user_flows.png": "7e43ecd2234f710c1faf3991c08de3ac",
"assets/assets/uxui_bg.png": "d3d57a4cc20675632a89da4f768bb86f",
"assets/assets/Video.png": "8bbd16294c3a9547755f9430b74233ec",
"assets/assets/vinyl.png": "1b81c891be2a2ac25d89a8df9cf49d80",
"assets/assets/vinyl_half.png": "3e0f0a193809dda7557dd42a2f75f989",
"assets/assets/whatsapp.png": "616dcad6079e0a99cdffe73682b66969",
"assets/assets/wireframe_background_beige.png": "a0190e7c6c08a87998a32aca54d7c142",
"assets/assets/wire_frame1.png": "345cdbbbd83704df491274566d52e43a",
"assets/assets/wire_frame2.png": "e14642ffbe95be1d3a04701d49a56ae8",
"assets/assets/wire_frame3.png": "a862676804a958f6e0986d6f53cc3a51",
"assets/assets/wire_frame4.png": "3bd17f57179e7c2ce74f59c38cf83253",
"assets/FontManifest.json": "e2fe4312b772f3c467fe6e8802ecb79c",
"assets/fonts/MaterialIcons-Regular.otf": "9877dc1655f2a935074db4561e2c721e",
"assets/NOTICES": "050ae90ce9936a75579f6ada94914081",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/easy_stepper/assets/loading_black.json": "d412b17ec906f03090996d68abab4eca",
"assets/packages/easy_stepper/assets/loading_white.json": "92623d18291ed579cf8bfe3f5fc74213",
"assets/packages/flutter_neumorphic_plus/fonts/NeumorphicIcons.ttf": "32be0c4c86773ba5c9f7791e69964585",
"assets/packages/line_icons/lib/assets/fonts/LineIcons.ttf": "bcaf3ba974cf7900b3c158ca593f4971",
"assets/packages/nes_ui/assets/checkered_pattern.png": "7f3e9d7ae73d37c7329ee95d1d54f531",
"assets/packages/nes_ui/google_fonts/OFL.txt": "5096248a0ad125929b038a264f57b570",
"assets/packages/nes_ui/google_fonts/PressStart2P-Regular.ttf": "f98cd910425bf727bd54ce767a9b6884",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.png": "13ff9ae0ec38ed5ef9b5319596ccab3e",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter.png": "5dcef449791fa27946b3d35ad8803796",
"flutter_bootstrap.js": "2138a4a7ed81c309d75d2c52dcde34c4",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "cf4ac560a2dee883bc2ef5f81b472370",
"/": "cf4ac560a2dee883bc2ef5f81b472370",
"main.dart.js": "5c02c649c6e2f489317387fc875fd934",
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
