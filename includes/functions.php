<?php
// ============================================================
// VIUSPOT - Core Functions & Session Management
// ============================================================

session_start();
require_once 'db.php';

// -----------------------------------------------------------
// Authentication Helpers
// -----------------------------------------------------------
function is_logged_in() {
    return isset($_SESSION['user_id']);
}

function is_admin() {
    return isset($_SESSION['role']) && $_SESSION['role'] === 'admin';
}

function require_login() {
    if (!is_logged_in()) {
        header("Location: login.php");
        exit;
    }
}

function require_admin() {
    if (!is_admin()) {
        header("Location: index.php");
        exit;
    }
}

function get_user_id() {
    return $_SESSION['user_id'] ?? 0;
}

function get_username() {
    return $_SESSION['username'] ?? '';
}

// -----------------------------------------------------------
// Flash Messages (stored in session, displayed via PHP)
// -----------------------------------------------------------
function set_flash($type, $message) {
    $_SESSION['flash'] = ['type' => $type, 'message' => $message];
}

function get_flash() {
    if (isset($_SESSION['flash'])) {
        $flash = $_SESSION['flash'];
        unset($_SESSION['flash']);
        return $flash;
    }
    return null;
}

// -----------------------------------------------------------
// Data Fetching Helpers
// -----------------------------------------------------------
function get_categories($pdo) {
    $stmt = $pdo->query("SELECT * FROM categories ORDER BY `name` ASC");
    return $stmt->fetchAll();
}

function get_places_by_category($pdo, $category_id, $status = 'approved') {
    $stmt = $pdo->prepare("SELECT * FROM places WHERE category_id = ? AND status = ? ORDER BY `name` ASC");
    $stmt->execute([$category_id, $status]);
    return $stmt->fetchAll();
}

function get_place_by_id($pdo, $place_id) {
    $stmt = $pdo->prepare("SELECT p.*, c.`name` as category_name, c.slug as category_slug 
                            FROM places p 
                            JOIN categories c ON p.category_id = c.id 
                            WHERE p.id = ?");
    $stmt->execute([$place_id]);
    return $stmt->fetch();
}

function get_reviews_by_place($pdo, $place_id) {
    $stmt = $pdo->prepare("SELECT * FROM reviews WHERE place_id = ? ORDER BY created_at DESC");
    $stmt->execute([$place_id]);
    return $stmt->fetchAll();
}

function get_avg_rating($pdo, $place_id) {
    $stmt = $pdo->prepare("SELECT AVG(rating) as avg_rating, COUNT(*) as count FROM reviews WHERE place_id = ?");
    $stmt->execute([$place_id]);
    return $stmt->fetch();
}

function get_recent_reviews($pdo, $limit = 5) {
    $stmt = $pdo->prepare("SELECT r.*, p.`name` as place_name 
                            FROM reviews r 
                            JOIN places p ON r.place_id = p.id 
                            ORDER BY r.created_at DESC LIMIT ?");
    $stmt->bindValue(1, (int)$limit, PDO::PARAM_INT);
    $stmt->execute();
    return $stmt->fetchAll();
}

function get_all_places($pdo, $status = null) {
    $sql = "SELECT p.*, c.`name` as category_name FROM places p JOIN categories c ON p.category_id = c.id";
    if ($status) {
        $sql .= " WHERE p.status = ?";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$status]);
    } else {
        $stmt = $pdo->query($sql . " ORDER BY p.created_at DESC");
    }
    return $stmt->fetchAll();
}

// -----------------------------------------------------------
// Badge System
// -----------------------------------------------------------
function get_user_review_count($pdo, $user_id) {
    $stmt = $pdo->prepare("SELECT COUNT(*) as count FROM reviews WHERE user_id = ?");
    $stmt->execute([$user_id]);
    return $stmt->fetch()['count'] ?? 0;
}

