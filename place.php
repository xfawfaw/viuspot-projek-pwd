<?php
$page_title = 'Detail Destinasi';
require_once 'includes/functions.php';

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
if (!$id) {
    header('Location: index.php');
    exit;
}

// Fetch place
$stmt = $pdo->prepare("SELECT p.*, c.name as category_name FROM places p JOIN categories c ON p.category_id = c.id WHERE p.id = ? AND p.status = 'approved'");
$stmt->execute([$id]);
$place = $stmt->fetch();

if (!$place) {
    header('Location: index.php');
    exit;
}

$page_title = $place['name'];
$rating = get_avg_rating($pdo, $id);
$crowd = get_latest_crowd($pdo, $id);

// Laporan keramaian milik user yang login (untuk fitur edit)
$user_crowd_report = null;
if (is_logged_in()) {
    $uid_crowd = get_user_id();
    $stmt_uc = $pdo->prepare("SELECT * FROM crowd_reports WHERE place_id = ? AND user_id = ? ORDER BY created_at DESC LIMIT 1");
    $stmt_uc->execute([$id, $uid_crowd]);
    $user_crowd_report = $stmt_uc->fetch() ?: null;
}

// Parse fasilitas (JSON)
$facilities_raw = $place['facilities'] ?? '';
$facilities = [];
if (!empty($facilities_raw)) {
    $decoded = json_decode($facilities_raw, true);
    if (is_array($decoded)) {
        $facilities = $decoded;
    }
}

// Definisi label dan ikon fasilitas
$facility_info = [
    'toilet'        => ['label' => 'Toilet',          'icon' => 'ti-toilet-paper'],
    'parkir'        => ['label' => 'Area Parkir',      'icon' => 'ti-parking'],
    'wifi'          => ['label' => 'WiFi',             'icon' => 'ti-wifi'],
    'mushola'       => ['label' => 'Mushola',          'icon' => 'ti-building-mosque'],
    'restoran'      => ['label' => 'Restoran/Warung',  'icon' => 'ti-tools-kitchen-2'],
    'atm'           => ['label' => 'ATM / Money Changer','icon' => 'ti-atm'],
    'aksesibilitas' => ['label' => 'Ramah Difabel',    'icon' => 'ti-wheelchair'],
    'area_foto'     => ['label' => 'Spot Foto',        'icon' => 'ti-camera'],
    'penginapan'    => ['label' => 'Penginapan',       'icon' => 'ti-bed'],
    'souvenir'      => ['label' => 'Toko Souvenir',    'icon' => 'ti-shopping-bag'],
    'pemandu'       => ['label' => 'Pemandu Wisata',   'icon' => 'ti-user-star'],
    'camping'       => ['label' => 'Area Camping',     'icon' => 'ti-tent'],
    'kolam_renang'  => ['label' => 'Kolam Renang',     'icon' => 'ti-swimming'],
    'pertolongan'   => ['label' => 'P3K / Klinik',     'icon' => 'ti-first-aid-kit'],
];

// Handle DELETE review (milik sendiri)
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['delete_review'])) {
    if (is_logged_in()) {
        $review_id = (int)($_POST['review_id'] ?? 0);
        $user_id   = get_user_id();
        // Pastikan review ini milik user yang login
        $del = $pdo->prepare("DELETE FROM reviews WHERE id = ? AND user_id = ? AND place_id = ?");
        $del->execute([$review_id, $user_id, $id]);
        set_flash('success', 'Ulasanmu berhasil dihapus.');
    }
    header("Location: place.php?id=$id");
    exit;
}

// Handle EDIT review (milik sendiri) – simpan perubahan
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['edit_review'])) {
    if (is_logged_in()) {
        $review_id   = (int)($_POST['review_id'] ?? 0);
        $rating_val  = (int)($_POST['rating'] ?? 0);
        $comment     = trim($_POST['comment'] ?? '');
        $user_id     = get_user_id();

        if ($rating_val >= 1 && $rating_val <= 5 && !empty($comment)) {
            $upd = $pdo->prepare("UPDATE reviews SET rating = ?, comment = ?, updated_at = NOW() WHERE id = ? AND user_id = ? AND place_id = ?");
            $upd->execute([$rating_val, $comment, $review_id, $user_id, $id]);
            set_flash('success', 'Ulasanmu berhasil diperbarui.');
        } else {
            set_flash('error', 'Rating (1-5) dan komentar wajib diisi.');
        }
    }
    header("Location: place.php?id=$id");
    exit;
}

