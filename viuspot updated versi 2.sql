-- ============================================================
-- VIUSPOT DATABASE PATCH
-- Penambahan: ulasan, fasilitas, estimasi biaya,
--             deskripsi panjang, komunitas, leaderboard
-- ============================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";
/*!40101 SET NAMES utf8mb4 */;

-- ============================================================
-- 1. TAMBAH USERS (untuk leaderboard & ulasan)
-- ============================================================

INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `full_name`, `role`, `created_at`, `updated_at`) VALUES
(3,  'ahmad_traveller',   'ahmad@example.com',    '$2y$10$dummyhashAhmad',   'Ahmad Fauzi',       'user', '2025-08-01 08:00:00', '2026-05-07 09:00:00'),
(4,  'rina_explorer',     'rina@example.com',     '$2y$10$dummyhashRina',    'Rina Kusuma',       'user', '2025-08-15 09:00:00', '2026-05-07 09:00:00'),
(5,  'budi_backpacker',   'budi@example.com',     '$2y$10$dummyhashBudi',    'Budi Santoso',      'user', '2025-09-01 07:00:00', '2026-05-07 09:00:00'),
(6,  'citra_culture',     'citra@example.com',    '$2y$10$dummyhashCitra',   'Citra Dewi',        'user', '2025-09-10 10:00:00', '2026-05-07 09:00:00'),
(7,  'dedi_foodie',       'dedi@example.com',     '$2y$10$dummyhashDedi',    'Dedi Hermawan',     'user', '2025-10-01 11:00:00', '2026-05-07 09:00:00'),
(8,  'sari_wanderer',     'sari@example.com',     '$2y$10$dummyhashSari',    'Sari Puspita',      'user', '2025-10-15 08:30:00', '2026-05-07 09:00:00'),
(9,  'hendra_adventures', 'hendra@example.com',   '$2y$10$dummyhashHendra',  'Hendra Gunawan',    'user', '2025-11-01 06:00:00', '2026-05-07 09:00:00'),
(10, 'maya_pilgrim',      'maya@example.com',     '$2y$10$dummyhashMaya',    'Maya Rahayu',       'user', '2025-11-20 14:00:00', '2026-05-07 09:00:00'),
(11, 'rizky_summit',      'rizky@example.com',    '$2y$10$dummyhashRizky',   'Rizky Pratama',     'user', '2025-12-01 05:00:00', '2026-05-07 09:00:00'),
(12, 'fitri_heritage',    'fitri@example.com',    '$2y$10$dummyhashFitri',   'Fitri Handayani',   'user', '2025-12-10 09:00:00', '2026-05-07 09:00:00'),
(13, 'reza_snapshot',     'reza@example.com',     '$2y$10$dummyhashReza',    'Reza Mahendra',     'user', '2026-01-05 07:00:00', '2026-05-07 09:00:00'),
(14, 'lina_foodhunter',   'lina@example.com',     '$2y$10$dummyhashLina',    'Lina Marlina',      'user', '2026-01-20 12:00:00', '2026-05-07 09:00:00'),
(15, 'bagas_trailblazer', 'bagas@example.com',    '$2y$10$dummyhashBagas',   'Bagas Wicaksono',   'user', '2026-02-01 06:30:00', '2026-05-07 09:00:00'),
(16, 'nina_nomad',        'nina@example.com',     '$2y$10$dummyhashNina',    'Nina Setiawati',    'user', '2026-02-14 10:00:00', '2026-05-07 09:00:00'),
(17, 'eko_roamer',        'eko@example.com',      '$2y$10$dummyhashEko',     'Eko Prasetyo',      'user', '2026-03-01 08:00:00', '2026-05-07 09:00:00');

-- ============================================================
-- 2. UPDATE DESKRIPSI DESTINASI (diperpanjang & diperkaya)
-- ============================================================

UPDATE `places` SET `description` = 'Gunung Merbabu adalah gunung berapi stratovolkano yang menjulang setinggi 3.145 mdpl di perbatasan Kabupaten Magelang, Boyolali, dan Semarang. Gunung ini terkenal dengan padang sabana yang luas dan menakjubkan, hamparan bunga edelweis yang harum, serta panorama matahari terbit yang spektakuler dari puncak Kenteng Songo. Terdapat beberapa jalur pendakian populer: Jalur Selo, Jalur Cunthel, dan Jalur Suwanting, masing-masing menawarkan karakteristik medan yang berbeda. Di puncak, pendaki bisa menyaksikan siluet Gunung Merapi, Sumbing, Sindoro, dan Lawu sekaligus. Sabana berlapis-lapis yang membentang di ketinggian 2.800 mdpl menjadi spot favorit foto dan kemah. Pendakian terbaik dilakukan pada musim kemarau (April–Oktober) saat trek kering dan pemandangan langit cerah.' WHERE `id` = 1;

UPDATE `places` SET `description` = 'Gunung Prau setinggi 2.565 mdpl adalah surga tersembunyi di kawasan Dataran Tinggi Dieng, Kabupaten Wonosobo dan Batang. Puncaknya dikelilingi padang sabana yang konon terluas di Jawa Tengah, menjadikannya lokasi glamping dan kemping favorit di kalangan milenial. Fenomena "lautan awan" di pagi hari dan langit berbintang tanpa polusi cahaya di malam hari adalah daya tarik utamanya. Dari puncak, pendaki dapat menyaksikan panorama 360 derajat meliputi Gunung Sindoro, Sumbing, Merapi, Merbabu, Ungaran, dan Slamet secara bersamaan. Jalur pendakian via Patak Banteng adalah yang paling populer karena jarak tempuh relatif singkat (±4 jam). Aktivitas terbaik adalah bermalam untuk menikmati golden hour pagi dan sunset sore hari.' WHERE `id` = 2;

UPDATE `places` SET `description` = 'Carstensz Pyramid atau Puncak Jaya adalah puncak tertinggi di Indonesia sekaligus puncak tertinggi di antara tujuh puncak beneng (Seven Summits) yang terletak di Benua Australia–Oceania, menjulang di ketinggian 4.884 mdpl. Berlokasi di jantung Pegunungan Sudirman, Papua Pegunungan, gunung ini ditutup lapisan gletser abadi yang kian menyusut akibat perubahan iklim. Pendakiannya dikategorikan sebagai salah satu yang paling teknis di dunia, membutuhkan keahlian panjat tebing, peralatan alpinisme lengkap, serta fisik dan mental yang prima. Izin pendakian harus diajukan jauh-jauh hari melalui prosedur administratif ketat. Pemandangan gletser tropis yang tersisa, ekosistem alpine unik, dan pengalaman mendaki di tanah Papua yang sakral menjadikan Carstensz sebagai impian setiap alpinis sejati Indonesia.' WHERE `id` = 3;

UPDATE `places` SET `description` = 'Pantai Ngetun adalah surga tersembunyi di ujung Kabupaten Gunungkidul, Yogyakarta, yang belum banyak terekspos secara masif. Pantai ini dikelilingi tebing-tebing karst megah khas pesisir selatan Jawa yang membentuk laguna alami dengan air berwarna biru kehijauan jernih. Akses menuju pantai melalui jalur trekking singkat melewati kebun warga yang asri, menambah sensasi petualangan. Ombak di teluk kecil ini relatif tenang sehingga aman untuk berenang dan snorkeling. Saat air surut, kawasan karang dangkal mengungkap berbagai biota laut yang menarik. Pantai ini buka hingga sore hari dan belum dipungut biaya pengelolaan besar, sehingga ideal bagi wisatawan yang mencari ketenangan jauh dari keramaian pantai utama seperti Baron atau Parangtritis.' WHERE `id` = 4;

UPDATE `places` SET `description` = 'Gunung Bromo (2.329 mdpl) adalah gunung berapi aktif paling ikonik di Indonesia, bagian dari Taman Nasional Bromo Tengger Semeru. Terletak di tengah lautan pasir luas bernama Segara Wedi seluas 10 km², kawah Bromo terus mengepulkan asap sulfur setiap saat. Ritual Yadnya Kasada yang dirayakan masyarakat Tengger setiap tahun menambah nilai budaya yang luar biasa. Titik matahari terbit terbaik adalah dari Bukit Pananjakan dan Bukit Kingkong. Untuk mencapai kawah, pengunjung dapat menyewa jeep 4WD dari Probolinggo/Malang, menaiki kuda, atau berjalan kaki melintasi lautan pasir. Pemandangan "lautan pasir dan pagi bersalju" yang melegenda telah menjadikan Bromo sebagai destinasi bucket-list nomor satu di Jawa Timur dan salah satu ikon pariwisata Indonesia di kancah internasional.' WHERE `id` = 5;

UPDATE `places` SET `description` = 'Desa Penglipuran di Kabupaten Bangli, Bali, telah memenangkan berbagai penghargaan sebagai salah satu desa terbersih dan terbaik di dunia. Desa adat ini mempertahankan tata ruang tradisional Bali Aga yang konsisten: satu jalan utama lurus diapit deretan pekarangan rumah bertembok dengan pintu masuk (angkul-angkul) seragam. Mobil dan motor dilarang masuk, menjaga kedamaian dan keasrian. Bambu menjadi tanaman dominan di sekeliling desa, membentuk hutan bambu yang nyaman dijelajahi. Warga masih menjalankan adat dan ritual Hindu Bali sehari-hari, sehingga pengunjung bisa menyaksikan kehidupan otentik. Tersedia homestay untuk menginap, serta warung khas penjual loloh cemcem (minuman herbal lokal) dan jajanan Bali. Waktu terbaik berkunjung adalah pagi hari sebelum rombongan wisata datang.' WHERE `id` = 6;

