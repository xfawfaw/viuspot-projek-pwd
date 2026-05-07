-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 07, 2026 at 10:45 AM
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
(2, 11, NULL, 'Heritage Lover', 'moderate', 15, 'Tiket masuk lancar. Area candi cukup ramai tapi nyaman.', '2026-05-07 06:59:45');

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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `forum_topics`
--

INSERT INTO `forum_topics` (`id`, `user_id`, `user_name`, `title`, `content`, `destination`, `travel_date`, `category`, `views`, `status`, `created_at`) VALUES
(1, NULL, 'Wisatawan Solo', 'Cari teman trip ke Bromo Mei ini', 'Halo, saya berencana ke Bromo tanggal 15-17 Mei. Ada yang mau join sharing jeep and penginapan?', 'Gunung Bromo', '2026-05-15', 'Diskusi', 0, 'open', '2026-05-07 06:59:45'),
(2, NULL, 'Backpacker Jogja', 'Sharing cost ke Dieng dari Yogyakarta', 'Mau ke Dieng untuk sunrise Gunung Prau. Cari 2 orang untuk sharing mobil. Budget 300K/orang PP.', 'Gunung Prau', '2026-05-10', 'Diskusi', 0, 'open', '2026-05-07 06:59:45');

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
(1, 'Gunung Merbabu', 1, 'Magelang, Jawa Tengah', 'Gunung berapi kerucut dengan pemandangan matahari terbit yang spektakuler dan sabana luas.', 25000.00, 15000.00, 35000.00, NULL, '-7.4531', '110.4394', 'merbabu.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(2, 'Gunung Prau', 1, 'Dieng, Jawa Tengah', 'Gunung dengan padang savana terluas di Indonesia dan pemandangan matahari terbit 360 derajat.', 15000.00, 10000.00, 30000.00, NULL, '-7.1911', '109.9072', 'prau.png', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(3, 'Cartenz Piramid', 1, 'Papua Pegunungan', 'Puncak tertinggi di Indonesia dengan salju abadi dan keindahan alam ekstrem.', 100000.00, 50000.00, 80000.00, NULL, '-4.0789', '137.1583', 'cartenz.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(4, 'Pantai Ngetun', 1, 'Gunung Kidul, Yogyakarta', 'Pantai tersembunyi dengan tebing karst dan air laut jernih berwarna biru kehijauan.', 10000.00, 5000.00, 25000.00, NULL, '-8.1345', '110.5678', 'ngetun.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(5, 'Gunung Bromo', 1, 'Probolinggo, Jawa Timur', 'Gunung berapi aktif yang terkenal dengan lautan pasir dan matahari terbit magis.', 35000.00, 25000.00, 40000.00, '[\"toilet\",\"parkir\",\"restoran\",\"mushola\",\"souvenir\",\"pemandu\"]', '-7.9425', '112.9530', 'bromo.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 07:16:38'),
(6, 'Desa Penglipuran', 2, 'Bangli, Bali', 'Desa adat Bali dengan arsitektur tradisional, jalan batu, dan tata ruang unik.', 25000.00, 5000.00, 30000.00, NULL, '-8.4238', '115.3564', 'panglipuran.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(7, 'Tana Toraja', 2, 'Sulawesi Selatan', 'Daerah dengan tradisi pemakunan unik, rumah adat tongkonan, dan pemandangan spektakuler.', 50000.00, 15000.00, 40000.00, NULL, '-3.0672', '119.8230', 'toraja.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(8, 'Desa Sade', 2, 'Lombok, NTB', 'Desa tradisional suku Sasak dengan rumah panggung beratap ilalang.', 15000.00, 5000.00, 25000.00, NULL, '-8.8945', '116.2876', 'sade.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(9, 'Tari Kecak Uluwatu', 2, 'Badung, Bali', 'Pertunjukan tari kecak dramatari Ramayana di tebing Uluwatu saat matahari terbenam.', 150000.00, 20000.00, 50000.00, NULL, '-8.8291', '115.0849', 'uluwatu.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(10, 'Desa Waerebo', 2, 'Manggarai, NTT', 'Desa tradisional dengan rumah adat Mbaru Niang berbentuk kerucut.', 50000.00, 0.00, 35000.00, NULL, '-8.7380', '120.5260', 'werebo.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(11, 'Candi Borobudur', 3, 'Magelang, Jawa Tengah', 'Candi Buddha terbesar di dunia dengan relief cermat dan stupa induk megah.', 50000.00, 15000.00, 35000.00, '[\"toilet\",\"parkir\",\"souvenir\",\"pemandu\",\"aksesibilitas\"]', '-7.6079', '110.2038', 'borobudur.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 07:16:38'),
(12, 'Kota Tua Jakarta', 3, 'Jakarta Barat, DKI Jakarta', 'Kawasan bersejarah dengan bangunan kolonial Belanda, museum, dan kafe vintage.', 0.00, 20000.00, 50000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"area_foto\",\"aksesibilitas\"]', '-6.1376', '106.8171', 'kotatua.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 07:16:38'),
(13, 'Lawang Sewu', 3, 'Semarang, Jawa Tengah', 'Gedung bersejarah dengan 1000 pintu dan sejarah angker yang kaya.', 10000.00, 10000.00, 35000.00, NULL, '-6.9840', '110.4105', 'lawangsewu.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(14, 'Benteng Vredeburg', 3, 'Yogyakarta, DI Yogyakarta', 'Benteng peninggalan Belanda yang kini menjadi museum sejarah perjuangan.', 3000.00, 5000.00, 30000.00, NULL, '-7.8003', '110.3665', 'vredeburg.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(15, 'Istana Maimun', 3, 'Medan, Sumatera Utara', 'Istana kerajaan Deli dengan arsitektur Melayu, India, Spanyol, dan Italia.', 10000.00, 5000.00, 40000.00, NULL, '3.5753', '98.6835', 'maimun.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(16, 'Masjid Istiqlal', 4, 'Jakarta Pusat, DKI Jakarta', 'Masjid nasional terbesar di Asia Tenggara with arsitektur modern megah.', 0.00, 0.00, 40000.00, '[\"toilet\",\"parkir\",\"mushola\",\"aksesibilitas\",\"area_foto\"]', '-6.1702', '106.8310', 'istiqlal.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 07:16:38'),
(17, 'Pura Besakih', 4, 'Karangasem, Bali', 'Pura induk terbesar dan paling suci di Bali, berlokasi di lereng Gunung Agung.', 60000.00, 10000.00, 35000.00, NULL, '-8.3739', '115.4567', 'besakih.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(18, 'Gereja Blenduk', 4, 'Semarang, Jawa Tengah', 'Gereja protestan bersejarah dengan kubah tembaga ikonik di Kota Lama.', 0.00, 10000.00, 35000.00, NULL, '-6.9682', '110.4275', 'blenduk.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(19, 'Makam Sunan Kalijaga', 4, 'Demak, Jawa Tengah', 'Makam wali songo dengan sejarah Islam yang dalam dan arsitektur tradisional.', 0.00, 5000.00, 25000.00, NULL, '-6.8940', '110.6370', 'makamsunan.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(20, 'Vihara Dhanagun', 4, 'Bogor, Jawa Barat', 'Vihara tertua dan terbesar di Bogor dengan patung Buddha raksasa.', 0.00, 5000.00, 30000.00, NULL, '-6.5950', '106.7896', 'vihara.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(21, 'Malioboro', 5, 'Yogyakarta, DI Yogyakarta', 'Jalan legendaris dengan kuliner malam, angkringan, and oleh-oleh khas.', 0.00, 15000.00, 50000.00, '[\"toilet\",\"parkir\",\"restoran\",\"souvenir\",\"pemandu\"]', '-7.7930', '110.3658', 'malioboro.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 07:16:38'),
(22, 'Pasar Cihapit', 5, 'Bandung, Jawa Barat', 'Pusat kuliner kaki lima legendaris dengan makanan Sund autentik.', 0.00, 10000.00, 35000.00, NULL, '-6.9034', '107.6201', 'chiapit.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(23, 'Jalan Sabang', 5, 'Jakarta Pusat, DKI Jakarta', 'Surga kuliner malam dengan beragam warung tenda dan makanan nusantara.', 0.00, 15000.00, 45000.00, NULL, '-6.1850', '106.8320', 'sabang.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(24, 'Kya-Kya Surabaya', 5, 'Surabaya, Jawa Timur', 'Kawasan wisata kuliner Chinatown dengan makanan Tionghoa autentik.', 0.00, 10000.00, 40000.00, NULL, '-7.2370', '112.7378', 'kyakya.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(25, 'Simpang Lima Semarang', 5, 'Semarang, Jawa Tengah', 'Alun-alun kota dengan food court, kuliner malam, and pemandangan urban.', 0.00, 5000.00, 35000.00, NULL, '-6.9845', '110.4108', 'simpangsemarang.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(26, 'Dufan Ancol', 6, 'Jakarta Utara, DKI Jakarta', 'Taman hiburan terbesar di Indonesia dengan wahana ekstrem dan edukasi.', 295000.00, 25000.00, 75000.00, NULL, '-6.1256', '106.8382', 'dufan.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(27, 'Jatim Park', 6, 'Batu, Jawa Timur', 'Kompleks wisata edutainment dengan wahana modern dan museum unik.', 150000.00, 20000.00, 60000.00, NULL, '-7.8806', '112.5246', 'jpark.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(28, 'Trans Studio', 6, 'Makassar, Sulawesi Selatan', 'Indoor theme park terbesar dengan wahana berteknologi tinggi.', 200000.00, 15000.00, 60000.00, NULL, '-5.1584', '119.4128', 'trans.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(29, 'Waterbom Bali', 6, 'Kuta, Bali', 'Taman air terbaik di Asia dengan seluncuran spektakuler.', 520000.00, 0.00, 80000.00, NULL, '-8.7610', '115.1690', 'waterboom.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(30, 'Saloka Park', 6, 'Semarang, Jawa Tengah', 'Theme park dengan nuansa lokal Jawa and wahana keluarga.', 150000.00, 15000.00, 50000.00, NULL, '-7.2820', '110.4778', 'saloka.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(31, 'Museum Geologi', 7, 'Bandung, Jawa Barat', 'Museum geologi lengkap dengan fosil, meteorit, and informasi vulkanologi.', 3000.00, 5000.00, 35000.00, NULL, '-6.9007', '107.6215', 'geologi.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(32, 'Taman Pintar', 7, 'Yogyakarta, DI Yogyakarta', 'Pusat edukasi interaktif untuk anak and keluarga dengan science center.', 7000.00, 10000.00, 30000.00, NULL, '-7.8005', '110.3689', 'tamanpintar.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(33, 'Seaworld Ancol', 7, 'Jakarta Utara, DKI Jakarta', 'Akuarium laut terbesar dengan terowongan bawah air and pertunjukan ikan.', 115000.00, 25000.00, 60000.00, NULL, '-6.1262', '106.8361', 'seaworld.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(34, 'Museum MACAN', 7, 'Jakarta Barat, DKI Jakarta', 'Museum seni modern and kontemporer dengan koleksi internasional.', 140000.00, 10000.00, 50000.00, NULL, '-6.1767', '106.7896', 'mmacan.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(35, 'Ragunan', 7, 'Jakarta Selatan, DKI Jakarta', 'Kebun binatang terluas di Indonesia dengan koleksi fauna nusantara.', 4000.00, 15000.00, 35000.00, NULL, '-6.3046', '106.8201', 'ragunan.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(36, 'Pasar Beringharjo', 8, 'Yogyakarta, DI Yogyakarta', 'Pasar tradisional legendaris dengan batik, makanan, and oleh-oleh khas.', 0.00, 10000.00, 30000.00, NULL, '-7.7988', '110.3671', 'beringharjo.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(37, 'Pasar Tanah Abang', 8, 'Jakarta Pusat, DKI Jakarta', 'Pasar grosir tekstil terbesar di Asia Tenggara dengan ribuan kios.', 0.00, 15000.00, 35000.00, NULL, '-6.1856', '106.8108', 'tanahabang.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(38, 'Pasar Sukawati', 8, 'Gianyar, Bali', 'Pasar seni tradisional Bali with lukisan, patung, and kerajinan.', 0.00, 5000.00, 25000.00, NULL, '-8.6062', '115.2885', 'sukawati.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(39, 'Grand Indonesia', 8, 'Jakarta Pusat, DKI Jakarta', 'Mall premium dengan tenant internasional and entertainment center.', 0.00, 20000.00, 80000.00, NULL, '-6.1947', '106.8208', 'grand.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45'),
(40, 'Jalan Riau Bandung', 8, 'Bandung, Jawa Barat', 'Kawasan distro and fashion lokal dengan merek-merek kreatif Indonesia.', 0.00, 10000.00, 40000.00, NULL, '-6.9076', '107.6113', 'jalanriauband.jpg', 'approved', NULL, '2026-05-07 06:59:45', '2026-05-07 06:59:45');

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
(5, 16, NULL, 'Dedi Foodie', 4, 'Malioboro malam hari sangat hidup. Angkringannya murah and enak.', '2026-05-07 06:59:45');

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
(2, 'uuy', 'alfarizireyhan5@gmail.com', '$2y$10$UStzzjyzXdrlF0BMu0gu4edEgqICpNDStw5KivdW8ffBg5Cw6FVyq', 'boy', 'user', '2026-05-07 08:08:54', '2026-05-07 08:08:54');

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

-- --------------------------------------------------------

--
-- Table structure for table `weather_cache`
--

CREATE TABLE `weather_cache` (
  `id` int(11) NOT NULL,
  `place_id` int(11) NOT NULL,
  `temperature` decimal(5,2) DEFAULT NULL,
  `condition_text` varchar(100) DEFAULT NULL,
  `humidity` int(11) DEFAULT NULL,
  `wind_speed` decimal(5,2) DEFAULT NULL,
  `cached_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `weather_cache`
--

INSERT INTO `weather_cache` (`id`, `place_id`, `temperature`, `condition_text`, `humidity`, `wind_speed`, `cached_at`) VALUES
(1, 5, 35.00, 'Berawan', 61, 16.00, '2026-05-07 07:01:36'),
(2, 21, 32.00, 'Cerah Berawan', 58, 13.00, '2026-05-07 07:20:48');

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
  ADD KEY `user_id` (`user_id`);

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
-- Indexes for table `weather_cache`
--
ALTER TABLE `weather_cache`
  ADD PRIMARY KEY (`id`),
  ADD KEY `place_id` (`place_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `forum_replies`
--
ALTER TABLE `forum_replies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `forum_topics`
--
ALTER TABLE `forum_topics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `itineraries`
--
ALTER TABLE `itineraries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `itinerary_items`
--
ALTER TABLE `itinerary_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `places`
--
ALTER TABLE `places`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user_badges`
--
ALTER TABLE `user_badges`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `weather_cache`
--
ALTER TABLE `weather_cache`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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

--
-- Constraints for table `weather_cache`
--
ALTER TABLE `weather_cache`
  ADD CONSTRAINT `weather_cache_ibfk_1` FOREIGN KEY (`place_id`) REFERENCES `places` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
