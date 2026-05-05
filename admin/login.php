<?php
require_once '../includes/functions.php';

if (is_admin()) {
    header("Location: dashboard.php");
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username'] ?? '');
    $password = $_POST['password'] ?? '';

    $stmt = $pdo->prepare("SELECT * FROM users WHERE (username = ? OR email = ?) AND role = 'admin'");
    $stmt->execute([$username, $username]);
    $user = $stmt->fetch();

    if ($user && password_verify($password, $user['password_hash'])) {
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['username'] = $user['username'];
        $_SESSION['role'] = $user['role'];
        $_SESSION['full_name'] = $user['full_name'];
        header("Location: dashboard.php");
        exit;
    } else {
        $error = 'Akses admin ditolak. Username atau password salah.';
    }
}
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | Viuspot</title>
    <link rel="stylesheet" href="../assets/css/style.css">
</head>
<body>
    <main class="main-content" style="display:flex; align-items:center; justify-content:center; min-height:80vh;">
        <div style="max-width:420px; width:100%; padding:2rem;">
            <div class="text-center mb-3">
                <h1 style="font-size:2rem; color:#2e3b2c;">VIU<span style="color:#8ea994;">SPOT</span></h1>
                <p style="color:#7d8165;">Admin Panel</p>
            </div>
            <?php if (isset($error)): ?>
                <div class="alert alert-error"><?php echo $error; ?></div>
            <?php endif; ?>
            <form method="POST" action="" style="background:#fff; padding:2rem; border-radius:8px; border:1px solid #e8e5d8;">
                <div class="form-group">
                    <label class="form-label">Username Admin</label>
                    <input type="text" name="username" class="form-control" required autofocus>
                </div>
                <div class="form-group">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Masuk Admin</button>
            </form>
        </div>
    </main>
</body>
</html>