UPDATE `places` SET `description` = 'Tana Toraja di Sulawesi Selatan adalah salah satu destinasi budaya paling memukau di Asia Tenggara. Masyarakat Toraja terkenal dengan upacara pemakaman mewah bernama Rambu Solo — pesta kematian yang bisa berlangsung berhari-hari dengan menyembelih puluhan kerbau dan babi sebagai simbol penghormatan kepada almarhum. Jenazah disimpan di tebing batu (liang) yang dihiasi patung tau-tau (representasi orang meninggal). Rumah adat Tongkonan dengan atap melengkung berbentuk perahu adalah landmark arsitektur yang tak tertandingi. Kawasan pegunungan Toraja menawarkan trek melalui desa-desa tradisional, sawah bertingkat, dan pemandangan alam hijau yang dramatis. Kete Kesu, Londa, dan Bori adalah situs yang wajib dikunjungi. Festival Lovely December rutin menarik ribuan wisatawan mancanegara setiap tahunnya.' WHERE `id` = 7;

UPDATE `places` SET `description` = 'Desa Sade adalah enclave budaya Suku Sasak di Lombok Tengah yang masih menjaga kemurnian tradisi leluhur. Rumah-rumah panggung beratap ilalang (bumbung) berderet rapi, lantainya dilapisi tanah liat campur kotoran kerbau yang dipercaya mengusir serangga — tradisi yang terus dijalankan hingga sekarang. Sekitar 700 warga Desa Sade hidup dari bertani dan menenun kain songket serta kain tenun khas Lombok yang dijual langsung kepada wisatawan. Pengunjung bisa belajar menenun, mengenakan pakaian adat, dan menyaksikan tari tradisional Sasak. Pemandu lokal (biasanya pemuda desa) siap menjelaskan filosofi hidup, adat pernikahan sorong serah aji krama, dan sejarah desa dalam bahasa Indonesia yang ramah. Desa ini buka setiap hari dan tidak ada tiket resmi, namun pemberian donasi sukarela sangat diapresiasi.' WHERE `id` = 8;

UPDATE `places` SET `description` = 'Pertunjukan Tari Kecak di Pura Uluwatu, Badung, Bali adalah salah satu pengalaman seni pertunjukan paling dramatis di dunia. Ribuan suara "cak" bergema dari ratusan penari lelaki berpakaian kotak-kotak hitam-putih yang membentuk lingkaran konsentris, melakonkan kisah Ramayana — penculikan Dewi Sita, pertempuran Rama melawan Rahwana, dan kemenangan kebaikan atas kejahatan. Pertunjukan berlangsung sore menjelang matahari terbenam di tepi tebing setinggi 70 meter, dengan laut biru Samudera Hindia sebagai latar belakang. Efek dramatisasi api lilin yang menyala saat momen klimaks menciptakan suasana magis. Pura Uluwatu sendiri adalah salah satu pura "Kayangan Jagat" (pura pelindung Bali) yang menjulang di tepi tebing dan dihuni kawanan kera. Datanglah 30 menit sebelum pertunjukan untuk memilih tempat duduk terbaik.' WHERE `id` = 9;

UPDATE `places` SET `description` = 'Desa Waerebo adalah desa tradisional paling terpencil dan paling magis di Flores, NTT, yang hanya bisa dijangkau dengan trekking 3–4 jam dari Desa Denge. Terletak di ketinggian 1.200 mdpl di dalam lembah hijau yang dikelilingi hutan tropis lebat, Waerebo dihuni komunitas Manggarai yang telah menjaga tujuh rumah adat Mbaru Niang mereka selama ratusan tahun. Mbaru Niang adalah rumah kerucut beratap jerami yang menjulang lima tingkat, masing-masing tingkat memiliki fungsi berbeda: hunian, penyimpanan makanan, benih, bekal darurat, dan persembahan. UNESCO mengakui Waerebo sebagai salah satu situs warisan arsitektur vernakular Asia Pasifik. Pengunjung wajib didampingi pemandu, melakukan ritual penyambutan adat (compang), dan bisa menginap semalam untuk merasakan kehidupan komunitas serta pemandangan kabut pagi yang tak terlupakan.' WHERE `id` = 10;

UPDATE `places` SET `description` = 'Candi Borobudur adalah mahakarya arsitektur Buddha terbesar di dunia yang dibangun pada abad ke-8 dan ke-9 Masehi oleh Dinasti Syailendra. Kompleks candi ini terdiri dari sembilan teras batu andesit yang tersusun dalam tiga zona kosmis: Kamadhatu (dunia hasrat), Rupadhatu (dunia bentuk), dan Arupadhatu (dunia tanpa bentuk) yang disimbolkan oleh 72 stupa berlubang dengan patung Buddha di dalamnya, serta stupa induk raksasa di puncak. Total relief yang terpahat sepanjang 2,5 km menceritakan kisah kehidupan Buddha dan ajaran kosmologi Buddha. Matahari terbit di Borobudur, saat siluet stupa-stupa terbalut kabut dengan latar belakang Gunung Merapi dan Merbabu, adalah salah satu pemandangan paling ikonik di Asia. Tersedia paket "Borobudur Sunrise" dengan akses eksklusif sebelum jam buka umum. UNESCO menetapkan Borobudur sebagai Warisan Budaya Dunia sejak 1991.' WHERE `id` = 11;

UPDATE `places` SET `description` = 'Kawasan Kota Tua Jakarta atau Batavia Lama adalah pusat kota dagang VOC Belanda yang dibangun sejak abad ke-17. Area seluas ±1,3 km² ini menyimpan ratusan bangunan bergaya neo-klasik dan Art Deco Eropa yang masih berdiri megah. Museum Fatahillah (Museum Sejarah Jakarta) berdiri di bekas Balai Kota Batavia dengan koleksi artefak masa kolonial yang lengkap. Di sekeliling alun-alun, pengunjung bisa menyewa sepeda onthel berbagai warna untuk berkeliling dengan nuansa vintage yang instagrammable. Kafe-kafe bergaya retro banyak bermunculan di ruko-ruko tua yang direnovasi. Malam hari kawasan ini hidup dengan pertunjukan seni jalanan, street food, dan pertunjukan komunitas. Kota Tua terus dikembangkan sebagai kawasan heritage modern yang memadukan sejarah dan kreativitas kota.' WHERE `id` = 12;

UPDATE `places` SET `description` = 'Lawang Sewu (secara harfiah: Seribu Pintu) adalah bangunan monumental warisan kolonial Belanda yang dibangun tahun 1904–1919 sebagai kantor pusat Nederlandsch-Indische Spoorweg Maatschappij (NIS), perusahaan kereta api swasta. Terletak di jantung Kota Semarang, gedung tiga lantai ini terkenal dengan deretan pintu dan jendela kaca berwarna-warni yang jumlahnya ribuan, menciptakan permainan cahaya yang menakjubkan. Basement Lawang Sewu menyimpan sejarah kelam sebagai tempat penahanan dan eksekusi pada masa pendudukan Jepang. Kini gedung ini telah direstorasi dan dikelola PT. KAI sebagai museum dan cagar budaya. Pengunjung bisa mengikuti tur malam bertema "misteri" yang populer, atau tur siang yang mengupas sejarah arsitektur dan perkeretaapian. Relief dan ornamen eksteriornya merupakan contoh arsitektur Art Nouveau terbaik di Indonesia.' WHERE `id` = 13;

UPDATE `places` SET `description` = 'Benteng Vredeburg dibangun oleh pemerintah kolonial VOC tahun 1760 atas permintaan Sri Sultan Hamengku Buwono I sebagai "jaminan keamanan" — meski sesungguhnya berfungsi mengawasi Keraton Yogyakarta dari jarak dekat. Berlokasi tepat di ujung Jalan Malioboro berhadapan dengan Gedung Agung (Istana Presiden), benteng berbentuk segi empat dengan bastion di setiap sudutnya ini kini menjadi Museum Perjuangan. Diorama-diorama di dalam museum menceritakan perjalanan perjuangan bangsa Indonesia dari masa penjajahan hingga kemerdekaan secara kronologis dan detail. Bagi peminat sejarah, museum ini adalah referensi visual terlengkap tentang revolusi kemerdekaan Indonesia. Halaman benteng yang luas juga menjadi venue rutin berbagai festival seni dan budaya Yogyakarta sepanjang tahun. Tiket masuknya sangat terjangkau, menjadikannya destinasi edukasi favorit keluarga.' WHERE `id` = 14;

UPDATE `places` SET `description` = 'Istana Maimun adalah istana Kesultanan Deli yang dibangun pada 1888 atas prakarsa Sultan Makmun Al Rasyid Perkasa Alamsyah. Istana ini merupakan perpaduan arsitektur Melayu, Islam, Spanyol, Italia, dan India — cerminan jaringan perdagangan dan diplomasi Kesultanan Deli yang kosmopolit pada zamannya. Bangunan utama berwarna kuning (warna khas Melayu) dengan kubah-kubah berbentuk bawang dan ornamen bintang segi delapan. Mahkota Deli, senjata, dan perlengkapan kerajaan dipajang di ruang utama yang masih digunakan untuk upacara adat. Sultan dan keluarga kerajaan masih tinggal di sebagian sayap istana. Di halaman terdapat meriam Puntung yang dikeramatkan dengan legenda Putri Hijau. Mengenakan baju kurung atau kebaya untuk berfoto di depan istana adalah aktivitas favorit wisatawan yang berkunjung ke Medan.' WHERE `id` = 15;

UPDATE `places` SET `description` = 'Masjid Istiqlal adalah masjid terbesar di Asia Tenggara dan salah satu yang terbesar di dunia, mampu menampung hingga 200.000 jamaah. Dibangun pada 1961–1978 dengan desain arsitek nasionalis Friedrich Silaban, Istiqlal mengusung arsitektur modern minimalis yang mencerminkan kemerdekaan dan persatuan (istiqlal = kemerdekaan dalam bahasa Arab). Kubah utama berdiameter 45 meter disimbolkan tahun kemerdekaan Indonesia. Lima menara setinggi 66,66 meter melambangkan panjang ayat Al-Quran. Posisinya yang berhadapan langsung dengan Gereja Katedral Jakarta menjadi simbol kerukunan beragama yang kuat. Masjid ini terbuka untuk wisatawan non-Muslim dengan dress code tertutup dan panduan tur tersedia. Suasana salat Jumat dan Idul Fitri di Istiqlal adalah pengalaman spiritual dan sosial yang tak terlupakan.' WHERE `id` = 16;