// Fetch reviews
$stmt = $pdo->prepare("
    SELECT r.*, u.full_name as user_name, u.username 
    FROM reviews r 
    JOIN users u ON r.user_id = u.id 
    WHERE r.place_id = ? 
    ORDER BY r.created_at DESC 
    LIMIT 10
");
$stmt->execute([$id]);
$reviews = $stmt->fetchAll();

// Cek apakah user yang login sudah punya review di tempat ini
$user_existing_review = null;
if (is_logged_in()) {
    $uid = get_user_id();
    foreach ($reviews as $rev) {
        if ((int)$rev['user_id'] === (int)$uid) {
            $user_existing_review = $rev;
            break;
        }
    }
}

// Handle crowd report submit (baru)
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['submit_crowd'])) {
    if (!is_logged_in()) {
        set_flash('error', 'Kamu harus login untuk melaporkan keramaian.');
    } else {
        $crowd_level = $_POST['crowd_level'] ?? 'moderate';
        $wait_time   = (int)($_POST['wait_time'] ?? 0);
        $crowd_notes = trim($_POST['crowd_notes'] ?? '');
        $user_id     = get_user_id();

        $ins = $pdo->prepare("INSERT INTO crowd_reports (place_id, user_id, crowd_level, wait_time, notes) VALUES (?,?,?,?,?)");
        $ins->execute([$id, $user_id, $crowd_level, $wait_time, $crowd_notes]);

        set_flash('success', 'Laporan keramaian berhasil dikirim!');
    }
    header("Location: place.php?id=$id");
    exit;
}

// Handle crowd report UPDATE (milik sendiri)
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['update_crowd'])) {
    if (is_logged_in()) {
        $report_id   = (int)($_POST['report_id'] ?? 0);
        $user_id     = get_user_id();
        $crowd_level = $_POST['crowd_level'] ?? 'moderate';
        $wait_time   = (int)($_POST['wait_time'] ?? 0);
        $crowd_notes = trim($_POST['crowd_notes'] ?? '');

        // Pastikan laporan ini milik user yang login & untuk tempat ini
        $chk = $pdo->prepare("SELECT id FROM crowd_reports WHERE id = ? AND user_id = ? AND place_id = ?");
        $chk->execute([$report_id, $user_id, $id]);
        if ($chk->fetch()) {
            $upd = $pdo->prepare("UPDATE crowd_reports SET crowd_level = ?, wait_time = ?, notes = ?, created_at = NOW() WHERE id = ?");
            $upd->execute([$crowd_level, $wait_time, $crowd_notes, $report_id]);
            set_flash('success', 'Laporan keramaian berhasil diperbarui!');
        } else {
            set_flash('error', 'Kamu tidak memiliki izin untuk mengubah laporan ini.');
        }
    }
    header("Location: place.php?id=$id");
    exit;
}

// Handle crowd report DELETE (milik sendiri)
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['delete_crowd'])) {
    if (is_logged_in()) {
        $report_id = (int)($_POST['report_id'] ?? 0);
        $user_id   = get_user_id();

        $del = $pdo->prepare("DELETE FROM crowd_reports WHERE id = ? AND user_id = ? AND place_id = ?");
        $del->execute([$report_id, $user_id, $id]);
        set_flash('success', 'Laporan keramaianmu berhasil dihapus.');
    }
    header("Location: place.php?id=$id");
    exit;
}

// Handle review submit (baru)
$review_error   = '';
$review_success = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['submit_review'])) {
    if (!is_logged_in()) {
        $review_error = 'Kamu harus login untuk memberikan ulasan.';
    } else {
        $rating_val = (int)($_POST['rating'] ?? 0);
        $comment    = trim($_POST['comment'] ?? '');
        $user_id    = get_user_id();

        if ($user_existing_review) {
            $review_error = 'Kamu sudah memberikan ulasan. Gunakan tombol Edit untuk merevisinya.';
        } elseif ($rating_val < 1 || $rating_val > 5) {
            $review_error = 'Pilih rating antara 1-5 bintang.';
        } elseif (empty($comment)) {
            $review_error = 'Tulis komentar ulasanmu.';
        } else {
            $ins = $pdo->prepare("INSERT INTO reviews (place_id, user_id, rating, comment) VALUES (?,?,?,?)");
            $ins->execute([$id, $user_id, $rating_val, $comment]);
            
            if (function_exists('check_and_award_badges')) {
                check_and_award_badges($pdo, $user_id);
            }
            
            set_flash('success', 'Ulasanmu berhasil ditambahkan!');
            header("Location: place.php?id=$id");
            exit;
        }
    }
}

