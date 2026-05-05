<?php
require_once '../includes/functions.php';
require_admin();

$page_title = 'Kelola Destinasi';

// Handle actions
if (isset($_GET['action']) && isset($_GET['id'])) {
    $action = $_GET['action'];
    $id = (int)$_GET['id'];

    if ($action === 'approve') {
        $pdo->prepare("UPDATE places SET status='approved' WHERE id=?")->execute([$id]);
        set_flash('success', 'Destinasi berhasil diapprove.');
    } elseif ($action === 'reject') {
        $pdo->prepare("UPDATE places SET status='rejected' WHERE id=?")->execute([$id]);
        set_flash('success', 'Destinasi berhasil direject.');
    } elseif ($action === 'delete') {
        $pdo->prepare("DELETE FROM places WHERE id=?")->execute([$id]);
        set_flash('success', 'Destinasi berhasil dihapus.');
    }
    header("Location: places.php");
    exit;
}

// Filter
$status_filter = $_GET['status'] ?? 'all';
if ($status_filter !== 'all') {
    $places = get_all_places($pdo, $status_filter);
} else {
    $stmt = $pdo->query("SELECT p.*, c.`name` as category_name FROM places p JOIN categories c ON p.category_id = c.id ORDER BY p.created_at DESC");
    $places = $stmt->fetchAll();
}

require_once '../includes/header.php';
?>

<div class="container">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem; flex-wrap:wrap; gap:1rem;">
        <h2>Kelola Destinasi</h2>
        <div style="display:flex; gap:0.5rem;">
            <a href="places.php?status=all" class="btn btn-sm <?php echo $status_filter=='all'?'btn-primary':'btn-outline'; ?>">Semua</a>
            <a href="places.php?status=pending" class="btn btn-sm <?php echo $status_filter=='pending'?'btn-primary':'btn-outline'; ?>">Pending</a>
            <a href="places.php?status=approved" class="btn btn-sm <?php echo $status_filter=='approved'?'btn-primary':'btn-outline'; ?>">Approved</a>
            <a href="places.php?status=rejected" class="btn btn-sm <?php echo $status_filter=='rejected'?'btn-primary':'btn-outline'; ?>">Rejected</a>
        </div>
    </div>

    <div class="table-responsive">
        <table class="data-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nama</th>
                    <th>Kategori</th>
                    <th>Lokasi</th>
                    <th>Status</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($places as $place): ?>
                <tr>
                    <td><?php echo $place['id']; ?></td>
                    <td><?php echo esc($place['name']); ?></td>
                    <td><?php echo esc($place['category_name']); ?></td>
                    <td><?php echo esc($place['location']); ?></td>
                    <td><span class="status-badge status-<?php echo $place['status']; ?>"><?php echo ucfirst($place['status']); ?></span></td>
                    <td>
                        <?php if ($place['status'] === 'pending'): ?>
                            <a href="?action=approve&id=<?php echo $place['id']; ?>" class="btn btn-accent btn-sm">Approve</a>
                            <a href="?action=reject&id=<?php echo $place['id']; ?>" class="btn btn-danger btn-sm">Reject</a>
                        <?php endif; ?>
                        <a href="?action=delete&id=<?php echo $place['id']; ?>" class="btn btn-danger btn-sm" onclick="return confirm('Hapus destinasi ini?')">Hapus</a>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</div>

<?php require_once '../includes/footer.php'; ?>