UPDATE `places` SET `description` = 'Malioboro adalah jantung wisata Kota Yogyakarta, sebuah koridor sepanjang ±1 km yang memadukan sejarah, budaya, kuliner, dan belanja dalam satu napas. Nama Malioboro dipercaya berasal dari nama Duke of Marlborough atau dari kata Sansekerta "malyabhara" (dihiasi bunga). Deretan pedagang kaki lima menjajakan batik, wayang kulit, perak, blangkon, dan berbagai kerajinan khas Jogja di sepanjang trotoar yang telah diperlebar dan diperindah. Malam hari, angkringan menjadi simbol kesetaraan sosial Yogyakarta — dari mahasiswa hingga pejabat duduk bersila menikmati nasi kucing, wedang jahe, dan berbagai lauk sederhana dengan harga sangat terjangkau. Kawasan ini juga merupakan koridor budaya menuju Keraton Yogyakarta dan Alun-Alun Utara. Street art, musisi jalanan berbakat, dan becak kayuh listrik melengkapi pengalaman berjalan-jalan di Malioboro yang sesungguhnya tak pernah tidur.' WHERE `id` = 21;

UPDATE `places` SET `description` = 'Pasar Cihapit di Kecamatan Cibeunying Kaler, Bandung, adalah pasar basah tradisional yang terkenal sebagai surga kuliner kaki lima autentik Sunda sejak era kolonial. Di sini berjejer warung-warung yang menjajakan nasi timbel, batagor, siomay, colenak, surabi, karedok, peuyeum, dan aneka jajanan Sunda lainnya dengan harga yang sangat merakyat. Kesegaran bahan baku langsung dari pasar membuat cita rasa masakan terasa sangat autentik. Suasana pasar yang hidup, interaksi hangat pedagang dan pembeli, serta aroma rempah yang khas menciptakan pengalaman kuliner yang jauh dari kesan komersialisasi. Pasar ini paling ramai pada pagi hari (06.00–10.00 WIB), cocok untuk sarapan pagi yang berkesan bagi wisatawan yang ingin merasakan keseharian warga Bandung.' WHERE `id` = 22;

UPDATE `places` SET `description` = 'Kawasan Jalan Sabang (H. Agus Salim) di Jakarta Pusat adalah destinasi kuliner malam yang legendaris dan lintas generasi. Ratusan warung tenda berjejer menyajikan menu nusantara yang lengkap: sate Madura, nasi goreng Kambing Kebon Sirih, soto Betawi, gulai, bakso, mie ayam, es cendol, dan masih banyak lagi. Lokasi strategis di pusat kota menjadikannya titik kumpul favorit pegawai kantoran, keluarga, hingga wisatawan mancanegara yang ingin merasakan street food Jakarta. Beberapa warung telah beroperasi sejak puluhan tahun dan diwariskan lintas generasi, mempertahankan resep otentik. Aktivitas terbaik adalah datang dalam rombongan, memesan berbagai menu dari warung berbeda, dan menikmati makan malam sambil merasakan denyut nadi kota Jakarta yang kosmopolit.' WHERE `id` = 23;

-- ============================================================
-- 3. UPDATE FASILITAS (places yang masih NULL)
-- ============================================================

UPDATE `places` SET `facilities` = '["toilet","parkir","warung","camping_ground","pos_pendakian","air_bersih"]' WHERE `id` = 1;
UPDATE `places` SET `facilities` = '["toilet","parkir","warung","camping_ground","pos_pendakian","penyewaan_tenda","air_bersih"]' WHERE `id` = 2;
UPDATE `places` SET `facilities` = '["helipad","porter","pemandu_wajib","basecamp"]' WHERE `id` = 3;
UPDATE `places` SET `facilities` = '["toilet","parkir","warung","area_foto"]' WHERE `id` = 4;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","mushola","souvenir","pemandu","jeep_rental","penyewaan_kuda"]' WHERE `id` = 5;
UPDATE `places` SET `facilities` = '["toilet","parkir","souvenir","warung","area_foto","homestay","mushola"]' WHERE `id` = 6;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","souvenir","pemandu","homestay","mushola"]' WHERE `id` = 7;
UPDATE `places` SET `facilities` = '["toilet","parkir","souvenir","pemandu","warung"]' WHERE `id` = 8;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","souvenir","area_foto","aksesibilitas"]' WHERE `id` = 9;
UPDATE `places` SET `facilities` = '["toilet","pemandu_wajib","warung","homestay","camping_area"]' WHERE `id` = 10;
UPDATE `places` SET `facilities` = '["toilet","parkir","souvenir","pemandu","restoran","aksesibilitas","wifi","area_foto"]' WHERE `id` = 11;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","souvenir","area_foto","aksesibilitas","wifi","sepeda_sewa"]' WHERE `id` = 12;
UPDATE `places` SET `facilities` = '["toilet","parkir","souvenir","pemandu","area_foto","aksesibilitas"]' WHERE `id` = 13;
UPDATE `places` SET `facilities` = '["toilet","parkir","souvenir","pemandu","area_foto","aksesibilitas","mushola"]' WHERE `id` = 14;
UPDATE `places` SET `facilities` = '["toilet","parkir","souvenir","pemandu","area_foto","mushola"]' WHERE `id` = 15;
UPDATE `places` SET `facilities` = '["toilet","parkir","mushola","aksesibilitas","area_foto","pemandu"]' WHERE `id` = 16;
UPDATE `places` SET `facilities` = '["toilet","parkir","souvenir","pemandu","restoran","mushola","area_foto"]' WHERE `id` = 17;
UPDATE `places` SET `facilities` = '["toilet","parkir","area_foto","pemandu"]' WHERE `id` = 18;
UPDATE `places` SET `facilities` = '["toilet","parkir","souvenir","mushola","warung"]' WHERE `id` = 19;
UPDATE `places` SET `facilities` = '["toilet","parkir","souvenir","mushola","area_foto"]' WHERE `id` = 20;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","souvenir","pemandu","angkringan","atm","wifi","aksesibilitas"]' WHERE `id` = 21;
UPDATE `places` SET `facilities` = '["toilet","warung","area_foto"]' WHERE `id` = 22;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","area_foto","atm"]' WHERE `id` = 23;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","area_foto","atm"]' WHERE `id` = 24;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","souvenir","area_foto","wifi","aksesibilitas"]' WHERE `id` = 25;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","souvenir","area_foto","wifi","aksesibilitas","mushola","atm","loker"]' WHERE `id` = 26;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","souvenir","area_foto","wifi","aksesibilitas","mushola","atm"]' WHERE `id` = 27;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","souvenir","area_foto","wifi","aksesibilitas","mushola","atm"]' WHERE `id` = 28;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","loker","area_foto","wifi","aksesibilitas","atm","lounge"]' WHERE `id` = 29;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","souvenir","area_foto","wifi","aksesibilitas","mushola","atm"]' WHERE `id` = 30;
UPDATE `places` SET `facilities` = '["toilet","parkir","souvenir","pemandu","area_foto","aksesibilitas","mushola"]' WHERE `id` = 31;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","souvenir","area_foto","wifi","aksesibilitas","mushola","atm"]' WHERE `id` = 32;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","souvenir","area_foto","wifi","aksesibilitas","mushola","atm"]' WHERE `id` = 33;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","souvenir","area_foto","wifi","aksesibilitas","atm"]' WHERE `id` = 34;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","souvenir","area_foto","aksesibilitas","mushola","atm"]' WHERE `id` = 35;
UPDATE `places` SET `facilities` = '["toilet","parkir","souvenir","warung","area_foto","aksesibilitas","atm"]' WHERE `id` = 36;
UPDATE `places` SET `facilities` = '["toilet","parkir","souvenir","restoran","area_foto","aksesibilitas","atm","mushola"]' WHERE `id` = 37;
UPDATE `places` SET `facilities` = '["toilet","parkir","souvenir","warung","area_foto"]' WHERE `id` = 38;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","souvenir","area_foto","wifi","aksesibilitas","atm","mushola","bioskop"]' WHERE `id` = 39;
UPDATE `places` SET `facilities` = '["toilet","parkir","restoran","souvenir","area_foto","wifi","atm"]' WHERE `id` = 40;

-- ============================================================
-- 4. UPDATE ESTIMASI BIAYA (lebih realistis & detail)
-- ============================================================

-- Nature
UPDATE `places` SET `entrance_fee`=27000, `parking_fee`=15000, `meal_cost`=40000 WHERE `id`=1;  -- Merbabu
UPDATE `places` SET `entrance_fee`=20000, `parking_fee`=10000, `meal_cost`=35000 WHERE `id`=2;  -- Prau
UPDATE `places` SET `entrance_fee`=2500000, `parking_fee`=0, `meal_cost`=150000 WHERE `id`=3;  -- Carstensz (izin+porter)
UPDATE `places` SET `entrance_fee`=10000, `parking_fee`=5000, `meal_cost`=30000 WHERE `id`=4;  -- Ngetun
UPDATE `places` SET `entrance_fee`=35000, `parking_fee`=30000, `meal_cost`=50000 WHERE `id`=5;  -- Bromo

-- Culture
UPDATE `places` SET `entrance_fee`=30000, `parking_fee`=5000, `meal_cost`=35000 WHERE `id`=6;  -- Penglipuran
UPDATE `places` SET `entrance_fee`=60000, `parking_fee`=20000, `meal_cost`=50000 WHERE `id`=7;  -- Toraja
UPDATE `places` SET `entrance_fee`=0, `parking_fee`=5000, `meal_cost`=25000 WHERE `id`=8;  -- Sade (donasi)
UPDATE `places` SET `entrance_fee`=150000, `parking_fee`=20000, `meal_cost`=60000 WHERE `id`=9;  -- Kecak Uluwatu
UPDATE `places` SET `entrance_fee`=50000, `parking_fee`=0, `meal_cost`=40000 WHERE `id`=10; -- Waerebo (donasi adat)

