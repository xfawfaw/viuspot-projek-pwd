<?php
$page_title = 'Badge & Level';
require_once 'includes/functions.php';

// Get all badges
$stmt = $pdo->query("SELECT * FROM badges ORDER BY min_reviews");
$all_badges = $stmt->fetchAll();

// Current user stats
$user_id = get_user_id();
$user_level = ['name' => '-', 'class' => 'tourist'];
$user_badges = [];
$review_count = 0;
$next_badge = null;
$progress = 0;

if ($user_id) {
    $review_count = get_user_review_count($pdo, $user_id);
    $user_level = get_user_level($pdo, $user_id);
    $user_badges = get_user_badges($pdo, $user_id);
    check_and_award_badges($pdo, $user_id);

    // Recalculate after awarding
    $user_badges = get_user_badges($pdo, $user_id);

    // Find next badge
    foreach ($all_badges as $badge) {
        $has = false;
        foreach ($user_badges as $ub) {
            if ($ub['id'] == $badge['id']) { $has = true; break; }
        }
        if (!$has) {
            $next_badge = $badge;
            break;
        }
    }

    if ($next_badge) {
        $prev_min = 0;
        foreach ($all_badges as $b) {
            if ($b['id'] == $next_badge['id']) break;
            $prev_min = $b['min_reviews'];
        }
        $range = $next_badge['min_reviews'] - $prev_min;
        $earned = $review_count - $prev_min;
        $progress = min(100, max(0, round(($earned / $range) * 100)));
    } else {
        $progress = 100;
    }
}

// Leaderboard
$stmt = $pdo->query("
    SELECT u.id as user_id, u.full_name as user_name, COUNT(r.id) as review_count 
    FROM users u 
    JOIN reviews r ON u.id = r.user_id 
    WHERE u.role = 'user' 
    GROUP BY u.id 
    ORDER BY review_count DESC 
    LIMIT 10
");
$leaderboard = $stmt->fetchAll();

require_once 'includes/header.php';
?>

<style>
.rank-icon {
    width: 80px;
    height: 80px;
    fill: #ffffff;
    margin-bottom: 1rem;
    filter: drop-shadow(0 4px 6px rgba(0,0,0,0.3));
}

.level-tourist { background: #8ea994 !important; }
.level-backpacker { background: #5a6b57 !important; }
.level-wanderer { background: #2e3b2c !important; }
.level-explorer { background: #0f625c !important; }
.level-legend {
    background: #79d9ff !important;
    position: relative;
    box-shadow: 0 0 20px rgba(0, 180, 216, 0.4);
    border: 1px solid #00b4d8;
    animation: blueFirePulse 1.5s infinite alternate;
}
@keyframes blueFirePulse {
    0% { box-shadow: 0 0 15px #00b4d8, 0 0 30px #0077b6, inset 0 0 10px #90e0ef; }
    100% { box-shadow: 0 0 30px #00b4d8, 0 0 60px #03045e, inset 0 0 20px #caf0f8; }
}

</style>

<?php
$level_class = 'level-tourist';
$lvl_name = strtolower($user_level['name'] ?? '');

if (str_contains($lvl_name, 'backpacker')) {
    $level_class = 'level-backpacker';
} elseif (str_contains($lvl_name, 'wanderer')) {
    $level_class = 'level-wanderer';
} elseif (str_contains($lvl_name, 'legend')) {
    $level_class = 'level-legend';
} elseif (str_contains($lvl_name, 'explorer')) {
    $level_class = 'level-explorer';
}
?>

<div class="container">
    <?php if ($user_id): ?>
        <div class="profile-badge-header <?php echo $level_class; ?>">
            <svg class="rank-icon" viewBox="0 0 24 24"><path d="M12 1L9 9H1L7 14L4 22L12 17L20 22L17 14L25 9H15L12 1Z"/></svg>
            <h2 style="color: #fff; margin-bottom: 0.5rem;"><?php echo $user_level['name']; ?></h2>
            <p style="opacity: 0.9;"><?php echo $review_count; ?> Kontribusi Ulasan</p>

            <?php if ($next_badge): ?>
                <div class="progress-container-alt">
                    <div style="display: flex; justify-content: space-between; font-size: 0.85rem; margin-bottom: 0.5rem;">
                        <span>Target: <?php echo $next_badge['name']; ?></span>
                        <span><?php echo $progress; ?>%</span>
                    </div>
                    <div class="progress-bar-transparent">
                        <div class="progress-fill-white" style="width:<?php echo $progress; ?>%;"></div>
                    </div>
                </div>
            <?php else: ?>
                <p style="margin-top:1.5rem; font-weight:600;">Hormat Kepada Sepuhh, Hormat Puhh</p>
            <?php endif; ?>
        </div>
    <?php else: ?>
        <div class="profile-badge-header" style="background: #2e3b2c;">
            <h2 style="color: #fff;">Sistem Badge & Level</h2>
            <p style="margin-bottom: 1.5rem;">Masuk untuk melacak kontribusi dan mendapatkan lencana eksklusif.</p>
            <a href="login.php" class="btn btn-accent">Mulai Sekarang</a>
        </div>
    <?php endif; ?>

    <div class="section-header mt-4">
        <h2>Pencapaian Traveler</h2>
        <p>Dapatkan badge berikut dengan berbagi ulasan di destinasi favoritmu</p>
    </div>

    <div class="achievement-grid mb-4">
        <?php foreach ($all_badges as $badge): ?>
            <div class="planner-card" style="text-align:center;">
                <svg style="width:48px; height:48px; fill:#2ab7a9; margin-bottom:1rem;" viewBox="0 0 24 24">
                    <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                </svg>
                <h4 style="margin-bottom:0.5rem;"><?php echo esc($badge['name']); ?></h4>
                <p style="font-size:0.85rem; color:#7d8165; margin-bottom:1rem;"><?php echo esc($badge['description']); ?></p>
                <span class="badge-display badge-tourist" style="background: var(--bg-cream);"><?php echo $badge['min_reviews']; ?>+ Ulasan</span>
            </div>
        <?php endforeach; ?>
    </div>

    <div class="section-header mt-4">
        <h3>Leaderboard Traveler</h3>
        <p>Traveler dengan kontribusi ulasan terbanyak</p>
    </div>

    <div class="table-responsive" style="max-width:800px; margin:0 auto 4rem;">
        <table class="leaderboard-clean">
            <thead>
                <tr>
                    <th style="width: 80px;">Rank</th>
                    <th>Nama</th>
                    <th>Jumlah Ulasan</th>
                    <th>Level</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($leaderboard as $idx => $user): 
                    $level = ['name' => 'Tourist'];
                    if ($user['review_count'] >= 80) $level['name'] = 'Explorer Legend';
                    elseif ($user['review_count'] >= 45) $level['name'] = 'Explorer';
                    elseif ($user['review_count'] >= 15) $level['name'] = 'Wanderer';
                    elseif ($user['review_count'] >= 5) $level['name'] = 'Backpacker';
                ?>
                <tr>
                    <td><strong>#<?php echo $idx + 1; ?></strong></td>
                    <td><?php echo esc($user['user_name']); ?></td>
                    <td><?php echo $user['review_count']; ?></td>
                    <td><span class="badge-display badge-wanderer" style="font-size:0.7rem; padding:0.3rem 0.6rem;"><?php echo $level['name']; ?></span></td>
                </tr>
                <?php endforeach; ?>
                <?php if (empty($leaderboard)): ?>
                <tr><td colspan="4" style="text-align:center; color:#7d8165;">Belum ada data leaderboard.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<?php require_once 'includes/footer.php'; ?>