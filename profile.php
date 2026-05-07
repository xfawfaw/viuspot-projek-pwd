<?php
$page_title = 'Profil Saya';
require_once 'includes/functions.php';

// Wajib login
if (!is_logged_in()) {
    set_flash('error', 'Kamu harus login untuk melihat profil.');
    header('Location: login.php?redirect=profile.php');
    exit;
}

$user_id = get_user_id();

// Fetch data user
$stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
$stmt->execute([$user_id]);
$user = $stmt->fetch();
if (!$user) {
    header('Location: logout.php');
    exit;
}

// Handle update profil
$update_error   = '';
$update_success = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['update_profile'])) {
    $full_name = trim($_POST['full_name'] ?? '');
    $email     = trim($_POST['email'] ?? '');
    $new_pass  = $_POST['new_password'] ?? '';
    $cur_pass  = $_POST['current_password'] ?? '';

    if (empty($full_name) || empty($email)) {
        $update_error = 'Nama lengkap dan email wajib diisi.';
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $update_error = 'Format email tidak valid.';
    } else {
        // Cek email duplikat (selain milik sendiri)
        $dup = $pdo->prepare("SELECT id FROM users WHERE email = ? AND id != ?");
        $dup->execute([$email, $user_id]);
        if ($dup->fetch()) {
            $update_error = 'Email sudah digunakan akun lain.';
        } else {
            if (!empty($new_pass)) {
                if (empty($cur_pass) || !password_verify($cur_pass, $user['password'])) {
                    $update_error = 'Password saat ini tidak sesuai.';
                } elseif (strlen($new_pass) < 6) {
                    $update_error = 'Password baru minimal 6 karakter.';
                } else {
                    $hashed = password_hash($new_pass, PASSWORD_DEFAULT);
                    $pdo->prepare("UPDATE users SET full_name=?, email=?, password=? WHERE id=?")
                        ->execute([$full_name, $email, $hashed, $user_id]);
                    $update_success = 'Profil & password berhasil diperbarui.';
                }
            } else {
                $pdo->prepare("UPDATE users SET full_name=?, email=? WHERE id=?")
                    ->execute([$full_name, $email, $user_id]);
                $update_success = 'Profil berhasil diperbarui.';
            }
            // Refresh data user
            $stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
            $stmt->execute([$user_id]);
            $user = $stmt->fetch();
        }
    }
}