require_once 'includes/header.php';
?>

<div class="container">
    <!-- Judul & Meta di atas -->
    <div style="padding: 2rem 0 1rem;">
        <h1 style="font-size: 2.8rem; font-weight: 800; margin-bottom: 0.5rem; color: var(--text-dark);"><?php echo esc($place['name']); ?></h1>
        <div style="display: flex; flex-wrap: wrap; gap: 1.5rem; align-items: center; color: #7d8165; font-size: 0.95rem; margin-bottom: 0.5rem;">
            <span><?php echo esc($place['category_name']); ?></span>
            <span><?php echo esc($place['location']); ?></span>
            <?php if ($rating['count'] > 0): ?>
                <span style="color: var(--accent); font-weight: 600;">⭐ <?php echo number_format($rating['avg_rating'], 1); ?> (<?php echo $rating['count']; ?> ulasan)</span>
            <?php else: ?>
                <span style="color: var(--accent);">Belum ada ulasan</span>
            <?php endif; ?>
            <?php if ($crowd): ?>
                <span class="crowd-badge crowd-<?php echo $crowd['crowd_level']; ?>" style="position:static;"><?php echo get_crowd_label($crowd['crowd_level']); ?></span>
            <?php endif; ?>
        </div>
    </div>

    <!-- Foto destinasi -->
    <div style="margin-bottom: 2rem;">
        <img src="assets/img/<?php echo esc($place['image_url']); ?>" 
             alt="<?php echo esc($place['name']); ?>"
             style="width: 100%; max-height: 500px; object-fit: cover; border-radius: 12px; display: block;">
    </div>

    <div class="place-body">
        <!-- Kolom Kiri: Konten Utama -->
        <div>
            <!-- Deskripsi -->
            <div class="facilities-section">
                <h3><i class="ti ti-info-circle"></i> Tentang Destinasi</h3>
                <p style="color:#4a4a3a; line-height:1.8;"><?php echo nl2br(esc($place['description'])); ?></p>
            </div>

            <!-- FASILITAS -->
            <div class="facilities-section">
                <h3><i class="ti ti-star"></i> Fasilitas Tersedia</h3>
                <?php if (!empty($facilities)): ?>
                    <div class="facilities-grid">
                        <?php foreach ($facilities as $fac):
                            $fac_key = strtolower(trim($fac));
                            $info = $facility_info[$fac_key] ?? ['label' => ucfirst($fac), 'icon' => 'ti-check'];
                        ?>
                            <div class="facility-item">
                                <i class="ti <?php echo $info['icon']; ?>"></i>
                                <span><?php echo esc($info['label']); ?></span>
                            </div>
                        <?php endforeach; ?>
                    </div>
                <?php else: ?>
                    <p class="no-facility">Informasi fasilitas belum tersedia untuk destinasi ini.</p>
                <?php endif; ?>
            </div>


            <!-- Ulasan -->
            <div class="section-header mt-3">
                <h2>Ulasan Pengunjung</h2>
                <p><?php echo $rating['count']; ?> ulasan · Rata-rata <?php echo $rating['count'] > 0 ? number_format($rating['avg_rating'], 1) . ' ★' : 'Belum ada rating'; ?></p>
            </div>

            <!-- Form tulis ulasan (hanya jika belum punya review) -->
            <?php if (is_logged_in()): ?>
                <?php if (!$user_existing_review): ?>
                <div class="review-form-section">
                    <h4 style="margin-bottom:1rem;">Tulis Ulasanmu</h4>
                    <?php if ($review_error): ?>
                        <div class="alert alert-error"><?php echo $review_error; ?></div>
                    <?php endif; ?>
                    <form method="POST">
                        <div class="form-group">
                            <label class="form-label">Rating</label>
                            <div class="star-selector">
                                <?php for ($s = 5; $s >= 1; $s--): ?>
                                    <input type="radio" name="rating" id="star<?php echo $s; ?>" value="<?php echo $s; ?>">
                                    <label for="star<?php echo $s; ?>">★</label>
                                <?php endfor; ?>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Komentar</label>
                            <textarea name="comment" class="form-control" rows="3" placeholder="Bagikan pengalamanmu di sini..." required></textarea>
                        </div>
                        <button type="submit" name="submit_review" class="btn btn-primary">Kirim Ulasan</button>
                    </form>
                </div>
                <?php else: ?>
                <div class="alert alert-info mb-3" style="display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:0.5rem;">
                    <span>✅ Kamu sudah memberikan ulasan untuk destinasi ini.</span>
                    <button class="btn btn-outline btn-sm" onclick="openEditModal(
                        '<?php echo $user_existing_review['id']; ?>',
                        <?php echo $user_existing_review['rating']; ?>,
                        <?php echo json_encode($user_existing_review['comment']); ?>
                    )">Edit Ulasanku</button>
                </div>
                <?php endif; ?>
            <?php else: ?>
            <div class="alert alert-info mb-3">
                <a href="login.php?redirect=place.php?id=<?php echo $id; ?>">Login</a> untuk memberikan ulasan.
            </div>
            <?php endif; ?>

            <!-- Daftar ulasan -->
            <?php foreach ($reviews as $rev): 
                $is_own = is_logged_in() && (int)$rev['user_id'] === (int)get_user_id();
            ?>
            <div class="review-card <?php echo $is_own ? 'own-review' : ''; ?>">
                <?php if ($is_own): ?>
                    <div style="font-size:0.75rem; color:#2ab7a9; font-weight:700; margin-bottom:0.3rem;">✏️ Ulasanmu</div>
                <?php endif; ?>
                <div class="review-header">
                    <span class="review-author"><?php echo esc($rev['user_name'] ?: $rev['username']); ?></span>
                    <span class="review-date"><?php echo date('d M Y', strtotime($rev['created_at'])); ?></span>
                </div>
                <div class="stars mb-1"><?php echo str_repeat('★', $rev['rating']) . str_repeat('☆', 5 - $rev['rating']); ?></div>
                <p class="review-text">"<?php echo esc($rev['comment']); ?>"</p>
                
                <?php if ($is_own): ?>
                <div class="review-actions">
                    <button class="btn-review-action btn-edit-review" onclick="openEditModal(
                        '<?php echo $rev['id']; ?>',
                        <?php echo $rev['rating']; ?>,
                        <?php echo json_encode($rev['comment']); ?>
                    )">
                        <i class="ti ti-pencil"></i> Edit
                    </button>
                    <form method="POST" onsubmit="return confirm('Yakin ingin menghapus ulasan ini?');" style="display:inline;">
                        <input type="hidden" name="review_id" value="<?php echo $rev['id']; ?>">
                        <button type="submit" name="delete_review" class="btn-review-action btn-delete-review">
                            <i class="ti ti-trash"></i> Hapus
                        </button>
                    </form>
                </div>
                <?php endif; ?>
            </div>
            <?php endforeach; ?>
            <?php if (empty($reviews)): ?>
                <p style="color:#aaa; text-align:center; padding:2rem 0;">Belum ada ulasan. Jadilah yang pertama!</p>
            <?php endif; ?>
        </div>

        <!-- Kolom Kanan: Sidebar Info -->
        <div>
            <!-- Harga -->
            <div class="info-card">
                <h4>Estimasi Biaya</h4>
                <div class="info-row">
                    <span class="info-label">Tiket Masuk</span>
                    <span class="info-value accent"><?php echo format_rupiah($place['entrance_fee']); ?></span>
                </div>
                <?php if (!empty($place['parking_fee']) && $place['parking_fee'] > 0): ?>
                <div class="info-row">
                    <span class="info-label">Parkir</span>
                    <span class="info-value"><?php echo format_rupiah($place['parking_fee']); ?></span>
                </div>
                <?php endif; ?>
                <?php if (!empty($place['meal_cost']) && $place['meal_cost'] > 0): ?>
                <div class="info-row">
                    <span class="info-label">Estimasi Makan</span>
                    <span class="info-value"><?php echo format_rupiah($place['meal_cost']); ?></span>
                </div>
                <?php endif; ?>
            </div>

            <!-- Info Keramaian -->
            <?php if ($crowd): ?>
            <div class="info-card">
                <h4 style="display:flex; align-items:center; justify-content:space-between;">
                    Kondisi Terkini
                    <?php if ($user_crowd_report && (int)$user_crowd_report['id'] === (int)$crowd['id']): ?>
                        <div style="display:flex; gap:0.4rem;">
                            <button class="btn-icon-sm" title="Edit laporan" onclick="openEditCrowdModal(
                                '<?php echo (int)$user_crowd_report['id']; ?>',
                                '<?php echo esc($user_crowd_report['crowd_level']); ?>',
                                '<?php echo (int)$user_crowd_report['wait_time']; ?>',
                                '<?php echo esc(addslashes($user_crowd_report['notes'] ?? '')); ?>'
                            )">✏️</button>
                            <form method="POST" style="display:inline;" onsubmit="return confirm('Hapus laporanmu?');">
                                <input type="hidden" name="report_id" value="<?php echo (int)$user_crowd_report['id']; ?>">
                                <button type="submit" name="delete_crowd" class="btn-icon-sm btn-icon-danger" title="Hapus laporan">🗑️</button>
                            </form>
                        </div>
                    <?php endif; ?>
                </h4>
                <div style="text-align:center; padding:0.5rem 0;">
                    <span class="crowd-badge crowd-<?php echo $crowd['crowd_level']; ?>" style="position:static; font-size:1rem; padding:0.5rem 1rem;">
                        <?php echo get_crowd_label($crowd['crowd_level']); ?>
                    </span>
                    <?php if (!empty($crowd['wait_time']) && $crowd['wait_time'] > 0): ?>
                    <p style="font-size:0.83rem; color:#5a6b57; margin-top:0.5rem;">
                        ⏱ Waktu tunggu ~<?php echo (int)$crowd['wait_time']; ?> menit
                    </p>
                    <?php endif; ?>
                    <?php if (!empty($crowd['notes'])): ?>
                    <p style="font-size:0.8rem; color:#aaa; font-style:italic; margin-top:0.25rem;">"<?php echo esc($crowd['notes']); ?>"</p>
                    <?php endif; ?>
                    <p style="font-size:0.8rem; color:#aaa; margin-top:0.5rem;">
                        <?php
                        $crowd_time = $crowd['reported_at']
                            ?? $crowd['created_at']
                            ?? $crowd['timestamp']
                            ?? $crowd['report_time']
                            ?? null;
                        if ($crowd_time && $crowd_time !== '0000-00-00 00:00:00' && strtotime($crowd_time) > 0):
                        ?>
                            Dilaporkan <?php echo date('d M Y H:i', strtotime($crowd_time)); ?>
                        <?php else: ?>
                            Dilaporkan baru-baru ini
                        <?php endif; ?>
                    </p>
                    <?php if ($user_crowd_report && (int)$user_crowd_report['id'] === (int)$crowd['id']): ?>
                        <p style="font-size:0.75rem; color:#2ab7a9; margin-top:0.25rem; font-weight:600;">📌 Laporanmu</p>
                    <?php endif; ?>
                </div>
            </div>
            <?php endif; ?>

            <!-- Widget Laporkan Keramaian -->
            <div class="info-card">
                <?php if ($user_crowd_report): ?>
                    <h4>Laporan Keramaianmu</h4>
                    <div style="background:#f7f6f0; border-radius:8px; padding:0.75rem 1rem; margin-bottom:0.75rem;">
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:0.35rem;">
                            <span class="crowd-badge crowd-<?php echo $user_crowd_report['crowd_level']; ?>" style="position:static; font-size:0.82rem; padding:0.25rem 0.75rem;">
                                <?php echo get_crowd_label($user_crowd_report['crowd_level']); ?>
                            </span>
                            <?php if ($user_crowd_report['wait_time'] > 0): ?>
                            <span style="font-size:0.8rem; color:#7d8165;">⏱ <?php echo (int)$user_crowd_report['wait_time']; ?> menit</span>
                            <?php endif; ?>
                        </div>
                        <?php if (!empty($user_crowd_report['notes'])): ?>
                        <p style="font-size:0.8rem; color:#7d8165; margin:0; font-style:italic;">"<?php echo esc($user_crowd_report['notes']); ?>"</p>
                        <?php endif; ?>
                    </div>
                    <div style="display:flex; gap:0.5rem;">
                        <button class="btn btn-outline btn-sm" style="flex:1;" onclick="openEditCrowdModal(
                            '<?php echo (int)$user_crowd_report['id']; ?>',
                            '<?php echo esc($user_crowd_report['crowd_level']); ?>',
                            '<?php echo (int)$user_crowd_report['wait_time']; ?>',
                            '<?php echo esc(addslashes($user_crowd_report['notes'] ?? '')); ?>'
                        )">✏️ Edit</button>
                        <form method="POST" style="flex:1;" onsubmit="return confirm('Hapus laporanmu?');">
                            <input type="hidden" name="report_id" value="<?php echo (int)$user_crowd_report['id']; ?>">
                            <button type="submit" name="delete_crowd" class="btn btn-outline btn-sm" style="width:100%; color:#e74c3c; border-color:#e74c3c;">🗑️ Hapus</button>
                        </form>
                    </div>
                <?php else: ?>
                    <h4>Laporkan Keramaian</h4>
                    <?php if (!is_logged_in()): ?>
                        <p style="font-size:0.85rem; color:#aaa; margin-bottom:0.75rem;">
                            <a href="login.php" style="color:#2ab7a9; font-weight:600;">Login</a> untuk melaporkan kondisi keramaian.
                        </p>
                    <?php else: ?>
                    <form method="POST">
                        <div class="form-group">
                            <label class="form-label">Tingkat Keramaian</label>
                            <select name="crowd_level" class="form-control" required>
                                <option value="low">🟢 Sepi</option>
                                <option value="moderate" selected>🟡 Sedang</option>
                                <option value="high">🟠 Ramai</option>
                                <option value="very_high">🔴 Sangat Ramai</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Waktu Tunggu (menit)</label>
                            <input type="number" name="wait_time" class="form-control" placeholder="0" min="0" max="999">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Catatan (opsional)</label>
                            <textarea name="crowd_notes" class="form-control" rows="2" placeholder="Info tambahan kondisi tempat..."></textarea>
                        </div>
                        <button type="submit" name="submit_crowd" class="btn btn-secondary btn-block">Kirim Laporan</button>
                    </form>
                    <?php endif; ?>
                <?php endif; ?>
            </div>

            <!-- Fasilitas ringkasan (sidebar) -->
            <?php if (!empty($facilities)): ?>
            <div class="info-card">
                <h4>Fasilitas (<?php echo count($facilities); ?>)</h4>
                <?php foreach ($facilities as $fac):
                    $fac_key = strtolower(trim($fac));
                    $info = $facility_info[$fac_key] ?? ['label' => ucfirst($fac), 'icon' => 'ti-check'];
                ?>
                <div class="info-row">
                    <span class="info-label"><i class="ti <?php echo $info['icon']; ?>" style="margin-right:5px;"></i><?php echo esc($info['label']); ?></span>
                    <span style="color:#2ab7a9;">✓</span>
                </div>
                <?php endforeach; ?>
            </div>
            <?php endif; ?>

            <!-- Tombol aksi -->
            <div class="info-card">
                <h4>Navigasi</h4>
                <?php if (!empty($place['latitude']) && !empty($place['longitude'])): ?>
                <a href="https://www.google.com/maps/dir/?api=1&destination=<?php echo esc($place['latitude']); ?>,<?php echo esc($place['longitude']); ?>" 
                   target="_blank" class="btn btn-primary btn-block mb-2">
                   Petunjuk Arah
                </a>
                <?php else: ?>
                <a href="https://www.google.com/maps/search/<?php echo urlencode($place['name'] . ' ' . $place['location']); ?>" 
                   target="_blank" class="btn btn-outline btn-block mb-2">
                   Cari di Google Maps
                </a>
                <?php endif; ?>
                <a href="index.php?category=<?php echo $place['category_id']; ?>" class="btn btn-outline btn-block">
                    Destinasi Sejenis
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Modal Edit Keramaian -->
<div class="modal-overlay" id="editCrowdModal">
    <div class="modal-box">
        <button class="modal-close" onclick="closeEditCrowdModal()">✕</button>
        <h3>Update Laporan Keramaian</h3>
        <form method="POST" id="editCrowdForm">
            <input type="hidden" name="report_id" id="editCrowdId">
            <div class="form-group">
                <label class="form-label">Tingkat Keramaian</label>
                <div class="crowd-level-selector" id="crowdLevelSelector">
                    <label class="crowd-opt" data-val="low">
                        <input type="radio" name="crowd_level" value="low">
                        <span>Sepi</span>
                    </label>
                    <label class="crowd-opt" data-val="moderate">
                        <input type="radio" name="crowd_level" value="moderate">
                        <span>Sedang</span>
                    </label>
                    <label class="crowd-opt" data-val="high">
                        <input type="radio" name="crowd_level" value="high">
                        <span>Ramai</span>
                    </label>
                    <label class="crowd-opt" data-val="very_high">
                        <input type="radio" name="crowd_level" value="very_high">
                        <span>Sangat Ramai</span>
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Waktu Tunggu (menit)</label>
                <input type="number" name="wait_time" id="editCrowdWait" class="form-control" placeholder="0" min="0" max="999">
            </div>
            <div class="form-group">
                <label class="form-label">Catatan (opsional)</label>
                <textarea name="crowd_notes" id="editCrowdNotes" class="form-control" rows="3" placeholder="Info tambahan kondisi tempat..."></textarea>
            </div>
            <div style="display:flex; gap:0.75rem;">
                <button type="submit" name="update_crowd" class="btn btn-primary">Simpan Perubahan</button>
                <button type="button" class="btn btn-outline" onclick="closeEditCrowdModal()">Batal</button>
            </div>
        </form>
    </div>
