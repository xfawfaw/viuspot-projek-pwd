<?php
$page_title = 'Community Hub';
require_once 'includes/functions.php';

/* ================================================================
   SCHEMA NOTES — run once to add new columns if upgrading:
   ALTER TABLE forum_replies ADD COLUMN IF NOT EXISTS parent_reply_id INT NULL;
   ================================================================ */

/* ── Helper ──────────────────────────────────────────────────── */
function time_ago(string $dt): string {
    $diff = time() - strtotime($dt);
    if ($diff < 60)     return $diff . 'd lalu';
    if ($diff < 3600)   return floor($diff/60) . 'm lalu';
    if ($diff < 86400)  return floor($diff/3600) . 'j lalu';
    if ($diff < 604800) return floor($diff/86400) . ' hari lalu';
    return date('d M Y', strtotime($dt));
}

function avatar_letter(string $name): string {
    return mb_strtoupper(mb_substr(trim($name), 0, 1));
}

function avatar_color(string $name): string {
    $colors = ['#2e6b55','#1a3a2f','#4a5d54','#6b7c73','#92400e','#065f46','#1e40af','#7e22ce'];
    return $colors[crc32($name) % count($colors)];
}

/* ── POST: New Topic ─────────────────────────────────────────── */
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['post_topic'])) {
    if (!empty($_POST['website_url'])) die("Spam detected.");

    $title       = trim($_POST['title'] ?? '');
    $content     = trim($_POST['content'] ?? '');
    $destination = trim($_POST['destination'] ?? '');
    $category    = $_POST['category'] ?? 'Diskusi';
    $travel_date = $_POST['travel_date'] ?: null;
    $user_name   = trim($_POST['user_name'] ?? 'Anonim');
    $user_id     = get_user_id() ?: null;

    if (!empty($title) && !empty($content)) {
        $stmt = $pdo->prepare("INSERT INTO forum_topics (user_id, user_name, title, content, destination, travel_date, category) VALUES (?, ?, ?, ?, ?, ?, ?)");
        $stmt->execute([$user_id, $user_name, $title, $content, $destination, $travel_date, $category]);
        set_flash('success', 'Topik berhasil dibuat!');
        header("Location: community.php");
        exit;
    }
}