-- History
UPDATE `places` SET `entrance_fee`=52000, `parking_fee`=20000, `meal_cost`=40000 WHERE `id`=11; -- Borobudur
UPDATE `places` SET `entrance_fee`=0, `parking_fee`=20000, `meal_cost`=55000 WHERE `id`=12; -- Kota Tua
UPDATE `places` SET `entrance_fee`=15000, `parking_fee`=10000, `meal_cost`=40000 WHERE `id`=13; -- Lawang Sewu
UPDATE `places` SET `entrance_fee`=3000, `parking_fee`=5000, `meal_cost`=35000 WHERE `id`=14; -- Vredeburg
UPDATE `places` SET `entrance_fee`=10000, `parking_fee`=5000, `meal_cost`=45000 WHERE `id`=15; -- Istana Maimun

-- Religious
UPDATE `places` SET `entrance_fee`=0, `parking_fee`=5000, `meal_cost`=40000 WHERE `id`=16; -- Istiqlal
UPDATE `places` SET `entrance_fee`=60000, `parking_fee`=10000, `meal_cost`=40000 WHERE `id`=17; -- Besakih
UPDATE `places` SET `entrance_fee`=0, `parking_fee`=10000, `meal_cost`=35000 WHERE `id`=18; -- Gereja Blenduk
UPDATE `places` SET `entrance_fee`=0, `parking_fee`=5000, `meal_cost`=25000 WHERE `id`=19; -- Makam Sunan
UPDATE `places` SET `entrance_fee`=0, `parking_fee`=5000, `meal_cost`=30000 WHERE `id`=20; -- Vihara Dhanagun

-- Culinary
UPDATE `places` SET `entrance_fee`=0, `parking_fee`=15000, `meal_cost`=60000 WHERE `id`=21; -- Malioboro
UPDATE `places` SET `entrance_fee`=0, `parking_fee`=0, `meal_cost`=40000 WHERE `id`=22; -- Cihapit
UPDATE `places` SET `entrance_fee`=0, `parking_fee`=15000, `meal_cost`=55000 WHERE `id`=23; -- Jl Sabang
UPDATE `places` SET `entrance_fee`=0, `parking_fee`=10000, `meal_cost`=50000 WHERE `id`=24; -- Kya-Kya
UPDATE `places` SET `entrance_fee`=0, `parking_fee`=5000, `meal_cost`=45000 WHERE `id`=25; -- Simpang Lima

-- Entertainment
UPDATE `places` SET `entrance_fee`=300000, `parking_fee`=25000, `meal_cost`=100000 WHERE `id`=26; -- Dufan
UPDATE `places` SET `entrance_fee`=160000, `parking_fee`=20000, `meal_cost`=80000 WHERE `id`=27; -- Jatim Park
UPDATE `places` SET `entrance_fee`=200000, `parking_fee`=15000, `meal_cost`=70000 WHERE `id`=28; -- Trans Studio
UPDATE `places` SET `entrance_fee`=530000, `parking_fee`=0, `meal_cost`=120000 WHERE `id`=29; -- Waterbom
UPDATE `places` SET `entrance_fee`=150000, `parking_fee`=15000, `meal_cost`=60000 WHERE `id`=30; -- Saloka

-- Education
UPDATE `places` SET `entrance_fee`=3000, `parking_fee`=5000, `meal_cost`=35000 WHERE `id`=31; -- Museum Geologi
UPDATE `places` SET `entrance_fee`=10000, `parking_fee`=10000, `meal_cost`=35000 WHERE `id`=32; -- Taman Pintar
UPDATE `places` SET `entrance_fee`=120000, `parking_fee`=25000, `meal_cost`=65000 WHERE `id`=33; -- Seaworld
UPDATE `places` SET `entrance_fee`=150000, `parking_fee`=10000, `meal_cost`=60000 WHERE `id`=34; -- Museum MACAN
UPDATE `places` SET `entrance_fee`=4000, `parking_fee`=15000, `meal_cost`=40000 WHERE `id`=35; -- Ragunan

-- Shopping
UPDATE `places` SET `entrance_fee`=0, `parking_fee`=10000, `meal_cost`=35000 WHERE `id`=36; -- Beringharjo
UPDATE `places` SET `entrance_fee`=0, `parking_fee`=15000, `meal_cost`=40000 WHERE `id`=37; -- Tanah Abang
UPDATE `places` SET `entrance_fee`=0, `parking_fee`=5000, `meal_cost`=30000 WHERE `id`=38; -- Sukawati
UPDATE `places` SET `entrance_fee`=0, `parking_fee`=25000, `meal_cost`=100000 WHERE `id`=39; -- Grand Indonesia
UPDATE `places` SET `entrance_fee`=0, `parking_fee`=10000, `meal_cost`=50000 WHERE `id`=40; -- Jl Riau Bandung

-- ============================================================
-- 5. TAMBAH ULASAN (reviews) — 60+ ulasan beragam destinasi
-- ============================================================

INSERT INTO `reviews` (`id`, `place_id`, `user_id`, `user_name`, `rating`, `comment`, `created_at`) VALUES
-- Gunung Merbabu (id=1)
(6,  1, 3, 'Ahmad Fauzi',      5, 'Sabana Merbabu benar-benar bikin speechless! Trek lumayan terjal tapi semua terbayar di puncak. Sunrise-nya surreal banget, kabutnya dramatis. Wajib bawa jaket tebal karena bisa di bawah 5°C malam hari.', '2026-03-15 05:30:00'),
(7,  1, 9, 'Hendra Gunawan',   4, 'Jalur Selo oke untuk pendaki pemula berbadan fit. Pemandangan sabana berlapis-lapisnya luar biasa. Sayang ada beberapa titik yang erosi cukup parah, semoga segera dibenahi. Bawa banyak air dan snack!', '2026-04-02 06:00:00'),
(8,  1, 11,'Rizky Pratama',    5, 'Sudah 3x ke Merbabu dan tidak pernah bosan. Puncak Kenteng Songo memberikan view Merapi yang tiada tandingannya. Jangan lupa sewa guide lokal untuk keselamatan dan mendukung ekonomi masyarakat sekitar.', '2026-04-20 07:00:00'),

-- Gunung Prau (id=2)
(9,  2, 4, 'Rina Kusuma',      5, 'Golden hour di Prau adalah pengalaman yang mengubah hidup! Lautan awan di pagi hari membuatku menangis haru. Ini gunung paling friendly untuk solo traveler karena sangat ramai dan aman. Trek 4 jam worth it banget!', '2026-02-10 05:00:00'),
(10, 2, 15,'Bagas Wicaksono',  4, 'Camping di Prau dengan pemandangan Sindoro-Sumbing-Merapi-Merbabu berjejer adalah bucket list yang HARUS dicoret. Area sabana puncaknya luas jadi bisa kemping santai. Pastikan beli tiket online dulu karena sering habis.', '2026-03-25 06:30:00'),
(11, 2, 16,'Nina Setiawati',   5, 'Solo trip pertama dan langsung jatuh cinta dengan Prau. Komunitas pendaki di sini sangat ramah dan saling membantu. Area sunrise-nya epic parah, stargazing malamnya juga magical. 11/10 will repeat!', '2026-04-15 05:15:00'),

-- Carstensz Pyramid (id=3)
(12, 3, 11,'Rizky Pratama',    5, 'Ekspedisi Carstensz 2025 — mimpi yang akhirnya kesampaian! Butuh latihan 2 tahun, budget puluhan juta, dan mental baja. Tapi saat berdiri di 4.884 mdpl dengan gletser di sisi kiri kanan, semua pengorbanan tidak ada artinya. Indonesia punya surga di timur!', '2026-01-30 14:00:00'),

-- Pantai Ngetun (id=4)
(13, 4, 8, 'Sari Puspita',     5, 'Hidden gem Gunungkidul yang masih sangat alami! Airnya jernih banget bisa langsung lihat karang dari permukaan. Tebing karst yang mengapit pantai bikin suasana sangat dramatis. Bawa bekal sendiri karena warung masih minim.', '2026-03-08 10:00:00'),
(14, 4, 16,'Nina Setiawati',   4, 'Pantai ini memang tersembunyi tapi worth the effort! Trekking singkat 15 menit dari parkiran melewati jalan berbatu yang sedikit tricky. Snorkeling di sini luar biasa, banyak ikan warna-warni. Tidak ada sinyal HP yang justru bikin lebih menikmati alam.', '2026-04-12 11:00:00'),

-- Gunung Bromo (id=5)
(15, 5, 5, 'Budi Santoso',     5, 'Bromo saat golden hour adalah salah satu pemandangan paling dramatis yang pernah saya lihat. Asap kawah yang mengepul dengan latar lautan pasir dan Semeru di kejauhan adalah lukisan alam sesungguhnya. Datanglah di weekday dan pesanlah jeep dari jauh-jauh hari.', '2026-01-20 06:00:00'),
(16, 5, 13,'Reza Mahendra',    4, 'Pengalaman seru tapi harus siap mental dengan keramaian di peak season. Jeep antrean panjang kalau weekend. Tips: booking jeep H-3, pilih spot Bukit Kingkong daripada Pananjakan untuk view yang lebih "private". Bawa masker karena debu pasir dan bau sulfur cukup kuat.', '2026-02-05 05:30:00'),
(17, 5, 3, 'Ahmad Fauzi',      3, 'Bromo memang indah tapi semakin komersil. Tarif jeep naik terus, pedagang di kawah semakin agresif, dan sampah di lautan pasir cukup mengganggu. Pemandangannya tetap luar biasa, tapi perlu regulasi wisata yang lebih ketat agar Bromo tetap lestari.', '2026-03-10 07:00:00'),

-- Desa Penglipuran (id=6)
(18, 6, 8, 'Sari Puspita',     5, 'Desa paling bersih yang pernah saya kunjungi di Indonesia! Tidak ada asap kendaraan, tidak ada sampah berserakan. Warganya ramah dan senang berbagi cerita tentang tradisi mereka. Hutan bambunya sangat menenangkan jiwa. Sangat recommended untuk slow travel!', '2026-02-28 09:00:00'),
(19, 6, 6, 'Citra Dewi',       5, 'Penglipuran adalah Bali yang sesungguhnya — sebelum komersialisasi mengubah segalanya. Arsitekturnya konsisten dan terjaga dengan sangat baik. Cobalah loloh cemcem di warung Ibu Made, rasanya unik dan menyegarkan. Datanglah pagi hari sebelum banyak tour bus masuk.', '2026-03-22 08:30:00'),

