<?php
$page_title = 'Daftar';
require_once 'includes/functions.php';

if (is_logged_in()) {
    header("Location: index.php");
    exit;
}

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';
    $full_name = trim($_POST['full_name'] ?? '');

    if (empty($username) || empty($email) || empty($password) || empty($full_name)) {
        $error = 'Semua field wajib diisi.';
    } elseif (strlen($password) < 6) {
        $error = 'Password minimal 6 karakter.';
    } else {
        // Check existing
        $stmt = $pdo->prepare("SELECT id FROM users WHERE username = ? OR email = ?");
        $stmt->execute([$username, $email]);
        if ($stmt->fetch()) {
            $error = 'Username atau email sudah terdaftar.';
        } else {
            $hash = password_hash($password, PASSWORD_DEFAULT);
            $stmt = $pdo->prepare("INSERT INTO users (username, email, password_hash, full_name, role) VALUES (?, ?, ?, ?, 'user')");
            $stmt->execute([$username, $email, $hash, $full_name]);
            set_flash('success', 'Pendaftaran berhasil! Silakan masuk.');
            header("Location: login.php");
            exit;
        }
    }
}
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar | Viuspot</title>
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
    <main class="main-content" style="display:flex; align-items:center; justify-content:center; min-height:80vh;">
        <div style="max-width:420px; width:100%; padding:2rem;">
            <div class="text-center mb-3">
                <h1 style="font-size:2rem; color:#2e3b2c;">VIU<span style="color:#8ea994;">SPOT</span></h1>
                <p style="color:#7d8165;">Bergabung dengan komunitas traveler</p>
            </div>

            <?php if ($error): ?>
                <div class="alert alert-error"><?php echo $error; ?></div>
            <?php endif; ?>

            <form method="POST" action="" style="background:#fff; padding:2rem; border-radius:8px; border:1px solid #e8e5d8;">
                <div class="form-group">
                    <label class="form-label">Nama Lengkap</label>
                    <input type="text" name="full_name" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Username</label>
                    <input type="text" name="username" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" required minlength="6">
                </div>
                <button type="submit" class="btn btn-primary btn-block">Daftar</button>
            </form>

            <p class="text-center mt-2" style="font-size:0.9rem;">
                Sudah punya akun? <a href="login.php">Masuk</a>
            </p>
        </div>
    </main>
</body>
</html>
