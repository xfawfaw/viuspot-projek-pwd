<?php
$page_title = 'Community Hub';
require_once 'includes/functions.php';

// Handle new topic
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['post_topic'])) {
    // Simple Honeypot Anti-Spam
    if (!empty($_POST['website_url'])) {
        die("Spam detected.");
    }

    $title = trim($_POST['title'] ?? '');
    $content = trim($_POST['content'] ?? '');
    $destination = trim($_POST['destination'] ?? '');
    $category = $_POST['category'] ?? 'Diskusi';
    $travel_date = $_POST['travel_date'] ?? null;
    $user_name = trim($_POST['user_name'] ?? 'Anonim');
    $user_id = get_user_id() ?: null;

    if (!empty($title) && !empty($content)) {
        $stmt = $pdo->prepare("INSERT INTO forum_topics (user_id, user_name, title, content, destination, travel_date, category) VALUES (?, ?, ?, ?, ?, ?, ?)");
        $stmt->execute([$user_id, $user_name, $title, $content, $destination, $travel_date, $category]);
        set_flash('success', 'Topik berhasil dibuat!');
        header("Location: community.php");
        exit;
    }
}

// Handle reply
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['post_reply'])) {
    $topic_id = (int)($_POST['topic_id'] ?? 0);
    $content = trim($_POST['reply_content'] ?? '');
    $user_name = trim($_POST['reply_user'] ?? 'Anonim');
    $user_id = get_user_id() ?: null;

    if ($topic_id > 0 && !empty($content)) {
        $stmt = $pdo->prepare("INSERT INTO forum_replies (topic_id, user_id, user_name, content) VALUES (?, ?, ?, ?)");
        $stmt->execute([$topic_id, $user_id, $user_name, $content]);
        set_flash('success', 'Balasan berhasil dikirim!');
        header("Location: community.php?topic=" . $topic_id);
        exit;
    }
}

// View topic detail or list
$view_topic = isset($_GET['topic']) && is_numeric($_GET['topic']) ? (int)$_GET['topic'] : null;

if ($view_topic) {
    $stmt = $pdo->prepare("SELECT * FROM forum_topics WHERE id = ?");
    $stmt->execute([$view_topic]);
    $topic = $stmt->fetch();

    $replies = [];
    if ($topic) {
        // Increment view count
        $pdo->prepare("UPDATE forum_topics SET views = views + 1 WHERE id = ?")->execute([$view_topic]);
        
        $stmt = $pdo->prepare("SELECT * FROM forum_replies WHERE topic_id = ? ORDER BY created_at ASC");
        $stmt->execute([$view_topic]);
        $replies = $stmt->fetchAll();
    }
} else {
    // List topics
    $stmt = $pdo->query("SELECT t.*, COUNT(r.id) as reply_count FROM forum_topics t LEFT JOIN forum_replies r ON t.id = r.topic_id WHERE t.status='open' GROUP BY t.id ORDER BY t.created_at DESC");
    $topics = $stmt->fetchAll();
}

require_once 'includes/header.php';
?>