-- Tana Toraja (id=7)
(20, 7, 6, 'Citra Dewi',       5, 'Toraja adalah pengalaman budaya paling mendalam yang pernah saya alami. Menyaksikan langsung Rambu Solo mengubah perspektif saya tentang kehidupan dan kematian. Tau-tau di tebing Londa terasa magis dan sedikit menyeramkan. Sewa pemandu lokal — mereka adalah storyteller terbaik!', '2026-01-15 10:00:00'),
(21, 7, 17,'Eko Prasetyo',     4, 'Toraja melampaui ekspektasi saya. Tongkonan-nya megah, persawahannya indah, dan orang-orangnya sangat hangat. Makanan khas seperti Pa\'piong (ikan/daging bambu bakar) dan kopi Toraja-nya premium. Butuh minimal 3 hari untuk menjelajahi area utama.', '2026-02-20 11:00:00'),

-- Desa Sade (id=8)
(22, 8, 10,'Maya Rahayu',      4, 'Desa Sade memberi gambaran nyata kehidupan suku Sasak yang autentik. Proses tenun songket yang saya saksikan sangat memukau — butuh ketelitian dan kesabaran luar biasa. Beli kain tenun langsung dari pengrajinnya sebagai bentuk dukungan ekonomi lokal.', '2026-03-05 10:30:00'),
(23, 8, 8, 'Sari Puspita',     3, 'Menarik tapi sedikit terlalu touristy. Pedagang souvenir sangat agresif mengejar wisatawan. Proses tur terasa terburu-buru. Saran: datang saat bukan musim liburan dan minta pemandu yang lebih santai. Isi debu kotoran kerbau di lantai rumah memang unik tapi perlu dijelaskan lebih baik kepada pengunjung.', '2026-04-01 09:00:00'),

-- Tari Kecak Uluwatu (id=9)
(24, 9, 10,'Maya Rahayu',      5, 'Pertunjukan Kecak terbaik yang pernah saya tonton dan saya sudah menonton di beberapa tempat berbeda. Setting di tebing Uluwatu dengan sunset di latar belakang adalah kombinasi sempurna. Datanglah 45 menit sebelum pertunjukan untuk tempat duduk di barisan depan. Sangat worth the price!', '2026-01-25 17:00:00'),
(25, 9, 12,'Fitri Handayani',  5, 'Kecak Uluwatu adalah seni yang membuat merinding! Kekompakan ratusan penari, gema suara "cak" yang resonan di tebing batu, dan api livin yang menyala saat klimaks cerita Ramayana — semua terasa magis dan spiritual. Pengalaman budaya Bali yang sesungguhnya tidak tergantikan.', '2026-02-18 18:00:00'),

-- Desa Waerebo (id=10)
(26, 10,6, 'Citra Dewi',       5, 'Trek ke Waerebo adalah salah satu pengalaman terberat sekaligus terindah dalam hidup saya. 3,5 jam trekking naik turun hutan lebat, tapi saat Mbaru Niang muncul di lembah berkabut — semua rasa lelah langsung hilang. Menginap semalam dan menikmati sarapan bersama warga adalah momen tak terlupakan.', '2025-12-10 15:00:00'),

-- Candi Borobudur (id=11)
(27, 11,12,'Fitri Handayani',  5, 'Borobudur sunrise adalah pengalaman spiritual yang saya rekomendasikan kepada siapapun. Kabus pagi yang menyelimuti stupa saat matahari mulai muncul dari balik Gunung Merapi menciptakan suasana sakral yang luar biasa. Beli paket sunrise yang sudah termasuk pemandu untuk pengalaman lebih mendalam.', '2026-01-05 05:30:00'),
(28, 11,17,'Eko Prasetyo',     4, 'Warisan budaya dunia yang memang layak masuk bucket list! Reliefnya sangat detail dan menceritakan kisah yang kaya makna. Panas saat siang hari jadi datanglah pagi-pagi. Area parkir jauh dari candi jadi siapkan fisik untuk jalan. Pemandu resmi sangat membantu memahami konteks sejarahnya.', '2026-02-12 07:00:00'),
(29, 11,7, 'Dedi Hermawan',    5, 'Kunjungan ketiga ke Borobudur dan selalu menemukan detail baru di relief-reliefnya. Stupa-stupa berlubang dengan patung Buddha di dalamnya sangat fotogenik saat golden hour. Jangan lupa kunjungi Candi Mendut yang jaraknya dekat — paket kombinasi tersedia dan worth it.', '2026-03-30 06:00:00'),

-- Kota Tua Jakarta (id=12)
(30, 12,14,'Lina Marlina',     4, 'Kota Tua setelah revitalisasi jauh lebih nyaman! Trotoarnya lebar, bersih, dan photo-friendly. Naik sepeda onthel warna-warni adalah aktivitas yang sangat seru dan instagrammable. Museum Fatahillah wajib dikunjungi untuk memahami sejarah Batavia. Datanglah pagi hari sebelum panas menyengat.', '2026-02-22 09:00:00'),
(31, 12,7, 'Dedi Hermawan',    3, 'Potensial besar tapi eksekusi masih setengah-setengah. Pedagang asongan masih cukup mengganggu, beberapa sudut masih kurang terawat. Museum-museumnya bagus tapi butuh pembaruan display agar lebih engaging. Kafe-kafe vintagenya enak dan Instagrammable. Harapan: semoga terus berkembang!', '2026-03-15 10:00:00'),

-- Lawang Sewu (id=13)
(32, 13,13,'Reza Mahendra',    4, 'Arsitektur Lawang Sewu sangat memukau — detail Art Nouveau-nya luar biasa apalagi kaca patri berwarnanya. Tur malam "misteri" yang ditawarkan pengelola lumayan seru meski lebih ke arah theatrical. Basement-nya memang mencekam dan bersejarah. Sangat recommended untuk pecinta heritage photography.', '2026-01-18 19:00:00'),
(33, 13,15,'Bagas Wicaksono',  5, 'Bangunan paling indah di Semarang! Bermandikan cahaya matahari sore yang masuk melalui ribuan kaca jendela berwarna — momen foto yang tidak akan bisa dilupakan. Penjelasan sejarah dari guide sangat informatif. Harga tiket sangat terjangkau untuk nilai heritage yang didapat.', '2026-03-05 16:00:00'),

-- Benteng Vredeburg (id=14)
(34, 14,12,'Fitri Handayani',  4, 'Museum diorama yang sangat edukatif! Perjuangan kemerdekaan Indonesia divisualisasikan dengan detail yang baik dan kronologis. Lokasinya yang tepat di ujung Malioboro membuatnya mudah dikombinasikan dengan wisata Malioboro. Harga tiketnya sangat murah — 3000 rupiah untuk nilai sejarah yang tak ternilai.', '2026-02-08 10:30:00'),
(35, 14,5, 'Budi Santoso',     5, 'Benteng Vredeburg adalah destinasi wajib untuk memahami Jogja lebih dalam. Arsitektur bungker dan bastionnya masih terawat baik. Diorama pertempuran Jogja sangat dramatis dan membuat saya lebih menghargai para pejuang kemerdekaan. Halaman luarnya sering ada event budaya gratis!', '2026-04-05 09:30:00'),

-- Istana Maimun (id=15)
(36, 15,13,'Reza Mahendra',    4, 'Istana yang unik karena perpaduan arsitektur multi-kulturalnya — Melayu, Arab, Eropa, India semua menyatu harmonis. Meriam Puntung di halaman punya legenda menarik tentang Putri Hijau. Koleksi kerajaan di dalam cukup terbatas tapi pemandunya bercerita dengan sangat hidup. Jangan lupa pakai baju rapi untuk masuk.', '2026-03-20 11:00:00'),

-- Masjid Istiqlal (id=16)
(37, 16,10,'Maya Rahayu',      5, 'Istiqlal bukan sekadar masjid tapi simbol kemegahan bangsa! Arsitektur modernnya terasa timeless. Yang paling berkesan adalah momen salat berjamaah — ribuan orang dari berbagai penjuru Indonesia bersatu dalam satu gerakan. Pemandu tur-nya informatif dan ramah kepada wisatawan non-Muslim.', '2026-01-10 14:00:00'),
(38, 16,14,'Lina Marlina',     4, 'Mengunjungi Istiqlal sebagai non-Muslim membuka wawasan yang luar biasa tentang Islam Indonesia yang moderat dan terbuka. Petugas sangat sopan memberikan penjelasan dan pakaian pinjaman tersedia. Lokasinya persis berhadapan dengan Gereja Katedral — kerukunan beragama yang hidup dan nyata.', '2026-02-16 10:00:00'),

-- Pura Besakih (id=17)
(39, 17,10,'Maya Rahayu',      4, 'Pura induk Bali yang memang megah dan spiritual. Kompleksnya sangat luas jadi siapkan stamina ekstra. Pemandu wajib didampingi dan tarifnya cukup tinggi tapi necessary untuk menghormati adat. View Gunung Agung dari area pura sangat dramatis apalagi saat cuaca cerah.', '2026-02-25 09:30:00'),
(40, 17,6, 'Citra Dewi',       5, 'Besakih adalah pengalaman spiritual Bali yang berbeda dari tempat lain. Saat upacara berlangsung, seluruh kompleks bergemuruh dengan mantram dan aroma dupa — sungguh sakral dan mengesankan. Hormatilah adat setempat dan kenakan kamen (kain) dengan benar. Sangat merekomendasikan kunjungan saat hari biasa, bukan saat upacara besar.', '2026-03-18 08:00:00'),

