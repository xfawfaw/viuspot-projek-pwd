<?php
require_once 'includes/functions.php';

if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
    header("Location: index.php");
    exit;
}

$place_id = (int)$_GET['id'];
$place = get_place_by_id($pdo, $place_id);

if (!$place) {
    header("Location: index.php");
    exit;
}

$page_title = $place['name'];

// Handle review submission
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['submit_review'])) {
    $rating = (int)($_POST['rating'] ?? 0);
    $comment = trim($_POST['comment'] ?? '');
    $user_name = trim($_POST['user_name'] ?? 'Anonim');

    if ($rating >= 1 && $rating <= 5 && !empty($comment)) {
        $user_id = get_user_id() ?: null;
        $stmt = $pdo->prepare("INSERT INTO reviews (place_id, user_id, user_name, rating, comment) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([$place_id, $user_id, $user_name, $rating, $comment]);

        if ($user_id) {
            check_and_award_badges($pdo, $user_id);
        }

        set_flash('success', 'Ulasan berhasil dikirim! Terima kasih atas kontribusimu.');
        header("Location: place.php?id=" . $place_id);
        exit;
    } else {
        $review_error = 'Rating dan komentar wajib diisi.';
    }
}

// Handle crowd report
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['submit_crowd'])) {
    $crowd_level = $_POST['crowd_level'] ?? 'moderate';
    $wait_time = (int)($_POST['wait_time'] ?? 0);
    $crowd_notes = trim($_POST['crowd_notes'] ?? '');
    $crowd_user = trim($_POST['crowd_user'] ?? 'Anonim');
    $user_id = get_user_id() ?: null;

    $stmt = $pdo->prepare("INSERT INTO crowd_reports (place_id, user_id, user_name, crowd_level, wait_time, notes) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->execute([$place_id, $user_id, $crowd_user, $crowd_level, $wait_time, $crowd_notes]);
    set_flash('success', 'Laporan keramaian berhasil dikirim!');
    header("Location: place.php?id=" . $place_id);
    exit;
}

$reviews = get_reviews_by_place($pdo, $place_id);
$rating_info = get_avg_rating($pdo, $place_id);

// Rating breakdown per star
$rating_breakdown = [];
for ($i = 1; $i <= 5; $i++) {
    $rating_breakdown[$i] = 0;
}
if ($rating_info['count'] > 0) {
    $stmt = $pdo->prepare("SELECT rating, COUNT(*) as cnt FROM reviews WHERE place_id = ? GROUP BY rating");
    $stmt->execute([$place_id]);
    foreach ($stmt->fetchAll() as $row) {
        $rating_breakdown[(int)$row['rating']] = (int)$row['cnt'];
    }
}

// Facilities (assume JSON array stored in place, fallback to empty)
$facilities_raw = $place['facilities'] ?? '';
$facilities_list = !empty($facilities_raw) ? json_decode($facilities_raw, true) : [];
if (!is_array($facilities_list)) $facilities_list = [];

// Opening hours
$open_time  = $place['open_time']  ?? '';
$close_time = $place['close_time'] ?? '';
$weather = get_weather_for_place($pdo, $place_id, $place['location']);
$crowd = get_latest_crowd($pdo, $place_id);
$maps_url = google_maps_url($place['latitude'], $place['longitude'], $place['name']);

require_once 'includes/header.php';
?>

<style>
/* ── Rating Breakdown ─────────────────────────── */
.rating-breakdown {
    display: flex;
    align-items: center;
    gap: 2rem;
}
.rating-summary {
    text-align: center;
    flex-shrink: 0;
}
.rating-big {
    font-size: 3rem;
    font-weight: 800;
    line-height: 1;
    color: #1e2d1f;
}
.stars-display {
    color: #f5a623;
    font-size: 1.1rem;
    margin: 0.25rem 0;
}
.rating-count {
    font-size: 0.8rem;
    color: #7d8165;
}
.rating-bars {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 0.35rem;
}
.rating-bar-row {
    display: flex;
    align-items: center;
    gap: 0.4rem;
    font-size: 0.82rem;
}
.bar-label { color: #5a6b57; width: 0.75rem; text-align: right; }
.bar-star  { color: #f5a623; font-size: 0.75rem; }
.bar-track {
    flex: 1;
    height: 6px;
    background: #e8ede6;
    border-radius: 99px;
    overflow: hidden;
}
.bar-fill {
    height: 100%;
    background: #f5a623;
    border-radius: 99px;
    transition: width 0.6s ease;
}
.bar-count { color: #7d8165; width: 1.25rem; text-align: right; }

/* ── Facilities ───────────────────────────────── */
.facilities-list {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
}
.facility-tag {
    display: inline-flex;
    align-items: center;
    gap: 0.3rem;
    padding: 0.35rem 0.85rem;
    background: #f4f7f3;
    border: 1px solid #dde8db;
    border-radius: 99px;
    font-size: 0.83rem;
    color: #3a4f3b;
    font-weight: 500;
}

/* ── Cost / Hours Cards ───────────────────────── */
.cost-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0.75rem;
    margin-top: 0.75rem;
}
.cost-card {
    background: #f9fbf8;
    border: 1px solid #e4ede1;
    border-radius: 12px;
    padding: 0.85rem 1rem;
}
.cost-label {
    font-size: 0.78rem;
    color: #7d8165;
    margin-bottom: 0.3rem;
}
.cost-value {
    font-size: 1rem;
    font-weight: 700;
    color: #1e2d1f;
}
</style>

<section class="place-header">
    <div class="container">
        <h1><?php echo esc($place['name']); ?></h1>
        <div class="place-meta">
            <span><?php echo esc($place['category_name']); ?></span>
            <span><?php echo esc($place['location']); ?></span>
            <span class="stars"><?php echo $rating_info['count'] > 0 ? number_format($rating_info['avg_rating'], 1) . ' ★ (' . $rating_info['count'] . ' ulasan)' : 'Belum ada ulasan'; ?></span>
        </div>
    </div>
</section>

<div class="container">
    <div class="place-image" style="background-image: url('assets/img/<?php echo esc($place['image_url']); ?>'); background-size: cover; background-position: center;">
    </div>

    <div class="place-info-grid">
        <div>
            <!-- Rating Breakdown -->
            <div class="info-panel">
                <div class="rating-breakdown">
                    <div class="rating-summary">
                        <div class="rating-big"><?php echo $rating_info['count'] > 0 ? number_format($rating_info['avg_rating'], 1) : '-'; ?></div>
                        <div class="stars-display">
                            <?php
                            $avg = $rating_info['count'] > 0 ? round($rating_info['avg_rating']) : 0;
                            echo str_repeat('★', $avg) . str_repeat('☆', 5 - $avg);
                            ?>
                        </div>
                        <div class="rating-count"><?php echo $rating_info['count']; ?> review</div>
                    </div>
                    <div class="rating-bars">
                        <?php for ($star = 5; $star >= 1; $star--): ?>
                            <?php
                            $count = $rating_breakdown[$star];
                            $pct = $rating_info['count'] > 0 ? round(($count / $rating_info['count']) * 100) : 0;
                            ?>
                            <div class="rating-bar-row">
                                <span class="bar-label"><?php echo $star; ?></span>
                                <span class="bar-star">★</span>
                                <div class="bar-track">
                                    <div class="bar-fill" style="width:<?php echo $pct; ?>%"></div>
                                </div>
                                <span class="bar-count"><?php echo $count; ?></span>
                            </div>
                        <?php endfor; ?>
                    </div>
                </div>
            </div>

            <!-- Tentang Destinasi -->
            <div class="info-panel">
                <h3>Tentang Destinasi</h3>
                <p style="line-height:1.7; color:#5a6b57;"><?php echo esc($place['description']); ?></p>

                <!-- Fasilitas -->
                <?php if (!empty($facilities_list)): ?>
                <div style="margin-top:1.25rem;">
                    <h4 style="font-size:1rem; font-weight:700; margin-bottom:0.75rem; color:#2c3e2d;">Fasilitas</h4>
                    <div class="facilities-list">
                        <?php
                        $facility_icons = [
                            'Toilet'    => '🚻',
                            'Mushola'   => '🕌',
                            'Warung'    => '🍢',
                            'Parkir'    => '🅿️',
                            'Home Stay' => '🏠',
                            'ATM'       => '🏧',
                            'WiFi'      => '📶',
                            'Restoran'  => '🍽️',
                        ];
                        foreach ($facilities_list as $fac):
                            $icon = $facility_icons[$fac] ?? '✓';
                        ?>
                            <span class="facility-tag">
                                <?php echo $icon; ?> <?php echo esc($fac); ?>
                            </span>
                        <?php endforeach; ?>
                    </div>
                </div>
                <?php endif; ?>
            </div>

            <!-- Jam Buka & Informasi Biaya -->
            <div class="info-panel">
                <h3>Informasi Kunjungan</h3>
                <div class="cost-grid">
                    <?php if (!empty($open_time) && !empty($close_time)): ?>
                    <div class="cost-card">
                        <div class="cost-label">Jam Buka</div>
                        <div class="cost-value"><?php echo esc($open_time); ?> – <?php echo esc($close_time); ?></div>
                    </div>
                    <?php endif; ?>
                    <div class="cost-card">
                        <div class="cost-label">Tiket Masuk</div>
                        <div class="cost-value"><?php echo format_rupiah($place['entrance_fee']); ?></div>
                    </div>
                    <div class="cost-card">
                        <div class="cost-label">Parkir</div>
                        <div class="cost-value"><?php echo format_rupiah($place['parking_fee']); ?></div>
                    </div>
                    <div class="cost-card">
                        <div class="cost-label">Estimasi Makan</div>
                        <div class="cost-value"><?php echo format_rupiah($place['meal_cost']); ?></div>
                    </div>
                </div>
            </div>

            <div class="info-panel">
                <h3>Tulis Ulasan</h3>
                <?php if (isset($review_error)): ?>
                    <div class="alert alert-error"><?php echo $review_error; ?></div>
                <?php endif; ?>
                <form method="POST" action="">
                    <?php if (!is_logged_in()): ?>
                    <div class="form-group">
                        <label class="form-label">Nama (atau login untuk tracking badge)</label>
                        <input type="text" name="user_name" class="form-control" required>
                    </div>
                    <?php else: ?>
                        <input type="hidden" name="user_name" value="<?php echo esc($_SESSION['full_name']); ?>">
                    <?php endif; ?>
                    <div class="form-group">
                        <label class="form-label">Rating</label>
                        <div class="rating-input">
                            <input type="radio" id="star5" name="rating" value="5"><label for="star5">★</label>
                            <input type="radio" id="star4" name="rating" value="4"><label for="star4">★</label>
                            <input type="radio" id="star3" name="rating" value="3"><label for="star3">★</label>
                            <input type="radio" id="star2" name="rating" value="2"><label for="star2">★</label>
                            <input type="radio" id="star1" name="rating" value="1" required><label for="star1">★</label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Komentar</label>
                        <textarea name="comment" class="form-control" rows="3" required></textarea>
                    </div>
                    <button type="submit" name="submit_review" class="btn btn-accent">Kirim Ulasan</button>
                </form>
            </div>

            <div class="info-panel">
                <h3>Ulasan (<?php echo count($reviews); ?>)</h3>
                <?php if (empty($reviews)): ?>
                    <p style="color:#7d8165;">Belum ada ulasan. Jadilah yang pertama!</p>
                <?php else: ?>
                    <?php foreach ($reviews as $rev): ?>
                        <div class="review-item" style="margin-bottom:0.75rem;">
                            <div class="review-header">
                                <span class="review-author"><?php echo esc($rev['user_name']); ?></span>
                                <span class="review-date"><?php echo date('d M Y', strtotime($rev['created_at'])); ?></span>
                            </div>
                            <div class="stars mb-1"><?php echo str_repeat('★', $rev['rating']) . str_repeat('☆', 5 - $rev['rating']); ?></div>
                            <p class="review-text"><?php echo esc($rev['comment']); ?></p>
                        </div>
                    <?php endforeach; ?>
                <?php endif; ?>
            </div>
        </div>

        <div>
            <div class="widget">
                <div class="widget-title">Arahkan ke Lokasi</div>
                <a href="<?php echo esc($maps_url); ?>" target="_blank" class="btn btn-primary btn-block" style="margin-bottom:0.75rem;">Buka Google Maps</a>
                <p style="font-size:0.8rem; color:#7d8165;">Koordinat: <?php echo esc($place['latitude']); ?>, <?php echo esc($place['longitude']); ?></p>
            </div>

            <div class="widget">
                <div class="widget-title">Cuaca Saat Ini</div>
                <div class="weather-display">
                    <div class="weather-temp"><?php echo $weather['temperature']; ?>°C</div>
                    <div>
                        <div style="font-weight:600;"><?php echo esc($weather['condition_text']); ?></div>
                        <div class="weather-detail">Kelembapan: <?php echo $weather['humidity']; ?>% | Angin: <?php echo $weather['wind_speed']; ?> km/j</div>
                    </div>
                </div>
            </div>

            <div class="widget">
                <div class="widget-title">Tingkat Keramaian</div>
                <?php if ($crowd): ?>
                    <span class="crowd-badge crowd-<?php echo $crowd['crowd_level']; ?>">
                        <?php echo get_crowd_label($crowd['crowd_level']); ?>
                    </span>
                    <p style="margin-top:0.5rem; font-size:0.85rem; color:#5a6b57;">
                        Waktu tunggu: ~<?php echo $crowd['wait_time']; ?> menit<br>
                        Dilaporkan: <?php echo date('d M H:i', strtotime($crowd['created_at'])); ?>
                    </p>
                    <?php if ($crowd['notes']): ?>
                        <p style="font-size:0.85rem; color:#7d8165; font-style:italic;">"<?php echo esc($crowd['notes']); ?>"</p>
                    <?php endif; ?>
                <?php else: ?>
                    <p style="font-size:0.85rem; color:#7d8165;">Belum ada laporan keramaian. Laporkan kondisi sekarang!</p>
                <?php endif; ?>
            </div>

            <div class="widget">
                <div class="widget-title">Laporkan Keramaian</div>
                <form method="POST" action="">
                    <?php if (!is_logged_in()): ?>
                    <div class="form-group">
                        <input type="text" name="crowd_user" class="form-control" placeholder="Nama Anda" required>
                    </div>
                    <?php else: ?>
                        <input type="hidden" name="crowd_user" value="<?php echo esc($_SESSION['full_name']); ?>">
                    <?php endif; ?>
                    <div class="form-group">
                        <select name="crowd_level" class="form-control" required>
                            <option value="low">Sepi</option>
                            <option value="moderate" selected>Sedang</option>
                            <option value="high">Ramai</option>
                            <option value="very_high">Sangat Ramai</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <input type="number" name="wait_time" class="form-control" placeholder="Waktu tunggu (menit)" min="0">
                    </div>
                    <div class="form-group">
                        <textarea name="crowd_notes" class="form-control" rows="2" placeholder="Catatan tambahan..."></textarea>
                    </div>
                    <button type="submit" name="submit_crowd" class="btn btn-secondary btn-sm btn-block">Kirim Laporan</button>
                </form>
            </div>
        </div>
    </div>
</div>

<?php require_once 'includes/footer.php'; ?>