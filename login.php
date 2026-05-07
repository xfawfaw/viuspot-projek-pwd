<?php
$page_title = 'Masuk';
require_once 'includes/functions.php';

if (is_logged_in()) {
    header("Location: index.php");
    exit;
}

// Simpan URL tujuan setelah login
$redirect = $_GET['redirect'] ?? $_POST['redirect'] ?? 'index.php';
// Keamanan: hanya izinkan redirect ke file .php lokal (tidak ke URL eksternal)
if (!preg_match('/^[a-zA-Z0-9_\-]+\.php(\?.*)?$/', $redirect)) {
    $redirect = 'index.php';
}

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username'] ?? '');
    $password = $_POST['password'] ?? '';

    if (empty($username) || empty($password)) {
        $error = 'Username dan password wajib diisi.';
    } else {
        $stmt = $pdo->prepare("SELECT * FROM users WHERE username = ? OR email = ?");
        $stmt->execute([$username, $username]);
        $user = $stmt->fetch();

        if ($user && password_verify($password, $user['password_hash'])) {
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['username'] = $user['username'];
            $_SESSION['role'] = $user['role'];
            $_SESSION['full_name'] = $user['full_name'];
            header("Location: " . $redirect);
            exit;
        } else {
            $error = 'Username atau password salah.';
        }
    }
}
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Masuk | Viuspot</title>
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
    <main class="main-content" style="display:flex; align-items:center; justify-content:center; min-height:80vh;">
        <div style="max-width:420px; width:100%; padding:2rem;">
            <div class="text-center mb-3">
                <h1 style="font-size:2rem; color:#2e3b2c;">VIU<span style="color:#8ea994;">SPOT</span></h1>
                <p style="color:#7d8165;">Masuk untuk mulai menjelajah</p>
            </div>

            <?php if ($error): ?>
                <div class="alert alert-error"><?php echo $error; ?></div>
            <?php endif; ?>

            <?php
            // Tampilkan flash message (misal: "harus login dulu")
            if (isset($_SESSION['flash'])) {
                $flash = $_SESSION['flash'];
                unset($_SESSION['flash']);
                echo '<div class="alert alert-' . $flash['type'] . '">' . $flash['message'] . '</div>';
            }
            ?>

            <form method="POST" action="" style="background:#fff; padding:2rem; border-radius:8px; border:1px solid #e8e5d8;">
                <input type="hidden" name="redirect" value="<?php echo esc($redirect); ?>">
                <div class="form-group">
                    <label class="form-label">Username atau Email</label>
                    <input type="text" name="username" class="form-control" required autofocus>
                </div>
                <div class="form-group">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Masuk</button>
            </form>

            <p class="text-center mt-2" style="font-size:0.9rem;">
                Belum punya akun? <a href="register.php">Daftar sekarang</a>
            </p>
        </div>
    </main>
</body>
</html>
