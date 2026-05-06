-- ============================================================
-- VIUSPOT - Indonesian Tourism Information & Review System
-- SQL Schema with Seeded Data
-- ============================================================

CREATE DATABASE IF NOT EXISTS viuspot CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE viuspot;

-- ============================================================
-- 1. USERS TABLE
-- ============================================================
CREATE TABLE users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(50) NOT NULL UNIQUE,
    email         VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name     VARCHAR(100) NOT NULL,
    role          ENUM('user', 'admin') DEFAULT 'user',
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- 2. CATEGORIES TABLE
-- ============================================================
CREATE TABLE categories (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL UNIQUE,
    slug        VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    icon        VARCHAR(50) DEFAULT 'map-pin'
) ENGINE=InnoDB;

-- ============================================================
-- 3. PLACES (ATTRACTIONS) TABLE
-- ============================================================
CREATE TABLE places (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(150) NOT NULL,
    category_id  INT NOT NULL,
    location     VARCHAR(200) NOT NULL,
    description  TEXT,
    entrance_fee DECIMAL(10, 2) DEFAULT 0,
    parking_fee  DECIMAL(10, 2) DEFAULT 0,
    meal_cost    DECIMAL(10, 2) DEFAULT 0,
    latitude     VARCHAR(20),
    longitude    VARCHAR(20),
    image_url    VARCHAR(255) DEFAULT '',
    status       ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    submitted_by INT,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id)  REFERENCES categories(id) ON DELETE CASCADE,
    FOREIGN KEY (submitted_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================================
-- 4. REVIEWS TABLE
-- ============================================================
CREATE TABLE reviews (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    place_id   INT NOT NULL,
    user_id    INT,
    user_name  VARCHAR(100) NOT NULL,
    rating     INT CHECK (rating BETWEEN 1 AND 5),
    comment    TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (place_id) REFERENCES places(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================================
-- 5. ITINERARIES TABLE
-- ============================================================
CREATE TABLE itineraries (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT,
    title       VARCHAR(150) NOT NULL,
    travel_date DATE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================================
-- 6. ITINERARY ITEMS TABLE
-- ============================================================
CREATE TABLE itinerary_items (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    itinerary_id INT NOT NULL,
    place_id     INT NOT NULL,
    day_number   INT NOT NULL DEFAULT 1,
    time_slot    VARCHAR(50) NOT NULL,
    notes        TEXT,
    FOREIGN KEY (itinerary_id) REFERENCES itineraries(id) ON DELETE CASCADE,
    FOREIGN KEY (place_id)     REFERENCES places(id)     ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 7. BADGES TABLE
-- ============================================================
CREATE TABLE badges (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255) NOT NULL,
    min_reviews INT NOT NULL,
    icon        VARCHAR(50) DEFAULT 'award'
) ENGINE=InnoDB;

-- ============================================================
-- 8. USER BADGES TABLE
-- ============================================================
CREATE TABLE user_badges (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    user_id   INT NOT NULL,
    badge_id  INT NOT NULL,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE CASCADE,
    FOREIGN KEY (badge_id) REFERENCES badges(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_badge (user_id, badge_id)
) ENGINE=InnoDB;

-- ============================================================
-- 9. FORUM TOPICS TABLE (Travel Buddy)
-- ============================================================
CREATE TABLE forum_topics (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT,
    user_name   VARCHAR(100) NOT NULL,
    title       VARCHAR(200) NOT NULL,
    content     TEXT NOT NULL,
    destination VARCHAR(100),
    travel_date DATE,
    category    VARCHAR(50) DEFAULT 'Diskusi',
    views       INT DEFAULT 0,
    status      ENUM('open', 'closed') DEFAULT 'open',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================================
-- 10. FORUM REPLIES TABLE
-- ============================================================
CREATE TABLE forum_replies (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    topic_id   INT NOT NULL,
    user_id    INT,
    user_name  VARCHAR(100) NOT NULL,
    content    TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (topic_id) REFERENCES forum_topics(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id)  REFERENCES users(id)       ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================================
-- 11. CROWD REPORTS TABLE
-- ============================================================
CREATE TABLE crowd_reports (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    place_id    INT NOT NULL,
    user_id     INT,
    user_name   VARCHAR(100) NOT NULL,
    crowd_level ENUM('low', 'moderate', 'high', 'very_high') NOT NULL,
    wait_time   INT DEFAULT 0,
    notes       TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (place_id) REFERENCES places(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================================
-- 12. WEATHER CACHE TABLE
-- ============================================================
CREATE TABLE weather_cache (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    place_id       INT NOT NULL,
    temperature    DECIMAL(5, 2),
    condition_text VARCHAR(100),
    humidity       INT,
    wind_speed     DECIMAL(5, 2),
    cached_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (place_id) REFERENCES places(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- SEED DATA: CATEGORIES
-- ============================================================
INSERT INTO categories (name, slug, description, icon) VALUES
('Nature', 'nature', 'Keindahan alam Indonesia dari pegunungan hingga pantai', 'mountain'),
('Culture', 'culture', 'Warisan budaya dan tradisi masyarakat Indonesia', 'users'),
('History', 'history', 'Situs bersejarah dan cagar budaya nasional', 'landmark'),
('Religious', 'religious', 'Tempat ibadah dan wisata rohani', 'heart'),
('Culinary', 'culinary', 'Surga kuliner dan wisata makanan khas', 'utensils'),
('Entertainment', 'entertainment', 'Taman hiburan dan tempat rekreasi modern', 'smile'),
('Education', 'education', 'Museum dan tempat wisata edukasi', 'book'),
('Shopping', 'shopping', 'Pusat perbelanjaan dan pasar tradisional', 'shopping-bag');

-- ============================================================
-- SEED DATA: BADGES
-- ============================================================
INSERT INTO badges (name, description, min_reviews, icon) VALUES
('Tourist', 'Pengguna baru yang mulai menjelajah', 1, 'user'),
('Backpacker', 'Traveler aktif dengan 5+ ulasan', 5, 'backpack'),
('Wanderer', 'Penjelajah dengan 15+ ulasan', 15, 'compass'),
('Explorer', 'Petualang berpengalaman dengan 45+ ulasan', 45, 'map'),
('Explorer Legend', 'Legenda wisata Indonesia dengan 80+ ulasan', 80, 'crown');

-- ============================================================
-- SEED DATA: ADMIN USER
-- ============================================================
INSERT INTO users (username, email, password_hash, full_name, role) VALUES
('admin', 'admin@viuspot.id', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Viuspot Administrator', 'admin');

-- ============================================================
-- SEED DATA: PLACES (40 ATTRACTIONS)
-- ============================================================

-- NATURE
INSERT INTO places (name, category_id, location, description, entrance_fee, parking_fee, meal_cost, latitude, longitude, image_url, status) VALUES
('Gunung Merbabu', 1, 'Magelang, Jawa Tengah', 'Gunung berapi kerucut dengan pemandangan matahari terbit yang spektakuler dan sabana luas.', 25000, 15000, 35000, '-7.4531', '110.4394', 'merbabu.jpg', 'approved'),
('Gunung Prau', 1, 'Dieng, Jawa Tengah', 'Gunung dengan padang savana terluas di Indonesia dan pemandangan matahari terbit 360 derajat.', 15000, 10000, 30000, '-7.1911', '109.9072', 'prau.png', 'approved'),
('Cartenz Piramid', 1, 'Papua Pegunungan', 'Puncak tertinggi di Indonesia dengan salju abadi dan keindahan alam ekstrem.', 100000, 50000, 80000, '-4.0789', '137.1583', 'cartenz.jpg', 'approved'),
('Pantai Ngetun', 1, 'Gunung Kidul, Yogyakarta', 'Pantai tersembunyi dengan tebing karst dan air laut jernih berwarna biru kehijauan.', 10000, 5000, 25000, '-8.1345', '110.5678', 'ngetun.jpg', 'approved'),
('Gunung Bromo', 1, 'Probolinggo, Jawa Timur', 'Gunung berapi aktif yang terkenal dengan lautan pasir dan matahari terbit magis.', 35000, 25000, 40000, '-7.9425', '112.9530', 'bromo.jpg', 'approved');

-- CULTURE
INSERT INTO places (name, category_id, location, description, entrance_fee, parking_fee, meal_cost, latitude, longitude, image_url, status) VALUES
('Desa Penglipuran', 2, 'Bangli, Bali', 'Desa adat Bali dengan arsitektur tradisional, jalan batu, dan tata ruang unik.', 25000, 5000, 30000, '-8.4238', '115.3564', 'panglipuran.jpg', 'approved'),
('Tana Toraja', 2, 'Sulawesi Selatan', 'Daerah dengan tradisi pemakunan unik, rumah adat tongkonan, dan pemandangan spektakuler.', 50000, 15000, 40000, '-3.0672', '119.8230', 'toraja.jpg', 'approved'),
('Desa Sade', 2, 'Lombok, NTB', 'Desa tradisional suku Sasak dengan rumah panggung beratap ilalang.', 15000, 5000, 25000, '-8.8945', '116.2876', 'sade.jpg', 'approved'),
('Tari Kecak Uluwatu', 2, 'Badung, Bali', 'Pertunjukan tari kecak dramatari Ramayana di tebing Uluwatu saat matahari terbenam.', 150000, 20000, 50000, '-8.8291', '115.0849', 'uluwatu.jpg', 'approved'),
('Desa Waerebo', 2, 'Manggarai, NTT', 'Desa tradisional dengan rumah adat Mbaru Niang berbentuk kerucut.', 50000, 0, 35000, '-8.7380', '120.5260', 'werebo.jpg', 'approved');

-- HISTORY
INSERT INTO places (name, category_id, location, description, entrance_fee, parking_fee, meal_cost, latitude, longitude, image_url, status) VALUES
('Candi Borobudur', 3, 'Magelang, Jawa Tengah', 'Candi Buddha terbesar di dunia dengan relief cermat dan stupa induk megah.', 50000, 15000, 35000, '-7.6079', '110.2038', 'borobudur.jpg', 'approved'),
('Kota Tua Jakarta', 3, 'Jakarta Barat, DKI Jakarta', 'Kawasan bersejarah dengan bangunan kolonial Belanda, museum, dan kafe vintage.', 0, 20000, 50000, '-6.1376', '106.8171', 'kotatua.jpg', 'approved'),
('Lawang Sewu', 3, 'Semarang, Jawa Tengah', 'Gedung bersejarah dengan 1000 pintu dan sejarah angker yang kaya.', 10000, 10000, 35000, '-6.9840', '110.4105', 'lawangsewu.jpg', 'approved'),
('Benteng Vredeburg', 3, 'Yogyakarta, DI Yogyakarta', 'Benteng peninggalan Belanda yang kini menjadi museum sejarah perjuangan.', 3000, 5000, 30000, '-7.8003', '110.3665', 'vredeburg.jpg', 'approved'),
('Istana Maimun', 3, 'Medan, Sumatera Utara', 'Istana kerajaan Deli dengan arsitektur Melayu, India, Spanyol, dan Italia.', 10000, 5000, 40000, '3.5753', '98.6835', 'maimun.jpg', 'approved');

-- RELIGIOUS
INSERT INTO places (name, category_id, location, description, entrance_fee, parking_fee, meal_cost, latitude, longitude, image_url, status) VALUES
('Masjid Istiqlal', 4, 'Jakarta Pusat, DKI Jakarta', 'Masjid nasional terbesar di Asia Tenggara dengan arsitektur modern megah.', 0, 0, 40000, '-6.1702', '106.8310', 'istiqlal.jpg', 'approved'),
('Pura Besakih', 4, 'Karangasem, Bali', 'Pura induk terbesar dan paling suci di Bali, berlokasi di lereng Gunung Agung.', 60000, 10000, 35000, '-8.3739', '115.4567', 'besakih.jpg', 'approved'),
('Gereja Blenduk', 4, 'Semarang, Jawa Tengah', 'Gereja protestan bersejarah dengan kubah tembaga ikonik di Kota Lama.', 0, 10000, 35000, '-6.9682', '110.4275', 'blenduk.jpg', 'approved'),
('Makam Sunan Kalijaga', 4, 'Demak, Jawa Tengah', 'Makam wali songo dengan sejarah Islam yang dalam dan arsitektur tradisional.', 0, 5000, 25000, '-6.8940', '110.6370', 'makamsunan.jpg', 'approved'),
('Vihara Dhanagun', 4, 'Bogor, Jawa Barat', 'Vihara tertua dan terbesar di Bogor dengan patung Buddha raksasa.', 0, 5000, 30000, '-6.5950', '106.7896', 'vihara.jpg', 'approved');

-- CULINARY
INSERT INTO places (name, category_id, location, description, entrance_fee, parking_fee, meal_cost, latitude, longitude, image_url, status) VALUES
('Malioboro', 5, 'Yogyakarta, DI Yogyakarta', 'Jalan legendaris dengan kuliner malam, angkringan, dan oleh-oleh khas.', 0, 15000, 50000, '-7.7930', '110.3658', 'malioboro.jpg', 'approved'),
('Pasar Cihapit', 5, 'Bandung, Jawa Barat', 'Pusat kuliner kaki lima legendaris dengan makanan Sund autentik.', 0, 10000, 35000, '-6.9034', '107.6201', 'chiapit.jpg', 'approved'),
('Jalan Sabang', 5, 'Jakarta Pusat, DKI Jakarta', 'Surga kuliner malam dengan beragam warung tenda dan makanan nusantara.', 0, 15000, 45000, '-6.1850', '106.8320', 'sabang.jpg', 'approved'),
('Kya-Kya Surabaya', 5, 'Surabaya, Jawa Timur', 'Kawasan wisata kuliner Chinatown dengan makanan Tionghoa autentik.', 0, 10000, 40000, '-7.2370', '112.7378', 'kyakya.jpg', 'approved'),
('Simpang Lima Semarang', 5, 'Semarang, Jawa Tengah', 'Alun-alun kota dengan food court, kuliner malam, dan pemandangan urban.', 0, 5000, 35000, '-6.9845', '110.4108', 'simpangsemarang.jpg', 'approved');

-- ENTERTAINMENT
INSERT INTO places (name, category_id, location, description, entrance_fee, parking_fee, meal_cost, latitude, longitude, image_url, status) VALUES
('Dufan Ancol', 6, 'Jakarta Utara, DKI Jakarta', 'Taman hiburan terbesar di Indonesia dengan wahana ekstrem dan edukasi.', 295000, 25000, 75000, '-6.1256', '106.8382', 'dufan.jpg', 'approved'),
('Jatim Park', 6, 'Batu, Jawa Timur', 'Kompleks wisata edutainment dengan wahana modern dan museum unik.', 150000, 20000, 60000, '-7.8806', '112.5246', 'jpark.jpg', 'approved'),
('Trans Studio', 6, 'Makassar, Sulawesi Selatan', 'Indoor theme park terbesar dengan wahana berteknologi tinggi.', 200000, 15000, 60000, '-5.1584', '119.4128', 'trans.jpg', 'approved'),
('Waterbom Bali', 6, 'Kuta, Bali', 'Taman air terbaik di Asia dengan seluncuran spektakuler.', 520000, 0, 80000, '-8.7610', '115.1690', 'waterboom.jpg', 'approved'),
('Saloka Park', 6, 'Semarang, Jawa Tengah', 'Theme park dengan nuansa lokal Jawa dan wahana keluarga.', 150000, 15000, 50000, '-7.2820', '110.4778', 'saloka.jpg', 'approved');

-- EDUCATION
INSERT INTO places (name, category_id, location, description, entrance_fee, parking_fee, meal_cost, latitude, longitude, image_url, status) VALUES
('Museum Geologi', 7, 'Bandung, Jawa Barat', 'Museum geologi lengkap dengan fosil, meteorit, dan informasi vulkanologi.', 3000, 5000, 35000, '-6.9007', '107.6215', 'geologi.jpg', 'approved'),
('Taman Pintar', 7, 'Yogyakarta, DI Yogyakarta', 'Pusat edukasi interaktif untuk anak dan keluarga dengan science center.', 7000, 10000, 30000, '-7.8005', '110.3689', 'tamanpintar.jpg', 'approved'),
('Seaworld Ancol', 7, 'Jakarta Utara, DKI Jakarta', 'Akuarium laut terbesar dengan terowongan bawah air dan pertunjukan ikan.', 115000, 25000, 60000, '-6.1262', '106.8361', 'seaworld.jpg', 'approved'),
('Museum MACAN', 7, 'Jakarta Barat, DKI Jakarta', 'Museum seni modern dan kontemporer dengan koleksi internasional.', 140000, 10000, 50000, '-6.1767', '106.7896', 'mmacan.jpg', 'approved'),
('Ragunan', 7, 'Jakarta Selatan, DKI Jakarta', 'Kebun binatang terluas di Indonesia dengan koleksi fauna nusantara.', 4000, 15000, 35000, '-6.3046', '106.8201', 'ragunan.jpg', 'approved');

-- SHOPPING
INSERT INTO places (name, category_id, location, description, entrance_fee, parking_fee, meal_cost, latitude, longitude, image_url, status) VALUES
('Pasar Beringharjo', 8, 'Yogyakarta, DI Yogyakarta', 'Pasar tradisional legendaris dengan batik, makanan, dan oleh-oleh khas.', 0, 10000, 30000, '-7.7988', '110.3671', 'beringharjo.jpg', 'approved'),
('Pasar Tanah Abang', 8, 'Jakarta Pusat, DKI Jakarta', 'Pasar grosir tekstil terbesar di Asia Tenggara dengan ribuan kios.', 0, 15000, 35000, '-6.1856', '106.8108', 'tanahabang.jpg', 'approved'),
('Pasar Sukawati', 8, 'Gianyar, Bali', 'Pasar seni tradisional Bali dengan lukisan, patung, dan kerajinan.', 0, 5000, 25000, '-8.6062', '115.2885', 'sukawati.jpg', 'approved'),
('Grand Indonesia', 8, 'Jakarta Pusat, DKI Jakarta', 'Mall premium dengan tenant internasional and entertainment center.', 0, 20000, 80000, '-6.1947', '106.8208', 'grand.jpg', 'approved'),
('Jalan Riau Bandung', 8, 'Bandung, Jawa Barat', 'Kawasan distro dan fashion lokal dengan merek-merek kreatif Indonesia.', 0, 10000, 40000, '-6.9076', '107.6113', 'jalanriauband.jpg', 'approved');

-- ============================================================
-- SEED DATA: SAMPLE REVIEWS
-- ============================================================
INSERT INTO reviews (place_id, user_id, user_name, rating, comment) VALUES
(1, NULL, 'Ahmad Traveller', 5, 'Sunrise di puncak Merbabu benar-benar memukau. Sabana luasnya sangat indah!'),
(5, NULL, 'Rina Explorer', 4, 'Bromo selalu magis. Saran: datang weekday untuk menghindari keramaian.'),
(6, NULL, 'Budi Backpacker', 5, 'Desa Penglipuran sangat bersih dan tenang. Arsitekturnya autentik.'),
(11, NULL, 'Citra Culture', 5, 'Candi Borobudur pagi hari adalah pengalaman spiritual terbaik.'),
(16, NULL, 'Dedi Foodie', 4, 'Malioboro malam hari sangat hidup. Angkringannya murah dan enak.');

-- ============================================================
-- SEED DATA: SAMPLE FORUM TOPICS
-- ============================================================
INSERT INTO forum_topics (user_id, user_name, title, content, destination, travel_date) VALUES
(NULL, 'Wisatawan Solo', 'Cari teman trip ke Bromo Mei ini', 'Halo, saya berencana ke Bromo tanggal 15-17 Mei. Ada yang mau join sharing jeep dan penginapan?', 'Gunung Bromo', '2026-05-15'),
(NULL, 'Backpacker Jogja', 'Sharing cost ke Dieng dari Yogyakarta', 'Mau ke Dieng untuk sunrise Gunung Prau. Cari 2 orang untuk sharing mobil. Budget 300K/orang PP.', 'Gunung Prau', '2026-05-10');

-- ============================================================
-- SEED DATA: SAMPLE CROWD REPORTS
-- ============================================================
INSERT INTO crowd_reports (place_id, user_id, user_name, crowd_level, wait_time, notes) VALUES
(5,  NULL, 'Bromo Hunter',   'high',     90, 'Antrean jeep sangat panjang pagi ini. Saran datang lebih awal.'),
(11, NULL, 'Heritage Lover', 'moderate', 15, 'Tiket masuk lancar. Area candi cukup ramai tapi nyaman.');

-- ==============================================================================================
-- JIKA INGIN MENAMBAH DATABASE, LAKUKAN UPDATE QUERY JANGAN MENGUBAH ATAU MENGHAPUS DATABASE INI
-- ==============================================================================================