/* ── POST: Reply (with optional parent_reply_id for nested) ──── */
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['post_reply'])) {
    $topic_id       = (int)($_POST['topic_id'] ?? 0);
    $parent_id      = (int)($_POST['parent_reply_id'] ?? 0) ?: null;
    $content        = trim($_POST['reply_content'] ?? '');
    $user_name      = trim($_POST['reply_user'] ?? 'Anonim');
    $user_id        = get_user_id() ?: null;

    if ($topic_id > 0 && !empty($content)) {
        $stmt = $pdo->prepare("INSERT INTO forum_replies (topic_id, parent_reply_id, user_id, user_name, content) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([$topic_id, $parent_id, $user_id, $user_name, $content]);
        set_flash('success', 'Balasan berhasil dikirim!');
        header("Location: community.php?topic=" . $topic_id . "#replies");
        exit;
    }
}


/* ── View: Topic Detail or List ──────────────────────────────── */
$view_topic = isset($_GET['topic']) && is_numeric($_GET['topic']) ? (int)$_GET['topic'] : null;

if ($view_topic) {
    $stmt = $pdo->prepare("SELECT * FROM forum_topics WHERE id = ?");
    $stmt->execute([$view_topic]);
    $topic = $stmt->fetch();

    $replies = [];
    if ($topic) {
        $pdo->prepare("UPDATE forum_topics SET views = views + 1 WHERE id = ?")->execute([$view_topic]);
        // Fetch all replies; we'll nest in PHP
        $stmt = $pdo->prepare("SELECT * FROM forum_replies WHERE topic_id = ? ORDER BY created_at ASC");
        $stmt->execute([$view_topic]);
        $all_replies = $stmt->fetchAll();

        // Build nested tree
        $reply_map  = [];
        $root_replies = [];
        foreach ($all_replies as $r) {
            $reply_map[$r['id']] = $r;
            $reply_map[$r['id']]['children'] = [];
        }
        foreach ($all_replies as $r) {
            if ($r['parent_reply_id'] && isset($reply_map[$r['parent_reply_id']])) {
                $reply_map[$r['parent_reply_id']]['children'][] = &$reply_map[$r['id']];
            } else {
                $root_replies[] = &$reply_map[$r['id']];
            }
        }
        $replies = $root_replies;
    }
} else {
    $filter_cat = $_GET['cat'] ?? '';
    $where  = "WHERE t.status='open'";
    $params = [];
    if ($filter_cat) { $where .= " AND t.category = ?"; $params[] = $filter_cat; }
    $stmt = $pdo->prepare("SELECT t.*, COUNT(r.id) as reply_count FROM forum_topics t LEFT JOIN forum_replies r ON t.id = r.topic_id $where GROUP BY t.id ORDER BY t.created_at DESC");
    $stmt->execute($params);
    $topics = $stmt->fetchAll();
}

require_once 'includes/header.php';

/* ── Recursive reply renderer ────────────────────────────────── */
function render_replies(array $replies, int $depth = 0): void {
    foreach ($replies as $reply):
        $av_color = avatar_color($reply['user_name']);
?>
<div class="reply-thread<?php echo $depth > 0 ? ' reply-nested' : ''; ?>" data-reply-id="<?php echo $reply['id']; ?>">
    <div class="reply-body">
        <div class="reply-author-row">
            <div class="avatar-xs" style="background:<?php echo $av_color; ?>"><?php echo avatar_letter($reply['user_name']); ?></div>
            <span class="reply-username"><?php echo esc($reply['user_name']); ?></span>
            <span class="reply-time"><?php echo time_ago($reply['created_at']); ?></span>
        </div>
        <div class="reply-content"><?php echo nl2br(esc($reply['content'])); ?></div>
        <div class="reply-actions">
            <button class="reply-action-btn toggle-reply-form" data-target="reply-form-<?php echo $reply['id']; ?>">
                git  Balas
            </button>
        </div>

        <!-- Inline reply form -->
        <div id="reply-form-<?php echo $reply['id']; ?>" class="inline-reply-form" style="display:none;">
            <form method="POST" action="">
                <input type="hidden" name="topic_id" value="<?php echo $reply['topic_id']; ?>">
                <input type="hidden" name="parent_reply_id" value="<?php echo $reply['id']; ?>">
                <?php if (!is_logged_in()): ?>
                <input type="text" name="reply_user" class="form-control" placeholder="Nama kamu" required style="margin-bottom:.5rem;">
                <?php else: ?>
                <input type="hidden" name="reply_user" value="<?php echo esc($_SESSION['full_name']); ?>">
                <?php endif; ?>
                <textarea name="reply_content" class="form-control" rows="2" required placeholder="Tulis balasan..."></textarea>
                <div class="flex gap-2 mt-2">
                    <button type="submit" name="post_reply" class="btn btn-primary btn-sm">Kirim</button>
                    <button type="button" class="btn btn-outline btn-sm toggle-reply-form" data-target="reply-form-<?php echo $reply['id']; ?>">Batal</button>
                </div>
            </form>
        </div>

        <?php if (!empty($reply['children'])): ?>
            <div class="children-thread">
                <?php render_replies($reply['children'], $depth + 1); ?>
            </div>
        <?php endif; ?>
    </div>
</div>
<?php
    endforeach;
}
?>

<div class="community-layout">

<?php /* ── TOPIC LIST VIEW ──────────────────────────────────────── */ ?>
<?php if (!$view_topic): ?>

<div class="community-main">
    <div class="community-header-bar">
        <div>
            <h2 class="community-title">Community Hub</h2>
            <p class="community-subtitle">Cari teman perjalanan, diskusi destinasi, dan bagikan rencana trip-mu</p>
        </div>
        <a href="#new-topic" class="btn btn-primary">+ Buat Topik</a>
    </div>

    <!-- Category Filter Chips -->
    <div class="cat-filter-bar">
        <a href="community.php" class="cat-chip <?php echo !$filter_cat?'active':''; ?>">Semua</a>
        <a href="?cat=Tips" class="cat-chip tag-tips <?php echo $filter_cat==='Tips'?'active':''; ?>">Tips</a>
        <a href="?cat=Rekomendasi" class="cat-chip tag-rekomendasi <?php echo $filter_cat==='Rekomendasi'?'active':''; ?>">Rekomendasi</a>
        <a href="?cat=Diskusi" class="cat-chip tag-diskusi <?php echo $filter_cat==='Diskusi'?'active':''; ?>">Diskusi</a>
    </div>

    <!-- Topic Feed -->
    <div class="topic-feed">
        <?php if (empty($topics)): ?>
            <div class="empty-state">
                <div class="empty-icon"></div>
                <h3>Belum ada topik</h3>
                <p>Jadilah yang pertama memulai diskusi!</p>
                <a href="#new-topic" class="btn btn-primary mt-3">Buat Topik Pertama</a>
            </div>
        <?php endif; ?>

        <?php foreach ($topics as $t):
            $av_color  = avatar_color($t['user_name']);
            $cat_class = 'tag-' . strtolower($t['category'] ?? 'diskusi');
        ?>
        <div class="topic-row">
            <!-- Content -->
            <div class="topic-content">
                <div class="topic-meta-row">
                    <div class="avatar-xs" style="background:<?php echo $av_color; ?>"><?php echo avatar_letter($t['user_name']); ?></div>
                    <span class="topic-author"><?php echo esc($t['user_name']); ?></span>
                    <span class="topic-time"><?php echo time_ago($t['created_at']); ?></span>
                    <?php if ($t['destination']): ?>
                        <span class="topic-dest"> <?php echo esc($t['destination']); ?></span>
                    <?php endif; ?>
                </div>

                <a href="community.php?topic=<?php echo $t['id']; ?>" class="topic-title-link">
                    <?php echo esc($t['title']); ?>
                </a>
                <p class="topic-excerpt"><?php echo esc(truncate($t['content'], 160)); ?></p>

                <div class="topic-footer-row">
                    <span class="tag <?php echo $cat_class; ?>"><?php echo esc($t['category']); ?></span>
                    <a href="community.php?topic=<?php echo $t['id']; ?>#replies" class="topic-stat-btn">
                         <?php echo $t['reply_count']; ?> komentar
                    </a>
                    <span class="topic-stat-btn"> <?php echo $t['views'] ?? 0; ?></span>
                    <?php if ($t['travel_date']): ?>
                        <span class="topic-stat-btn"> <?php echo date('d M Y', strtotime($t['travel_date'])); ?></span>
                    <?php endif; ?>
                </div>
            </div>
        </div>
        <?php endforeach; ?>
    </div>
</div>

<!-- Sidebar -->
<aside class="community-sidebar">
    <div class="sidebar-card">
        <h4>Tentang Community</h4>
        <p>Forum diskusi perjalanan — cari teman, bagikan tips, dan rencanakan trip bersama komunitas VIUSPOT.</p>
        <a href="#new-topic" class="btn btn-primary w-100 mt-3">+ Buat Topik Baru</a>
    </div>

    <div class="sidebar-card rules-card">
        <h4>Aturan Forum</h4>
        <ol class="rules-list">
            <li>Hormati sesama traveler</li>
            <li>Informasi yang akurat & jujur</li>
            <li>Dilarang spam atau promosi berlebih</li>
            <li>Gunakan kategori yang sesuai</li>
        </ol>
    </div>
</aside>

<!-- New Topic Form -->
<div id="new-topic" class="new-topic-section">
    <div class="new-topic-card">
        <h3>Buat Topik Baru</h3>
        <form method="POST" action="" class="mt-3">
            <input type="text" name="website_url" class="honeypot">
            <?php if (!is_logged_in()): ?>
            <div class="form-group">
                <label class="form-label">Nama</label>
                <input type="text" name="user_name" class="form-control" placeholder="Nama kamu" required>
            </div>
            <?php else: ?>
                <input type="hidden" name="user_name" value="<?php echo esc($_SESSION['full_name']); ?>">
            <?php endif; ?>

            <div class="grid grid-2">
                <div class="form-group">
                    <label class="form-label">Judul Topik</label>
                    <input type="text" name="title" class="form-control" placeholder="Topik yang ingin didiskusikan..." required>
                </div>
                <div class="form-group">
                    <label class="form-label">Kategori</label>
                    <div class="radio-group">
                        <label class="radio-pill"><input type="radio" name="category" value="Tips" checked> Tips</label>
                        <label class="radio-pill"><input type="radio" name="category" value="Rekomendasi"> Rekomendasi</label>
                        <label class="radio-pill"><input type="radio" name="category" value="Diskusi"> Diskusi</label>
                    </div>
                </div>
            </div>

            <div class="grid grid-2">
                <div class="form-group">
                    <label class="form-label">Destinasi</label>
                    <input type="text" name="destination" class="form-control" placeholder="Contoh: Yogyakarta">
                </div>
                <div class="form-group">
                    <label class="form-label">Tanggal Perjalanan</label>
                    <input type="date" name="travel_date" class="form-control">
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Isi Diskusi</label>
                <textarea name="content" class="form-control" rows="5" required placeholder="Ceritakan rencana perjalananmu, cari teman, atau tanyakan sesuatu..."></textarea>
            </div>

            <button type="submit" name="post_topic" class="btn btn-primary"> Posting Topik</button>
        </form>
    </div>
</div>

<?php /* ── TOPIC DETAIL VIEW ────────────────────────────────────── */ ?>
<?php else: ?>
<?php if ($topic): 
    $av_color = avatar_color($topic['user_name']);
    $cat_class = 'tag-' . strtolower($topic['category'] ?? 'diskusi');
?>

<div class="community-main">
    <a href="community.php" class="back-link">← Kembali ke Forum</a>

    <!-- Topic post (Reddit OP style) -->
    <div class="thread-op" style="display:block;">
        <div class="thread-op-body">
            <div class="topic-meta-row">
                <div class="avatar-xs" style="background:<?php echo $av_color; ?>"><?php echo avatar_letter($topic['user_name']); ?></div>
                <span class="topic-author"><?php echo esc($topic['user_name']); ?></span>
                <span class="topic-time"><?php echo time_ago($topic['created_at']); ?></span>
                <span class="tag <?php echo $cat_class; ?>"><?php echo esc($topic['category']); ?></span>
                <?php if ($topic['destination']): ?><span class="topic-dest"><?php echo esc($topic['destination']); ?></span><?php endif; ?>
                <?php if ($topic['travel_date']): ?><span class="topic-dest"> <?php echo date('d M Y', strtotime($topic['travel_date'])); ?></span><?php endif; ?>
            </div>

            <h1 class="thread-title"><?php echo esc($topic['title']); ?></h1>
            <div class="thread-body"><?php echo nl2br(esc($topic['content'])); ?></div>

            <div class="thread-stats-row">
                <span class="topic-stat-btn"> <?php echo $topic['views'] ?? 0; ?> views</span>
                <span class="topic-stat-btn"> <?php echo count($replies); ?> komentar</span>
                <button class="topic-stat-btn toggle-reply-form" data-target="main-reply-form"> Balas</button>
            </div>
        </div>
    </div>

    <!-- Main Reply Form -->
    <div id="main-reply-form" class="main-reply-box" style="display:none;">
        <h4>Tulis Komentar</h4>
        <form method="POST" action="">
            <input type="hidden" name="topic_id" value="<?php echo $topic['id']; ?>">
            <input type="hidden" name="parent_reply_id" value="">
            <?php if (!is_logged_in()): ?>
            <div class="form-group">
                <label class="form-label">Nama</label>
                <input type="text" name="reply_user" class="form-control" placeholder="Nama kamu" required>
            </div>
            <?php else: ?>
                <input type="hidden" name="reply_user" value="<?php echo esc($_SESSION['full_name']); ?>">
            <?php endif; ?>
            <div class="form-group">
                <textarea name="reply_content" class="form-control" rows="4" required placeholder="Tulis komentarmu..."></textarea>
            </div>
            <button type="submit" name="post_reply" class="btn btn-accent">Kirim Komentar</button>
        </form>
    </div>

    <!-- Replies Section -->
    <div id="replies" class="replies-section">
        <div class="replies-header">
            <h3><?php echo count($replies); ?> Komentar</h3>
            <button class="btn btn-outline btn-sm toggle-reply-form" data-target="main-reply-form">+ Tambah Komentar</button>
        </div>

        <?php if (empty($replies)): ?>
            <div class="empty-state compact">
                <div class="empty-icon">💬</div>
                <p>Belum ada komentar. Jadilah yang pertama!</p>
            </div>
        <?php else: ?>
            <?php render_replies($replies); ?>
        <?php endif; ?>
    </div>
</div>

<?php else: ?>
    <div class="alert alert-error">Topik tidak ditemukan.</div>
    <a href="community.php" class="btn btn-outline mt-3">Kembali ke Forum</a>
<?php endif; ?>
<?php endif; ?>

</div><!-- .community-layout -->



<script>
// Toggle reply forms
document.querySelectorAll('.toggle-reply-form').forEach(btn => {
    btn.addEventListener('click', () => {
        const id = btn.dataset.target;
        const form = document.getElementById(id);
        if (!form) return;
        const isHidden = form.style.display === 'none' || form.style.display === '';
        form.style.display = isHidden ? 'block' : 'none';
        if (isHidden) {
            form.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            form.querySelector('textarea, input[type=text]')?.focus();
        }
    });
});


</script>

<?php require_once 'includes/footer.php'; ?>