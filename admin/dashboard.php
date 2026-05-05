<?php
require_once '../includes/functions.php';
require_admin();

$page_title = 'Admin Dashboard';

// Stats
$stmt = $pdo->query("SELECT COUNT(*) as total FROM places WHERE status='pending'");
$pending_count = $stmt->fetch()['total'];

$stmt = $pdo->query("SELECT COUNT(*) as total FROM places WHERE status='approved'");
$approved_count = $stmt->fetch()['total'];

$stmt = $pdo->query("SELECT COUNT(*) as total FROM reviews");
$review_count = $stmt->fetch()['total'];

$stmt = $pdo->query("SELECT COUNT(*) as total FROM users WHERE role='user'");
$user_count = $stmt->fetch()['total'];

// Recent pending places
$stmt = $pdo->query("SELECT p.*, c.`name` as category_name FROM places p JOIN categories c ON p.category_id = c.id WHERE p.status='pending' ORDER BY p.created_at DESC LIMIT 5");
$pending_places = $stmt->fetchAll();

require_once '../includes/header.php';
?>

<div class="container">
    <div class="admin-layout mt-2">
        <aside class="admin-sidebar">
            <h3 class="mb-3">Menu Admin</h3>
            <nav class="admin-sidebar-nav">
                <a href="dashboard.php" class="active">🏠 Dashboard</a>
                <a href="places.php">📍 Kelola Destinasi</a>
                <a href="reviews.php">💬 Kelola Ulasan</a>
                <a href="../logout.php">🚪 Logout</a>
            </nav>
        </aside>

        <main class="admin-main-content">
            <div class="section-header" style="text-align:left; margin-bottom:1.5rem;">
                <h2>Ringkasan Statistik</h2>
                <p>Kondisi terkini database Viuspot</p>
            </div>

            <div class="grid grid-4 mb-4">
                <div class="stat-card-iconic">
                    <div class="stat-icon-box" style="color: #d4a843;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                    </div>
                    <div class="stat-info">
                        <h4>Pending</h4>
                        <div class="stat-value"><?php echo $pending_count; ?></div>
                    </div>
                </div>
                <div class="stat-card-iconic">
                    <div class="stat-icon-box" style="color: var(--emerald-green);">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                    </div>
                    <div class="stat-info">
                        <h4>Aktif</h4>
                        <div class="stat-value"><?php echo $approved_count; ?></div>
                    </div>
                </div>
                <div class="stat-card-iconic">
                    <div class="stat-icon-box" style="color: #6e9895;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                    </div>
                    <div class="stat-info">
                        <h4>Ulasan</h4>
                        <div class="stat-value"><?php echo $review_count; ?></div>
                    </div>
                </div>
                <div class="stat-card-iconic">
                    <div class="stat-icon-box" style="color: #2e3b2c;">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><circle cx="19" cy="11" r="4"/></svg>
                    </div>
                    <div class="stat-info">
                        <h4>User</h4>
                        <div class="stat-value"><?php echo $user_count; ?></div>
                    </div>
                </div>
            </div>

            <div class="section-header" style="text-align:left; margin-bottom:1.5rem;">
                <h3>Usulan Destinasi Baru</h3>
            </div>

            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Nama</th>
                            <th>Kategori</th>
                            <th>Lokasi</th>
                            <th>Tanggal</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($pending_places as $place): ?>
                        <tr>
                            <td><strong><?php echo esc($place['name']); ?></strong></td>
                            <td><span class="badge-display badge-tourist" style="font-size:0.75rem;"><?php echo esc($place['category_name']); ?></span></td>
                            <td><?php echo esc($place['location']); ?></td>
                            <td style="font-size: 0.85rem;"><?php echo date('d/m/y', strtotime($place['created_at'])); ?></td>
                            <td>
                                <div class="flex gap-1">
                                    <a href="places.php?action=approve&id=<?php echo $place['id']; ?>" class="btn btn-accent btn-sm">Approve</a>
                                    <a href="places.php?action=reject&id=<?php echo $place['id']; ?>" class="btn btn-danger btn-sm">Reject</a>
                                </div>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                        <?php if (empty($pending_places)): ?>
                        <tr><td colspan="5" style="text-align:center; color:#7d8165; padding: 3rem;">🎉 Tidak ada usulan pending saat ini.</td></tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>

<?php require_once '../includes/footer.php'; ?>
