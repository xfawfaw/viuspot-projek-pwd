<?php
$page_title = 'Usulkan Destinasi';
require_once 'includes/functions.php';

$categories = get_categories($pdo);
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = trim($_POST['name'] ?? '');
    $category_id = (int)($_POST['category_id'] ?? 0);
    $location = trim($_POST['location'] ?? '');
    $description = trim($_POST['description'] ?? '');
    $entrance_fee = (float)($_POST['entrance_fee'] ?? 0);
    $parking_fee = (float)($_POST['parking_fee'] ?? 0);
    $meal_cost = (float)($_POST['meal_cost'] ?? 0);
    $latitude = trim($_POST['latitude'] ?? '');
    $longitude = trim($_POST['longitude'] ?? '');

    if (empty($name) || empty($location) || empty($description) || $category_id === 0) {
        $error = 'Nama, kategori, lokasi, dan deskripsi wajib diisi.';
    } else {
        $user_id = get_user_id() ?: null;
        $stmt = $pdo->prepare("INSERT INTO places (name, category_id, location, description, entrance_fee, parking_fee, meal_cost, latitude, longitude, status, submitted_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending', ?)");
        $stmt->execute([$name, $category_id, $location, $description, $entrance_fee, $parking_fee, $meal_cost, $latitude, $longitude, $user_id]);

        set_flash('success', 'Destinasi berhasil diajukan! Admin akan meninjau usulanmu.');
        header("Location: index.php");
        exit;
    }
}

require_once 'includes/header.php';
?>

<div class="container">
    <div class="section-header">
        <h2>Usulkan Destinasi Baru</h2>
        <p>Bantu kami memperkaya database wisata Indonesia. Destinasi akan ditinjau oleh admin sebelum ditampilkan.</p>
    </div>

    <div style="max-width:700px; margin:0 auto;">
        <?php if ($error): ?>
            <div class="alert alert-error"><?php echo $error; ?></div>
        <?php endif; ?>

        <form method="POST" action="" style="background:#fff; padding:2rem; border-radius:8px; border:1px solid #e8e5d8;">
            <div class="form-group">
                <label class="form-label">Nama Destinasi *</label>
                <input type="text" name="name" class="form-control" required>
            </div>

            <div class="form-group">
                <label class="form-label">Kategori *</label>
                <select name="category_id" class="form-control" required>
                    <option value="">-- Pilih Kategori --</option>
                    <?php foreach ($categories as $cat): ?>
                        <option value="<?php echo $cat['id']; ?>"><?php echo esc($cat['name']); ?></option>
                    <?php endforeach; ?>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Lokasi *</label>
                <input type="text" name="location" class="form-control" placeholder="Contoh: Yogyakarta, DI Yogyakarta" required>
            </div>

            <div class="form-group">
                <label class="form-label">Deskripsi *</label>
                <textarea name="description" class="form-control" rows="4" required></textarea>
            </div>

            <div class="grid grid-3">
                <div class="form-group">
                    <label class="form-label">Tiket Masuk (Rp)</label>
                    <input type="number" name="entrance_fee" class="form-control" min="0" value="0">
                </div>
                <div class="form-group">
                    <label class="form-label">Parkir (Rp)</label>
                    <input type="number" name="parking_fee" class="form-control" min="0" value="0">
                </div>
                <div class="form-group">
                    <label class="form-label">Estimasi Makan (Rp)</label>
                    <input type="number" name="meal_cost" class="form-control" min="0" value="0">
                </div>
            </div>

            <div class="grid grid-2">
                <div class="form-group">
                    <label class="form-label">Latitude</label>
                    <input type="text" name="latitude" class="form-control" placeholder="-7.7956">
                </div>
                <div class="form-group">
                    <label class="form-label">Longitude</label>
                    <input type="text" name="longitude" class="form-control" placeholder="110.3695">
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-block">Ajukan Destinasi</button>
        </form>
    </div>
</div>

<?php require_once 'includes/footer.php'; ?>
