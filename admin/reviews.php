<?php
require_once '../includes/functions.php';
require_admin();

$page_title = 'Kelola Ulasan';

if (isset($_GET['action']) && $_GET['action'] === 'delete' && isset($_GET['id'])) {
    $id = (int)$_GET['id'];
    $pdo->prepare("DELETE FROM reviews WHERE id=?")->execute([$id]);
    set_flash('success', 'Ulasan berhasil dihapus.');
    header("Location: reviews.php");
    exit;
}

$stmt = $pdo->query("SELECT r.*, p.name as place_name FROM reviews r JOIN places p ON r.place_id = p.id ORDER BY r.created_at DESC");
$reviews = $stmt->fetchAll();

require_once '../includes/header.php';
?>

<div class="container">
    <h2 style="margin-bottom:1.5rem;">Kelola Ulasan</h2>

    <div class="table-responsive">
        <table class="data-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Pengguna</th>
                    <th>Destinasi</th>
                    <th>Rating</th>
                    <th>Komentar</th>
                    <th>Tanggal</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($reviews as $rev): ?>
                <tr>
                    <td><?php echo $rev['id']; ?></td>
                    <td><?php echo esc($rev['user_name']); ?></td>
                    <td><?php echo esc($rev['place_name']); ?></td>
                    <td class="stars"><?php echo str_repeat('★', $rev['rating']); ?></td>
                    <td><?php echo esc(truncate($rev['comment'], 60)); ?></td>
                    <td><?php echo date('d M Y', strtotime($rev['created_at'])); ?></td>
                    <td>
                        <a href="?action=delete&id=<?php echo $rev['id']; ?>" class="btn btn-danger btn-sm" onclick="return confirm('Hapus ulasan ini?')">Hapus</a>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</div>

<?php require_once '../includes/footer.php'; ?>