-- Malioboro (id=21)
(41, 21,14,'Lina Marlina',     5, 'Malioboro malam hari adalah yang paling hidup! Angkringan dengan nasi kucing 3000-an dan teh jahe hangat sambil dengar musik jalanan adalah Jogja yang sesungguhnya. Harga tawar-menawar di pedagang kaki lima masih ada, jadi jangan ragu menawar dengan sopan. Ini destinasi yang tidak pernah membosankan.', '2026-01-28 19:30:00'),
(42, 21,17,'Eko Prasetyo',     4, 'Malioboro pasca revitalisasi lebih tertata tapi ada yang hilang — kesan semrawut yang justru itu khasnya. Pedagang kaki lima kini di satu sisi jalan, membuat pengalaman sedikit berbeda. Tapi tetap wajib dikunjungi! Jangan lupa mampir ke Pasar Beringharjo dan Benteng Vredeburg yang bersebelahan.', '2026-02-14 20:00:00'),
(43, 21,4, 'Rina Kusuma',      5, 'Malioboro = jiwa Yogyakarta. Saya tidak pernah ke Jogja tanpa berjalan-jalan di sini setidaknya sekali. Bakpia pathok fresh dari toko langsung, gudeg dari warung Mbah Lindu, batik cap dari pedagang kaki lima — semuanya ada di sini. Wisata yang paling affordable dan paling kaya pengalaman.', '2026-03-28 18:00:00'),

-- Dufan Ancol (id=26)
(44, 26,7, 'Dedi Hermawan',    4, 'Dufan masih jadi tema park terbaik untuk keluarga dengan budget yang cukup. Wahana Halilintar dan Tornado masih mendebarkan meski sudah lama. Antrian weekday jauh lebih pendek dari weekend. Tips: beli tiket online dan datang tepat saat buka untuk memaksimalkan waktu.', '2026-03-12 10:00:00'),
(45, 26,14,'Lina Marlina',     3, 'Beberapa wahana sudah cukup tua dan perlu pembaruan. Harga food court di dalam sangat mahal — 3x lipat harga normal. Tapi kalau bawa anak kecil mereka pasti senang. Semoga manajemen lebih fokus pada upgrade wahana dan fasilitas toilet yang lebih bersih.', '2026-04-08 14:00:00'),

-- Jatim Park (id=27)
(46, 27,9, 'Hendra Gunawan',   4, 'Jatim Park komplex wisata yang sangat complete — dari edukasi sampai hiburan semua ada. Museum Satwa, Batu Secret Zoo, dan wahana permainannya semuanya berkualitas. Suasana Kota Batu yang sejuk bikin betah. Rencanakan minimal full day atau bahkan 2 hari untuk mengunjungi semuanya.', '2026-01-22 09:00:00'),

-- Waterbom Bali (id=29)
(47, 29,9, 'Hendra Gunawan',   5, 'Waterbom Bali memang terbaik se-Asia dan saya tidak bisa membantah setelah mengunjunginya! Seluncuran Climax dan Smashdown benar-benar menantang adrenalin. Fasilitas sangat bersih dan terawat. Harganya memang premium tapi value for money. Sistem cashless dengan gelang chip sangat convenient.', '2026-02-03 11:00:00'),

-- Museum Geologi (id=31)
(48, 31,12,'Fitri Handayani',  5, 'Museum Geologi Bandung adalah salah satu museum terbaik di Indonesia dalam hal konten dan display! Fosil manusia purba, tulang dinosaurus, koleksi meteorit, dan peta vulkanologi yang interaktif — semua tersaji dengan sangat baik. Tiketnya murah banget (3000 rupiah) untuk kualitas museum seperti ini. Wajib bawa anak ke sini!', '2026-02-06 10:00:00'),

-- Taman Pintar (id=32)
(49, 32,15,'Bagas Wicaksono',  4, 'Taman Pintar adalah wisata edukasi terbaik di Yogyakarta untuk keluarga dengan anak-anak. Zona sains interaktifnya dirancang dengan baik dan membuat anak senang belajar. Planetarium di dalamnya juga tidak boleh dilewatkan. Bisa dikombinasikan dengan kunjungan ke Benteng Vredeburg dan Malioboro dalam satu hari.', '2026-03-02 10:30:00'),

-- Museum MACAN (id=34)
(50, 34,4, 'Rina Kusuma',      5, 'Museum MACAN adalah hidden gem Jakarta yang masih kurang dikenal! Koleksi seni modern dan kontemporer internasionalnya sangat impressive — ada karya Yayoi Kusama, Jean-Michel Basquiat, dan seniman Indonesia kelas dunia. Ruang Infinity Room-nya selalu ramai tapi worth the wait. Harga tiket wajar untuk standar museum internasional.', '2026-01-30 14:00:00'),

-- Pasar Beringharjo (id=36)
(51, 36,14,'Lina Marlina',     5, 'Beringharjo adalah surganya batik dengan harga paling bersahabat! Batik cap mulai 30 ribuan, batik tulis ratusan ribu dengan kualitas premium. Pandai-pandailah menawar dengan santai dan senyum. Juga banyak jajanan pasar tradisional yang enak seperti kipo, peyek, dan geplak. Ini pasar yang paling "Jogja" dari semua tempat di Jogja.', '2026-02-10 09:30:00'),
(52, 36,16,'Nina Setiawati',   4, 'Wajib masuk daftar belanja saat ke Jogja! Tapi persiapkan diri dengan kondisi pasar yang ramai, panas, dan sempit terutama weeked. Datanglah pagi hari untuk suasana lebih nyaman dan pilihan barang lebih lengkap sebelum diserbu pembeli lain. Jangan lupa coba dawet ireng di lantai bawah — segar banget!', '2026-03-20 10:00:00'),

-- Ragunan (id=35)
(53, 35,7, 'Dedi Hermawan',    4, 'Ragunan adalah kebun binatang terluas dan terbaik di Indonesia meski masih ada ruang untuk improvement dalam hal kandang hewan. Koleksi satwa asli Nusantara seperti komodo, orang utan, gajah, dan harimau Sumatera sangat lengkap. Bawa bekal sendiri, sewa sepeda atau mobil kelinci untuk keliling lebih efisien. Tiket masuknya sangat murah!', '2026-03-25 09:00:00'),

-- Pasar Tanah Abang (id=37)
(54, 37,14,'Lina Marlina',     3, 'Surga belanja grosir yang penuh tantangan! Harga memang sangat murah tapi kondisi fisik pasar panas, sempit, dan padat. Lift dan eskalator sering tidak berfungsi. Tapi kalau tahu cara navigasinya dan pandai mencari, bisa dapat baju branded KW berkualitas bagus atau bahan tekstil premium dengan harga grosir. Datanglah bukan hari Senin (hari libur pasar).', '2026-02-18 10:00:00'),

-- Grand Indonesia (id=39)
(55, 39,4, 'Rina Kusuma',      5, 'Grand Indonesia tetap menjadi raja mal Jakarta! Tenant internasional tier-1 semua ada, area entertainmentnya luas, dan food court-nya sangat beragam dari kelas warteg hingga fine dining. Lokasi di jantung Jakarta sangat strategis dengan akses MRT Bundaran HI. Tempat hangout premium yang tidak membosankan.', '2026-04-10 14:00:00'),

-- Simpang Lima Semarang (id=25)
(56, 25,17,'Eko Prasetyo',     4, 'Simpang Lima adalah jantung kota Semarang yang hidup 24 jam! Sore-malam adalah waktu terbaik ketika banyak pedagang kuliner malam buka. Lumpia, tahu gimbal, soto Semarang — semuanya ada di sekitar alun-alun. Suasana kota yang ramai dengan lampu-lampu malam menciptakan vibes urban yang menarik.', '2026-04-22 19:00:00'),

-- Kya-Kya Surabaya (id=24)
(57, 24,13,'Reza Mahendra',    4, 'Kawasan Pecinan Surabaya yang autentik! Masakan Tionghoa seperti Rawon Setan, Lontong Balap, dan Es Teler-nya khas banget. Suasana malam dengan lampion merah dan pedagang yang berteriak menambah keseruan. Kombinasikan dengan kunjungan ke House of Sampoerna yang berada tidak jauh dari sini.', '2026-03-17 18:30:00'),

-- Gereja Blenduk (id=18)
(58, 18,12,'Fitri Handayani',  5, 'Gereja Blenduk adalah landmark paling ikonik Kota Lama Semarang! Kubah tembaganya yang menghijau karena oksidasi sangat fotogenik. Interior gereja bergaya neo-klasik dengan orgen pipa antik masih terawat sangat baik. Kawasan Kota Lama di sekitarnya kini semakin dipercantik dan banyak kafe heritage bermunculan.', '2026-01-12 11:00:00'),

-- Seaworld Ancol (id=33)
(59, 33,5, 'Budi Santoso',     4, 'Seaworld Ancol menghadirkan pengalaman bawah laut yang impressive tanpa harus menyelam! Terowongan akrilik bawah air dengan ikan hiu, pari, dan ribuan ikan tropis adalah highlight utama. Pertunjukan feeding time menarik untuk disaksikan. Sering ada paket combo dengan Dufan yang lebih hemat.', '2026-04-18 13:00:00');

-- ============================================================
-- 6. FORUM TOPICS & REPLIES — DATA KOMUNITAS AKTIF
-- ============================================================

INSERT INTO `forum_topics` (`id`, `user_id`, `user_name`, `title`, `content`, `destination`, `travel_date`, `category`, `views`, `status`, `created_at`) VALUES
(3, 3,  'Ahmad Fauzi',       'Tips mendaki Gunung Merbabu via Selo untuk pemula',
 'Halo traveler! Saya baru saja pulang dari pendakian Merbabu via Jalur Selo dan ingin berbagi tips. (1) Registrasi online di SIMAKSI minimal 3 hari sebelum keberangkatan. (2) Bawa sleeping bag yang mampu menahan suhu -5°C. (3) Sumber air ada di Pos 2 jadi isi penuh botol. (4) Summit attack idealnya mulai pukul 02.00 pagi agar dapat sunrise. Ada yang mau tanya-tanya?',
 'Gunung Merbabu', '2026-03-15', 'Tips & Tricks', 320, 'open', '2026-03-16 07:00:00'),

