-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 19, 2026 at 06:55 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `viuspot`
--

-- --------------------------------------------------------

--
-- Table structure for table `badges`
--

CREATE TABLE `badges` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `min_reviews` int(11) NOT NULL,
  `icon` varchar(50) DEFAULT 'award'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `badges`
--

INSERT INTO `badges` (`id`, `name`, `description`, `min_reviews`, `icon`) VALUES
(1, 'Tourist', 'Pengguna baru yang mulai menjelajah', 1, 'user'),
(2, 'Backpacker', 'Traveler aktif dengan 5+ ulasan', 5, 'backpack'),
(3, 'Wanderer', 'Penjelajah dengan 15+ ulasan', 15, 'compass'),
(4, 'Explorer', 'Petualang berpengalaman dengan 45+ ulasan', 45, 'map'),
(5, 'Explorer Legend', 'Legenda wisata Indonesia dengan 80+ ulasan', 80, 'crown');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `slug` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `icon` varchar(50) DEFAULT 'map-pin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `icon`) VALUES
(1, 'Nature', 'nature', 'Keindahan alam Indonesia dari pegunungan hingga pantai', 'mountain'),
(2, 'Culture', 'culture', 'Warisan budaya dan tradisi masyarakat Indonesia', 'users'),
(3, 'History', 'history', 'Situs bersejarah dan cagar budaya nasional', 'landmark'),
(4, 'Religious', 'religious', 'Tempat ibadah dan wisata rohani', 'heart'),
(5, 'Culinary', 'culinary', 'Surga kuliner dan wisata makanan khas', 'utensils'),
(6, 'Entertainment', 'entertainment', 'Taman hiburan dan tempat rekreasi modern', 'smile'),
(7, 'Education', 'education', 'Museum dan tempat wisata edukasi', 'book'),
(8, 'Shopping', 'shopping', 'Pusat perbelanjaan dan pasar tradisional', 'shopping-bag');

-- --------------------------------------------------------

--
-- Table structure for table `crowd_reports`
--

