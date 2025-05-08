'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "ccc4c52f5956f4c5a7514854ec8fd505",
".git/config": "532e2f1f1dbb415e57fbf272db68eac5",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "c42b8a5f52f1f17bd40858f7715b4082",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "946ce9c7191a0301635797cb62b81ea4",
".git/logs/refs/heads/gh-pages": "9ce7e5bc3b4a8770cd3583f1eb45f5e4",
".git/logs/refs/remotes/origin/gh-pages": "deaabd1ae59ebc5bd6f4fb8a194b4cdd",
".git/objects/01/6157cf8822a413b9561d97734809ae9143dfaf": "210849d3945989bb426ec6ef1013cc33",
".git/objects/04/4347459979ab6bb365857d876f03d7d1296ee1": "fa668717b0940c42a0c2d13ebdfe7730",
".git/objects/06/859c1ab3fd5f490b545d0c93e6454127ea4e15": "4a9662ce475bb1224527215b497b33cc",
".git/objects/08/614799d5735009b855350b2a85d2da3d279263": "60d077203516305f9ba435e847c4e1a0",
".git/objects/09/4612fa6105f6de56ea24acfb454bb6ed7a54fa": "3c438654d92602243b65b2bb9890c0e3",
".git/objects/09/7029a6845cc951840d64839e2788a7f804ca1c": "b790e739a692b90991a85904298e6cd3",
".git/objects/09/74441396cd96db01c57b0a0f9c5cc6a931fe9b": "fc91519ffe927c09f076bac8c6829eec",
".git/objects/09/ef4dd4dcaf4978d9cd7692e6888f0b30187450": "b77e806588acd5fb2a43073ed5351132",
".git/objects/0a/3cbf19769159f8bdb0b697b9a6bf27831e4a11": "5e4655caf187fde38c18fc171aff606b",
".git/objects/0a/980c297b840299b650161630736d7bbb20635d": "d11eab1b1d1f000e81c9a22881cec021",
".git/objects/0a/bc20fb5761dc992226a1be58612b67073c142c": "706c5eec4d74312dc2776c929c0f7d6c",
".git/objects/0b/af5c0f2c51044a4c21cd9ab01cdf984a93f0a0": "399d926aed1019eac1a31df48b9f6016",
".git/objects/0b/b6e6164b8539326a3becbf674ba2780e6a025a": "0db885297a5bd3a69c9452168d3d7050",
".git/objects/0c/b97d1e81c7103c1038ae6f96649264a263a1c2": "60720ef20b8c63cba97d2196494280c9",
".git/objects/0e/a71e1b81580cd4874f9202b1b336177252225f": "603df550809619335827fb50dffefab8",
".git/objects/10/f1e17bce2d0f51c0da19ad6b75122f0c836cee": "7d683ac85be77ff8f1a6abf84cccd19d",
".git/objects/12/8ec628e4d58ffe462baab27a9fb1e895ff1b50": "72a57db96288fa95f997908d632bf17d",
".git/objects/12/e27f2fd77a2709640e9db9c6b523eacc89b550": "7e5669bdac8cf3cf5d768bf49e709833",
".git/objects/14/73baa6982a55d494a74ab16b73c003e313d2e0": "0841cfe750238a7f3ea897b54003cce5",
".git/objects/14/88b3941732af24b6db16e5755487415121a6c9": "cd8fae03ee82514070a96d4e42aa28a3",
".git/objects/15/d07e735207fe0d45d8c4ff2e1c4d4a5cc489db": "54dadb68393bc780a6ffa6d3273224e8",
".git/objects/16/13e97235e4ee10e4ee9442ee88d7fb972ae9d5": "bcb3fe0a460f4fa8fac863c0f24c7a42",
".git/objects/19/a48ef9a4aec01ed0a7ffcaf3062864797a5741": "e57d7aba2ac99c43d00814b5af0726f8",
".git/objects/1a/41d7433c6e6432ceab4b24b1fd1644c0459a07": "a283e41e1dfeaa1d2dce49ad5c961f1f",
".git/objects/1a/c978f304797cfab06c2da33e66ac1fc7d743ac": "5006d4372653d47f6b94a21bcb6ddbaf",
".git/objects/1b/43d422d0091f65ff6dfa3ef185a0a1b22cd9b0": "809b67ff2ebfd648d16554bb9845873d",
".git/objects/1c/dde49462a4d496259fb5791f77beaf9e71f5ae": "8f3ece8123a25f786801f45e0b43e197",
".git/objects/1d/0f2c6b7c0d824c7bac7995b1d8bdf8e1bf5ff6": "7bcf3379bc1e7b432da8e40d12736084",
".git/objects/1d/468b85698a60041b450286f31b3264b3bbd6f7": "5c8c497111befde32ac151f14cf92f85",
".git/objects/21/f48286f4c5730c14ba9c42c462207d76146660": "65644571e7fcca90dd192baf66a7dc5a",
".git/objects/22/7a8b27444f15ffaf88244cfe93ab9a7df2e601": "813f4c43086c2e01a723965d9311e97a",
".git/objects/22/8b963b78631815170f9e8e73d4658d5c5eeb70": "636a5539a965c3a1c40644cc7a012616",
".git/objects/24/386865ff4a80973fda3cf4a8d494373a610b8f": "458cd7569ada4a3a0f564c866c153cf4",
".git/objects/24/42affbf6570d23c0b2b270cca8d49535df27bf": "538d932d1b9806e9100542b30c19db99",
".git/objects/25/fa39ac8b7766deecc2f7402e9ed38b5a649a8b": "db5a464c9319282752ef58587b2c386b",
".git/objects/26/d1ef00039d802b7dd10fc76ae87359eb79b2fc": "c136b47e10037c76f31ed092474a3378",
".git/objects/2a/ffc5111b276f9b83aa6f48795b6dfa3cbeeba2": "720ee51530a5ba2bcfc8ffd7d6404233",
".git/objects/2b/4fbc14ced9ebcbd7354c8e4bda3f182f20e21f": "49170969170d4a52114b58d1f636b6ba",
".git/objects/2d/29c078c0d5a96398d16d6f25b6a7d7394b385a": "41e1495a8a2a28117e1acbe05e491c4d",
".git/objects/2d/e3a5bd585de78da2abc461b3552167f8d2c0c3": "4b13d337cd0ec4bd20e2baff4fa35fa3",
".git/objects/2f/0e18198340613905de7d6561b5e4b345417a3f": "68929e92a87e7946cd5ca2ee3a074739",
".git/objects/31/2ff99bcdf78364c0821f1beddffd71e3c6667f": "3a98c7fe551a471a5ac6dc0a669bbe92",
".git/objects/32/8fdae92e8ef4db2e61937e9cdf08c936eb6abf": "0e0fc01f4908676626877cbc9b7bcc6d",
".git/objects/32/b797352c4b1df77a52d5980b7e4894eb1d4ac8": "89071e9ae3a4dbe91083ed2d9c6814de",
".git/objects/34/901b400b97c83d0390889eb040c1b72f9930d1": "697eb59e815efbd6c6dd4f2b2502f0e7",
".git/objects/35/618793d662f025dcc44ac522ba5159b21b40c7": "8e5c540fb29e0f78973c5f2b734f7aee",
".git/objects/35/83a44c10533d84389ef5f8c6257c930fd4927c": "a9b27e932ff4c1be4532b1dfdfbe1c37",
".git/objects/35/96d08a5b8c249a9ff1eb36682aee2a23e61bac": "e931dda039902c600d4ba7d954ff090f",
".git/objects/37/45a023e2beed2029394878c9762cf076e29222": "2d839d3cb5dd669ed4cc5c6fd6fe8ad5",
".git/objects/38/87aee8e22399baccef3cefd0adb729d6b0a67f": "3395141fb2b620c0cb1c6dbb979bd6f3",
".git/objects/38/c81f69e50684d24b936a0e44d44aae5abff8ad": "2251ef566d1cb04b28b3cfc8713d8117",
".git/objects/3c/226cba9b54855dfd2bd4861942d88ba841f6e5": "6fc78717d33f26ef54ab68d5b7fa0740",
".git/objects/3c/3298caeec6ebe5d772a792a25d11b1cda2ec12": "d5f689651126ef9f76f1bc67f60ccc87",
".git/objects/3e/5b460291b1425d006479822973d304d532989d": "1d777b70de5f560a184bc6dc4385e26a",
".git/objects/40/1184f2840fcfb39ffde5f2f82fe5957c37d6fa": "1ea653b99fd29cd15fcc068857a1dbb2",
".git/objects/44/58dc037bc25d74a6bcfa71d5f90b24e3c15b76": "cf28e458cca6e767019dfd1a20bdee39",
".git/objects/47/77cc0e64d4a3e0d2b8ac17fb0b105e593f8d0a": "0e84d1bf280f60ab82460dfc069612b5",
".git/objects/48/cbe68f5af00457e61db14c73056d55cf24fdff": "faedfa8b79c3d727067b46590ebfd952",
".git/objects/48/dd21b1f798e4fec17d1a1ba666bb660277c3a5": "b6b774fde0c0bca7ae8a9d26c4a5274c",
".git/objects/49/10a76e2c032cef1fe24d7e972c03f2ed1f6572": "a9a8144ae8cf18d9c0b9726b9166cdc8",
".git/objects/4b/a2b87a9282f6a2fe3f67f9767c1e68b1c8a6c0": "4d52b099eefed6d87ffbf267dfa31622",
".git/objects/4f/7e9edee92ad5da33c8437618b33089f4462291": "4c9d0bd463e5c81774a378726bbcb23c",
".git/objects/50/22412e63d213148ab900e72023c0be5d3262e6": "11b9c10a79a01585d25dbfbc83b6b7e4",
".git/objects/53/3402c75429e6feaa7b8f92878ae2313dbdf2de": "63ab067b0b447b461fa3e8f58a1f23a9",
".git/objects/54/f8d994ecb78ccc8acb674ecaa0a473234e3d4b": "fd16c407f85e320f33965f89ecd2ebb3",
".git/objects/56/312d64b027dc783a0c8b272f9a74c5b55568b7": "e9c0b9775043f632e15293cd51866934",
".git/objects/57/7946daf6467a3f0a883583abfb8f1e57c86b54": "846aff8094feabe0db132052fd10f62a",
".git/objects/58/e40a391383d5bf6e691446bbd88d8435acce59": "bd481c4ff94f53c509cff8206452c84b",
".git/objects/59/ef9261841959fe709d12c2f2d8467b854988f5": "d1f5f08289cb8a375a5ede0b8d3b6382",
".git/objects/59/f3f291e824c87e43a8760aa12024532c3d7484": "d80b9e3f7587274989dea2ec73058b50",
".git/objects/5a/2faa3727a7ad2816c41cf960ae31ef93c927f3": "2fd5a592a9907e7c20bc0ef8274c9d54",
".git/objects/5b/4b5afe6ee4b560b65b2f2040ad38f6c094b347": "0901836da3e30bead1d28a9ffb8329ff",
".git/objects/5e/1ccd4be8420a81cee7dc6cca16dc95aa5ca5a8": "315902e72395a56a479e1887e1fa7175",
".git/objects/5f/bf1f5ee49ba64ffa8e24e19c0231e22add1631": "f19d414bb2afb15ab9eb762fd11311d6",
".git/objects/60/9afb227e9414e2d13c67f14b2a87f95bfc939d": "fe68c99c8dee7ba648bbd9ab75345f14",
".git/objects/61/3e11df39fa157d21333a23de4547323ac3b3b9": "5855a91e9d6bd4cc82a1e0b32f6fdba2",
".git/objects/62/2a825ebab10a11dabe75c37ed5e72b65dbbab8": "a018e4803960fbb632d792226b4bb58c",
".git/objects/63/fb04cb19c2e1ef89ec723505988eb8669a91d2": "193f575b845d0d6acb1f17146c00a27d",
".git/objects/66/24db2eb691f373fcc8a65c88bdf7fe78b1e4f9": "39ee4f84855c1b95d55123ea5e68f0a2",
".git/objects/68/a4391dafd1e154c80402796278690a71ba75ea": "1832b9c7daf5793c8a2d980061ce8149",
".git/objects/69/d4dcc8799cbb4182062ece7de1ae9359ee188d": "654564ebaab46736b0715a2fbe9de7d9",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/6c/31ba9384c687c247f97bbe9dd99de51c51a5d4": "2083b0ab64007e40ffef9695dcc44f7e",
".git/objects/6f/9fa55ca99b4cf6ac06ae1ac2dfe454eda7697d": "728b8b76f3b46d2c318ff676e2aef01a",
".git/objects/70/da1484bc9d24477161f1b45b938066cf0cc29b": "4ed06cd7dfae8d0f09cc7afeaafa3b3c",
".git/objects/71/d084fd234a7d0764f824664860d86894ccaa33": "b12dfdf3da4edca87364e57b6244721d",
".git/objects/71/f71c48af31300ed9b28f5b6a3fa13249eca33b": "b17c113060d59793218409876363af26",
".git/objects/72/3d030bc89a4250e63d16b082affe1998618c3f": "e4299c419434fc51f64a5266659918fa",
".git/objects/73/aa180fcc51ffc43340fd5d86b806e90773d2b9": "d5e6d35ecd50c609211d0cc75d9315a4",
".git/objects/77/79fa9d206374e0992669eb2f62991073c50405": "59dcea18a9fe952743efd5b3343012c5",
".git/objects/79/09d39fd66cf74efed13ab020c5cf10c656606d": "636179cd1a29f75482a1cdec55164ce5",
".git/objects/79/b960588f63dee6ee15723ab0350c5874c5cfc9": "81a5f644d684ee2979ba67a3ed5a1f2c",
".git/objects/7a/c519ec4cffbba0c5ea21ad0601502db41d941d": "632272b0748b24537edcf647a4e7d709",
".git/objects/7c/39f728945227c040d8e6ef87aec1164b01d722": "e461eae53ec295e57c654af8f01a9266",
".git/objects/7c/96ff0b4e11dfc881d6bbbb94ad5e427f33b8e6": "5cd737e9cdf81099ff6383c430abd0fb",
".git/objects/80/12ba30844028f4e2a5af9f1e5be5aaacc2582a": "e6908b6caf74c45bc3ae5809f8130a6b",
".git/objects/80/22d6bc884cfe6fb95fe7fd88a117e453948990": "205601911158c7dd1f9b23a174a41449",
".git/objects/80/f8a176782e4d1fe281f491ae43cf0bfccc7dab": "32ffa1eb5faf7d636396c27c96b68850",
".git/objects/83/abbf2dde4f8c959fc69762349090d2951ef430": "dc1517ab6ef7377022b1fc371b423a73",
".git/objects/85/43bbad6d43f0511c6805789b64a27d0f33d68b": "9877f549bc0932f1804424ac3b1313bb",
".git/objects/85/5e482f37f52d39870e47be1a11b1003f8f1a0d": "82083f66afae118e791c96a36c9a76cc",
".git/objects/85/b749b73295a510879cd5bce0f7bd9739729c0c": "8b53fa3e83efd1addd2bf8cf05a9989d",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/89/76dc5b753a9e9a398d75336c87e3cc83a3749b": "d81b9c45d238275b0aa9a33572abdd42",
".git/objects/8a/51a9b155d31c44b148d7e287fc2872e0cafd42": "9f785032380d7569e69b3d17172f64e8",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8a/eedc8921dbbf2c48420d56cb1c5059fa063e6d": "81fbe97a960f0b1067970c1fe593f4a2",
".git/objects/8b/cac074e1a89183e7ef0fa58bd45a774976988c": "d6d04ec0d2f45727ae22bc33a0d972fc",
".git/objects/8b/faa13a2cdc9dd25494a8eb3d335c09b1d765fb": "c743d37d9d49d158fcc2f048277f32b8",
".git/objects/8e/033b951af0cda62a6b644a26c29f67677bb30f": "08fd5cd633b487cf684171c022359ebb",
".git/objects/8f/c8be62f202c40e7d3e2e16242fb065cfc4e1a7": "6fda1b80da67a8d96186cf8ab8b24087",
".git/objects/90/59dc5cf7687de3cada4a2f22cf294eb2a3e443": "2b3a4510c9275c3b16384712f2bef763",
".git/objects/90/c2f7298af777ee4cfb2bd5f79f7c062e62c0e1": "76cb68d39ddfcb773c34af8f1afc2d90",
".git/objects/91/4a40ccb508c126fa995820d01ea15c69bb95f7": "8963a99a625c47f6cd41ba314ebd2488",
".git/objects/91/864a7a0bb4f1f8a21f6b27ebd30952416fc4fc": "cd32e3215e4e108dca64e39709b25029",
".git/objects/91/9249535ac71395b4f6ec6b3c5afc2f3c6940a2": "0383f6492078288ef5bfd49361b7f96d",
".git/objects/91/98d0b1c77b4e375e7018b51f5e58c673d9cce6": "82db4082b9b93f2c8853895bb348664a",
".git/objects/92/7e9891277e420248f06893b0c87c5cb22f2fad": "feed4d5d3902e4980c3b159f4e1fe530",
".git/objects/93/291500a898d9f585d6c530ee9573cb77e123ca": "d51af6c2bb159ebd4ed6e56f21cef264",
".git/objects/95/ddca78c3c829dde548f1cba32f2872e42778df": "e5567c7f923ccaaf7491efcc292a5201",
".git/objects/98/03d26eb77b016cc6ebe9025f06c27c8e2c04bf": "68ff94e94d3a9f44424ac070d500ae6c",
".git/objects/98/80405ebfe0ec26a678bbf2fd9f00eadb4ad3eb": "343a4bb3ddb513dd4f3a601caf03e060",
".git/objects/99/6978c337a68e3781cff81b207a2e53ebe3ab74": "a2b9a5acca07f163a281806ca666b42e",
".git/objects/9c/a6dbbaf9bbac822f4954511f4c7d47a9731a02": "b36aca8038ffdbee703bb51777f4753b",
".git/objects/a2/864bf210bbff780f6e73d95ba0807a3ac1d120": "0ca068bf1d9f5418ec46d5fa3e4cad98",
".git/objects/a3/14fc2148f79289fe9c5e2fe2bc95bcefc31672": "b79e5e3ec569f7a20bc162746bcfcc6b",
".git/objects/a4/e9660be6775909f33c08088ad6250005e6b91e": "a2257e93ebb660746f0f1f993ed944d2",
".git/objects/a5/2ab6788d4313bce21bcb595174a883bf27da88": "961d142a3de64461f2a5787204f676e4",
".git/objects/a5/47ed8ff2a706ee16a150a6e470d96fc9feb842": "ead9143f45681702d747b14bdf921a4b",
".git/objects/a5/b10e882838b9468620a354df1b8a5f9f2644d7": "68b3bec7f5ccb574ec5c169beba7b38a",
".git/objects/a5/de584f4d25ef8aace1c5a0c190c3b31639895b": "9fbbb0db1824af504c56e5d959e1cdff",
".git/objects/a6/866a14d897af0cdab443d8017ac33853515d49": "f6754c5a1926a1474dfc7e1b319a6a36",
".git/objects/a6/8e9f1082175ba6335e5d40a5608179cdce109a": "33ec8afab3a83c5cde76066cf2aaecec",
".git/objects/a7/56a0948854fea214deed246dc5315a63e9ec64": "e43335697e4a0cd76f01050fe1545dba",
".git/objects/a8/8c9340e408fca6e68e2d6cd8363dccc2bd8642": "11e9d76ebfeb0c92c8dff256819c0796",
".git/objects/a9/ff2fcb612333d4eb1ffd1c994a6475e52f6fc4": "6ee85f9d399ea0954e66f33c2b473d9c",
".git/objects/aa/8c36d79cf47f669cb0349e40c8816c6b50a4e0": "9c671a0d2bbbeaacd7fbf13c592409af",
".git/objects/aa/bff2d7f9272de7066259a06f67b6f20e7c0d15": "effcabf3e93cbd4200cbbcc37fe4bc0b",
".git/objects/ae/33a4538132c8fc174dd53b3ce771009405d7a4": "640b959ab8644a4b5e518f9db9bd6526",
".git/objects/b1/cbbd532b9ac435786094c67d6e54ea685f8f47": "88b34f95ea6537fdae8d34362ee0bed0",
".git/objects/b3/9721fafda6c8bc292d4297ae7f69b19736c059": "b8fff66492c32db324ffe0e42dbeeee6",
".git/objects/b4/28950c4b0254f085d09b0f8f6a7a4d95f0a00c": "bb746d6958ba360e8a4eaf47bb95b6e0",
".git/objects/b4/cd833703e56b239605a044fa6cb51a865b3b10": "fd2f16eebdceefe76ce37390947badaf",
".git/objects/b5/aa5c33c4ecda0b60e9d62a84e4f998cbc165ad": "bfb6bbe88595185f2da6bfd71c54cd13",
".git/objects/b7/21da56b4cf7c50bfca09e9c98a7aad6961cdff": "258ed87612228f30e73b442fc7e7e7cb",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b7/c9fe324e68dd6cfcab1c18dc88656035c7acac": "8c606909566bcb3d338a18205a758f2c",
".git/objects/b8/7a97b96456d3aa732acb1b47edad100a828a19": "17b00ec8755599ce644ccc738f7f5f77",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/b9/bed47d89b1d1e5808053af39c1e72b3055c306": "c528d5518370aeed88ddf69835a48e4e",
".git/objects/bc/76534812f6699fb8aff949b71b5f9dfb310965": "5c4b3db4ce516476056f26b0dbc3460a",
".git/objects/be/48684874f2e2a1542cdbbf855338b750fc19e1": "aa62bd8666ba1977006938512e3cb98f",
".git/objects/be/f1e79c8c9c6c6528259b027072a353b804cadb": "a563b7afe5bd2254720f9cf69d249c16",
".git/objects/bf/6adc6e2ae9c1b5f27c841f92d8a85e2fa02836": "558e5c3a9c02971a8e8574cbac465281",
".git/objects/c0/f43831c6cbc1dd785e8e23f32502edeb58212b": "79b65afdde3837b37fe721320bef275f",
".git/objects/c1/00de0194d5245d08a5163b4a53d7c6128a5178": "af2ee025d6185d799e2a30144fbd7820",
".git/objects/c4/06ec0ad799086d2f574f3e5cd53ae3b15cd348": "846d6a9945bcc261d389cb9dae688276",
".git/objects/c8/69354f3d3add1463587077a1924f038d1a350b": "3119def0beb5d310e5e5753a0214a1ea",
".git/objects/c8/c48b6f6a9b27d9121ae78ec598e6692d329001": "ab467ce1aa8dd5e1fe3113cc7bd0b2d6",
".git/objects/c9/ef134e7a6e28bcd936c1eccee59e998570866d": "afb1fa5b496ea08fe5d5de0a0b113395",
".git/objects/cb/14248a2c3458f2a4b4a995d3232a283315ec5b": "109dfb6aded29093cc12e57c14987da3",
".git/objects/ce/0c5def0325f098c60344805eba3ac7994d585a": "d6bd9c461d73cba8414abbc6865bec30",
".git/objects/d1/088668062ab0a7c7b84b65493a5bf7eadede90": "e31aea81d667e7777c1d2a29a260cbd4",
".git/objects/d1/7f84e042a30fc74cef2657dcf4d6174d7b3f5a": "20e2ba7137c3468d994b269d29eaa32a",
".git/objects/d1/c17772031b77b270929df60a11f203ef618d1e": "5dd4e214778e41129219b29469575e72",
".git/objects/d2/3d840856c4ed6419c47afd901d7c7c0d78f868": "373c3c93d4773867f1434d46ae6c0982",
".git/objects/d3/10eac202670917cea588f939bd59b43e392352": "9a82f4612eb13bc1e583421a94d138e0",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d9/1e6e431e973a3592dd728da884d3cee7593b65": "fd747f1b649149f153fd0685eaeea8f1",
".git/objects/d9/3952e90f26e65356f31c60fc394efb26313167": "1401847c6f090e48e83740a00be1c303",
".git/objects/dd/2d9637d227f8e8490d116a3f56b72e7456e5bb": "c0bcdacc3b35cde4e674f58551784b32",
".git/objects/de/b7f0f3ddf28f267f133c1a417f5f925a1c88bc": "c8f4029521d88fdc92294a99f6a1d337",
".git/objects/de/d80fb68888895953f71d0c6c36d021a806e2f6": "b88d801dcba559eaba1ab5100ab064ca",
".git/objects/e0/47d64160b9e5a0bc5951099c7913581055490a": "53116f01e84ff4424b720953264dd452",
".git/objects/e2/a420ad5dc161d2cecdbb8da43b972ea08b1e71": "118a2ada2c7f5ba6924f844fed5d5966",
".git/objects/e3/597adbf4c9f8cc1620551b546196d37d7f9f5d": "27dbb1d19a97341eb575982beb0635c9",
".git/objects/e5/d6b9b5c2de13a78a9ae34bebd8b901e807665f": "3804996d525f08373e137da6b2a60720",
".git/objects/e6/15dbbd16e2337678e087c43d00241df67c377a": "df0d1bc168d222eabda62002157833ad",
".git/objects/e6/6c7dcfc58734342097dbc3326a04d1dcf644cc": "492223ff7f5a3bdbf7bdeafe595c1717",
".git/objects/e6/9de29bb2d1d6434b8b29ae775ad8c2e48c5391": "c70c34cbeefd40e7c0149b7a0c2c64c2",
".git/objects/e7/14a95748c2750a58623ba31d4931e4141a8a5b": "9122477e6a8c61a9bfb14e95b1235149",
".git/objects/e9/38349e93ed6cf9f8623aac9a5cd065033b5824": "7b191268ce9ae52bb3f46e488c99173f",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/ea/2a8e8879c5a64bdb9130655ad580b067ff39ce": "c34c2e9736ec5658db9bcd090c03a155",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ed/1b6f7a6f033585fae0fe3ffc20f1d8b7077aee": "367f9bb14b31affb2b040fe0f1e608b4",
".git/objects/ed/35d1076941ca45781e5e1629b66402972fcb90": "da5eeee56cfcd3c63c34e4a30394f2b0",
".git/objects/ee/45f1a4f3919cb95cd26ea59342cbbb1fdc3f7f": "e4559391d004f13a364567d3de69cc20",
".git/objects/ee/8b72f51015219cecd5478a024d9511be2fc18d": "25d1fb7a0403804df9cd7dac17f434c5",
".git/objects/ee/e989f06a021fc751c23cd549be471e316a6a25": "662fdaa6f9ba25d47291f84f360c4be6",
".git/objects/ef/b875788e4094f6091d9caa43e35c77640aaf21": "27e32738aea45acd66b98d36fc9fc9e0",
".git/objects/f0/fbed03422c27d3892b2b73723f5e6e1c76cdaa": "b333f9684f4691e170578393c0fa2719",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f3/709a83aedf1f03d6e04459831b12355a9b9ef1": "538d2edfa707ca92ed0b867d6c3903d1",
".git/objects/f3/7d8c41b6278f55636314099c6046e925b80296": "3681943b01a46a7b0b19df1ec7b73265",
".git/objects/f3/e8b0bb2158d91d43fe7782fada58989dc78d7d": "aa8695a159e85f6d7326789978f74cf5",
".git/objects/f4/29e1c3218259137e523e857be85b230c6a663c": "fad97d6cf781ed73a6d23f9b6945b466",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/f7/5b304c2e5ed67eab3311b919a566782dbcdd55": "1924a9a1aa29aaec29965c1c216370bf",
".git/objects/f8/4f0a48679b4e2a598d699648782fe0c6faaafc": "3480783a8abdb24b8ca98ecf0bd054e5",
".git/objects/f9/e8bd2e0adbb4161cda6bcbc7f71ec869005a94": "a94f4b6317fa806cb694861364fec13b",
".git/objects/fa/1ed8ddc6ed75a03542fffe25ae594e3848dd34": "36ae275462b473739db84c2ba70853ad",
".git/refs/heads/gh-pages": "c1033e0019c83623f37b9da2cb5843c0",
".git/refs/remotes/origin/gh-pages": "c1033e0019c83623f37b9da2cb5843c0",
"assets/AssetManifest.bin": "bc41a0f14a3427c1ee8cc2e862bfd732",
"assets/AssetManifest.bin.json": "ef6a9341dba766466647080c464e92f1",
"assets/AssetManifest.json": "cd1b27af00a3d2f86d7f2ecf59f3c440",
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
"assets/assets/gameboy.png": "d51f8d21caf7ab4665bdf662354bcbf0",
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
"assets/assets/switch_large.png": "640604f766b9b8254686b192751d3f68",
"assets/assets/switch_med.png": "82b6ee51a9d286a3e3f6c8e891ba614d",
"assets/assets/switch_modal.png": "c9652a9cdac534bada1f78a327e46300",
"assets/assets/switch_small.png": "5d6bbf7a559a65bd14e0176abf58583e",
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
"assets/fonts/MaterialIcons-Regular.otf": "07c9564cf5708c4e7a589131fa61a3b7",
"assets/NOTICES": "1e34036e580f2b4def6b597079ce46e5",
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
"CNAME": "facfa48d85de5ee0f56d8f325cc8d76e",
"favicon.png": "13ff9ae0ec38ed5ef9b5319596ccab3e",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter.png": "5dcef449791fa27946b3d35ad8803796",
"flutter_bootstrap.js": "17852be45a9d4fae378282f91b35c18f",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "ca42a21897abf2725eb2691883ff5bf6",
"/": "ca42a21897abf2725eb2691883ff5bf6",
"main.dart.js": "7e89bd3b599209fb4b85d10435127ae2",
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
