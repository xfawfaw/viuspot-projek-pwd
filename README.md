# VIUSPOT - Indonesian Tourism Information & Review System

## Deskripsi
Viuspot adalah sistem informasi dan ulasan wisata berbasis web yang dikembangkan menggunakan PHP Native, HTML5, dan CSS3. Sistem ini menyediakan informasi destinasi wisata Indonesia, ulasan pengguna, perencanaan perjalanan, kalkulator budget, sistem badge & level, forum komunitas, integrasi cuaca, dan laporan keramaian.

## Teknologi
- **Backend**: PHP 8.x Native (Procedural & OOP PDO)
- **Database**: MySQL / MariaDB
- **Frontend**: HTML5, CSS3 (Tanpa JavaScript)
- **Interaksi**: CSS3 Pseudo-classes (:hover, :active, :target)

## Fitur Utama

### Publik
- **Browse Destinasi**: Jelajahi 40 destinasi dalam 8 kategori
- **Detail Tempat**: Informasi lengkap dengan cuaca, keramaian, arah Google Maps
- **Ulasan Instan**: Kirim ulasan tanpa moderasi (anonim atau login)
- **Usulkan Destinasi**: Kirim destinasi baru (pending approval admin)
- **Viuspot Planner**: Buat itinerary harian dengan timeline
- **Budget Calculator**: Hitung estimasi biaya perjalanan
- **Badge & Level**: Gamifikasi berbasis jumlah ulasan
- **Community Hub**: Forum cari teman perjalanan (Travel Buddy)
- **Weather**: Informasi cuaca server-side (simulated)
- **Crowd Level**: Crowdsourcing kondisi keramaian lokasi

### Admin
- **Dashboard**: Statistik sistem
- **Kelola Destinasi**: Approve, reject, hapus tempat wisata
- **Kelola Ulasan**: Moderasi dan hapus ulasan

## Instalasi

### Persyaratan
- PHP 8.0 atau lebih baru
- MySQL 5.7+ / MariaDB 10.3+
- Web Server (Apache/Nginx)

### Langkah Instalasi
1. Clone atau copy project ke direktori web server (contoh: `htdocs/viuspot/`)
2. Buat database MySQL baru:
   ```sql
   CREATE DATABASE viuspot CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
3. Import file SQL:
   ```bash
   mysql -u root -p viuspot < viuspot.sql
   ```
4. Sesuaikan konfigurasi database di `includes/db.php`:
   ```php
   $host = 'localhost';
   $dbname = 'viuspot';
   $username = 'root';
   $password = ''; // sesuaikan password MySQL
   ```
5. Akses aplikasi via browser: `http://localhost/viuspot/`

### Akun Default
- **Admin**: username `admin`, password `password`
- **User**: Daftar melalui halaman register

## Struktur Direktori
```
viuspot/
├── assets/css/style.css       # Stylesheet utama (responsive, CSS3 interactions)
├── includes/
│   ├── db.php                 # Koneksi database (PDO + MySQLi)
│   ├── functions.php          # Fungsi helper, auth, badge, weather
│   ├── header.php             # Template header (navigation, flash messages)
│   └── footer.php             # Template footer
├── admin/
│   ├── login.php              # Login admin terpisah
│   ├── dashboard.php          # Dashboard admin
│   ├── places.php             # Kelola destinasi (approve/reject/delete)
│   ├── reviews.php            # Kelola ulasan (delete)
│   └── logout.php             # Logout admin
├── index.php                  # Halaman utama (kategori, review, stats)
├── place.php                  # Detail destinasi + ulasan + cuaca + crowd
├── submit_place.php           # Form usul destinasi baru
├── login.php                  # Login user
├── register.php               # Register user baru
├── logout.php                 # Logout user
├── planner.php                # Itinerary builder
├── budget.php                 # Budget calculator
├── badges.php                 # Gamification engine
├── community.php              # Forum travel buddy
├── viuspot.sql                # Database schema + seed data
└── README.md                  # Dokumentasi ini
```

## Catatan Keamanan
- Password di-hash menggunakan `password_hash()` (bcrypt)
- Menggunakan prepared statements PDO untuk mencegah SQL Injection
- Escape output menggunakan `htmlspecialchars()` untuk mencegah XSS
- Session-based authentication dengan role checking

## Batasan (Sesuai Requirement)
- Tidak menggunakan JavaScript (interaksi hanya via CSS3 :hover, :active, :target)
- Tidak menggunakan framework frontend/backend (React, Next.js, Laravel, dll.)
- Animasi terbatas pada transformasi scale, opacity, shake
- Tidak ada video background atau motion graphics kompleks

## Lisensi
Project ini dibuat untuk tujuan akademik dan demonstrasi sistem informasi wisata.
