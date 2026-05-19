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

// Fetch popular destinations – dinamis berdasarkan avg rating (min. 1 ulasan)
$stmt = $pdo->query("
    SELECT p.*, AVG(r.rating) as avg_rating, COUNT(r.id) as review_count
    FROM places p
    LEFT JOIN reviews r ON r.place_id = p.id
    WHERE p.status = 'approved'
    GROUP BY p.id
    HAVING review_count > 0
    ORDER BY avg_rating DESC, review_count DESC
    LIMIT 3
");
$popular_places = $stmt->fetchAll();

// Jika belum ada review sama sekali, fallback tampilkan 3 tempat terbaru
if (empty($popular_places)) {
    $stmt = $pdo->query("SELECT * FROM places WHERE status='approved' ORDER BY id DESC LIMIT 3");
    $popular_places = $stmt->fetchAll();
}

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
?>

<!-- AJAX Search endpoint (diproses di file ini sebelum HTML) -->
<?php
if (isset($_GET['ajax_search'])) {
    header('Content-Type: application/json');
    $q = trim($_GET['q'] ?? '');
    $results = [];
    if (strlen($q) >= 2) {
        $like = '%' . $q . '%';
        $s = $pdo->prepare("
            SELECT p.id, p.name, p.location, p.image_url, p.entrance_fee,
                    c.name as category_name,
                    AVG(r.rating) as avg_rating, COUNT(r.id) as review_count
            FROM places p
            JOIN categories c ON c.id = p.category_id
            LEFT JOIN reviews r ON r.place_id = p.id
            WHERE p.status='approved' AND (p.name LIKE ? OR p.location LIKE ? OR p.description LIKE ?)
            GROUP BY p.id
            ORDER BY avg_rating DESC
            LIMIT 8
        ");
        $s->execute([$like, $like, $like]);
        $results = $s->fetchAll(PDO::FETCH_ASSOC);
    }
    echo json_encode($results);
    exit;
}
?>

</div>

<section class="hero" style="background-image: url('assets/img/home.jpg');">
    <div class="container">
        <h1>Jelajahi Keindahan Indonesia</h1>
        <p>Viuspot adalah sistem informasi dan ulasan wisata terlengkap.<br>Temukan destinasi, rencanakan perjalanan, dan bagikan pengalamanmu.</p>

        <!-- ====== SEARCH BAR ====== -->
        <form action="index.php" method="GET" class="hero-search" style="margin: 1.5rem 0 1.25rem; position:relative; max-width:580px; margin-left:auto; margin-right:auto;">
            <div style="display:flex; background:#fff; border-radius:50px; overflow:hidden; box-shadow:0 4px 20px rgba(0,0,0,0.2);">
                <i class="ti ti-search" style="padding: 0 0 0 1.2rem; font-size:1.3rem; color:#7d8165; display:flex; align-items:center;"></i>
                <input type="text" name="search" placeholder="Cari destinasi, kota, atau kategori..." 
                       value="<?php echo isset($_GET['search']) ? esc($_GET['search']) : ''; ?>"
                       style="flex:1; border:none; outline:none; padding:0.9rem 1rem; font-size:1rem; background:transparent; color:#333;">
                <button type="submit" style="background:#2ab7a9; color:#fff; border:none; padding:0 1.5rem; font-weight:700; font-size:0.95rem; cursor:pointer; border-radius:0 50px 50px 0;">Cari</button>
            </div>
        </form>
        <!-- ====== END SEARCH BAR ====== -->

        <a href="planner.php" class="btn btn-accent btn-lg" style="position:relative;z-index:5;">✦ Rencanakan Perjalanan</a>

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

<style>
/* Style dropdown dihapus karena tidak lagi menggunakan JavaScript */
</style>

<div class="container">
    <div class="section-header">
        <h2>Kategori Wisata</h2>
        <p>Pilih kategori destinasi sesuai minat perjalananmu</p>
    </div>

    <div class="grid grid-4 mb-4">
        <?php
        $category_icons = [
            'culinary'      => ['icon' => 'ti-tools-kitchen-2', 'class' => 'ic-culinary'],
            'culture'       => ['icon' => 'ti-building-arch',   'class' => 'ic-culture'],
            'education'     => ['icon' => 'ti-school',          'class' => 'ic-education'],
            'entertainment' => ['icon' => 'ti-confetti',        'class' => 'ic-entertainment'],
            'history'       => ['icon' => 'ti-building-castle', 'class' => 'ic-history'],
            'nature'        => ['icon' => 'ti-trees',           'class' => 'ic-nature'],
            'religious'     => ['icon' => 'ti-building-mosque', 'class' => 'ic-religious'],
            'shopping'      => ['icon' => 'ti-shopping-bag',    'class' => 'ic-shopping'],
        ];
        foreach ($categories_with_count as $cat):
            $key = strtolower($cat['name']);
            $icon_data = $category_icons[$key] ?? ['icon' => 'ti-map-pin', 'class' => 'ic-nature'];
        ?>
            <a href="index.php?category=<?php echo $cat['id']; ?>" class="category-card">
                <div class="category-icon <?php echo $icon_data['class']; ?>">
                    <i class="ti <?php echo $icon_data['icon']; ?>" aria-hidden="true"></i>
                </div>
                <div>
                    <h3><?php echo esc($cat['name']); ?></h3>
                    <p><?php echo $cat['place_count']; ?> destinasi</p>
                </div>
                <span class="cat-arrow">→</span>
            </a>
        <?php endforeach; ?>
    </div>

    <?php
    // Hasil pencarian (full-page)
    if (isset($_GET['search']) && strlen(trim($_GET['search'])) >= 2):
        $q    = trim($_GET['search']);
        $like = '%' . $q . '%';
        $s    = $pdo->prepare("
            SELECT p.*, c.name as category_name,
                   AVG(r.rating) as avg_rating, COUNT(r.id) as review_count
            FROM places p
            JOIN categories c ON c.id = p.category_id
            LEFT JOIN reviews r ON r.place_id = p.id
            WHERE p.status='approved' AND (p.name LIKE ? OR p.location LIKE ? OR p.description LIKE ?)
            GROUP BY p.id
            ORDER BY avg_rating DESC
        ");
        $s->execute([$like, $like, $like]);
        $search_results = $s->fetchAll();
    ?>
    <div class="section-header">
        <h2>Hasil Pencarian: "<?php echo esc($q); ?>"</h2>
        <p><?php echo count($search_results); ?> destinasi ditemukan</p>
    </div>

    <?php if (!empty($search_results)): ?>
    <div class="grid grid-3 mb-4">
        <?php foreach ($search_results as $place):
            $rating = get_avg_rating($pdo, $place['id']);
        ?>
            <article class="card">
                <div class="card-image" style="background-image: url('assets/img/<?php echo esc($place['image_url']); ?>'); background-size: cover; background-position: center;">
                </div>
                <div class="card-body">
                    <h3 class="card-title"><?php echo esc($place['name']); ?></h3>
                    <div class="card-meta"><?php echo esc($place['location']); ?> &middot; <?php echo esc($place['category_name']); ?></div>
                    <p class="card-text"><?php echo esc(truncate($place['description'], 100)); ?></p>
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
    <?php else: ?>
        <div class="alert alert-info">Tidak ada destinasi yang cocok dengan pencarian "<strong><?php echo esc($q); ?></strong>". Coba kata kunci lain.</div>
    <?php endif; ?>

    <?php // Akhir blok search
    elseif (isset($_GET['category']) && is_numeric($_GET['category'])): ?>
    <?php
        $cat_id  = (int)$_GET['category'];
        $places  = get_places_by_category($pdo, $cat_id, 'approved');
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
                    <div class="card-image" style="background-image: url('assets/img/<?php echo esc($place['image_url']); ?>'); background-size: cover; background-position: center;"></div>
                    <div class="card-body">
                        <h3 class="card-title"><?php echo esc($place['name']); ?></h3>
                        <div class="card-meta">
                            <?php echo esc($place['location']); ?>
                        </div>
                        <p class="card-text"><?php echo esc(truncate($place['description'], 100)); ?></p>
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
            <p>Pilihan terbaik berdasarkan rating dan ulasan pengunjung</p>
        </div>
        <div class="grid grid-3 mb-4">
            <?php foreach ($popular_places as $place): 
                $rating = get_avg_rating($pdo, $place['id']);
            ?>
                <article class="card">
                    <div class="card-image" style="background-image: url('assets/img/<?php echo esc($place['image_url']); ?>'); background-size: cover; background-position: center;">
                    </div>
                    <div class="card-body">
                        <h3 class="card-title"><?php echo esc($place['name']); ?></h3>
                        <div class="card-meta"><?php echo esc($place['location']); ?></div>
                        <p class="card-text"><?php echo esc(truncate($place['description'], 100)); ?></p>
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