</div>

<script>
function openEditCrowdModal(reportId, crowdLevel, waitTime, notes) {
    document.getElementById('editCrowdId').value   = reportId;
    document.getElementById('editCrowdWait').value = waitTime;
    document.getElementById('editCrowdNotes').value = notes;

    // Set radio crowd level & highlight
    document.querySelectorAll('.crowd-opt').forEach(function(opt) {
        const val = opt.getAttribute('data-val');
        const radio = opt.querySelector('input[type="radio"]');
        if (val === crowdLevel) {
            radio.checked = true;
            opt.classList.add('selected');
        } else {
            radio.checked = false;
            opt.classList.remove('selected');
        }
    });

    document.getElementById('editCrowdModal').classList.add('active');
}
function closeEditCrowdModal() {
    document.getElementById('editCrowdModal').classList.remove('active');
}
// Highlight saat pilihan berubah
document.querySelectorAll('.crowd-opt').forEach(function(opt) {
    opt.addEventListener('click', function() {
        document.querySelectorAll('.crowd-opt').forEach(o => o.classList.remove('selected'));
        this.classList.add('selected');
    });
});
// Tutup modal saat klik di luar
document.getElementById('editCrowdModal').addEventListener('click', function(e) {
    if (e.target === this) closeEditCrowdModal();
});
</script>


