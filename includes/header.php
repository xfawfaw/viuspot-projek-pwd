<?php
require_once __DIR__ . '/functions.php';
$categories = get_categories($pdo);
$current_page = basename($_SERVER['PHP_SELF']);
$prefix = str_contains($_SERVER['PHP_SELF'], '/admin/') ? '../' : '';
$flash = get_flash();
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo isset($page_title) ? esc($page_title) . ' | ' : ''; ?>Viuspot - Wisata Indonesia</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="<?php echo $prefix; ?>assets/css/style.css">
</head>
<body>
    <header class="site-header">
        <div class="container">
            <a href="<?php echo $prefix; ?>index.php" class="logo">Viu<span>spot</span></a>

            <a href="#main-nav" class="menu-toggle" aria-label="Toggle navigation">&#9776; Menu</a>

            <nav class="main-nav" id="main-nav">
                <a href="<?php echo $prefix; ?>index.php"
                    class="<?php echo $current_page === 'index.php' ? 'active' : ''; ?>">Beranda</a>
                <a href="<?php echo $prefix; ?>planner.php"
                    class="<?php echo $current_page === 'planner.php' ? 'active' : ''; ?>">Planner</a>
                <a href="<?php echo $prefix; ?>budget.php"
                    class="<?php echo $current_page === 'budget.php' ? 'active' : ''; ?>">Budget</a>
                <a href="<?php echo $prefix; ?>badges.php"
                    class="<?php echo $current_page === 'badges.php' ? 'active' : ''; ?>">Badges</a>
                <a href="<?php echo $prefix; ?>community.php"
                    class="<?php echo $current_page === 'community.php' ? 'active' : ''; ?>">Komunitas</a>
                <?php if (is_admin()): ?>
                    <a href="<?php echo $prefix; ?>admin/dashboard.php"
                        class="<?php echo str_contains($_SERVER['PHP_SELF'], '/admin/') ? 'active' : ''; ?>">Admin</a>
                <?php endif; ?>
                <?php if (is_logged_in()): ?>
                    <a href="<?php echo $prefix; ?>logout.php">Logout&nbsp;(<?php echo esc(get_username()); ?>)</a>
                <?php else: ?>
                    <a href="<?php echo $prefix; ?>login.php"
                        class="btn-nav-cta <?php echo $current_page === 'login.php' ? 'active' : ''; ?>">Masuk</a>
                <?php endif; ?>
            </nav>
        </div>
    </header>

    <main class="main-content">
        <div class="container">
            <?php if ($flash): ?>
                <div class="alert alert-<?php echo $flash['type']; ?>">
                    <?php echo esc($flash['message']); ?>
                </div>
            <?php endif; ?>