(4, 4,  'Rina Kusuma',       'Review lengkap: Solo trip 5 hari Yogyakarta – Dieng – Semarang',
 'Baru selesai trip 5 hari dan mau sharing itinerary + budget! Hari 1-2: Yogyakarta (Prambanan, Malioboro, Benteng Vredeburg, Taman Sari) ~ Rp450rb/hari. Hari 3: Dieng (Gunung Prau sunrise, Telaga Warna, Kawah Sikidang) ~ Rp380rb. Hari 4: perjalanan ke Semarang via Wonosobo (Lawang Sewu, Kota Lama) ~ Rp350rb. Hari 5: Semarang explore + balik. Total sekitar Rp2,2 juta sudah termasuk transport, penginapan budget, dan makan. Ada yang mau rute ini?',
 'Yogyakarta', '2026-04-01', 'Itinerary', 587, 'open', '2026-04-06 09:00:00'),

(5, 11, 'Rizky Pratama',     'Persiapan fisik dan mental sebelum mendaki Carstensz Pyramid',
 'Carstensz bukan gunung biasa — ini rock climbing expedition! Setelah 2 tahun persiapan, saya akhirnya berhasil summit bulan Januari. Yang perlu dipersiapkan: (1) Latihan panjat tebing indoor minimal 6 bulan. (2) Latihan cardio intensif: lari, hiking beban, bersepeda. (3) Simulasi altitude sickness di gunung 3000+ mdpl. (4) Budget: siapkan 25–40 juta untuk paket all-in dengan operator resmi. (5) Izin dan akomodasi diurus operator. AMA!',
 'Carstensz Pyramid', '2026-01-20', 'Diskusi', 1250, 'open', '2026-01-31 10:00:00'),

(6, 6,  'Citra Dewi',        'Wisata budaya Tana Toraja: panduan lengkap dan etika berkunjung',
 'Toraja adalah destinasi budaya yang membutuhkan kepekaan dan etika khusus. Beberapa hal penting: (1) Selalu minta izin sebelum memotret upacara atau jenazah. (2) Kenakan pakaian yang sopan dan tidak mencolok. (3) Jika diundang ke Rambu Solo, bawalah gula atau kopi sebagai simbol penghormatan. (4) Gunakan pemandu lokal — ini cara terbaik mendukung ekonomi warga sekaligus mendapatkan penjelasan otentik. (5) Jangan pernah menyentuh tau-tau atau benda adat tanpa izin. Ada yang punya pengalaman khusus di Toraja?',
 'Tana Toraja', '2026-01-10', 'Tips & Tricks', 890, 'open', '2026-01-16 11:00:00'),

(7, 8,  'Sari Puspita',      'Pantai-pantai tersembunyi Gunungkidul yang masih sepi pengunjung',
 'Sebagai solo traveler yang sudah 4x ke Gunungkidul, saya mau sharing pantai-pantai hidden gem yang belum banyak di-explore: (1) Pantai Ngetun — laguna biru dengan tebing karst, snorkeling bagus. (2) Pantai Sedahan — sunset point terbaik, pasir putih lembut. (3) Pantai Greweng — akses trekking 45 menit tapi worth it, sangat sepi. (4) Pantai Timang — ikon gondola kayu dan kepiting lobster segar. Mana favorit kalian?',
 'Gunung Kidul', '2026-03-01', 'Rekomendasi', 445, 'open', '2026-03-10 14:00:00'),

(8, 14, 'Lina Marlina',      'Food trip Jakarta: kuliner khas Betawi yang mulai langka',
 'Sebagai Jakartian asli yang cinta kuliner, saya prihatin banyak kuliner Betawi otentik yang mulai sulit ditemukan. Berikut daftar yang HARUS dicoba sebelum benar-benar hilang: (1) Soto Tangkar di Pasar Senen (bumbu kuning khas). (2) Bir Pletok di warung-warung sekitar Condet. (3) Asinan Betawi di Bogor Street Food Jl. Dewi Sartika. (4) Kerak Telor — masih ada di Kota Tua weekend. (5) Laksa Betawi di Warung Laksa Ibu Haji Mansyur, Sawah Besar. Siapa yang masih ingat kuliner Betawi lain?',
 'Jakarta', '2026-02-20', 'Kuliner', 723, 'open', '2026-02-25 12:00:00'),

(9, 15, 'Bagas Wicaksono',   'Trip Bromo backpacker budget di bawah 500 ribu',
 'Sering lihat orang bilang Bromo mahal. Tapi ternyata bisa backpacker dengan budget ketat! Rute saya: (1) Naik bus malam Surabaya-Probolinggo (Rp60rb). (2) Angkot Probolinggo-Cemoro Lawang (Rp35rb). (3) Nginap di homestay bersama (Rp75rb/malam). (4) Jalan kaki ke lautan pasir (gratis, bukan naik jeep). (5) Sunrise dari Bukit Cinta yang gratisan (bukan Pananjakan berbayar). (6) Makan nasi + telur di warung sekitar (Rp20rb/porsi). Total: ±Rp350rb untuk 2D1N. Tips lengkap ada di thread ini!',
 'Gunung Bromo', '2026-02-10', 'Budget Travel', 2140, 'open', '2026-02-15 08:00:00'),

(10, 16,'Nina Setiawati',    'First solo trip ke Bali: itinerary 7 hari dengan budget 3 jutaan',
 'Baru pulang dari solo trip pertama ke Bali dan tidak menyesal sama sekali! Budget total Rp3,1 juta sudah termasuk tiket PP pesawat promo. Highlight: D1-D2 Ubud (Tegallalang, Monkey Forest, Kecak Uluwatu). D3-D4 Seminyak-Kuta (pantai, Pura Tanah Lot sunset). D5 Bedugul (Pura Ulun Danu, Kebun Raya). D6 Karangasem (Tirta Gangga, Besakih). D7 Pulang. Akomodasi: hostel dormitory rata-rata Rp90rb/malam. Transport: sewa motor Rp75rb/hari. DM kalau mau itinerary lengkap!',
 'Bali', '2026-04-10', 'Itinerary', 1830, 'open', '2026-04-18 15:00:00'),

(11, 5,  'Budi Santoso',     'Komunitas pendaki Yogyakarta: open rekrut member baru!',
 'Halo semua! Kami dari komunitas pendaki Jogja Mountain Community membuka rekrutmen anggota baru untuk periode Juni-Juli 2026. Program yang ada: (1) Pendakian rutin bulanan (Merbabu, Prau, Lawu, Sindoro). (2) Kelas survival dan navigasi peta kompas. (3) Training P3K untuk pendaki. (4) Program leave no trace dan bersih gunung. Biaya keanggotaan Rp150rb/tahun. Hubungi WA 0812-xxxx-xxxx atau DM di sini untuk daftar. Yuk berpetualang dengan aman dan bertanggung jawab!',
 'Yogyakarta', NULL, 'Komunitas', 560, 'open', '2026-05-01 10:00:00');

-- Forum Replies

INSERT INTO `forum_replies` (`id`, `topic_id`, `user_id`, `user_name`, `content`, `created_at`) VALUES
-- Reply untuk Tips Merbabu (topic 3)
(1, 3, 4,  'Rina Kusuma',    'Makasih banyak tipnya! Saya baru pertama kali mau ke Merbabu bulan depan via jalur yang sama. Pertanyaan: untuk sleeping bag -5°C, brand apa yang recommended dengan budget di bawah 500 ribu? Dan apakah perlu bawa nesting atau warung di base camp sudah cukup memadai?', '2026-03-17 08:00:00'),
(2, 3, 3,  'Ahmad Fauzi',    '@Rina: Untuk sleeping bag budget, Consina Cilo bisa jadi pilihan bagus di sekitar 350-400rb. Nesting tetap saran saya bawa karena masak sendiri jauh lebih hemat dan bebas. Di Pos 1 ada warung tapi tutup setelah jam 8 malam dan harganya lumayan mahal karena harus naik ke atas. Happy climbing!', '2026-03-17 09:30:00'),
(3, 3, 11, 'Rizky Pratama',  'Tambahan tips dari saya yang sudah 3x ke Merbabu: pakai trekking pole itu game changer terutama untuk turun. Lutut langsung jauh lebih aman. Dan bawa headlamp cadangan! Saya pernah kehabisan baterai pas summit attack, untung pinjam teman. Semangat untuk yang mau naik!', '2026-03-17 11:00:00'),
(4, 3, 9,  'Hendra Gunawan', 'Setuju sama tipsnya! Satu lagi yang sering dilupakan: acclimatize dulu kalau belum pernah di ketinggian. Saya dulu maksa naik langsung dari Surabaya dan kena AMS ringan di atas. Sekarang selalu tidur semalam dulu di Selo sebelum naik. Badan jadi jauh lebih siap.', '2026-03-18 07:00:00'),

-- Reply untuk Review Yogyakarta-Dieng-Semarang (topic 4)
(5, 4, 7,  'Dedi Hermawan',  'Wahh itinerary yang sangat solid! Mau tanya, untuk transport Dieng ke Semarang naik apa? Dan penginapan di Dieng rekomendasinya mana? Saya mau modifikasi itinerary ini jadi 7 hari dengan tambahan Magelang (Borobudur) di tengah-tengahnya.', '2026-04-07 10:00:00'),
(6, 4, 4,  'Rina Kusuma',    '@Dedi: Transport Dieng ke Semarang bisa naik travel langsung sekitar Rp80-100rb, pesan H-1. Untuk penginapan di Dieng, saya rekomen Losmen Gunung Mas — murah, bersih, pemiliknya sangat ramah dan bisa bantu atur jeep ke Prau. Ide tambah Borobudur bagus banget, tinggal tambah semalam di Magelang!', '2026-04-07 12:00:00'),
(7, 4, 17, 'Eko Prasetyo',   'Rute yang hampir sama pernah saya lakukan! Tips tambahan: kalau mau hemat di Yogya, manfaatkan Trans Jogja dan jalan kaki. Malioboro ke Taman Sari cuma 15 menit jalan kaki. Makan di warung Nasi Kucing di ring road lebih murah tapi kualitasnya tidak jauh beda dengan yang di pusat kota.', '2026-04-08 08:00:00'),

