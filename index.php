<?php
$page_title = 'Beranda';
require_once 'includes/header.php';

// Fetch stats
$stmt = $pdo->query("SELECT COUNT(*) as total FROM places WHERE status='approved'");
$total_places = $stmt->fetch()['total'];

$stmt = $pdo->query("SELECT COUNT(*) as total FROM reviews");
$total_reviews = $stmt->fetch()['total'];

$stmt = $pdo->query("SELECT COUNT(*) as total FROM users WHERE role='user'");
$total_users = $stmt->fetch()['total'];

$stmt = $pdo->query("SELECT COUNT(*) as total FROM categories");
$total_cats = $stmt->fetch()['total'];

// Fetch popular destinations (top 3)
$popular_places = array_slice(get_all_places($pdo, 'approved'), 0, 3);

// Fetch recent reviews
$recent_reviews = get_recent_reviews($pdo, 4);

// Fetch all categories with counts
$stmt = $pdo->query("
    SELECT c.*, COUNT(p.id) as place_count 
    FROM categories c 
    LEFT JOIN places p ON c.id = p.category_id AND p.status = 'approved' 
    GROUP BY c.id 
    ORDER BY c.`name`
");
$categories_with_count = $stmt->fetchAll();

// Simulated weather for the region
$weather = get_weather_for_place($pdo, 0, 'Indonesia');
?>

<section class="hero">
    <div class="container">
        <h1>Jelajahi Keindahan Indonesia</h1>
        <p>Viuspot adalah sistem informasi dan ulasan wisata terlengkap. Temukan destinasi, rencanakan perjalanan, dan bagikan pengalamanmu.</p>
        <a href="planner.php" class="btn btn-accent btn-lg">Rencanakan Perjalanan</a>

        <div class="hero-stats">
            <div class="hero-stat">
                <strong><?php echo $total_places; ?></strong>
                <span>Destinasi</span>
            </div>
            <div class="hero-stat">
                <strong><?php echo $total_reviews; ?></strong>
                <span>Ulasan</span>
            </div>
            <div class="hero-stat">
                <strong><?php echo $total_users; ?></strong>
                <span>Traveler</span>
            </div>
            <div class="hero-stat">
                <strong><?php echo $total_cats; ?></strong>
                <span>Kategori</span>
            </div>
        </div>
    </div>
</section>

<div class="container">
    <div class="section-header">
        <h2>Kategori Wisata</h2>
        <p>Pilih kategori destinasi sesuai minat perjalananmu</p>
    </div>

    <div class="grid grid-5 mb-4">
        <?php foreach ($categories_with_count as $cat): ?>
            <a href="index.php?category=<?php echo $cat['id']; ?>" class="category-card">
                <div class="category-icon"><?php echo substr($cat['name'], 0, 2); ?></div>
                <h3><?php echo esc($cat['name']); ?></h3>
                <p><?php echo $cat['place_count']; ?> destinasi</p>
            </a>
        <?php endforeach; ?>
    </div>

    <?php
    // If category selected, show places
    if (isset($_GET['category']) && is_numeric($_GET['category'])):
        $cat_id = (int)$_GET['category'];
        $places = get_places_by_category($pdo, $cat_id, 'approved');
        $cat_info = null;
        foreach ($categories_with_count as $c) {
            if ($c['id'] == $cat_id) { $cat_info = $c; break; }
        }
    ?>
        <div class="section-header">
            <h2>Destinasi <?php echo esc($cat_info['name'] ?? ''); ?></h2>
            <p><?php echo count($places); ?> tempat ditemukan</p>
        </div>

        <div class="grid grid-3 mb-4">
            <?php foreach ($places as $place): 
                $rating = get_avg_rating($pdo, $place['id']);
            ?>
                <article class="card">
                    <div class="card-image" data-initial="<?php echo esc(substr($place['name'], 0, 1)); ?>"></div>
                    <div class="card-body">
                        <h3 class="card-title"><?php echo esc($place['name']); ?></h3>
                        <div class="card-meta">
                            <?php echo esc($place['location']); ?>
                            <?php 
                                $crowd = get_latest_crowd($pdo, $place['id']);
                                if ($crowd): 
                            ?>
                                <span class="crowd-badge crowd-<?php echo $crowd['crowd_level']; ?>" style="position:static; margin-left:5px;"><?php echo get_crowd_label($crowd['crowd_level']); ?></span>
                            <?php endif; ?>
                        </div>
                        <p class="card-text"><?php echo esc(truncate($place['description'], 120)); ?></p>
                    </div>
                    <div class="card-footer">
                        <span class="card-price"><?php echo format_rupiah($place['entrance_fee']); ?></span>
                        <span class="stars"><?php echo $rating['count'] > 0 ? number_format($rating['avg_rating'], 1) . ' ★' : 'Belum ada rating'; ?></span>
                    </div>
                    <div style="padding: 0 1.25rem 1rem;">
                        <a href="place.php?id=<?php echo $place['id']; ?>" class="btn btn-primary btn-sm btn-block">Lihat Detail</a>
                    </div>
                </article>
            <?php endforeach; ?>
        </div>

        <?php if (empty($places)): ?>
            <div class="alert alert-info">Belum ada destinasi yang tersedia di kategori ini.</div>
        <?php endif; ?>
    <?php endif; ?>

    <section class="mt-4">
        <div class="section-header">
            <h2>Destinasi Populer</h2>
            <p>Pilihan terbaik untuk petualanganmu selanjutnya</p>
        </div>
        <div class="grid grid-3 mb-4">
            <?php foreach ($popular_places as $place): 
                $rating = get_avg_rating($pdo, $place['id']);
                $crowd = get_latest_crowd($pdo, $place['id']);
            ?>
                <article class="card">
                    <div class="card-image" data-initial="<?php echo esc(substr($place['name'], 0, 1)); ?>">
                        <?php if ($crowd): ?>
                            <span class="crowd-badge crowd-<?php echo $crowd['crowd_level']; ?>">
                                <?php echo get_crowd_label($crowd['crowd_level']); ?>
                            </span>
                        <?php endif; ?>
                    </div>
                    <div class="card-body">
                        <h3 class="card-title"><?php echo esc($place['name']); ?></h3>
                        <div class="card-meta"><?php echo esc($place['location']); ?></div>
                        <p class="card-text"><?php echo esc(truncate($place['description'], 120)); ?></p>
                    </div>
                    <div class="card-footer">
                        <span class="card-price"><?php echo format_rupiah($place['entrance_fee']); ?></span>
                        <span class="stars"><?php echo $rating['count'] > 0 ? number_format($rating['avg_rating'], 1) . ' ★' : 'N/A'; ?></span>
                    </div>
                    <div style="padding: 0 1.25rem 1rem;">
                        <a href="place.php?id=<?php echo $place['id']; ?>" class="btn btn-primary btn-sm btn-block">Eksplorasi</a>
                    </div>
                </article>
            <?php endforeach; ?>
        </div>
    </section>

    <aside class="weather-widget-fixed">
        <div class="widget-title">Cuaca Hari Ini</div>
        <div class="weather-temp"><?php echo $weather['temperature']; ?>°C</div>
        <div class="weather-detail"><?php echo esc($weather['condition_text']); ?></div>
    </aside>

    <div class="section-header mt-4">
        <h2>Ulasan Terbaru</h2>
        <p>Apa kata traveler tentang destinasi Indonesia</p>
    </div>

    <div class="grid grid-2 mb-4">
        <?php foreach ($recent_reviews as $rev): ?>
            <div class="review-item">
                <div class="review-header">
                    <span class="review-author"><?php echo esc($rev['user_name']); ?></span>
                    <span class="review-date"><?php echo date('d M Y', strtotime($rev['created_at'])); ?></span>
                </div>
                <div class="stars mb-1"><?php echo str_repeat('★', $rev['rating']) . str_repeat('☆', 5 - $rev['rating']); ?></div>
                <p class="review-text">"<?php echo esc(truncate($rev['comment'], 150)); ?>"</p>
                <div style="margin-top:0.5rem;">
                    <a href="place.php?id=<?php echo $rev['place_id']; ?>" style="font-size:0.85rem;">di <?php echo esc($rev['place_name']); ?> &rarr;</a>
                </div>
            </div>
        <?php endforeach; ?>
    </div>

    <div class="text-center mt-3 mb-4">
        <a href="submit_place.php" class="btn btn-outline btn-lg">+ Usulkan Destinasi Baru</a>
    </div>
</div>

<?php require_once 'includes/footer.php'; ?>