<div class="modal-overlay" id="editReviewModal">
    <div class="modal-box">
        <button class="modal-close" onclick="closeEditModal()">✕</button>
        <h3>Edit Ulasanmu</h3>
        <form method="POST" id="editReviewForm">
            <input type="hidden" name="review_id" id="editReviewId">
            <div class="form-group">
                <label class="form-label">Rating</label>
                <div class="star-selector" id="editStarSelector">
                    <?php for ($s = 5; $s >= 1; $s--): ?>
                        <input type="radio" name="rating" id="editStar<?php echo $s; ?>" value="<?php echo $s; ?>">
                        <label for="editStar<?php echo $s; ?>">★</label>
                    <?php endfor; ?>
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Komentar</label>
                <textarea name="comment" id="editComment" class="form-control" rows="4" required></textarea>
            </div>
            <div style="display:flex; gap:0.75rem;">
                <button type="submit" name="edit_review" class="btn btn-primary">Simpan Perubahan</button>
                <button type="button" class="btn btn-outline" onclick="closeEditModal()">Batal</button>
            </div>
        </form>
    </div>
</div>

<script>
function openEditModal(reviewId, rating, comment) {
    document.getElementById('editReviewId').value = reviewId;
    document.getElementById('editComment').value = comment;
    // Set bintang yang sesuai
    const starInput = document.getElementById('editStar' + rating);
    if (starInput) starInput.checked = true;
    document.getElementById('editReviewModal').classList.add('active');
}
function closeEditModal() {
    document.getElementById('editReviewModal').classList.remove('active');
}
// Tutup modal saat klik di luar
document.getElementById('editReviewModal').addEventListener('click', function(e) {
    if (e.target === this) closeEditModal();
});
</script>

<?php require_once 'includes/footer.php'; ?>