function get_user_badges($pdo, $user_id) {
    $stmt = $pdo->prepare("SELECT b.* FROM badges b 
                            JOIN user_badges ub ON b.id = ub.badge_id 
                            WHERE ub.user_id = ? ORDER BY b.min_reviews");
    $stmt->execute([$user_id]);
    return $stmt->fetchAll();
}

function check_and_award_badges($pdo, $user_id) {
    $review_count = get_user_review_count($pdo, $user_id);
    $stmt = $pdo->prepare("SELECT * FROM badges WHERE min_reviews <= ? ORDER BY min_reviews DESC");
    $stmt->execute([$review_count]);
    $badges = $stmt->fetchAll();
    
    foreach ($badges as $badge) {
        // Check if already earned
        $check = $pdo->prepare("SELECT id FROM user_badges WHERE user_id = ? AND badge_id = ?");
        $check->execute([$user_id, $badge['id']]);
        if (!$check->fetch()) {
            $insert = $pdo->prepare("INSERT INTO user_badges (user_id, badge_id) VALUES (?, ?)");
            $insert->execute([$user_id, $badge['id']]);
        }
    }
}

function get_user_level($pdo, $user_id) {
    $count = get_user_review_count($pdo, $user_id);
    if ($count >= 50) return ['name' => 'Explorer Legend', 'class' => 'legend'];
    if ($count >= 30) return ['name' => 'Explorer', 'class' => 'explorer'];
    if ($count >= 15) return ['name' => 'Wanderer', 'class' => 'wanderer'];
    if ($count >= 5) return ['name' => 'Backpacker', 'class' => 'backpacker'];
    return ['name' => 'Tourist', 'class' => 'tourist'];
}

// -----------------------------------------------------------
// Weather Helpers (Simulated/Server-side)
// -----------------------------------------------------------
function get_weather_for_place($pdo, $place_id, $location_name) {
    // Check cache first (within 1 hour)
    if ($place_id > 0) {
        $stmt = $pdo->prepare("SELECT * FROM weather_cache WHERE place_id = ? AND cached_at > DATE_SUB(NOW(), INTERVAL 1 HOUR)");
        $stmt->execute([$place_id]);
        $cached = $stmt->fetch();
        if ($cached) {
            return $cached;
        }
    }
    
    // Simulated weather data based on location hash for consistency
    $hash = crc32($location_name);
    $conditions = ['Cerah', 'Berawan', 'Hujan Ringan', 'Cerah Berawan', 'Kabut Tipis'];
    $condition = $conditions[abs($hash) % count($conditions)];
    $temp = 24 + (abs($hash) % 12);
    $humidity = 50 + (abs($hash) % 40);
    $wind = 5 + (abs($hash) % 20);
    
    // Cache it
    if ($place_id > 0) {
        $stmt = $pdo->prepare("DELETE FROM weather_cache WHERE place_id = ?");
        $stmt->execute([$place_id]);
        $stmt = $pdo->prepare("INSERT INTO weather_cache (place_id, temperature, condition_text, humidity, wind_speed) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([$place_id, $temp, $condition, $humidity, $wind]);
    }
    
    return [
        'temperature' => $temp,
        'condition_text' => $condition,
        'humidity' => $humidity,
        'wind_speed' => $wind
    ];
}

// -----------------------------------------------------------
// Crowd Level Helpers
// -----------------------------------------------------------
function get_latest_crowd($pdo, $place_id) {
    $stmt = $pdo->prepare("SELECT * FROM crowd_reports WHERE place_id = ? ORDER BY created_at DESC LIMIT 1");
    $stmt->execute([$place_id]);
    return $stmt->fetch();
}

function get_crowd_label($level) {
    $labels = [
        'low' => 'Sepi',
        'moderate' => 'Sedang',
        'high' => 'Ramai',
        'very_high' => 'Sangat Ramai'
    ];
    return $labels[$level] ?? 'Tidak Diketahui';
}

// -----------------------------------------------------------
// Utility
// -----------------------------------------------------------
function esc($str) {
    return htmlspecialchars($str ?? '', ENT_QUOTES, 'UTF-8');
}

function format_rupiah($amount) {
    return 'Rp ' . number_format($amount, 0, ',', '.');
}

function truncate($str, $length = 100) {
    if (strlen($str) <= $length) return $str;
    return substr($str, 0, $length) . '...';
}

function generate_slug($str) {
    return strtolower(preg_replace('/[^a-z0-9]+/i', '-', $str));
}

function google_maps_url($lat, $lng, $name) {
    return "https://www.google.com/maps/dir/?api=1&destination=" . urlencode($lat . "," . $lng);
}
?>