-- Reply untuk Tips Carstensz (topic 5)
(8, 5, 15, 'Bagas Wicaksono', 'Keren banget pengalamannya Mas Rizky! Saya mimpi ke Carstensz tapi belum berani. Pertanyaan: operator yang terpercaya dan legal mana yang Mas Rizky rekomendasikan? Dan apa bisa pakai asuransi perjalanan biasa atau harus yang spesifik mountaineering?', '2026-02-01 11:00:00'),
(9, 5, 11, 'Rizky Pratama',   '@Bagas: Operator yang saya pakai adalah PT Rimba Raya Adventure — sangat profesional dan semua izinnya beres. Untuk asuransi, wajib pakai yang cover mountaineering dan helicopter rescue, asuransi biasa tidak akan cover. Pastikan baca polis dengan teliti. Budget tambahan 3-5 juta untuk asuransi khusus ini.', '2026-02-01 14:00:00'),
(10, 5, 3, 'Ahmad Fauzi',     'Luar biasa pencapaiannya! Sebagai sesama pendaki, saya sangat menghormati perjuangan dan persiapan panjang yang dibutuhkan. Semoga ceritanya menginspirasi lebih banyak pendaki Indonesia untuk bermimpi besar. Indonesia punya gunung-gunung terhebat di dunia!', '2026-02-02 07:00:00'),

-- Reply untuk Budget Bromo (topic 9) — paling populer
(11, 9, 4,  'Rina Kusuma',    'OMG tips ini yang saya cari selama ini!! Selama ini saya pikir Bromo itu minimal 1,5-2 juta. Ternyata bisa se-efisien itu! Pertanyaan: untuk jalan kaki ke lautan pasir, seberapa jauh dari Cemoro Lawang? Dan apa aman jalan sendiri tanpa guide?', '2026-02-15 09:00:00'),
(12, 9, 15, 'Bagas Wicaksono', '@Rina: Dari Cemoro Lawang ke kaki Gunung Bromo jalan kaki sekitar 3km melewati lautan pasir. Sangat aman selama siang/sore hari karena jalurnya jelas. Kalau pagi buta (untuk sunrise) memang agak tricky navigasinya kalau belum pernah, tapi bisa ikuti rombongan pendaki lain yang juga berjalan kaki. Bawa headlamp dan jacket tebal!', '2026-02-15 10:00:00'),
(13, 9, 17, 'Eko Prasetyo',   'Tambahan: warung di Cemoro Lawang buka 24 jam untuk yang datang pagi buta. Nasi + mie goreng + teh panas sekitar 25-30rb. Untuk yang mau lebih hemat lagi, bawa bekal dari bawah atau masak sendiri kalau bawa kompor. Total bisa turun ke 250rb bahkan untuk 2D1N!', '2026-02-16 06:00:00'),
(14, 9, 8,  'Sari Puspita',   'Info sangat bermanfaat! Satu tips tambahan: kalau naik bus malam dari Surabaya, minta turun di Terminal Bayuangga Probolinggo (bukan terminal lama). Dari sana angkot ke Cemoro Lawang lebih mudah dan langsung. Pastikan negosiasi harga angkot dulu, jangan mau kemahalan karena kelihatan turis.', '2026-02-16 08:30:00'),

-- Reply untuk Solo Trip Bali (topic 10)
(15, 10,6,  'Citra Dewi',     'Itinerary yang sangat komprehensif! Untuk Kecak di Uluwatu, pastikan beli tiket langsung di loket (150rb) dan jangan mau dibeli calo di luar yang harganya bisa 2-3x lipat. Posisi duduk terbaik adalah di sisi kiri menghadap tebing untuk view sunset yang sempurna. Enjoy Bali!', '2026-04-19 10:00:00'),
(16, 10,10, 'Maya Rahayu',    'Wah budget 3 jutaan PP untuk 7 hari itu efisien banget! Boleh minta rekomen hostel di Ubud yang bagusan? Saya juga mau solo trip ke Bali bulan depan, pertama kali dan agak nervous hehe. Terima kasih sudah share!', '2026-04-19 12:00:00'),
(17, 10,16, 'Nina Setiawati', '@Maya: Jangan nervous! Bali sangat ramah untuk solo traveler terutama perempuan. Hostel yang saya rekomen di Ubud: Alaya Hostel (bersih, sosial, ada rooftop), sekitar 90-110rb/malam dormitory. Minta kamar yang jauh dari jalan raya kalau mau lebih tenang tidurnya. DM saya kalau mau detail lebih lengkap!', '2026-04-19 14:00:00'),

-- Reply untuk Komunitas Pendaki Jogja (topic 11)
(18, 11,9,  'Hendra Gunawan', 'Tertarik join! Sudah lama cari komunitas pendaki Jogja yang serius dan ada program edukasi kayak gini. Saya di Sleman. Bisa hubungi WA yang mana ya untuk registrasi?', '2026-05-02 08:00:00'),
(19, 11,4,  'Rina Kusuma',    'Program leave no trace-nya yang bikin saya tertarik! Sudah terlalu sering lihat sampah di jalur pendakian dan itu menyedihkan. Komunitas yang aktif bantu jaga kelestarian gunung sangat dibutuhkan. Daftar ah!', '2026-05-02 10:00:00'),
(20, 11,13, 'Reza Mahendra',  'Saya photographer dan sering ikut pendakian untuk keperluan dokumentasi. Komunitas kalian terbuka untuk anggota dengan keahlian khusus seperti photography/videography? Saya bisa bantu dokumentasi kegiatan komunitas secara sukarela.', '2026-05-03 09:00:00');

-- ============================================================
-- 7. LEADERBOARD TRAVELER — USER_BADGES & REVIEW COUNT UPDATE
-- ============================================================

-- Update AUTO_INCREMENT users agar aman
ALTER TABLE `users` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

-- Assign badges berdasarkan aktivitas review
-- Ahmad Fauzi (id=3): 3 reviews → Tourist (badge 1)
INSERT INTO `user_badges` (`user_id`, `badge_id`, `earned_at`) VALUES
(3, 1, '2026-03-16 07:00:00');

-- Rina Kusuma (id=4): 5 reviews → Backpacker (badge 2)
INSERT INTO `user_badges` (`user_id`, `badge_id`, `earned_at`) VALUES
(4, 1, '2026-02-11 06:00:00'),
(4, 2, '2026-04-07 09:00:00');

-- Budi Santoso (id=5): 3 reviews → Tourist (badge 1)
INSERT INTO `user_badges` (`user_id`, `badge_id`, `earned_at`) VALUES
(5, 1, '2026-01-21 07:00:00');

-- Citra Dewi (id=6): 5 reviews → Backpacker (badge 2)
INSERT INTO `user_badges` (`user_id`, `badge_id`, `earned_at`) VALUES
(6, 1, '2025-12-11 16:00:00'),
(6, 2, '2026-02-26 10:00:00');

-- Dedi Hermawan (id=7): 4 reviews → Tourist (badge 1)
INSERT INTO `user_badges` (`user_id`, `badge_id`, `earned_at`) VALUES
(7, 1, '2025-12-11 16:00:00');

-- Sari Puspita (id=8): 4 reviews → Tourist (badge 1)
INSERT INTO `user_badges` (`user_id`, `badge_id`, `earned_at`) VALUES
(8, 1, '2026-02-28 10:00:00');

-- Hendra Gunawan (id=9): 3 reviews → Tourist (badge 1)
INSERT INTO `user_badges` (`user_id`, `badge_id`, `earned_at`) VALUES
(9, 1, '2026-01-23 10:00:00');

-- Maya Rahayu (id=10): 4 reviews → Tourist (badge 1)
INSERT INTO `user_badges` (`user_id`, `badge_id`, `earned_at`) VALUES
(10, 1, '2026-01-11 15:00:00');

-- Rizky Pratama (id=11): 4 reviews → Tourist → Backpacker
INSERT INTO `user_badges` (`user_id`, `badge_id`, `earned_at`) VALUES
(11, 1, '2026-01-31 15:00:00'),
(11, 2, '2026-04-21 08:00:00');

-- Fitri Handayani (id=12): 5 reviews → Backpacker
INSERT INTO `user_badges` (`user_id`, `badge_id`, `earned_at`) VALUES
(12, 1, '2026-01-06 06:00:00'),
(12, 2, '2026-03-03 11:00:00');

-- Reza Mahendra (id=13): 3 reviews → Tourist
INSERT INTO `user_badges` (`user_id`, `badge_id`, `earned_at`) VALUES
(13, 1, '2026-01-19 20:00:00');

-- Lina Marlina (id=14): 6 reviews → Backpacker
INSERT INTO `user_badges` (`user_id`, `badge_id`, `earned_at`) VALUES
(14, 1, '2026-01-29 13:00:00'),
(14, 2, '2026-02-19 11:00:00');

-- Bagas Wicaksono (id=15): 4 reviews → Tourist
INSERT INTO `user_badges` (`user_id`, `badge_id`, `earned_at`) VALUES
(15, 1, '2025-12-11 07:00:00');

-- Nina Setiawati (id=16): 3 reviews → Tourist
INSERT INTO `user_badges` (`user_id`, `badge_id`, `earned_at`) VALUES
(16, 1, '2026-02-15 09:00:00');

-- Eko Prasetyo (id=17): 3 reviews → Tourist
INSERT INTO `user_badges` (`user_id`, `badge_id`, `earned_at`) VALUES
(17, 1, '2026-03-02 09:00:00');

-- ============================================================
-- 8. VIEW LEADERBOARD (opsional: bisa dipakai sebagai query)
-- ============================================================
-- Contoh query leaderboard yang bisa dipanggil dari aplikasi:
-- SELECT u.id, u.full_name, u.username,
--        COUNT(r.id) AS total_reviews,
--        b.name AS badge_name, b.icon AS badge_icon
-- FROM users u
-- LEFT JOIN reviews r ON r.user_id = u.id
-- LEFT JOIN user_badges ub ON ub.user_id = u.id
-- LEFT JOIN badges b ON b.id = ub.badge_id
-- WHERE u.role = 'user'
-- GROUP BY u.id
-- ORDER BY total_reviews DESC
-- LIMIT 10;

-- ============================================================
-- UPDATE AUTO_INCREMENT
-- ============================================================
ALTER TABLE `reviews` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;
ALTER TABLE `forum_topics` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
ALTER TABLE `forum_replies` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
ALTER TABLE `user_badges` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

COMMIT;
-- ============================================================
-- END OF PATCH
-- ============================================================