CREATE TABLE `crowd_reports` (
  `id` int(11) NOT NULL,
  `place_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(100) NOT NULL,
  `crowd_level` enum('low','moderate','high','very_high') NOT NULL,
  `wait_time` int(11) DEFAULT 0,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `crowd_reports`
--

INSERT INTO `crowd_reports` (`id`, `place_id`, `user_id`, `user_name`, `crowd_level`, `wait_time`, `notes`, `created_at`) VALUES
(1, 5, NULL, 'Bromo Hunter', 'high', 90, 'Antrean jeep sangat panjang pagi ini. Saran datang lebih awal.', '2026-05-07 06:59:45'),
(2, 11, NULL, 'Heritage Lover', 'moderate', 15, 'Tiket masuk lancar. Area candi cukup ramai tapi nyaman.', '2026-05-07 06:59:45'),
(3, 3, 1, '', 'high', 40, '', '2026-05-08 06:03:07');

-- --------------------------------------------------------

--
-- Table structure for table `forum_replies`
--

CREATE TABLE `forum_replies` (
  `id` int(11) NOT NULL,
  `topic_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `parent_reply_id` int(11) DEFAULT NULL,
  `upvotes` int(11) DEFAULT 0,
  `downvotes` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `forum_replies`
--

INSERT INTO `forum_replies` (`id`, `topic_id`, `user_id`, `user_name`, `content`, `created_at`, `parent_reply_id`, `upvotes`, `downvotes`) VALUES
(1, 3, 4, 'Rina Kusuma', 'Makasih banyak tipnya! Saya baru pertama kali mau ke Merbabu bulan depan via jalur yang sama. Pertanyaan: untuk sleeping bag -5°C, brand apa yang recommended dengan budget di bawah 500 ribu? Dan apakah perlu bawa nesting atau warung di base camp sudah cukup memadai?', '2026-03-17 08:00:00', NULL, 12, 0),
(2, 3, 3, 'Ahmad Fauzi', '@Rina: Untuk sleeping bag budget, Consina Cilo bisa jadi pilihan bagus di sekitar 350-400rb. Nesting tetap saran saya bawa karena masak sendiri jauh lebih hemat dan bebas. Di Pos 1 ada warung tapi tutup setelah jam 8 malam dan harganya lumayan mahal karena harus naik ke atas. Happy climbing!', '2026-03-17 09:30:00', NULL, 34, 1),
(3, 3, 11, 'Rizky Pratama', 'Tambahan tips dari saya yang sudah 3x ke Merbabu: pakai trekking pole itu game changer terutama untuk turun. Lutut langsung jauh lebih aman. Dan bawa headlamp cadangan! Saya pernah kehabisan baterai pas summit attack, untung pinjam teman. Semangat untuk yang mau naik!', '2026-03-17 11:00:00', NULL, 28, 0),
(4, 3, 9, 'Hendra Gunawan', 'Setuju sama tipsnya! Satu lagi yang sering dilupakan: acclimatize dulu kalau belum pernah di ketinggian. Saya dulu maksa naik langsung dari Surabaya dan kena AMS ringan di atas. Sekarang selalu tidur semalam dulu di Selo sebelum naik. Badan jadi jauh lebih siap.', '2026-03-18 07:00:00', NULL, 41, 0),
(5, 4, 7, 'Dedi Hermawan', 'Wahh itinerary yang sangat solid! Mau tanya, untuk transport Dieng ke Semarang naik apa? Dan penginapan di Dieng rekomendasinya mana? Saya mau modifikasi itinerary ini jadi 7 hari dengan tambahan Magelang (Borobudur) di tengah-tengahnya.', '2026-04-07 10:00:00', NULL, 15, 0),
(6, 4, 4, 'Rina Kusuma', '@Dedi: Transport Dieng ke Semarang bisa naik travel langsung sekitar Rp80-100rb, pesan H-1. Untuk penginapan di Dieng, saya rekomen Losmen Gunung Mas — murah, bersih, pemiliknya sangat ramah dan bisa bantu atur jeep ke Prau. Ide tambah Borobudur bagus banget, tinggal tambah semalam di Magelang!', '2026-04-07 12:00:00', NULL, 53, 1),
(7, 4, 17, 'Eko Prasetyo', 'Rute yang hampir sama pernah saya lakukan! Tips tambahan: kalau mau hemat di Yogya, manfaatkan Trans Jogja dan jalan kaki. Malioboro ke Taman Sari cuma 15 menit jalan kaki. Makan di warung Nasi Kucing di ring road lebih murah tapi kualitasnya tidak jauh beda dengan yang di pusat kota.', '2026-04-08 08:00:00', NULL, 38, 0),
(8, 5, 15, 'Bagas Wicaksono', 'Keren banget pengalamannya Mas Rizky! Saya mimpi ke Carstensz tapi belum berani. Pertanyaan: operator yang terpercaya dan legal mana yang Mas Rizky rekomendasikan? Dan apa bisa pakai asuransi perjalanan biasa atau harus yang spesifik mountaineering?', '2026-02-01 11:00:00', NULL, 47, 0),
(9, 5, 11, 'Rizky Pratama', '@Bagas: Operator yang saya pakai adalah PT Rimba Raya Adventure — sangat profesional dan semua izinnya beres. Untuk asuransi, wajib pakai yang cover mountaineering dan helicopter rescue, asuransi biasa tidak akan cover. Pastikan baca polis dengan teliti. Budget tambahan 3-5 juta untuk asuransi khusus ini.', '2026-02-01 14:00:00', NULL, 112, 2),
(10, 5, 3, 'Ahmad Fauzi', 'Luar biasa pencapaiannya! Sebagai sesama pendaki, saya sangat menghormati perjuangan dan persiapan panjang yang dibutuhkan. Semoga ceritanya menginspirasi lebih banyak pendaki Indonesia untuk bermimpi besar. Indonesia punya gunung-gunung terhebat di dunia!', '2026-02-02 07:00:00', NULL, 76, 0),
(11, 9, 4, 'Rina Kusuma', 'OMG tips ini yang saya cari selama ini!! Selama ini saya pikir Bromo itu minimal 1,5-2 juta. Ternyata bisa se-efisien itu! Pertanyaan: untuk jalan kaki ke lautan pasir, seberapa jauh dari Cemoro Lawang? Dan apa aman jalan sendiri tanpa guide?', '2026-02-15 09:00:00', NULL, 38, 0),
(12, 9, 15, 'Bagas Wicaksono', '@Rina: Dari Cemoro Lawang ke kaki Gunung Bromo jalan kaki sekitar 3km melewati lautan pasir. Sangat aman selama siang/sore hari karena jalurnya jelas. Kalau pagi buta (untuk sunrise) memang agak tricky navigasinya kalau belum pernah, tapi bisa ikuti rombongan pendaki lain yang juga berjalan kaki. Bawa headlamp dan jacket tebal!', '2026-02-15 10:00:00', NULL, 95, 1),
(13, 9, 17, 'Eko Prasetyo', 'Tambahan: warung di Cemoro Lawang buka 24 jam untuk yang datang pagi buta. Nasi + mie goreng + teh panas sekitar 25-30rb. Untuk yang mau lebih hemat lagi, bawa bekal dari bawah atau masak sendiri kalau bawa kompor. Total bisa turun ke 250rb bahkan untuk 2D1N!', '2026-02-16 06:00:00', NULL, 88, 0),
(14, 9, 8, 'Sari Puspita', 'Info sangat bermanfaat! Satu tips tambahan: kalau naik bus malam dari Surabaya, minta turun di Terminal Bayuangga Probolinggo (bukan terminal lama). Dari sana angkot ke Cemoro Lawang lebih mudah dan langsung. Pastikan negosiasi harga angkot dulu, jangan mau kemahalan karena kelihatan turis.', '2026-02-16 08:30:00', NULL, 72, 0),
(15, 10, 6, 'Citra Dewi', 'Itinerary yang sangat komprehensif! Untuk Kecak di Uluwatu, pastikan beli tiket langsung di loket (150rb) dan jangan mau dibeli calo di luar yang harganya bisa 2-3x lipat. Posisi duduk terbaik adalah di sisi kiri menghadap tebing untuk view sunset yang sempurna. Enjoy Bali!', '2026-04-19 10:00:00', NULL, 64, 0),
(16, 10, 10, 'Maya Rahayu', 'Wah budget 3 jutaan PP untuk 7 hari itu efisien banget! Boleh minta rekomen hostel di Ubud yang bagusan? Saya juga mau solo trip ke Bali bulan depan, pertama kali dan agak nervous hehe. Terima kasih sudah share!', '2026-04-19 12:00:00', NULL, 22, 0),
(17, 10, 16, 'Nina Setiawati', '@Maya: Jangan nervous! Bali sangat ramah untuk solo traveler terutama perempuan. Hostel yang saya rekomen di Ubud: Alaya Hostel (bersih, sosial, ada rooftop), sekitar 90-110rb/malam dormitory. Minta kamar yang jauh dari jalan raya kalau mau lebih tenang tidurnya. DM saya kalau mau detail lebih lengkap!', '2026-04-19 14:00:00', NULL, 89, 1),
(18, 11, 9, 'Hendra Gunawan', 'Tertarik join! Sudah lama cari komunitas pendaki Jogja yang serius dan ada program edukasi kayak gini. Saya di Sleman. Bisa hubungi WA yang mana ya untuk registrasi?', '2026-05-02 08:00:00', NULL, 8, 0),
(19, 11, 4, 'Rina Kusuma', 'Program leave no trace-nya yang bikin saya tertarik! Sudah terlalu sering lihat sampah di jalur pendakian dan itu menyedihkan. Komunitas yang aktif bantu jaga kelestarian gunung sangat dibutuhkan. Daftar ah!', '2026-05-02 10:00:00', NULL, 14, 0),
(20, 11, 13, 'Reza Mahendra', 'Saya photographer dan sering ikut pendakian untuk keperluan dokumentasi. Komunitas kalian terbuka untuk anggota dengan keahlian khusus seperti photography/videography? Saya bisa bantu dokumentasi kegiatan komunitas secara sukarela.', '2026-05-03 09:00:00', NULL, 31, 0),
(21, 3, 4, 'Rina Kusuma', '@Ahmad oke makasih banget! Satu lagi, apakah jalur Selo ada batas jam masuk? Saya rencana berangkat dari Yogya jam 22.00 naik bus, kira-kira tiba di basecamp sekitar jam 02.00 dini hari.', '2026-03-17 10:00:00', 2, 19, 0),
(22, 3, 3, 'Ahmad Fauzi', '@Rina: Basecamp Selo buka 24 jam dan bisa registrasi kapan saja. Tiba jam 02.00 pas banget untuk istirahat 1-2 jam, summit attack jam 03.30-04.00, sampai puncak sekitar jam 07.00 dapat sunrise yang indah. Jangan lupa cek cuaca H-1 via BMKG!', '2026-03-17 10:45:00', 21, 55, 0),
(23, 3, 9, 'Hendra Gunawan', '@Rizky setuju banget soal trekking pole! Brand apa yang kamu pakai? Saya pakai Eiger tapi sering goyah di medan berbatu. Ada rekomendasi yang lebih stabil di kisaran 300-500 ribu?', '2026-03-18 06:00:00', 3, 17, 0),
(24, 3, 11, 'Rizky Pratama', '@Hendra: Saya pakai Black Diamond Trail yang emang agak mahal, tapi untuk budget 300-500 ribu coba Consina Trekforce — aluminium, lumayan rigid. Beli di toko outdoor Malioboro banyak pilihan. Yang penting jangan beli yang full plastik, pasti memble di tanjakan curam.', '2026-03-18 08:30:00', 23, 44, 1),
(25, 4, 16, 'Nina Setiawati', '@Dedi: Kalau mau tambah Borobudur, saran saya masukkan di hari ke-2 atau ke-3 setelah dari Yogya sebelum lanjut ke Dieng. Rute Yogya → Borobudur → Magelang → Wonosobo (Dieng) itu satu jalur lurus, tidak perlu balik ke Yogya dulu. Hemat waktu dan ongkos!', '2026-04-07 14:00:00', 5, 67, 0),
(26, 4, 7, 'Dedi Hermawan', '@Nina: Wah ini tips emas! Saya belum kepikiran rute lurus itu. Berarti dari Borobudur ke Magelang kota sekitar 1 jam ya? Ada penginapan budget yang recommended di Magelang buat 1 malam sebelum ke Dieng?', '2026-04-07 16:00:00', 25, 23, 0),
(27, 4, 16, 'Nina Setiawati', '@Dedi: Iya sekitar 45 menit dari Borobudur ke pusat Magelang. Untuk penginapan budget coba Guest House Tidar, sekitar 120-150rb/malam, bersih dan pemiliknya ramah. Lokasinya strategis dekat alun-alun Magelang.', '2026-04-07 18:00:00', 26, 38, 0),
(28, 5, 3, 'Ahmad Fauzi', '@Rizky: Untuk izin dari Kementerian Lingkungan Hidup, berapa lama biasanya prosesnya? Dan apakah warga negara asing juga bisa ikut satu tim atau ada batasan kuota tertentu?', '2026-02-02 08:00:00', 9, 28, 0),
(29, 5, 11, 'Rizky Pratama', '@Ahmad: Proses izin biasanya 2-4 minggu via operator resmi, mereka yang urus semua. WNA boleh ikut tapi ada biaya permit tambahan dan wajib dalam tim mixed dengan minimal 1 pendaki WNI. Kuota maksimal 6 orang per tim per periode pendakian untuk menjaga kelestarian jalur.', '2026-02-02 10:00:00', 28, 89, 0),
(30, 5, 15, 'Bagas Wicaksono', '@Rizky: Terima kasih info operatornya! Satu lagi — untuk standar fisik minimum, apakah ada tes atau sertifikasi yang perlu dipenuhi sebelum operator mau terima kita? Saya sudah bisa lead climbing 5c, apakah itu cukup?', '2026-02-03 09:00:00', 8, 35, 0),
(31, 5, 11, 'Rizky Pratama', '@Bagas: Lead 5c sudah oke sebagai dasar tapi Carstensz butuh minimal 6a+ karena ada beberapa pitch basah dan licin. Operator biasanya lakukan seleksi wawancara + cek portofolio pendakian sebelumnya. Paling penting: rekam jejak mendaki gunung 3000+ mdpl minimal 5 kali dalam 2 tahun terakhir.', '2026-02-03 11:00:00', 30, 104, 1),
(32, 9, 16, 'Nina Setiawati', '@Rina: Saya juga pernah jalan kaki dan ternyata asyik banget! Sambil jalan kaki kamu bisa lebih menikmati suasana lautan pasir, foto-foto tanpa buru-buru kejar jeep. Bawa buff/masker ya karena debu pasirnya lumayan kencang kalau angin bertiup.', '2026-02-15 11:00:00', 11, 43, 0),
(33, 9, 4, 'Rina Kusuma', '@Nina: Noted soal buff/masker! Kalau dari Cemoro Lawang ke kawah itu elevasi naik berapa meter kira-kira? Saya agak khawatir soal altitude sickness karena belum pernah di atas 2000 mdpl sebelumnya.', '2026-02-15 12:30:00', 32, 19, 0),
(34, 9, 15, 'Bagas Wicaksono', '@Rina: Cemoro Lawang sekitar 2200 mdpl, kawah Bromo sekitar 2329 mdpl — jadi bedanya hanya 130 meter dan jalannya relatif datar melintasi lautan pasir. Risiko AMS sangat rendah untuk ketinggian segitu. Yang lebih perlu diwaspadai adalah suhu dingin (bisa 5-10°C subuh) dan debu vulkanik sulfur.', '2026-02-15 13:00:00', 33, 76, 0),
(35, 9, 17, 'Eko Prasetyo', '@Bagas dan semua: tambahan penting — hindari datang saat musim Yadnya Kasada (biasanya Juli-Agustus, cek kalender Tengger). Saat itu kawah ditutup total dan lautan pasir penuh sesak. Tapi kalau mau lihat upacara melempar sesaji ke kawah, justru itu momen budaya yang luar biasa langka!', '2026-02-16 10:00:00', 13, 58, 0),
(36, 9, 8, 'Sari Puspita', '@Eko: Pernah tidak sengaja ke Bromo saat Yadnya Kasada dan itu justru jadi pengalaman paling berkesan! Ribuan warga Tengger berbaju adat beriringan naik ke kawah. Memang tidak bisa masuk kawah tapi momen kulturalnya jauh lebih berharga. Sangat recommend kalau waktunya pas!', '2026-02-16 14:00:00', 35, 91, 0),
(37, 10, 10, 'Maya Rahayu', '@Nina: Terima kasih banyak! Satu yang saya agak khawatirkan sebagai solo traveler perempuan — apakah aman keliling Ubud sendiri malam hari? Dan untuk sewa motor, apakah aman tanpa SIM internasional?', '2026-04-19 13:00:00', 16, 27, 0),
(38, 10, 16, 'Nina Setiawati', '@Maya: Ubud malam hari sangat aman untuk perempuan solo, bahkan banyak solo traveler perempuan yang keliling sendiri. Tetap ikuti common sense: hindari gang gelap dan jangan pulang terlalu larut. Soal SIM — secara hukum butuh SIM internasional tapi praktiknya jarang diperiksa. Lebih aman pakai ojek atau sewa driver harian ~250rb yang jauh lebih praktis.', '2026-04-19 15:30:00', 37, 114, 2),
(39, 10, 6, 'Citra Dewi', '@Nina: Setuju soal driver harian! Saya selalu pakai Pak Wayan via platform Airbnb Experience, harganya 280rb untuk 10 jam dan dia hafal semua spot off-the-beaten-path yang tidak ada di Google Maps. Sangat worth it dan lebih hemat kalau dihitung ongkos + waktu dibanding naik motor sendiri yang tidak tahu jalan.', '2026-04-19 17:00:00', 38, 87, 0),
(40, 6, 17, 'Eko Prasetyo', 'Panduan yang sangat lengkap dan respectful! Pertanyaan: kapan waktu terbaik untuk datang ke Toraja agar kemungkinan menyaksikan Rambu Solo paling besar? Apakah ada kalender festival yang bisa diikuti?', '2026-01-17 08:00:00', NULL, 34, 0),
(41, 6, 6, 'Citra Dewi', '@Eko: Rambu Solo paling banyak diselenggarakan pada musim kemarau (Juli-September) karena keluarga yang ditinggalkan biasanya menabung dulu bertahun-tahun. Festival Lovely December juga bagus untuk melihat banyak aktivitas budaya sekaligus. Hubungi Dinas Pariwisata Toraja Utara untuk jadwal upacara — mereka sering update di akun Instagram resminya.', '2026-01-17 10:00:00', 40, 67, 0),
(42, 6, 10, 'Maya Rahayu', '@Citra dan Eko: Mau ikut diskusi — untuk budget realistis mengunjungi Toraja 4 hari 3 malam, kira-kira berapa all-in dari Makassar? Termasuk transport, penginapan, makan, dan guide lokal.', '2026-01-18 09:00:00', 40, 28, 0),
(43, 6, 6, 'Citra Dewi', '@Maya: Estimasi dari Makassar 4D3N: Bus Makassar-Rantepao PP ~Rp300rb, penginapan guesthouse ~Rp150rb/malam, makan ~Rp80rb/hari, guide ~Rp400rb/hari (bisa split sama traveler lain), tiket masuk situs ~Rp200rb total. Gross sekitar Rp2,5-3 juta tergantung gaya perjalanan. Ikut open trip bisa lebih hemat lagi sekitar 1,8-2 juta semua termasuk.', '2026-01-18 11:30:00', 42, 93, 0),
(44, 7, 3, 'Ahmad Fauzi', 'Pantai Greweng yang disebutkan itu menarik banget! Trekking 45 menit dari mana persisnya? Apakah butuh guide atau jalurnya cukup jelas? Dan ada tidak titik snorkeling yang bagus di sekitar sana?', '2026-03-11 08:00:00', NULL, 22, 0),
(45, 7, 8, 'Sari Puspita', '@Ahmad: Trekking mulai dari Pantai Jungwok, ikuti jalan setapak ke arah timur sepanjang tebing, jalurnya cukup jelas dengan penanda batu. Tidak perlu guide tapi disarankan jangan solo karena sinyal HP mati total. Spot snorkeling terbaik di sisi kanan pantai dekat batu besar — koralnya masih virgin dan ikannya banyak banget!', '2026-03-11 10:00:00', 44, 56, 0),
(46, 7, 16, 'Nina Setiawati', 'Yang paling bikin penasaran adalah Pantai Timang dengan gondolanya! Gondola kayunya itu aman tidak sih? Saya punya fobia ketinggian ringan tapi pengen banget ke sana. Ada pengalaman yang mau share?', '2026-03-12 09:00:00', NULL, 19, 0),
(47, 7, 8, 'Sari Puspita', '@Nina: Gondola Timang itu sebenernya sangat aman meski terlihat mengerikan — sudah dioperasikan nelayan selama bertahun-tahun dan dirawat rutin. Tapi kalau fobia ketinggian, pertimbangkan matang-matang karena gondola menggantung di atas lautan bergelombang dengan jarak cukup tinggi. Alternatif: nikmati saja dari tepi — view kepiting lobster di bawah sudah luar biasa!', '2026-03-12 11:00:00', 46, 72, 0),
(48, 8, 17, 'Eko Prasetyo', 'Sebagai orang Bandung yang sering ke Jakarta, saya selalu bingung bedain Asinan Jakarta vs Asinan Bogor. Kalau yang versi Betawi asli itu seperti apa? Bumbu dan isiannya berbeda tidak?', '2026-02-26 09:00:00', NULL, 31, 0),
(49, 8, 14, 'Lina Marlina', '@Eko: Asinan Betawi kuahnya lebih ringan dan segar, dominan cuka dan gula aren, isian sayuran segar (taoge, kol, selada, timun) dengan tambahan tahu goreng dan kerupuk mi kuning. Berbeda dengan Asinan Bogor yang buahnya dominan dan kuahnya lebih kental. Kalau mau yang asli coba di warung Asinan Gang Sentiong, Sawah Besar — sudah buka sejak 1950-an!', '2026-02-26 11:00:00', 48, 88, 0),
(50, 8, 3, 'Ahmad Fauzi', 'Mau nambahin: Kerak Telor sekarang sudah ada yang permanen di luar area Kota Tua, tepatnya di Kawasan Glodok dan juga di Food Festival Ancol yang tiap weekend. Jadi tidak perlu nunggu acara khusus. Yang paling autentik masih yang pakai Anglo (anglo batok kelapa) bukan kompor gas — bisa dibedakan dari aroma asap bakarannya.', '2026-02-27 08:00:00', NULL, 62, 0),
(51, 8, 14, 'Lina Marlina', '@Ahmad: Info yang sangat bermanfaat! Satu hal yang biasanya tidak disebutkan — saat pesan Kerak Telor minta \"dengan kelapa parut lebih banyak\" karena biasanya agak dihemat untuk mempercepat produksi. Dan jangan minta dibalik terlalu sering, biarkan bagian bawahnya gosong tipis karena itu justru yang bikin nikmat. Selamat culinary hunting!', '2026-02-27 10:00:00', 50, 54, 0),
(52, 11, NULL, 'hhwb', 'anjayy', '2026-05-19 04:20:51', 18, 0, 0),
(53, 1, NULL, 'bubu', 'anjayy', '2026-05-19 04:21:10', NULL, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `forum_topics`
--

CREATE TABLE `forum_topics` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(100) NOT NULL,
  `title` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `destination` varchar(100) DEFAULT NULL,
  `travel_date` date DEFAULT NULL,
  `category` varchar(50) DEFAULT 'Diskusi',
  `views` int(11) DEFAULT 0,
  `status` enum('open','closed') DEFAULT 'open',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `upvotes` int(11) DEFAULT 0,
  `downvotes` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `forum_topics`
--

INSERT INTO `forum_topics` (`id`, `user_id`, `user_name`, `title`, `content`, `destination`, `travel_date`, `category`, `views`, `status`, `created_at`, `upvotes`, `downvotes`) VALUES
(1, NULL, 'Wisatawan Solo', 'Cari teman trip ke Bromo Mei ini', 'Halo, saya berencana ke Bromo tanggal 15-17 Mei. Ada yang mau join sharing jeep and penginapan?', 'Gunung Bromo', '2026-05-15', 'Diskusi', 5, 'open', '2026-05-07 06:59:45', 18, 1),
(2, NULL, 'Backpacker Jogja', 'Sharing cost ke Dieng dari Yogyakarta', 'Mau ke Dieng untuk sunrise Gunung Prau. Cari 2 orang untuk sharing mobil. Budget 300K/orang PP.', 'Gunung Prau', '2026-05-10', 'Diskusi', 0, 'open', '2026-05-07 06:59:45', 24, 0),
(3, 3, 'Ahmad Fauzi', 'Tips mendaki Gunung Merbabu via Selo untuk pemula', 'Halo traveler! Saya baru saja pulang dari pendakian Merbabu via Jalur Selo dan ingin berbagi tips. (1) Registrasi online di SIMAKSI minimal 3 hari sebelum keberangkatan. (2) Bawa sleeping bag yang mampu menahan suhu -5°C. (3) Sumber air ada di Pos 2 jadi isi penuh botol. (4) Summit attack idealnya mulai pukul 02.00 pagi agar dapat sunrise. Ada yang mau tanya-tanya?', 'Gunung Merbabu', '2026-03-15', 'Tips', 320, 'open', '2026-03-16 07:00:00', 87, 3),
(4, 4, 'Rina Kusuma', 'Review lengkap: Solo trip 5 hari Yogyakarta – Dieng – Semarang', 'Baru selesai trip 5 hari dan mau sharing itinerary + budget! Hari 1-2: Yogyakarta (Prambanan, Malioboro, Benteng Vredeburg, Taman Sari) ~ Rp450rb/hari. Hari 3: Dieng (Gunung Prau sunrise, Telaga Warna, Kawah Sikidang) ~ Rp380rb. Hari 4: perjalanan ke Semarang via Wonosobo (Lawang Sewu, Kota Lama) ~ Rp350rb. Hari 5: Semarang explore + balik. Total sekitar Rp2,2 juta sudah termasuk transport, penginapan budget, dan makan. Ada yang mau rute ini?', 'Yogyakarta', '2026-04-01', 'Diskusi', 587, 'open', '2026-04-06 09:00:00', 142, 4),
(5, 11, 'Rizky Pratama', 'Persiapan fisik dan mental sebelum mendaki Carstensz Pyramid', 'Carstensz bukan gunung biasa — ini rock climbing expedition! Setelah 2 tahun persiapan, saya akhirnya berhasil summit bulan Januari. Yang perlu dipersiapkan: (1) Latihan panjat tebing indoor minimal 6 bulan. (2) Latihan cardio intensif: lari, hiking beban, bersepeda. (3) Simulasi altitude sickness di gunung 3000+ mdpl. (4) Budget: siapkan 25–40 juta untuk paket all-in dengan operator resmi. (5) Izin dan akomodasi diurus operator. AMA!', 'Carstensz Pyramid', '2026-01-20', 'Diskusi', 1250, 'open', '2026-01-31 10:00:00', 320, 7),
(6, 6, 'Citra Dewi', 'Wisata budaya Tana Toraja: panduan lengkap dan etika berkunjung', 'Toraja adalah destinasi budaya yang membutuhkan kepekaan dan etika khusus. Beberapa hal penting: (1) Selalu minta izin sebelum memotret upacara atau jenazah. (2) Kenakan pakaian yang sopan dan tidak mencolok. (3) Jika diundang ke Rambu Solo, bawalah gula atau kopi sebagai simbol penghormatan. (4) Gunakan pemandu lokal — ini cara terbaik mendukung ekonomi warga sekaligus mendapatkan penjelasan otentik. (5) Jangan pernah menyentuh tau-tau atau benda adat tanpa izin. Ada yang punya pengalaman khusus di Toraja?', 'Tana Toraja', '2026-01-10', 'Tips', 890, 'open', '2026-01-16 11:00:00', 215, 5),
(7, 8, 'Sari Puspita', 'Pantai-pantai tersembunyi Gunungkidul yang masih sepi pengunjung', 'Sebagai solo traveler yang sudah 4x ke Gunungkidul, saya mau sharing pantai-pantai hidden gem yang belum banyak di-explore: (1) Pantai Ngetun — laguna biru dengan tebing karst, snorkeling bagus. (2) Pantai Sedahan — sunset point terbaik, pasir putih lembut. (3) Pantai Greweng — akses trekking 45 menit tapi worth it, sangat sepi. (4) Pantai Timang — ikon gondola kayu dan kepiting lobster segar. Mana favorit kalian?', 'Gunung Kidul', '2026-03-01', 'Rekomendasi', 445, 'open', '2026-03-10 14:00:00', 108, 2),
(8, 14, 'Lina Marlina', 'Food trip Jakarta: kuliner khas Betawi yang mulai langka', 'Sebagai Jakartian asli yang cinta kuliner, saya prihatin banyak kuliner Betawi otentik yang mulai sulit ditemukan. Berikut daftar yang HARUS dicoba sebelum benar-benar hilang: (1) Soto Tangkar di Pasar Senen (bumbu kuning khas). (2) Bir Pletok di warung-warung sekitar Condet. (3) Asinan Betawi di Bogor Street Food Jl. Dewi Sartika. (4) Kerak Telor — masih ada di Kota Tua weekend. (5) Laksa Betawi di Warung Laksa Ibu Haji Mansyur, Sawah Besar. Siapa yang masih ingat kuliner Betawi lain?', 'Jakarta', '2026-02-20', 'Tips', 724, 'open', '2026-02-25 12:00:00', 176, 6),
(9, 15, 'Bagas Wicaksono', 'Trip Bromo backpacker budget di bawah 500 ribu', 'Sering lihat orang bilang Bromo mahal. Tapi ternyata bisa backpacker dengan budget ketat! Rute saya: (1) Naik bus malam Surabaya-Probolinggo (Rp60rb). (2) Angkot Probolinggo-Cemoro Lawang (Rp35rb). (3) Nginap di homestay bersama (Rp75rb/malam). (4) Jalan kaki ke lautan pasir (gratis, bukan naik jeep). (5) Sunrise dari Bukit Cinta yang gratisan (bukan Pananjakan berbayar). (6) Makan nasi + telur di warung sekitar (Rp20rb/porsi). Total: ±Rp350rb untuk 2D1N. Tips lengkap ada di thread ini!', 'Gunung Bromo', '2026-02-10', 'Rekomendasi', 2140, 'open', '2026-02-15 08:00:00', 535, 12),
(10, 16, 'Nina Setiawati', 'First solo trip ke Bali: itinerary 7 hari dengan budget 3 jutaan', 'Baru pulang dari solo trip pertama ke Bali dan tidak menyesal sama sekali! Budget total Rp3,1 juta sudah termasuk tiket PP pesawat promo. Highlight: D1-D2 Ubud (Tegallalang, Monkey Forest, Kecak Uluwatu). D3-D4 Seminyak-Kuta (pantai, Pura Tanah Lot sunset). D5 Bedugul (Pura Ulun Danu, Kebun Raya). D6 Karangasem (Tirta Gangga, Besakih). D7 Pulang. Akomodasi: hostel dormitory rata-rata Rp90rb/malam. Transport: sewa motor Rp75rb/hari. DM kalau mau itinerary lengkap!', 'Bali', '2026-04-10', 'Rekomendasi', 1832, 'open', '2026-04-18 15:00:00', 448, 8),
(11, 5, 'Budi Santoso', 'Komunitas pendaki Yogyakarta: open rekrut member baru!', 'Halo semua! Kami dari komunitas pendaki Jogja Mountain Community membuka rekrutmen anggota baru untuk periode Juni-Juli 2026. Program yang ada: (1) Pendakian rutin bulanan (Merbabu, Prau, Lawu, Sindoro). (2) Kelas survival dan navigasi peta kompas. (3) Training P3K untuk pendaki. (4) Program leave no trace dan bersih gunung. Biaya keanggotaan Rp150rb/tahun. Hubungi WA 0812-xxxx-xxxx atau DM di sini untuk daftar. Yuk berpetualang dengan aman dan bertanggung jawab!', 'Yogyakarta', NULL, 'Rekomendasi', 562, 'open', '2026-05-01 10:00:00', 134, 2);

-- --------------------------------------------------------

--
-- Table structure for table `itineraries`
--

CREATE TABLE `itineraries` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(150) NOT NULL,
  `travel_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `itineraries`
--

INSERT INTO `itineraries` (`id`, `user_id`, `title`, `travel_date`, `created_at`) VALUES
(1, 2, 'Perjalanan ke Yogyakarta', '2026-05-07', '2026-05-07 09:56:19');

-- --------------------------------------------------------

--
-- Table structure for table `itinerary_items`
--

CREATE TABLE `itinerary_items` (
  `id` int(11) NOT NULL,
  `itinerary_id` int(11) NOT NULL,
  `place_id` int(11) NOT NULL,
  `day_number` int(11) NOT NULL DEFAULT 1,
  `time_slot` varchar(50) NOT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `itinerary_items`
--

INSERT INTO `itinerary_items` (`id`, `itinerary_id`, `place_id`, `day_number`, `time_slot`, `notes`) VALUES
(1, 1, 35, 1, '09:00', '');

-- --------------------------------------------------------

--
-- Table structure for table `places`
--

CREATE TABLE `places` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `category_id` int(11) NOT NULL,
  `location` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `entrance_fee` decimal(10,2) DEFAULT 0.00,
  `parking_fee` decimal(10,2) DEFAULT 0.00,
  `meal_cost` decimal(10,2) DEFAULT 0.00,
  `facilities` text DEFAULT NULL COMMENT 'JSON array fasilitas, contoh: ["toilet","parkir","wifi","mushola"]',
  `latitude` varchar(20) DEFAULT NULL,
  `longitude` varchar(20) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT '',
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `submitted_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `places`
--

INSERT INTO `places` (`id`, `name`, `category_id`, `location`, `description`, `entrance_fee`, `parking_fee`, `meal_cost`, `facilities`, `latitude`, `longitude`, `image_url`, `status`, `submitted_by`, `created_at`, `updated_at`) VALUES
(1, 'Gunung Merbabu', 1, 'Magelang, Jawa Tengah', 'Gunung Merbabu adalah gunung berapi stratovolkano yang menjulang setinggi 3.145 mdpl di perbatasan Kabupaten Magelang, Boyolali, dan Semarang. Gunung ini terkenal dengan padang sabana yang luas dan menakjubkan, hamparan bunga edelweis yang harum, serta panorama matahari terbit yang spektakuler dari puncak Kenteng Songo. Terdapat beberapa jalur pendakian populer: Jalur Selo, Jalur Cunthel, dan Jalur Suwanting, masing-masing menawarkan karakteristik medan yang berbeda. Di puncak, pendaki bisa menyaksikan siluet Gunung Merapi, Sumbing, Sindoro, dan Lawu sekaligus. Sabana berlapis-lapis yang membentang di ketinggian 2.800 mdpl menjadi spot favorit foto dan kemah. Pendakian terbaik dilakukan pada musim kemarau (April–Oktober) saat trek kering dan pemandangan langit cerah.', 27000.00, 15000.00, 40000.00, '[\"toilet\",\"parkir\",\"warung\",\"camping ground\",\"pos pendakian\",\"air bersih\"]', '-7.4531', '110.4394', 'merbabu.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 05:55:55'),
(2, 'Gunung Prau', 1, 'Dieng, Jawa Tengah', 'Gunung Prau setinggi 2.565 mdpl adalah surga tersembunyi di kawasan Dataran Tinggi Dieng, Kabupaten Wonosobo dan Batang. Puncaknya dikelilingi padang sabana yang konon terluas di Jawa Tengah, menjadikannya lokasi glamping dan kemping favorit di kalangan milenial. Fenomena \"lautan awan\" di pagi hari dan langit berbintang tanpa polusi cahaya di malam hari adalah daya tarik utamanya. Dari puncak, pendaki dapat menyaksikan panorama 360 derajat meliputi Gunung Sindoro, Sumbing, Merapi, Merbabu, Ungaran, dan Slamet secara bersamaan. Jalur pendakian via Patak Banteng adalah yang paling populer karena jarak tempuh relatif singkat (±4 jam). Aktivitas terbaik adalah bermalam untuk menikmati golden hour pagi dan sunset sore hari.', 20000.00, 10000.00, 35000.00, '[\"toilet\",\"parkir\",\"warung\",\"camping ground\",\"pos pendakian\",\"penyewaan tenda\",\"air bersih\"]', '-7.1911', '109.9072', 'prau.png', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 05:56:21'),
(3, 'Cartenz Piramid', 1, 'Papua Pegunungan', 'Carstensz Pyramid atau Puncak Jaya adalah puncak tertinggi di Indonesia sekaligus puncak tertinggi di antara tujuh puncak beneng (Seven Summits) yang terletak di Benua Australia–Oceania, menjulang di ketinggian 4.884 mdpl. Berlokasi di jantung Pegunungan Sudirman, Papua Pegunungan, gunung ini ditutup lapisan gletser abadi yang kian menyusut akibat perubahan iklim. Pendakiannya dikategorikan sebagai salah satu yang paling teknis di dunia, membutuhkan keahlian panjat tebing, peralatan alpinisme lengkap, serta fisik dan mental yang prima. Izin pendakian harus diajukan jauh-jauh hari melalui prosedur administratif ketat. Pemandangan gletser tropis yang tersisa, ekosistem alpine unik, dan pengalaman mendaki di tanah Papua yang sakral menjadikan Carstensz sebagai impian setiap alpinis sejati Indonesia.', 2500000.00, 0.00, 150000.00, '[\"helipad\",\"porter\",\"pemandu wajib\",\"basecamp\"]', '-4.0789', '137.1583', 'cartenz.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 05:56:49'),
(4, 'Pantai Ngetun', 1, 'Gunung Kidul, Yogyakarta', 'Pantai Ngetun adalah surga tersembunyi di ujung Kabupaten Gunungkidul, Yogyakarta, yang belum banyak terekspos secara masif. Pantai ini dikelilingi tebing-tebing karst megah khas pesisir selatan Jawa yang membentuk laguna alami dengan air berwarna biru kehijauan jernih. Akses menuju pantai melalui jalur trekking singkat melewati kebun warga yang asri, menambah sensasi petualangan. Ombak di teluk kecil ini relatif tenang sehingga aman untuk berenang dan snorkeling. Saat air surut, kawasan karang dangkal mengungkap berbagai biota laut yang menarik. Pantai ini buka hingga sore hari dan belum dipungut biaya pengelolaan besar, sehingga ideal bagi wisatawan yang mencari ketenangan jauh dari keramaian pantai utama seperti Baron atau Parangtritis.', 10000.00, 5000.00, 30000.00, '[\"toilet\",\"parkir\",\"warung\",\"area foto\"]', '-8.1345', '110.5678', 'ngetun.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 05:57:07'),
(5, 'Gunung Bromo', 1, 'Probolinggo, Jawa Timur', 'Gunung Bromo (2.329 mdpl) adalah gunung berapi aktif paling ikonik di Indonesia, bagian dari Taman Nasional Bromo Tengger Semeru. Terletak di tengah lautan pasir luas bernama Segara Wedi seluas 10 km², kawah Bromo terus mengepulkan asap sulfur setiap saat. Ritual Yadnya Kasada yang dirayakan masyarakat Tengger setiap tahun menambah nilai budaya yang luar biasa. Titik matahari terbit terbaik adalah dari Bukit Pananjakan dan Bukit Kingkong. Untuk mencapai kawah, pengunjung dapat menyewa jeep 4WD dari Probolinggo/Malang, menaiki kuda, atau berjalan kaki melintasi lautan pasir. Pemandangan \"lautan pasir dan pagi bersalju\" yang melegenda telah menjadikan Bromo sebagai destinasi bucket-list nomor satu di Jawa Timur dan salah satu ikon pariwisata Indonesia di kancah internasional.', 35000.00, 30000.00, 50000.00, '[\"toilet\",\"parkir\",\"restoran\",\"mushola\",\"souvenir\",\"pemandu\",\"jeep_rental\",\"penyewaan_kuda\"]', '-7.9425', '112.9530', 'bromo.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(6, 'Desa Penglipuran', 2, 'Bangli, Bali', 'Desa Penglipuran di Kabupaten Bangli, Bali, telah memenangkan berbagai penghargaan sebagai salah satu desa terbersih dan terbaik di dunia. Desa adat ini mempertahankan tata ruang tradisional Bali Aga yang konsisten: satu jalan utama lurus diapit deretan pekarangan rumah bertembok dengan pintu masuk (angkul-angkul) seragam. Mobil dan motor dilarang masuk, menjaga kedamaian dan keasrian. Bambu menjadi tanaman dominan di sekeliling desa, membentuk hutan bambu yang nyaman dijelajahi. Warga masih menjalankan adat dan ritual Hindu Bali sehari-hari, sehingga pengunjung bisa menyaksikan kehidupan otentik. Tersedia homestay untuk menginap, serta warung khas penjual loloh cemcem (minuman herbal lokal) dan jajanan Bali. Waktu terbaik berkunjung adalah pagi hari sebelum rombongan wisata datang.', 30000.00, 5000.00, 35000.00, '[\"toilet\",\"parkir\",\"souvenir\",\"warung\",\"area foto\",\"homestay\",\"mushola\"]', '-8.4238', '115.3564', 'panglipuran.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 05:57:24'),
(7, 'Tana Toraja', 2, 'Sulawesi Selatan', 'Tana Toraja di Sulawesi Selatan adalah salah satu destinasi budaya paling memukau di Asia Tenggara. Masyarakat Toraja terkenal dengan upacara pemakaman mewah bernama Rambu Solo — pesta kematian yang bisa berlangsung berhari-hari dengan menyembelih puluhan kerbau dan babi sebagai simbol penghormatan kepada almarhum. Jenazah disimpan di tebing batu (liang) yang dihiasi patung tau-tau (representasi orang meninggal). Rumah adat Tongkonan dengan atap melengkung berbentuk perahu adalah landmark arsitektur yang tak tertandingi. Kawasan pegunungan Toraja menawarkan trek melalui desa-desa tradisional, sawah bertingkat, dan pemandangan alam hijau yang dramatis. Kete Kesu, Londa, dan Bori adalah situs yang wajib dikunjungi. Festival Lovely December rutin menarik ribuan wisatawan mancanegara setiap tahunnya.', 60000.00, 20000.00, 50000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"pemandu\",\"homestay\",\"mushola\"]', '-3.0672', '119.8230', 'toraja.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(8, 'Desa Sade', 2, 'Lombok, NTB', 'Desa Sade adalah enclave budaya Suku Sasak di Lombok Tengah yang masih menjaga kemurnian tradisi leluhur. Rumah-rumah panggung beratap ilalang (bumbung) berderet rapi, lantainya dilapisi tanah liat campur kotoran kerbau yang dipercaya mengusir serangga — tradisi yang terus dijalankan hingga sekarang. Sekitar 700 warga Desa Sade hidup dari bertani dan menenun kain songket serta kain tenun khas Lombok yang dijual langsung kepada wisatawan. Pengunjung bisa belajar menenun, mengenakan pakaian adat, dan menyaksikan tari tradisional Sasak. Pemandu lokal (biasanya pemuda desa) siap menjelaskan filosofi hidup, adat pernikahan sorong serah aji krama, dan sejarah desa dalam bahasa Indonesia yang ramah. Desa ini buka setiap hari dan tidak ada tiket resmi, namun pemberian donasi sukarela sangat diapresiasi.', 0.00, 5000.00, 25000.00, '[\"toilet\",\"parkir\",\"souvenir\",\"pemandu\",\"warung\"]', '-8.8945', '116.2876', 'sade.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(9, 'Tari Kecak Uluwatu', 2, 'Badung, Bali', 'Pertunjukan Tari Kecak di Pura Uluwatu, Badung, Bali adalah salah satu pengalaman seni pertunjukan paling dramatis di dunia. Ribuan suara \"cak\" bergema dari ratusan penari lelaki berpakaian kotak-kotak hitam-putih yang membentuk lingkaran konsentris, melakonkan kisah Ramayana — penculikan Dewi Sita, pertempuran Rama melawan Rahwana, dan kemenangan kebaikan atas kejahatan. Pertunjukan berlangsung sore menjelang matahari terbenam di tepi tebing setinggi 70 meter, dengan laut biru Samudera Hindia sebagai latar belakang. Efek dramatisasi api lilin yang menyala saat momen klimaks menciptakan suasana magis. Pura Uluwatu sendiri adalah salah satu pura \"Kayangan Jagat\" (pura pelindung Bali) yang menjulang di tepi tebing dan dihuni kawanan kera. Datanglah 30 menit sebelum pertunjukan untuk memilih tempat duduk terbaik.', 150000.00, 20000.00, 60000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"area foto\",\"aksesibilitas\"]', '-8.8291', '115.0849', 'uluwatu.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 05:57:43'),
(10, 'Desa Waerebo', 2, 'Manggarai, NTT', 'Desa Waerebo adalah desa tradisional paling terpencil dan paling magis di Flores, NTT, yang hanya bisa dijangkau dengan trekking 3–4 jam dari Desa Denge. Terletak di ketinggian 1.200 mdpl di dalam lembah hijau yang dikelilingi hutan tropis lebat, Waerebo dihuni komunitas Manggarai yang telah menjaga tujuh rumah adat Mbaru Niang mereka selama ratusan tahun. Mbaru Niang adalah rumah kerucut beratap jerami yang menjulang lima tingkat, masing-masing tingkat memiliki fungsi berbeda: hunian, penyimpanan makanan, benih, bekal darurat, dan persembahan. UNESCO mengakui Waerebo sebagai salah satu situs warisan arsitektur vernakular Asia Pasifik. Pengunjung wajib didampingi pemandu, melakukan ritual penyambutan adat (compang), dan bisa menginap semalam untuk merasakan kehidupan komunitas serta pemandangan kabut pagi yang tak terlupakan.', 50000.00, 0.00, 40000.00, '[\"toilet\",\"pemandu wajib\",\"warung\",\"homestay\",\"camping area\"]', '-8.7380', '120.5260', 'werebo.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 05:55:30'),
(11, 'Candi Borobudur', 3, 'Magelang, Jawa Tengah', 'Candi Borobudur adalah mahakarya arsitektur Buddha terbesar di dunia yang dibangun pada abad ke-8 dan ke-9 Masehi oleh Dinasti Syailendra. Kompleks candi ini terdiri dari sembilan teras batu andesit yang tersusun dalam tiga zona kosmis: Kamadhatu (dunia hasrat), Rupadhatu (dunia bentuk), dan Arupadhatu (dunia tanpa bentuk) yang disimbolkan oleh 72 stupa berlubang dengan patung Buddha di dalamnya, serta stupa induk raksasa di puncak. Total relief yang terpahat sepanjang 2,5 km menceritakan kisah kehidupan Buddha dan ajaran kosmologi Buddha. Matahari terbit di Borobudur, saat siluet stupa-stupa terbalut kabut dengan latar belakang Gunung Merapi dan Merbabu, adalah salah satu pemandangan paling ikonik di Asia. Tersedia paket \"Borobudur Sunrise\" dengan akses eksklusif sebelum jam buka umum. UNESCO menetapkan Borobudur sebagai Warisan Budaya Dunia sejak 1991.', 52000.00, 20000.00, 40000.00, '[\"toilet\",\"parkir\",\"souvenir\",\"pemandu\",\"restoran\",\"aksesibilitas\",\"wifi\",\"area foto\"]', '-7.6079', '110.2038', 'borobudur.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 06:00:33'),
(12, 'Kota Tua Jakarta', 3, 'Jakarta Barat, DKI Jakarta', 'Kawasan Kota Tua Jakarta atau Batavia Lama adalah pusat kota dagang VOC Belanda yang dibangun sejak abad ke-17. Area seluas ±1,3 km² ini menyimpan ratusan bangunan bergaya neo-klasik dan Art Deco Eropa yang masih berdiri megah. Museum Fatahillah (Museum Sejarah Jakarta) berdiri di bekas Balai Kota Batavia dengan koleksi artefak masa kolonial yang lengkap. Di sekeliling alun-alun, pengunjung bisa menyewa sepeda onthel berbagai warna untuk berkeliling dengan nuansa vintage yang instagrammable. Kafe-kafe bergaya retro banyak bermunculan di ruko-ruko tua yang direnovasi. Malam hari kawasan ini hidup dengan pertunjukan seni jalanan, street food, dan pertunjukan komunitas. Kota Tua terus dikembangkan sebagai kawasan heritage modern yang memadukan sejarah dan kreativitas kota.', 0.00, 20000.00, 55000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"area foto\",\"aksesibilitas\",\"wifi\",\"sepeda sewa\"]', '-6.1376', '106.8171', 'kotatua.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 05:59:00'),
(13, 'Lawang Sewu', 3, 'Semarang, Jawa Tengah', 'Lawang Sewu (secara harfiah: Seribu Pintu) adalah bangunan monumental warisan kolonial Belanda yang dibangun tahun 1904–1919 sebagai kantor pusat Nederlandsch-Indische Spoorweg Maatschappij (NIS), perusahaan kereta api swasta. Terletak di jantung Kota Semarang, gedung tiga lantai ini terkenal dengan deretan pintu dan jendela kaca berwarna-warni yang jumlahnya ribuan, menciptakan permainan cahaya yang menakjubkan. Basement Lawang Sewu menyimpan sejarah kelam sebagai tempat penahanan dan eksekusi pada masa pendudukan Jepang. Kini gedung ini telah direstorasi dan dikelola PT. KAI sebagai museum dan cagar budaya. Pengunjung bisa mengikuti tur malam bertema \"misteri\" yang populer, atau tur siang yang mengupas sejarah arsitektur dan perkeretaapian. Relief dan ornamen eksteriornya merupakan contoh arsitektur Art Nouveau terbaik di Indonesia.', 15000.00, 10000.00, 40000.00, '[\"toilet\",\"parkir\",\"souvenir\",\"pemandu\",\"area foto\",\"aksesibilitas\"]', '-6.9840', '110.4105', 'lawangsewu.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 06:01:00'),
(14, 'Benteng Vredeburg', 3, 'Yogyakarta, DI Yogyakarta', 'Benteng Vredeburg dibangun oleh pemerintah kolonial VOC tahun 1760 atas permintaan Sri Sultan Hamengku Buwono I sebagai \"jaminan keamanan\" — meski sesungguhnya berfungsi mengawasi Keraton Yogyakarta dari jarak dekat. Berlokasi tepat di ujung Jalan Malioboro berhadapan dengan Gedung Agung (Istana Presiden), benteng berbentuk segi empat dengan bastion di setiap sudutnya ini kini menjadi Museum Perjuangan. Diorama-diorama di dalam museum menceritakan perjalanan perjuangan bangsa Indonesia dari masa penjajahan hingga kemerdekaan secara kronologis dan detail. Bagi peminat sejarah, museum ini adalah referensi visual terlengkap tentang revolusi kemerdekaan Indonesia. Halaman benteng yang luas juga menjadi venue rutin berbagai festival seni dan budaya Yogyakarta sepanjang tahun. Tiket masuknya sangat terjangkau, menjadikannya destinasi edukasi favorit keluarga.', 3000.00, 5000.00, 35000.00, '[\"toilet\",\"parkir\",\"souvenir\",\"pemandu\",\"area foto\",\"aksesibilitas\",\"mushola\"]', '-7.8003', '110.3665', 'vredeburg.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 06:01:21'),
(15, 'Istana Maimun', 3, 'Medan, Sumatera Utara', 'Istana Maimun adalah istana Kesultanan Deli yang dibangun pada 1888 atas prakarsa Sultan Makmun Al Rasyid Perkasa Alamsyah. Istana ini merupakan perpaduan arsitektur Melayu, Islam, Spanyol, Italia, dan India — cerminan jaringan perdagangan dan diplomasi Kesultanan Deli yang kosmopolit pada zamannya. Bangunan utama berwarna kuning (warna khas Melayu) dengan kubah-kubah berbentuk bawang dan ornamen bintang segi delapan. Mahkota Deli, senjata, dan perlengkapan kerajaan dipajang di ruang utama yang masih digunakan untuk upacara adat. Sultan dan keluarga kerajaan masih tinggal di sebagian sayap istana. Di halaman terdapat meriam Puntung yang dikeramatkan dengan legenda Putri Hijau. Mengenakan baju kurung atau kebaya untuk berfoto di depan istana adalah aktivitas favorit wisatawan yang berkunjung ke Medan.', 10000.00, 5000.00, 45000.00, '[\"toilet\",\"parkir\",\"souvenir\",\"pemandu\",\"area foto\",\"mushola\"]', '3.5753', '98.6835', 'maimun.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 06:01:39'),
(16, 'Masjid Istiqlal', 4, 'Jakarta Pusat, DKI Jakarta', 'Masjid Istiqlal adalah masjid terbesar di Asia Tenggara dan salah satu yang terbesar di dunia, mampu menampung hingga 200.000 jamaah. Dibangun pada 1961–1978 dengan desain arsitek nasionalis Friedrich Silaban, Istiqlal mengusung arsitektur modern minimalis yang mencerminkan kemerdekaan dan persatuan (istiqlal = kemerdekaan dalam bahasa Arab). Kubah utama berdiameter 45 meter disimbolkan tahun kemerdekaan Indonesia. Lima menara setinggi 66,66 meter melambangkan panjang ayat Al-Quran. Posisinya yang berhadapan langsung dengan Gereja Katedral Jakarta menjadi simbol kerukunan beragama yang kuat. Masjid ini terbuka untuk wisatawan non-Muslim dengan dress code tertutup dan panduan tur tersedia. Suasana salat Jumat dan Idul Fitri di Istiqlal adalah pengalaman spiritual dan sosial yang tak terlupakan.', 0.00, 5000.00, 40000.00, '[\"toilet\",\"parkir\",\"mushola\",\"aksesibilitas\",\"area_foto\",\"pemandu\"]', '-6.1702', '106.8310', 'istiqlal.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(17, 'Pura Besakih', 4, 'Karangasem, Bali', 'Pura induk terbesar dan paling suci di Bali, berlokasi di lereng Gunung Agung.', 60000.00, 10000.00, 40000.00, '[\"toilet\",\"parkir\",\"souvenir\",\"pemandu\",\"restoran\",\"mushola\",\"area_foto\"]', '-8.3739', '115.4567', 'besakih.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(18, 'Gereja Blenduk', 4, 'Semarang, Jawa Tengah', 'Gereja protestan bersejarah dengan kubah tembaga ikonik di Kota Lama.', 0.00, 10000.00, 35000.00, '[\"toilet\",\"parkir\",\"area foto\",\"pemandu\"]', '-6.9682', '110.4275', 'blenduk.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 05:58:16'),
(19, 'Makam Sunan Kalijaga', 4, 'Demak, Jawa Tengah', 'Makam wali songo dengan sejarah Islam yang dalam dan arsitektur tradisional.', 0.00, 5000.00, 25000.00, '[\"toilet\",\"parkir\",\"souvenir\",\"mushola\",\"warung\"]', '-6.8940', '110.6370', 'makamsunan.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(20, 'Vihara Dhanagun', 4, 'Bogor, Jawa Barat', 'Vihara tertua dan terbesar di Bogor dengan patung Buddha raksasa.', 0.00, 5000.00, 30000.00, '[\"toilet\",\"parkir\",\"souvenir\",\"mushola\",\"area foto\"]', '-6.5950', '106.7896', 'vihara.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 05:58:00'),
(21, 'Malioboro', 5, 'Yogyakarta, DI Yogyakarta', 'Malioboro adalah jantung wisata Kota Yogyakarta, sebuah koridor sepanjang ±1 km yang memadukan sejarah, budaya, kuliner, dan belanja dalam satu napas. Nama Malioboro dipercaya berasal dari nama Duke of Marlborough atau dari kata Sansekerta \"malyabhara\" (dihiasi bunga). Deretan pedagang kaki lima menjajakan batik, wayang kulit, perak, blangkon, dan berbagai kerajinan khas Jogja di sepanjang trotoar yang telah diperlebar dan diperindah. Malam hari, angkringan menjadi simbol kesetaraan sosial Yogyakarta — dari mahasiswa hingga pejabat duduk bersila menikmati nasi kucing, wedang jahe, dan berbagai lauk sederhana dengan harga sangat terjangkau. Kawasan ini juga merupakan koridor budaya menuju Keraton Yogyakarta dan Alun-Alun Utara. Street art, musisi jalanan berbakat, dan becak kayuh listrik melengkapi pengalaman berjalan-jalan di Malioboro yang sesungguhnya tak pernah tidur.', 0.00, 15000.00, 60000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"pemandu\",\"angkringan\",\"atm\",\"wifi\",\"aksesibilitas\"]', '-7.7930', '110.3658', 'malioboro.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(22, 'Pasar Cihapit', 5, 'Bandung, Jawa Barat', 'Pasar Cihapit di Kecamatan Cibeunying Kaler, Bandung, adalah pasar basah tradisional yang terkenal sebagai surga kuliner kaki lima autentik Sunda sejak era kolonial. Di sini berjejer warung-warung yang menjajakan nasi timbel, batagor, siomay, colenak, surabi, karedok, peuyeum, dan aneka jajanan Sunda lainnya dengan harga yang sangat merakyat. Kesegaran bahan baku langsung dari pasar membuat cita rasa masakan terasa sangat autentik. Suasana pasar yang hidup, interaksi hangat pedagang dan pembeli, serta aroma rempah yang khas menciptakan pengalaman kuliner yang jauh dari kesan komersialisasi. Pasar ini paling ramai pada pagi hari (06.00–10.00 WIB), cocok untuk sarapan pagi yang berkesan bagi wisatawan yang ingin merasakan keseharian warga Bandung.', 0.00, 0.00, 40000.00, '[\"toilet\",\"warung\",\"area foto\"]', '-6.9034', '107.6201', 'chiapit.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 05:59:56'),
(23, 'Jalan Sabang', 5, 'Jakarta Pusat, DKI Jakarta', 'Kawasan Jalan Sabang (H. Agus Salim) di Jakarta Pusat adalah destinasi kuliner malam yang legendaris dan lintas generasi. Ratusan warung tenda berjejer menyajikan menu nusantara yang lengkap: sate Madura, nasi goreng Kambing Kebon Sirih, soto Betawi, gulai, bakso, mie ayam, es cendol, dan masih banyak lagi. Lokasi strategis di pusat kota menjadikannya titik kumpul favorit pegawai kantoran, keluarga, hingga wisatawan mancanegara yang ingin merasakan street food Jakarta. Beberapa warung telah beroperasi sejak puluhan tahun dan diwariskan lintas generasi, mempertahankan resep otentik. Aktivitas terbaik adalah datang dalam rombongan, memesan berbagai menu dari warung berbeda, dan menikmati makan malam sambil merasakan denyut nadi kota Jakarta yang kosmopolit.', 0.00, 15000.00, 55000.00, '[\"toilet\",\"parkir\",\"restoran\",\"area foto\",\"atm\"]', '-6.1850', '106.8320', 'sabang.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 05:59:39'),
(24, 'Kya-Kya Surabaya', 5, 'Surabaya, Jawa Timur', 'Kawasan wisata kuliner Chinatown dengan makanan Tionghoa autentik.', 0.00, 10000.00, 50000.00, '[\"toilet\",\"parkir\",\"restoran\",\"area foto\",\"atm\"]', '-7.2370', '112.7378', 'kyakya.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 05:59:24'),
(25, 'Simpang Lima Semarang', 5, 'Semarang, Jawa Tengah', 'Alun-alun kota dengan food court, kuliner malam, and pemandangan urban.', 0.00, 5000.00, 45000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"area foto\",\"wifi\",\"aksesibilitas\"]', '-6.9845', '110.4108', 'simpangsemarang.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 05:59:13'),
(26, 'Dufan Ancol', 6, 'Jakarta Utara, DKI Jakarta', 'Taman hiburan terbesar di Indonesia dengan wahana ekstrem dan edukasi.', 300000.00, 25000.00, 100000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"area_foto\",\"wifi\",\"aksesibilitas\",\"mushola\",\"atm\",\"loker\"]', '-6.1256', '106.8382', 'dufan.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(27, 'Jatim Park', 6, 'Batu, Jawa Timur', 'Kompleks wisata edutainment dengan wahana modern dan museum unik.', 160000.00, 20000.00, 80000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"area_foto\",\"wifi\",\"aksesibilitas\",\"mushola\",\"atm\"]', '-7.8806', '112.5246', 'jpark.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(28, 'Trans Studio', 6, 'Makassar, Sulawesi Selatan', 'Indoor theme park terbesar dengan wahana berteknologi tinggi.', 200000.00, 15000.00, 70000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"area_foto\",\"wifi\",\"aksesibilitas\",\"mushola\",\"atm\"]', '-5.1584', '119.4128', 'trans.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(29, 'Waterbom Bali', 6, 'Kuta, Bali', 'Taman air terbaik di Asia dengan seluncuran spektakuler.', 530000.00, 0.00, 120000.00, '[\"toilet\",\"parkir\",\"restoran\",\"loker\",\"area_foto\",\"wifi\",\"aksesibilitas\",\"atm\",\"lounge\"]', '-8.7610', '115.1690', 'waterboom.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(30, 'Saloka Park', 6, 'Semarang, Jawa Tengah', 'Theme park dengan nuansa lokal Jawa and wahana keluarga.', 150000.00, 15000.00, 60000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"area_foto\",\"wifi\",\"aksesibilitas\",\"mushola\",\"atm\"]', '-7.2820', '110.4778', 'saloka.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(31, 'Museum Geologi', 7, 'Bandung, Jawa Barat', 'Museum geologi lengkap dengan fosil, meteorit, and informasi vulkanologi.', 3000.00, 5000.00, 35000.00, '[\"toilet\",\"parkir\",\"souvenir\",\"pemandu\",\"area_foto\",\"aksesibilitas\",\"mushola\"]', '-6.9007', '107.6215', 'geologi.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(32, 'Taman Pintar', 7, 'Yogyakarta, DI Yogyakarta', 'Pusat edukasi interaktif untuk anak and keluarga dengan science center.', 10000.00, 10000.00, 35000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"area_foto\",\"wifi\",\"aksesibilitas\",\"mushola\",\"atm\"]', '-7.8005', '110.3689', 'tamanpintar.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(33, 'Seaworld Ancol', 7, 'Jakarta Utara, DKI Jakarta', 'Akuarium laut terbesar dengan terowongan bawah air and pertunjukan ikan.', 120000.00, 25000.00, 65000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"area_foto\",\"wifi\",\"aksesibilitas\",\"mushola\",\"atm\"]', '-6.1262', '106.8361', 'seaworld.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(34, 'Museum MACAN', 7, 'Jakarta Barat, DKI Jakarta', 'Museum seni modern and kontemporer dengan koleksi internasional.', 150000.00, 10000.00, 60000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"area_foto\",\"wifi\",\"aksesibilitas\",\"atm\"]', '-6.1767', '106.7896', 'mmacan.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(35, 'Ragunan', 7, 'Jakarta Selatan, DKI Jakarta', 'Kebun binatang terluas di Indonesia dengan koleksi fauna nusantara.', 4000.00, 15000.00, 40000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"area_foto\",\"aksesibilitas\",\"mushola\",\"atm\"]', '-6.3046', '106.8201', 'ragunan.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(36, 'Pasar Beringharjo', 8, 'Yogyakarta, DI Yogyakarta', 'Pasar tradisional legendaris dengan batik, makanan, and oleh-oleh khas.', 0.00, 10000.00, 35000.00, '[\"toilet\",\"parkir\",\"souvenir\",\"warung\",\"area_foto\",\"aksesibilitas\",\"atm\"]', '-7.7988', '110.3671', 'beringharjo.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(37, 'Pasar Tanah Abang', 8, 'Jakarta Pusat, DKI Jakarta', 'Pasar grosir tekstil terbesar di Asia Tenggara dengan ribuan kios.', 0.00, 15000.00, 40000.00, '[\"toilet\",\"parkir\",\"souvenir\",\"restoran\",\"area_foto\",\"aksesibilitas\",\"atm\",\"mushola\"]', '-6.1856', '106.8108', 'tanahabang.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(38, 'Pasar Sukawati', 8, 'Gianyar, Bali', 'Pasar seni tradisional Bali with lukisan, patung, and kerajinan.', 0.00, 5000.00, 30000.00, '[\"toilet\",\"parkir\",\"souvenir\",\"warung\",\"area_foto\"]', '-8.6062', '115.2885', 'sukawati.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(39, 'Grand Indonesia', 8, 'Jakarta Pusat, DKI Jakarta', 'Mall premium dengan tenant internasional and entertainment center.', 0.00, 25000.00, 100000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"area_foto\",\"wifi\",\"aksesibilitas\",\"atm\",\"mushola\",\"bioskop\"]', '-6.1947', '106.8208', 'grand.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14'),
(40, 'Jalan Riau Bandung', 8, 'Bandung, Jawa Barat', 'Kawasan distro and fashion lokal dengan merek-merek kreatif Indonesia.', 0.00, 10000.00, 50000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"area_foto\",\"wifi\",\"atm\"]', '-6.9076', '107.6113', 'jalanriauband.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-08 04:23:14');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `place_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(100) NOT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` between 1 and 5),
  `comment` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`id`, `place_id`, `user_id`, `user_name`, `rating`, `comment`, `created_at`) VALUES
(1, 1, NULL, 'Ahmad Traveller', 5, 'Sunrise di puncak Merbabu benar-benar memukau. Sabana luasnya sangat indah!', '2026-05-07 06:59:45'),
(2, 5, NULL, 'Rina Explorer', 4, 'Bromo selalu magis. Saran: datang weekday untuk menghindari keramaian.', '2026-05-07 06:59:45'),
(3, 6, NULL, 'Budi Backpacker', 5, 'Desa Penglipuran sangat bersih and tenang. Arsitekturnya autentik.', '2026-05-07 06:59:45'),
(4, 11, NULL, 'Citra Culture', 5, 'Candi Borobudur pagi hari adalah pengalaman spiritual terbaik.', '2026-05-07 06:59:45'),
(5, 16, NULL, 'Dedi Foodie', 4, 'Malioboro malam hari sangat hidup. Angkringannya murah and enak.', '2026-05-07 06:59:45'),
(6, 1, 3, 'Ahmad Fauzi', 5, 'Sabana Merbabu benar-benar bikin speechless! Trek lumayan terjal tapi semua terbayar di puncak. Sunrise-nya surreal banget, kabutnya dramatis. Wajib bawa jaket tebal karena bisa di bawah 5°C malam hari.', '2026-03-15 05:30:00'),
(7, 1, 9, 'Hendra Gunawan', 4, 'Jalur Selo oke untuk pendaki pemula berbadan fit. Pemandangan sabana berlapis-lapisnya luar biasa. Sayang ada beberapa titik yang erosi cukup parah, semoga segera dibenahi. Bawa banyak air dan snack!', '2026-04-02 06:00:00'),
(8, 1, 11, 'Rizky Pratama', 5, 'Sudah 3x ke Merbabu dan tidak pernah bosan. Puncak Kenteng Songo memberikan view Merapi yang tiada tandingannya. Jangan lupa sewa guide lokal untuk keselamatan dan mendukung ekonomi masyarakat sekitar.', '2026-04-20 07:00:00'),
(9, 2, 4, 'Rina Kusuma', 5, 'Golden hour di Prau adalah pengalaman yang mengubah hidup! Lautan awan di pagi hari membuatku menangis haru. Ini gunung paling friendly untuk solo traveler karena sangat ramai dan aman. Trek 4 jam worth it banget!', '2026-02-10 05:00:00'),
(10, 2, 15, 'Bagas Wicaksono', 4, 'Camping di Prau dengan pemandangan Sindoro-Sumbing-Merapi-Merbabu berjejer adalah bucket list yang HARUS dicoret. Area sabana puncaknya luas jadi bisa kemping santai. Pastikan beli tiket online dulu karena sering habis.', '2026-03-25 06:30:00'),
(11, 2, 16, 'Nina Setiawati', 5, 'Solo trip pertama dan langsung jatuh cinta dengan Prau. Komunitas pendaki di sini sangat ramah dan saling membantu. Area sunrise-nya epic parah, stargazing malamnya juga magical. 11/10 will repeat!', '2026-04-15 05:15:00'),
(12, 3, 11, 'Rizky Pratama', 5, 'Ekspedisi Carstensz 2025 — mimpi yang akhirnya kesampaian! Butuh latihan 2 tahun, budget puluhan juta, dan mental baja. Tapi saat berdiri di 4.884 mdpl dengan gletser di sisi kiri kanan, semua pengorbanan tidak ada artinya. Indonesia punya surga di timur!', '2026-01-30 14:00:00'),
(13, 4, 8, 'Sari Puspita', 5, 'Hidden gem Gunungkidul yang masih sangat alami! Airnya jernih banget bisa langsung lihat karang dari permukaan. Tebing karst yang mengapit pantai bikin suasana sangat dramatis. Bawa bekal sendiri karena warung masih minim.', '2026-03-08 10:00:00'),
(14, 4, 16, 'Nina Setiawati', 4, 'Pantai ini memang tersembunyi tapi worth the effort! Trekking singkat 15 menit dari parkiran melewati jalan berbatu yang sedikit tricky. Snorkeling di sini luar biasa, banyak ikan warna-warni. Tidak ada sinyal HP yang justru bikin lebih menikmati alam.', '2026-04-12 11:00:00'),
(15, 5, 5, 'Budi Santoso', 5, 'Bromo saat golden hour adalah salah satu pemandangan paling dramatis yang pernah saya lihat. Asap kawah yang mengepul dengan latar lautan pasir dan Semeru di kejauhan adalah lukisan alam sesungguhnya. Datanglah di weekday dan pesanlah jeep dari jauh-jauh hari.', '2026-01-20 06:00:00'),
(16, 5, 13, 'Reza Mahendra', 4, 'Pengalaman seru tapi harus siap mental dengan keramaian di peak season. Jeep antrean panjang kalau weekend. Tips: booking jeep H-3, pilih spot Bukit Kingkong daripada Pananjakan untuk view yang lebih \"private\". Bawa masker karena debu pasir dan bau sulfur cukup kuat.', '2026-02-05 05:30:00'),
(17, 5, 3, 'Ahmad Fauzi', 3, 'Bromo memang indah tapi semakin komersil. Tarif jeep naik terus, pedagang di kawah semakin agresif, dan sampah di lautan pasir cukup mengganggu. Pemandangannya tetap luar biasa, tapi perlu regulasi wisata yang lebih ketat agar Bromo tetap lestari.', '2026-03-10 07:00:00'),
(18, 6, 8, 'Sari Puspita', 5, 'Desa paling bersih yang pernah saya kunjungi di Indonesia! Tidak ada asap kendaraan, tidak ada sampah berserakan. Warganya ramah dan senang berbagi cerita tentang tradisi mereka. Hutan bambunya sangat menenangkan jiwa. Sangat recommended untuk slow travel!', '2026-02-28 09:00:00'),
(19, 6, 6, 'Citra Dewi', 5, 'Penglipuran adalah Bali yang sesungguhnya — sebelum komersialisasi mengubah segalanya. Arsitekturnya konsisten dan terjaga dengan sangat baik. Cobalah loloh cemcem di warung Ibu Made, rasanya unik dan menyegarkan. Datanglah pagi hari sebelum banyak tour bus masuk.', '2026-03-22 08:30:00'),
(20, 7, 6, 'Citra Dewi', 5, 'Toraja adalah pengalaman budaya paling mendalam yang pernah saya alami. Menyaksikan langsung Rambu Solo mengubah perspektif saya tentang kehidupan dan kematian. Tau-tau di tebing Londa terasa magis dan sedikit menyeramkan. Sewa pemandu lokal — mereka adalah storyteller terbaik!', '2026-01-15 10:00:00'),
(21, 7, 17, 'Eko Prasetyo', 4, 'Toraja melampaui ekspektasi saya. Tongkonan-nya megah, persawahannya indah, dan orang-orangnya sangat hangat. Makanan khas seperti Pa\'piong (ikan/daging bambu bakar) dan kopi Toraja-nya premium. Butuh minimal 3 hari untuk menjelajahi area utama.', '2026-02-20 11:00:00'),
(22, 8, 10, 'Maya Rahayu', 4, 'Desa Sade memberi gambaran nyata kehidupan suku Sasak yang autentik. Proses tenun songket yang saya saksikan sangat memukau — butuh ketelitian dan kesabaran luar biasa. Beli kain tenun langsung dari pengrajinnya sebagai bentuk dukungan ekonomi lokal.', '2026-03-05 10:30:00'),
(23, 8, 8, 'Sari Puspita', 3, 'Menarik tapi sedikit terlalu touristy. Pedagang souvenir sangat agresif mengejar wisatawan. Proses tur terasa terburu-buru. Saran: datang saat bukan musim liburan dan minta pemandu yang lebih santai. Isi debu kotoran kerbau di lantai rumah memang unik tapi perlu dijelaskan lebih baik kepada pengunjung.', '2026-04-01 09:00:00'),
(24, 9, 10, 'Maya Rahayu', 5, 'Pertunjukan Kecak terbaik yang pernah saya tonton dan saya sudah menonton di beberapa tempat berbeda. Setting di tebing Uluwatu dengan sunset di latar belakang adalah kombinasi sempurna. Datanglah 45 menit sebelum pertunjukan untuk tempat duduk di barisan depan. Sangat worth the price!', '2026-01-25 17:00:00'),
(25, 9, 12, 'Fitri Handayani', 5, 'Kecak Uluwatu adalah seni yang membuat merinding! Kekompakan ratusan penari, gema suara \"cak\" yang resonan di tebing batu, dan api livin yang menyala saat klimaks cerita Ramayana — semua terasa magis dan spiritual. Pengalaman budaya Bali yang sesungguhnya tidak tergantikan.', '2026-02-18 18:00:00'),
(26, 10, 6, 'Citra Dewi', 5, 'Trek ke Waerebo adalah salah satu pengalaman terberat sekaligus terindah dalam hidup saya. 3,5 jam trekking naik turun hutan lebat, tapi saat Mbaru Niang muncul di lembah berkabut — semua rasa lelah langsung hilang. Menginap semalam dan menikmati sarapan bersama warga adalah momen tak terlupakan.', '2025-12-10 15:00:00'),
(27, 11, 12, 'Fitri Handayani', 5, 'Borobudur sunrise adalah pengalaman spiritual yang saya rekomendasikan kepada siapapun. Kabus pagi yang menyelimuti stupa saat matahari mulai muncul dari balik Gunung Merapi menciptakan suasana sakral yang luar biasa. Beli paket sunrise yang sudah termasuk pemandu untuk pengalaman lebih mendalam.', '2026-01-05 05:30:00'),
(28, 11, 17, 'Eko Prasetyo', 4, 'Warisan budaya dunia yang memang layak masuk bucket list! Reliefnya sangat detail dan menceritakan kisah yang kaya makna. Panas saat siang hari jadi datanglah pagi-pagi. Area parkir jauh dari candi jadi siapkan fisik untuk jalan. Pemandu resmi sangat membantu memahami konteks sejarahnya.', '2026-02-12 07:00:00'),
(29, 11, 7, 'Dedi Hermawan', 5, 'Kunjungan ketiga ke Borobudur dan selalu menemukan detail baru di relief-reliefnya. Stupa-stupa berlubang dengan patung Buddha di dalamnya sangat fotogenik saat golden hour. Jangan lupa kunjungi Candi Mendut yang jaraknya dekat — paket kombinasi tersedia dan worth it.', '2026-03-30 06:00:00'),
(30, 12, 14, 'Lina Marlina', 4, 'Kota Tua setelah revitalisasi jauh lebih nyaman! Trotoarnya lebar, bersih, dan photo-friendly. Naik sepeda onthel warna-warni adalah aktivitas yang sangat seru dan instagrammable. Museum Fatahillah wajib dikunjungi untuk memahami sejarah Batavia. Datanglah pagi hari sebelum panas menyengat.', '2026-02-22 09:00:00'),
(31, 12, 7, 'Dedi Hermawan', 3, 'Potensial besar tapi eksekusi masih setengah-setengah. Pedagang asongan masih cukup mengganggu, beberapa sudut masih kurang terawat. Museum-museumnya bagus tapi butuh pembaruan display agar lebih engaging. Kafe-kafe vintagenya enak dan Instagrammable. Harapan: semoga terus berkembang!', '2026-03-15 10:00:00'),
(32, 13, 13, 'Reza Mahendra', 4, 'Arsitektur Lawang Sewu sangat memukau — detail Art Nouveau-nya luar biasa apalagi kaca patri berwarnanya. Tur malam \"misteri\" yang ditawarkan pengelola lumayan seru meski lebih ke arah theatrical. Basement-nya memang mencekam dan bersejarah. Sangat recommended untuk pecinta heritage photography.', '2026-01-18 19:00:00'),
(33, 13, 15, 'Bagas Wicaksono', 5, 'Bangunan paling indah di Semarang! Bermandikan cahaya matahari sore yang masuk melalui ribuan kaca jendela berwarna — momen foto yang tidak akan bisa dilupakan. Penjelasan sejarah dari guide sangat informatif. Harga tiket sangat terjangkau untuk nilai heritage yang didapat.', '2026-03-05 16:00:00'),
(34, 14, 12, 'Fitri Handayani', 4, 'Museum diorama yang sangat edukatif! Perjuangan kemerdekaan Indonesia divisualisasikan dengan detail yang baik dan kronologis. Lokasinya yang tepat di ujung Malioboro membuatnya mudah dikombinasikan dengan wisata Malioboro. Harga tiketnya sangat murah — 3000 rupiah untuk nilai sejarah yang tak ternilai.', '2026-02-08 10:30:00'),
(35, 14, 5, 'Budi Santoso', 5, 'Benteng Vredeburg adalah destinasi wajib untuk memahami Jogja lebih dalam. Arsitektur bungker dan bastionnya masih terawat baik. Diorama pertempuran Jogja sangat dramatis dan membuat saya lebih menghargai para pejuang kemerdekaan. Halaman luarnya sering ada event budaya gratis!', '2026-04-05 09:30:00'),
(36, 15, 13, 'Reza Mahendra', 4, 'Istana yang unik karena perpaduan arsitektur multi-kulturalnya — Melayu, Arab, Eropa, India semua menyatu harmonis. Meriam Puntung di halaman punya legenda menarik tentang Putri Hijau. Koleksi kerajaan di dalam cukup terbatas tapi pemandunya bercerita dengan sangat hidup. Jangan lupa pakai baju rapi untuk masuk.', '2026-03-20 11:00:00'),
(37, 16, 10, 'Maya Rahayu', 5, 'Istiqlal bukan sekadar masjid tapi simbol kemegahan bangsa! Arsitektur modernnya terasa timeless. Yang paling berkesan adalah momen salat berjamaah — ribuan orang dari berbagai penjuru Indonesia bersatu dalam satu gerakan. Pemandu tur-nya informatif dan ramah kepada wisatawan non-Muslim.', '2026-01-10 14:00:00'),
(38, 16, 14, 'Lina Marlina', 4, 'Mengunjungi Istiqlal sebagai non-Muslim membuka wawasan yang luar biasa tentang Islam Indonesia yang moderat dan terbuka. Petugas sangat sopan memberikan penjelasan dan pakaian pinjaman tersedia. Lokasinya persis berhadapan dengan Gereja Katedral — kerukunan beragama yang hidup dan nyata.', '2026-02-16 10:00:00'),
(39, 17, 10, 'Maya Rahayu', 4, 'Pura induk Bali yang memang megah dan spiritual. Kompleksnya sangat luas jadi siapkan stamina ekstra. Pemandu wajib didampingi dan tarifnya cukup tinggi tapi necessary untuk menghormati adat. View Gunung Agung dari area pura sangat dramatis apalagi saat cuaca cerah.', '2026-02-25 09:30:00'),
(40, 17, 6, 'Citra Dewi', 5, 'Besakih adalah pengalaman spiritual Bali yang berbeda dari tempat lain. Saat upacara berlangsung, seluruh kompleks bergemuruh dengan mantram dan aroma dupa — sungguh sakral dan mengesankan. Hormatilah adat setempat dan kenakan kamen (kain) dengan benar. Sangat merekomendasikan kunjungan saat hari biasa, bukan saat upacara besar.', '2026-03-18 08:00:00'),
(41, 21, 14, 'Lina Marlina', 5, 'Malioboro malam hari adalah yang paling hidup! Angkringan dengan nasi kucing 3000-an dan teh jahe hangat sambil dengar musik jalanan adalah Jogja yang sesungguhnya. Harga tawar-menawar di pedagang kaki lima masih ada, jadi jangan ragu menawar dengan sopan. Ini destinasi yang tidak pernah membosankan.', '2026-01-28 19:30:00'),
(42, 21, 17, 'Eko Prasetyo', 4, 'Malioboro pasca revitalisasi lebih tertata tapi ada yang hilang — kesan semrawut yang justru itu khasnya. Pedagang kaki lima kini di satu sisi jalan, membuat pengalaman sedikit berbeda. Tapi tetap wajib dikunjungi! Jangan lupa mampir ke Pasar Beringharjo dan Benteng Vredeburg yang bersebelahan.', '2026-02-14 20:00:00'),
(43, 21, 4, 'Rina Kusuma', 5, 'Malioboro = jiwa Yogyakarta. Saya tidak pernah ke Jogja tanpa berjalan-jalan di sini setidaknya sekali. Bakpia pathok fresh dari toko langsung, gudeg dari warung Mbah Lindu, batik cap dari pedagang kaki lima — semuanya ada di sini. Wisata yang paling affordable dan paling kaya pengalaman.', '2026-03-28 18:00:00'),
(44, 26, 7, 'Dedi Hermawan', 4, 'Dufan masih jadi tema park terbaik untuk keluarga dengan budget yang cukup. Wahana Halilintar dan Tornado masih mendebarkan meski sudah lama. Antrian weekday jauh lebih pendek dari weekend. Tips: beli tiket online dan datang tepat saat buka untuk memaksimalkan waktu.', '2026-03-12 10:00:00'),
(45, 26, 14, 'Lina Marlina', 3, 'Beberapa wahana sudah cukup tua dan perlu pembaruan. Harga food court di dalam sangat mahal — 3x lipat harga normal. Tapi kalau bawa anak kecil mereka pasti senang. Semoga manajemen lebih fokus pada upgrade wahana dan fasilitas toilet yang lebih bersih.', '2026-04-08 14:00:00'),
(46, 27, 9, 'Hendra Gunawan', 4, 'Jatim Park komplex wisata yang sangat complete — dari edukasi sampai hiburan semua ada. Museum Satwa, Batu Secret Zoo, dan wahana permainannya semuanya berkualitas. Suasana Kota Batu yang sejuk bikin betah. Rencanakan minimal full day atau bahkan 2 hari untuk mengunjungi semuanya.', '2026-01-22 09:00:00'),
(47, 29, 9, 'Hendra Gunawan', 5, 'Waterbom Bali memang terbaik se-Asia dan saya tidak bisa membantah setelah mengunjunginya! Seluncuran Climax dan Smashdown benar-benar menantang adrenalin. Fasilitas sangat bersih dan terawat. Harganya memang premium tapi value for money. Sistem cashless dengan gelang chip sangat convenient.', '2026-02-03 11:00:00'),
(48, 31, 12, 'Fitri Handayani', 5, 'Museum Geologi Bandung adalah salah satu museum terbaik di Indonesia dalam hal konten dan display! Fosil manusia purba, tulang dinosaurus, koleksi meteorit, dan peta vulkanologi yang interaktif — semua tersaji dengan sangat baik. Tiketnya murah banget (3000 rupiah) untuk kualitas museum seperti ini. Wajib bawa anak ke sini!', '2026-02-06 10:00:00'),
(49, 32, 15, 'Bagas Wicaksono', 4, 'Taman Pintar adalah wisata edukasi terbaik di Yogyakarta untuk keluarga dengan anak-anak. Zona sains interaktifnya dirancang dengan baik dan membuat anak senang belajar. Planetarium di dalamnya juga tidak boleh dilewatkan. Bisa dikombinasikan dengan kunjungan ke Benteng Vredeburg dan Malioboro dalam satu hari.', '2026-03-02 10:30:00'),
(50, 34, 4, 'Rina Kusuma', 5, 'Museum MACAN adalah hidden gem Jakarta yang masih kurang dikenal! Koleksi seni modern dan kontemporer internasionalnya sangat impressive — ada karya Yayoi Kusama, Jean-Michel Basquiat, dan seniman Indonesia kelas dunia. Ruang Infinity Room-nya selalu ramai tapi worth the wait. Harga tiket wajar untuk standar museum internasional.', '2026-01-30 14:00:00'),
(51, 36, 14, 'Lina Marlina', 5, 'Beringharjo adalah surganya batik dengan harga paling bersahabat! Batik cap mulai 30 ribuan, batik tulis ratusan ribu dengan kualitas premium. Pandai-pandailah menawar dengan santai dan senyum. Juga banyak jajanan pasar tradisional yang enak seperti kipo, peyek, dan geplak. Ini pasar yang paling \"Jogja\" dari semua tempat di Jogja.', '2026-02-10 09:30:00'),
(52, 36, 16, 'Nina Setiawati', 4, 'Wajib masuk daftar belanja saat ke Jogja! Tapi persiapkan diri dengan kondisi pasar yang ramai, panas, dan sempit terutama weeked. Datanglah pagi hari untuk suasana lebih nyaman dan pilihan barang lebih lengkap sebelum diserbu pembeli lain. Jangan lupa coba dawet ireng di lantai bawah — segar banget!', '2026-03-20 10:00:00'),
(53, 35, 7, 'Dedi Hermawan', 4, 'Ragunan adalah kebun binatang terluas dan terbaik di Indonesia meski masih ada ruang untuk improvement dalam hal kandang hewan. Koleksi satwa asli Nusantara seperti komodo, orang utan, gajah, dan harimau Sumatera sangat lengkap. Bawa bekal sendiri, sewa sepeda atau mobil kelinci untuk keliling lebih efisien. Tiket masuknya sangat murah!', '2026-03-25 09:00:00'),
(54, 37, 14, 'Lina Marlina', 3, 'Surga belanja grosir yang penuh tantangan! Harga memang sangat murah tapi kondisi fisik pasar panas, sempit, dan padat. Lift dan eskalator sering tidak berfungsi. Tapi kalau tahu cara navigasinya dan pandai mencari, bisa dapat baju branded KW berkualitas bagus atau bahan tekstil premium dengan harga grosir. Datanglah bukan hari Senin (hari libur pasar).', '2026-02-18 10:00:00'),
(55, 39, 4, 'Rina Kusuma', 5, 'Grand Indonesia tetap menjadi raja mal Jakarta! Tenant internasional tier-1 semua ada, area entertainmentnya luas, dan food court-nya sangat beragam dari kelas warteg hingga fine dining. Lokasi di jantung Jakarta sangat strategis dengan akses MRT Bundaran HI. Tempat hangout premium yang tidak membosankan.', '2026-04-10 14:00:00'),
(56, 25, 17, 'Eko Prasetyo', 4, 'Simpang Lima adalah jantung kota Semarang yang hidup 24 jam! Sore-malam adalah waktu terbaik ketika banyak pedagang kuliner malam buka. Lumpia, tahu gimbal, soto Semarang — semuanya ada di sekitar alun-alun. Suasana kota yang ramai dengan lampu-lampu malam menciptakan vibes urban yang menarik.', '2026-04-22 19:00:00'),
(57, 24, 13, 'Reza Mahendra', 4, 'Kawasan Pecinan Surabaya yang autentik! Masakan Tionghoa seperti Rawon Setan, Lontong Balap, dan Es Teler-nya khas banget. Suasana malam dengan lampion merah dan pedagang yang berteriak menambah keseruan. Kombinasikan dengan kunjungan ke House of Sampoerna yang berada tidak jauh dari sini.', '2026-03-17 18:30:00'),
(58, 18, 12, 'Fitri Handayani', 5, 'Gereja Blenduk adalah landmark paling ikonik Kota Lama Semarang! Kubah tembaganya yang menghijau karena oksidasi sangat fotogenik. Interior gereja bergaya neo-klasik dengan orgen pipa antik masih terawat sangat baik. Kawasan Kota Lama di sekitarnya kini semakin dipercantik dan banyak kafe heritage bermunculan.', '2026-01-12 11:00:00'),
(59, 33, 5, 'Budi Santoso', 4, 'Seaworld Ancol menghadirkan pengalaman bawah laut yang impressive tanpa harus menyelam! Terowongan akrilik bawah air dengan ikan hiu, pari, dan ribuan ikan tropis adalah highlight utama. Pertunjukan feeding time menarik untuk disaksikan. Sering ada paket combo dengan Dufan yang lebih hemat.', '2026-04-18 13:00:00'),
(60, 9, 1, '', 4, 'bagus keren', '2026-05-11 15:06:11');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `full_name`, `role`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'admin@viuspot.id', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Viuspot Administrator', 'admin', '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(2, 'uuy', 'alfarizireyhan5@gmail.com', '$2y$10$UStzzjyzXdrlF0BMu0gu4edEgqICpNDStw5KivdW8ffBg5Cw6FVyq', 'boy', 'user', '2026-05-07 08:08:54', '2026-05-07 08:08:54'),
(3, 'ahmad_traveller', 'ahmad@example.com', '$2y$10$dummyhashAhmad', 'Ahmad Fauzi', 'user', '2025-08-01 08:00:00', '2026-05-07 09:00:00'),
(4, 'rina_explorer', 'rina@example.com', '$2y$10$dummyhashRina', 'Rina Kusuma', 'user', '2025-08-15 09:00:00', '2026-05-07 09:00:00'),
(5, 'budi_backpacker', 'budi@example.com', '$2y$10$dummyhashBudi', 'Budi Santoso', 'user', '2025-09-01 07:00:00', '2026-05-07 09:00:00'),
(6, 'citra_culture', 'citra@example.com', '$2y$10$dummyhashCitra', 'Citra Dewi', 'user', '2025-09-10 10:00:00', '2026-05-07 09:00:00'),
(7, 'dedi_foodie', 'dedi@example.com', '$2y$10$dummyhashDedi', 'Dedi Hermawan', 'user', '2025-10-01 11:00:00', '2026-05-07 09:00:00'),
(8, 'sari_wanderer', 'sari@example.com', '$2y$10$dummyhashSari', 'Sari Puspita', 'user', '2025-10-15 08:30:00', '2026-05-07 09:00:00'),
(9, 'hendra_adventures', 'hendra@example.com', '$2y$10$dummyhashHendra', 'Hendra Gunawan', 'user', '2025-11-01 06:00:00', '2026-05-07 09:00:00'),
(10, 'maya_pilgrim', 'maya@example.com', '$2y$10$dummyhashMaya', 'Maya Rahayu', 'user', '2025-11-20 14:00:00', '2026-05-07 09:00:00'),
(11, 'rizky_summit', 'rizky@example.com', '$2y$10$dummyhashRizky', 'Rizky Pratama', 'user', '2025-12-01 05:00:00', '2026-05-07 09:00:00'),
(12, 'fitri_heritage', 'fitri@example.com', '$2y$10$dummyhashFitri', 'Fitri Handayani', 'user', '2025-12-10 09:00:00', '2026-05-07 09:00:00'),
(13, 'reza_snapshot', 'reza@example.com', '$2y$10$dummyhashReza', 'Reza Mahendra', 'user', '2026-01-05 07:00:00', '2026-05-07 09:00:00'),
(14, 'lina_foodhunter', 'lina@example.com', '$2y$10$dummyhashLina', 'Lina Marlina', 'user', '2026-01-20 12:00:00', '2026-05-07 09:00:00'),
(15, 'bagas_trailblazer', 'bagas@example.com', '$2y$10$dummyhashBagas', 'Bagas Wicaksono', 'user', '2026-02-01 06:30:00', '2026-05-07 09:00:00'),
(16, 'nina_nomad', 'nina@example.com', '$2y$10$dummyhashNina', 'Nina Setiawati', 'user', '2026-02-14 10:00:00', '2026-05-07 09:00:00'),
(17, 'eko_roamer', 'eko@example.com', '$2y$10$dummyhashEko', 'Eko Prasetyo', 'user', '2026-03-01 08:00:00', '2026-05-07 09:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `user_badges`
--

CREATE TABLE `user_badges` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `badge_id` int(11) NOT NULL,
  `earned_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_badges`
--

INSERT INTO `user_badges` (`id`, `user_id`, `badge_id`, `earned_at`) VALUES
(1, 3, 1, '2026-03-16 07:00:00'),
(2, 4, 1, '2026-02-11 06:00:00'),
(3, 4, 2, '2026-04-07 09:00:00'),
(4, 5, 1, '2026-01-21 07:00:00'),
(5, 6, 1, '2025-12-11 16:00:00'),
(6, 6, 2, '2026-02-26 10:00:00'),
(7, 7, 1, '2025-12-11 16:00:00'),
(8, 8, 1, '2026-02-28 10:00:00'),
(9, 9, 1, '2026-01-23 10:00:00'),
(10, 10, 1, '2026-01-11 15:00:00'),
(11, 11, 1, '2026-01-31 15:00:00'),
(12, 11, 2, '2026-04-21 08:00:00'),
(13, 12, 1, '2026-01-06 06:00:00'),
(14, 12, 2, '2026-03-03 11:00:00'),
(15, 13, 1, '2026-01-19 20:00:00'),
(16, 14, 1, '2026-01-29 13:00:00'),
(17, 14, 2, '2026-02-19 11:00:00'),
(18, 15, 1, '2025-12-11 07:00:00'),
(19, 16, 1, '2026-02-15 09:00:00'),
(20, 17, 1, '2026-03-02 09:00:00'),
(30, 1, 1, '2026-05-11 15:06:11');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `badges`
--
ALTER TABLE `badges`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `crowd_reports`
--
ALTER TABLE `crowd_reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `place_id` (`place_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `forum_replies`
--
ALTER TABLE `forum_replies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `topic_id` (`topic_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `fk_parent_reply` (`parent_reply_id`);

--
-- Indexes for table `forum_topics`
--
ALTER TABLE `forum_topics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `itineraries`
--
ALTER TABLE `itineraries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `itinerary_items`
--
ALTER TABLE `itinerary_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `itinerary_id` (`itinerary_id`),
  ADD KEY `place_id` (`place_id`);

--
-- Indexes for table `places`
--
ALTER TABLE `places`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `submitted_by` (`submitted_by`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `place_id` (`place_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_badges`
--
ALTER TABLE `user_badges`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_badge` (`user_id`,`badge_id`),
  ADD KEY `badge_id` (`badge_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `badges`
--
ALTER TABLE `badges`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `crowd_reports`
--
ALTER TABLE `crowd_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `forum_replies`
--
ALTER TABLE `forum_replies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `forum_topics`
--
ALTER TABLE `forum_topics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `itineraries`
--
ALTER TABLE `itineraries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `itinerary_items`
--
ALTER TABLE `itinerary_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `places`
--
ALTER TABLE `places`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `user_badges`
--
ALTER TABLE `user_badges`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `crowd_reports`
--
ALTER TABLE `crowd_reports`
  ADD CONSTRAINT `crowd_reports_ibfk_1` FOREIGN KEY (`place_id`) REFERENCES `places` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `crowd_reports_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `forum_replies`
--
ALTER TABLE `forum_replies`
  ADD CONSTRAINT `fk_parent_reply` FOREIGN KEY (`parent_reply_id`) REFERENCES `forum_replies` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `forum_replies_ibfk_1` FOREIGN KEY (`topic_id`) REFERENCES `forum_topics` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `forum_replies_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `forum_topics`
--
ALTER TABLE `forum_topics`
  ADD CONSTRAINT `forum_topics_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `itineraries`
--
ALTER TABLE `itineraries`
  ADD CONSTRAINT `itineraries_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `itinerary_items`
--
ALTER TABLE `itinerary_items`
  ADD CONSTRAINT `itinerary_items_ibfk_1` FOREIGN KEY (`itinerary_id`) REFERENCES `itineraries` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `itinerary_items_ibfk_2` FOREIGN KEY (`place_id`) REFERENCES `places` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `places`
--
ALTER TABLE `places`
  ADD CONSTRAINT `places_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `places_ibfk_2` FOREIGN KEY (`submitted_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`place_id`) REFERENCES `places` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `user_badges`
--
ALTER TABLE `user_badges`
  ADD CONSTRAINT `user_badges_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_badges_ibfk_2` FOREIGN KEY (`badge_id`) REFERENCES `badges` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