<div class="container">
    <div class="section-header">
        <h2>Community Hub</h2>
        <p>Cari teman perjalanan, diskusi destinasi, dan bagikan rencana trip-mu</p>
    </div>

    <?php if (!$view_topic): ?>
        <!-- Topic List -->
        <div class="fab-container">
            <a href="#new-topic" class="btn-fab" title="Buat Topik Baru">+</a>
        </div>

        <div class="discussion-grid">
            <?php foreach ($topics as $t): 
                $cat_class = 'tag-' . strtolower($t['category'] ?? 'Diskusi');
            ?>
                <div class="topic-card-modern">
                    <div class="tag <?php echo $cat_class; ?>"><?php echo esc($t['category'] ?? 'Diskusi'); ?></div>
                    <h3 class="mb-1" style="font-size: 1.15rem;">
                        <a href="community.php?topic=<?php echo $t['id']; ?>" style="color: var(--hero-gradient);"><?php echo esc($t['title']); ?></a>
                    </h3>
                    <p class="card-text" style="flex:1;"><?php echo esc(truncate($t['content'], 120)); ?></p>
                    
                    <div class="flex flex-between mt-2" style="border-top: 1px solid #f5f3eb; padding-top: 1rem;">
                        <div class="discussion-meta-item">
                            <span>👤 <?php echo esc($t['user_name']); ?></span>
                        </div>
                        <div class="flex gap-2">
                            <div class="discussion-meta-item">💬 <?php echo $t['reply_count']; ?></div>
                            <div class="discussion-meta-item">👁️ <?php echo $t['views'] ?? 0; ?></div>
                        </div>
                    </div>
                    <div class="mt-1" style="font-size: 0.75rem; color: #7d8165; opacity: 0.8;">
                        <?php echo date('d M Y', strtotime($t['created_at'])); ?>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>

        <?php if (empty($topics)): ?>
            <div class="alert alert-info">Belum ada topik. Jadilah yang pertama memulai diskusi!</div>
        <?php endif; ?>

        <!-- New Topic Form -->
        <div id="new-topic" class="planner-card" style="max-width: 800px; margin: 0 auto 4rem;">
            <h3>Buat Topik Baru</h3>
            <form method="POST" action="" class="mt-2">
                <input type="text" name="website_url" class="honeypot">
                <?php if (!is_logged_in()): ?>
                <div class="form-group">
                    <label class="form-label">Nama</label>
                    <input type="text" name="user_name" class="form-control" required>
                </div>
                <?php else: ?>
                    <input type="hidden" name="user_name" value="<?php echo esc($_SESSION['full_name']); ?>">
                <?php endif; ?>
                <div class="form-group">
                    <label class="form-label">Judul</label>
                    <input type="text" name="title" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Kategori</label>
                    <div class="flex gap-2">
                        <label class="dest-item" style="padding-left: 30px;">
                            <input type="radio" name="category" value="Tips" checked><span class="checkmark"></span> Tips
                        </label>
                        <label class="dest-item" style="padding-left: 30px;">
                            <input type="radio" name="category" value="Rekomendasi"><span class="checkmark"></span> Rekomendasi
                        </label>
                        <label class="dest-item" style="padding-left: 30px;">
                            <input type="radio" name="category" value="Diskusi"><span class="checkmark"></span> Diskusi
                        </label>
                    </div>
                </div>
                <div class="grid grid-2">
                    <div class="form-group">
                        <label class="form-label">Destinasi / Tujuan</label>
                        <input type="text" name="destination" class="form-control" placeholder="Contoh: Yogyakarta">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Tanggal Perjalanan</label>
                        <input type="date" name="travel_date" class="form-control">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Isi Diskusi</label>
                    <textarea name="content" class="form-control" rows="4" required placeholder="Ceritakan rencana perjalananmu, cari teman, atau tanyakan sesuatu..."></textarea>
                </div>
                <button type="submit" name="post_topic" class="btn btn-primary">Posting Topik</button>
            </form>
        </div>

    <?php else: ?>
        <!-- Topic Detail -->
        <?php if ($topic): ?>
            <div style="margin-bottom:1rem;">
                <a href="community.php" class="btn btn-outline btn-sm">&larr; Kembali ke Forum</a>
            </div>

            <div class="topic-item" style="background:#2e3b2c; color:#cec9b0;">
                <h2 style="margin-bottom:0.5rem; color:#cec9b0;"><?php echo esc($topic['title']); ?></h2>
                <div style="font-size:0.85rem; opacity:0.8; margin-bottom:1rem;">
                    Oleh <?php echo esc($topic['user_name']); ?> | 
                    <?php echo date('d M Y H:i', strtotime($topic['created_at'])); ?>
                    <?php if ($topic['destination']): ?> | Tujuan: <?php echo esc($topic['destination']); ?><?php endif; ?>
                    <?php if ($topic['travel_date']): ?> | Tanggal: <?php echo $topic['travel_date']; ?><?php endif; ?>
                </div>
                <p style="line-height:1.7;"><?php echo nl2br(esc($topic['content'])); ?></p>
            </div>

            <h3 style="margin:1.5rem 0 1rem;"><?php echo count($replies); ?> Balasan</h3>

            <?php foreach ($replies as $reply): ?>
                <div class="reply-item">
                    <div class="reply-header">
                        <strong><?php echo esc($reply['user_name']); ?></strong> • 
                        <?php echo date('d M Y H:i', strtotime($reply['created_at'])); ?>
                    </div>
                    <p style="font-size:0.95rem; color:#5a6b57;"><?php echo nl2br(esc($reply['content'])); ?></p>
                </div>
            <?php endforeach; ?>

            <?php if (empty($replies)): ?>
                <p style="color:#7d8165;">Belum ada balasan. Jadilah yang pertama membalas!</p>
            <?php endif; ?>

            <div style="margin-top:1.5rem; background:#fff; padding:1.5rem; border-radius:8px; border:1px solid #e8e5d8;">
                <h4>Tulis Balasan</h4>
                <form method="POST" action="">
                    <input type="hidden" name="topic_id" value="<?php echo $topic['id']; ?>">
                    <?php if (!is_logged_in()): ?>
                    <div class="form-group">
                        <label class="form-label">Nama</label>
                        <input type="text" name="reply_user" class="form-control" required>
                    </div>
                    <?php else: ?>
                        <input type="hidden" name="reply_user" value="<?php echo esc($_SESSION['full_name']); ?>">
                    <?php endif; ?>
                    <div class="form-group">
                        <label class="form-label">Balasan</label>
                        <textarea name="reply_content" class="form-control" rows="3" required></textarea>
                    </div>
                    <button type="submit" name="post_reply" class="btn btn-accent">Kirim Balasan</button>
                </form>
            </div>
        <?php else: ?>
            <div class="alert alert-error">Topik tidak ditemukan.</div>
            <a href="community.php" class="btn btn-outline">Kembali</a>
        <?php endif; ?>
    <?php endif; ?>
</div>

<?php require_once 'includes/footer.php'; ?>