// Riwayat ulasan milik user
$stmt = $pdo->prepare("
    SELECT r.*, p.name as place_name, p.id as place_id, p.image_url
    FROM reviews r
    JOIN places p ON r.place_id = p.id
    WHERE r.user_id = ?
    ORDER BY r.created_at DESC
");
$stmt->execute([$user_id]);
$my_reviews = $stmt->fetchAll();

// Badge milik user
$my_badges = [];
if (function_exists('get_user_badges')) {
    $my_badges = get_user_badges($pdo, $user_id);
} else {
    // Fallback query jika fungsi tidak ada
    $stmt = $pdo->prepare("
        SELECT b.* FROM badges b
        JOIN user_badges ub ON ub.badge_id = b.id
        WHERE ub.user_id = ?
        ORDER BY ub.earned_at DESC
    ");
    $stmt->execute([$user_id]);
    $my_badges = $stmt->fetchAll();
}

// Statistik singkat
$total_reviews   = count($my_reviews);
$avg_given_rating = $total_reviews > 0
    ? array_sum(array_column($my_reviews, 'rating')) / $total_reviews
    : 0;

require_once 'includes/header.php';
?>

<style>
.profile-grid {
    display: grid;
    grid-template-columns: 300px 1fr;
    gap: 2rem;
    align-items: start;
}
@media (max-width: 860px) {
    .profile-grid { grid-template-columns: 1fr; }
}
.profile-card {
    background: #fff;
    border: 1px solid #e8e5d8;
    border-radius: 12px;
    padding: 1.75rem;
    margin-bottom: 1.25rem;
}
.profile-card h3 {
    font-size: 1rem;
    font-weight: 700;
    color: var(--text-dark);
    margin-bottom: 1.25rem;
    padding-bottom: 0.6rem;
    border-bottom: 1px solid #e8e5d8;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}
.avatar-circle {
    width: 80px; height: 80px;
    border-radius: 50%;
    background: linear-gradient(135deg, #2ab7a9, #1e8c85);
    display: flex; align-items: center; justify-content: center;
    font-size: 2.2rem; font-weight: 800; color: #fff;
    margin: 0 auto 1rem;
    box-shadow: 0 4px 16px rgba(42,183,169,0.3);
}
.stat-row {
    display: flex; justify-content: space-between;
    align-items: center; padding: 0.55rem 0;
    border-bottom: 1px dashed #f0ece0; font-size: 0.88rem;
}
.stat-row:last-child { border-bottom: none; }
.stat-label { color: #7d8165; }
.stat-value { font-weight: 700; color: var(--text-dark); }
.stat-value.accent { color: #2ab7a9; }

.badge-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
    gap: 0.75rem;
    margin-top: 0.25rem;
}
.badge-item {
    text-align: center;
    padding: 0.85rem 0.5rem;
    background: #f7f6f0;
    border-radius: 10px;
    border: 1px solid #e8e5d8;
    transition: all 0.2s;
}
.badge-item:hover {
    background: #edfaf8; border-color: #2ab7a9;
    transform: translateY(-2px); box-shadow: 0 4px 12px rgba(42,183,169,0.1);
}
.badge-icon { font-size: 2rem; margin-bottom: 0.35rem; }
.badge-name { font-size: 0.72rem; font-weight: 700; color: var(--text-dark); line-height: 1.2; }
.badge-desc { font-size: 0.65rem; color: #7d8165; margin-top: 0.2rem; }

.review-history-item {
    display: flex; gap: 1rem; align-items: flex-start;
    padding: 1rem; background: #fff; border: 1px solid #e8e5d8;
    border-radius: 10px; margin-bottom: 0.75rem; transition: box-shadow 0.2s;
}
.review-history-item:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.07); }
.review-history-img {
    width: 70px; height: 70px; flex-shrink: 0;
    object-fit: cover; border-radius: 8px;
}
.review-history-body { flex: 1; min-width: 0; }
.review-history-place {
    font-weight: 700; font-size: 0.95rem; color: var(--text-dark);
    text-decoration: none; display: block;
}
.review-history-place:hover { color: #2ab7a9; }
.review-history-stars { color: #f9c74f; font-size: 0.9rem; margin: 0.2rem 0; }
.review-history-comment {
    font-size: 0.85rem; color: #4a4a3a; line-height: 1.5;
    display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}
.review-history-meta { font-size: 0.75rem; color: #aaa; margin-top: 0.3rem; }

.tabs { display: flex; gap: 0; border-bottom: 2px solid #e8e5d8; margin-bottom: 1.5rem; }
.tab-btn {
    padding: 0.7rem 1.25rem; border: none; background: transparent;
    font-size: 0.9rem; font-weight: 600; color: #7d8165; cursor: pointer;
    border-bottom: 2px solid transparent; margin-bottom: -2px; transition: all 0.2s;
}
.tab-btn.active { color: #2ab7a9; border-bottom-color: #2ab7a9; }
.tab-content { display: none; }
.tab-content.active { display: block; }
</style>

<div class="container" style="padding-top: 2rem; padding-bottom: 3rem;">
    <div class="section-header">
        <h2>Profil Saya</h2>
        <p>Kelola akun, riwayat ulasan, dan pencapaianmu</p>
    </div>

    <div class="profile-grid">
        <!-- Kolom Kiri: Info + Statistik + Badge -->
        <div>
            <!-- Avatar & info singkat -->
            <div class="profile-card" style="text-align:center;">
                <div class="avatar-circle"><?php echo mb_strtoupper(mb_substr($user['full_name'] ?: $user['username'], 0, 1)); ?></div>
                <h2 style="font-size:1.3rem; font-weight:800; margin-bottom:0.2rem;"><?php echo esc($user['full_name'] ?: $user['username']); ?></h2>
                <p style="color:#7d8165; font-size:0.85rem;">@<?php echo esc($user['username']); ?></p>
                <p style="color:#7d8165; font-size:0.8rem; margin-top:0.3rem;">
                    Bergabung <?php echo date('M Y', strtotime($user['created_at'])); ?>
                </p>
            </div>

            <!-- Statistik -->
            <div class="profile-card">
                <h3><i class="ti ti-chart-bar"></i> Statistikku</h3>
                <div class="stat-row">
                    <span class="stat-label">Total Ulasan</span>
                    <span class="stat-value accent"><?php echo $total_reviews; ?></span>
                </div>
                <div class="stat-row">
                    <span class="stat-label">Rata-rata Rating Diberikan</span>
                    <span class="stat-value"><?php echo $avg_given_rating > 0 ? number_format($avg_given_rating, 1) . ' ★' : '-'; ?></span>
                </div>
                <div class="stat-row">
                    <span class="stat-label">Badge Diraih</span>
                    <span class="stat-value accent"><?php echo count($my_badges); ?></span>
                </div>
            </div>

            <!-- Badge -->
            <?php if (!empty($my_badges)): ?>
            <div class="profile-card">
                <h3><i class="ti ti-award"></i> Badge Diraih</h3>
                <div class="badge-grid">
                    <?php foreach ($my_badges as $badge): ?>
                    <div class="badge-item" title="<?php echo esc($badge['description'] ?? ''); ?>">
                        <div class="badge-icon"><?php echo $badge['icon'] ?? '🏆'; ?></div>
                        <div class="badge-name"><?php echo esc($badge['name']); ?></div>
                        <?php if (!empty($badge['description'])): ?>
                            <div class="badge-desc"><?php echo esc($badge['description']); ?></div>
                        <?php endif; ?>
                    </div>
                    <?php endforeach; ?>
                </div>
            </div>
            <?php else: ?>
            <div class="profile-card" style="text-align:center; color:#aaa;">
                <i class="ti ti-award" style="font-size:2.5rem; opacity:0.3;"></i>
                <p style="margin-top:0.5rem; font-size:0.88rem;">Belum ada badge. Mulai berikan ulasan untuk meraih badge!</p>
                <a href="badges.php" style="font-size:0.85rem; color:#2ab7a9;">Lihat semua badge →</a>
            </div>
            <?php endif; ?>
        </div>

        <!-- Kolom Kanan: Tab (Ulasan | Edit Profil) -->
        <div>
            <div class="tabs">
                <button class="tab-btn active" onclick="switchTab(event, 'tab-reviews')">
                    <i class="ti ti-message-circle"></i> Riwayat Ulasan (<?php echo $total_reviews; ?>)
                </button>
                <button class="tab-btn" onclick="switchTab(event, 'tab-edit')">
                    <i class="ti ti-user-edit"></i> Edit Profil
                </button>
            </div>

            <!-- Tab: Riwayat Ulasan -->
            <div class="tab-content active" id="tab-reviews">
                <?php if (!empty($my_reviews)): ?>
                    <?php foreach ($my_reviews as $rev): ?>
                    <div class="review-history-item">
                        <img class="review-history-img" 
                             src="assets/img/<?php echo esc($rev['image_url']); ?>"
                             onerror="this.src='assets/img/home.jpg'"
                             alt="<?php echo esc($rev['place_name']); ?>">
                        <div class="review-history-body">
                            <a href="place.php?id=<?php echo $rev['place_id']; ?>" class="review-history-place">
                                <?php echo esc($rev['place_name']); ?>
                            </a>
                            <div class="review-history-stars">
                                <?php echo str_repeat('★', $rev['rating']) . str_repeat('☆', 5 - $rev['rating']); ?>
                                <span style="color:#aaa; font-size:0.8rem; margin-left:4px;"><?php echo $rev['rating']; ?>/5</span>
                            </div>
                            <p class="review-history-comment"><?php echo esc($rev['comment']); ?></p>
                            <div class="review-history-meta">
                                <?php echo date('d M Y, H:i', strtotime($rev['created_at'])); ?>
                                <?php if (!empty($rev['updated_at']) && $rev['updated_at'] !== $rev['created_at']): ?>
                                    &middot; <em>diedit <?php echo date('d M Y', strtotime($rev['updated_at'])); ?></em>
                                <?php endif; ?>
                            </div>
                        </div>
                        <div style="display:flex; flex-direction:column; gap:0.4rem; flex-shrink:0;">
                            <a href="place.php?id=<?php echo $rev['place_id']; ?>" class="btn btn-outline btn-sm" style="font-size:0.75rem; white-space:nowrap;">Lihat</a>
                        </div>
                    </div>
                    <?php endforeach; ?>
                <?php else: ?>
                    <div style="text-align:center; padding:3rem 1rem; color:#aaa;">
                        <i class="ti ti-message-off" style="font-size:3rem; opacity:0.3;"></i>
                        <p style="margin-top:0.75rem;">Kamu belum pernah memberikan ulasan.</p>
                        <a href="index.php" class="btn btn-primary btn-sm" style="margin-top:0.75rem;">Jelajahi Destinasi</a>
                    </div>
                <?php endif; ?>
            </div>

            <!-- Tab: Edit Profil -->
            <div class="tab-content" id="tab-edit">
                <div class="profile-card" style="margin-bottom:0;">
                    <h3><i class="ti ti-user-edit"></i> Ubah Data Akun</h3>

                    <?php if ($update_error): ?>
                        <div class="alert alert-error"><?php echo $update_error; ?></div>
                    <?php endif; ?>
                    <?php if ($update_success): ?>
                        <div class="alert alert-success"><?php echo $update_success; ?></div>
                    <?php endif; ?>

                    <form method="POST">
                        <div class="form-group">
                            <label class="form-label">Username</label>
                            <input type="text" class="form-control" value="<?php echo esc($user['username']); ?>" disabled style="background:#f7f6f0; color:#aaa;">
                            <small style="color:#aaa; font-size:0.78rem;">Username tidak bisa diubah.</small>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Nama Lengkap *</label>
                            <input type="text" name="full_name" class="form-control" value="<?php echo esc($user['full_name']); ?>" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Email *</label>
                            <input type="email" name="email" class="form-control" value="<?php echo esc($user['email']); ?>" required>
                        </div>

                        <hr style="border:none; border-top:1px dashed #e8e5d8; margin:1.25rem 0;">
                        <p style="font-size:0.85rem; color:#7d8165; margin-bottom:1rem;">Isi bagian ini hanya jika ingin mengubah password:</p>

                        <div class="form-group">
                            <label class="form-label">Password Saat Ini</label>
                            <input type="password" name="current_password" class="form-control" placeholder="Masukkan password saat ini">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Password Baru</label>
                            <input type="password" name="new_password" class="form-control" placeholder="Min. 6 karakter">
                        </div>

                        <button type="submit" name="update_profile" class="btn btn-primary">Simpan Perubahan</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function switchTab(e, tabId) {
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
    e.currentTarget.classList.add('active');
    document.getElementById(tabId).classList.add('active');
}

// Buka tab edit jika ada pesan sukses/error edit profil
<?php if ($update_error || $update_success): ?>
(function() {
    const tabs = document.querySelectorAll('.tab-btn');
    const contents = document.querySelectorAll('.tab-content');
    tabs.forEach(b => b.classList.remove('active'));
    contents.forEach(c => c.classList.remove('active'));
    tabs[1].classList.add('active');
    document.getElementById('tab-edit').classList.add('active');
})();
<?php endif; ?>
</script>

<?php require_once 'includes/footer.php'; ?>