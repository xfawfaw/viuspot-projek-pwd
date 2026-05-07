<?php
$page_title = 'Viuspot Planner';
require_once 'includes/functions.php';

$user_logged_in = is_logged_in();
$user_id = get_user_id();

$categories = get_categories($pdo);
$stmt = $pdo->query("SELECT p.*, c.name as category_name, c.id as cat_id FROM places p JOIN categories c ON p.category_id = c.id WHERE p.status='approved' ORDER BY c.name ASC, p.name ASC");
$all_places = $stmt->fetchAll();

$places_by_cat = [];
foreach ($all_places as $p) {
    $places_by_cat[$p['cat_id']]['label'] = $p['category_name'];
    $places_by_cat[$p['cat_id']]['places'][] = $p;
}

$locations = array_unique(array_filter(array_column($all_places, 'location')));
sort($locations);

$my_itineraries = [];
if ($user_logged_in) {
    $stmt = $pdo->prepare("SELECT i.*, COUNT(ii.id) as total_stops FROM itineraries i LEFT JOIN itinerary_items ii ON i.id = ii.itinerary_id WHERE i.user_id = ? GROUP BY i.id ORDER BY i.created_at DESC LIMIT 10");
    $stmt->execute([$user_id]);
    $my_itineraries = $stmt->fetchAll();
}

$save_message = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['save_itinerary'])) {
    if (!$user_logged_in) {
        $save_message = 'error:Kamu harus login untuk menyimpan riwayat perjalanan.';
    } else {
        $title       = trim($_POST['title'] ?? 'Perjalanan Saya');
        $travel_date = $_POST['travel_date'] ?? date('Y-m-d');
        $selected    = $_POST['places'] ?? [];
        $times       = $_POST['times'] ?? [];
        $days_arr    = $_POST['days'] ?? [];
        $notes_arr   = $_POST['notes'] ?? [];
        $checklists  = $_POST['checklists'] ?? [];
        $travel_times = $_POST['travel_times'] ?? [];

        $stmt = $pdo->prepare("INSERT INTO itineraries (user_id, title, travel_date) VALUES (?, ?, ?)");
        $stmt->execute([$user_id, $title, $travel_date]);
        $itin_id = $pdo->lastInsertId();

        foreach ($selected as $place_id) {
            try {
                $stmt = $pdo->prepare("INSERT INTO itinerary_items (itinerary_id, place_id, day_number, time_slot, notes, checklist, travel_time_after) VALUES (?, ?, ?, ?, ?, ?, ?)");
                $stmt->execute([$itin_id, (int)$place_id, (int)($days_arr[$place_id] ?? 1), $times[$place_id] ?? '09:00', $notes_arr[$place_id] ?? '', $checklists[$place_id] ?? '', (int)($travel_times[$place_id] ?? 30)]);
            } catch (Exception $e) {
                $stmt = $pdo->prepare("INSERT INTO itinerary_items (itinerary_id, place_id, day_number, time_slot, notes) VALUES (?, ?, ?, ?, ?)");
                $stmt->execute([$itin_id, (int)$place_id, (int)($days_arr[$place_id] ?? 1), $times[$place_id] ?? '09:00', $notes_arr[$place_id] ?? '']);
            }
        }

        $save_message = 'success:Itinerary "' . htmlspecialchars($title) . '" berhasil disimpan!';
        $stmt = $pdo->prepare("SELECT i.*, COUNT(ii.id) as total_stops FROM itineraries i LEFT JOIN itinerary_items ii ON i.id = ii.itinerary_id WHERE i.user_id = ? GROUP BY i.id ORDER BY i.created_at DESC LIMIT 10");
        $stmt->execute([$user_id]);
        $my_itineraries = $stmt->fetchAll();
    }
}

if (isset($_GET['delete_itin']) && $user_logged_in) {
    $del_id = (int)$_GET['delete_itin'];
    $stmt = $pdo->prepare("DELETE FROM itineraries WHERE id = ? AND user_id = ?");
    $stmt->execute([$del_id, $user_id]);
    header("Location: planner.php");
    exit;
}

$view_itinerary = null;
$view_items = [];
if (isset($_GET['view']) && $user_logged_in) {
    $view_id = (int)$_GET['view'];
    $stmt = $pdo->prepare("SELECT * FROM itineraries WHERE id = ? AND user_id = ?");
    $stmt->execute([$view_id, $user_id]);
    $view_itinerary = $stmt->fetch();
    if ($view_itinerary) {
        $stmt = $pdo->prepare("SELECT ii.*, p.name as place_name, p.location, p.entrance_fee, p.meal_cost, p.parking_fee FROM itinerary_items ii JOIN places p ON ii.place_id = p.id WHERE ii.itinerary_id = ? ORDER BY ii.day_number ASC, ii.time_slot ASC");
        $stmt->execute([$view_id]);
        $view_items = $stmt->fetchAll();
    }
}

$itinerary = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST' && (isset($_POST['build_itinerary']) || isset($_POST['save_itinerary']))) {
    $title       = trim($_POST['title'] ?? 'Perjalanan Saya');
    $travel_date = $_POST['travel_date'] ?? date('Y-m-d');
    $selected    = $_POST['places'] ?? [];
    $times       = $_POST['times'] ?? [];
    $days_arr    = $_POST['days'] ?? [];
    $notes_arr   = $_POST['notes'] ?? [];
    $checklists  = $_POST['checklists'] ?? [];
    $travel_times = $_POST['travel_times'] ?? [];

    $itinerary = ['title' => $title, 'travel_date' => $travel_date, 'items' => []];
    foreach ($selected as $place_id) {
        foreach ($all_places as $p) {
            if ($p['id'] == $place_id) {
                $itinerary['items'][] = [
                    'place' => $p, 'day' => (int)($days_arr[$place_id] ?? 1),
                    'time' => $times[$place_id] ?? '09:00', 'note' => $notes_arr[$place_id] ?? '',
                    'checklist' => $checklists[$place_id] ?? '', 'travel_time' => (int)($travel_times[$place_id] ?? 30),
                ];
                break;
            }
        }
    }
    usort($itinerary['items'], function($a, $b) {
        if ($a['day'] === $b['day']) return strcmp($a['time'], $b['time']);
        return $a['day'] - $b['day'];
    });
}

require_once 'includes/header.php';
?>

<div class="container planner-page" style="padding-bottom:4rem;">
    <div class="section-header">
        <h2>Viuspot Planner</h2>
        <p>Buat jadwal perjalanan harianmu dengan destinasi pilihan</p>
    </div>

    <?php if ($save_message): [$type, $msg] = explode(':', $save_message, 2); ?>
        <div class="alert alert-<?php echo $type; ?>" style="margin-bottom:1.5rem;"><?php echo $msg; ?></div>
    <?php endif; ?>

    <?php if ($user_logged_in && !empty($my_itineraries)): ?>
    <div class="planner-card" style="margin-bottom:2rem;">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;">
            <h3 style="margin:0;">Riwayat Perjalananmu</h3>
            <span style="font-size:0.8rem;color:#7d8165;"><?php echo count($my_itineraries); ?> tersimpan</span>
        </div>
        <div style="display:flex;flex-wrap:wrap;gap:0.75rem;">
            <?php foreach ($my_itineraries as $itin): ?>
            <div style="background:#f9f9f7;border:1px solid #e8e5d8;border-radius:10px;padding:0.75rem 1rem;min-width:200px;flex:1;">
                <div style="font-weight:600;font-size:0.9rem;"><?php echo esc($itin['title']); ?></div>
                <div style="font-size:0.78rem;color:#7d8165;margin-top:0.2rem;"><?php echo date('d M Y', strtotime($itin['travel_date'])); ?> &bull; <?php echo $itin['total_stops']; ?> destinasi</div>
                <div style="margin-top:0.5rem;display:flex;gap:0.4rem;">
                    <a href="planner.php?view=<?php echo $itin['id']; ?>" class="btn btn-sm btn-outline" style="font-size:0.75rem;padding:0.2rem 0.6rem;">👁 Lihat</a>
                    <a href="planner.php?delete_itin=<?php echo $itin['id']; ?>" class="btn btn-sm btn-danger" style="font-size:0.75rem;padding:0.2rem 0.6rem;" onclick="return confirm('Hapus perjalanan ini?')">🗑</a>
                </div>
            </div>
            <?php endforeach; ?>
        </div>
    </div>
    <?php elseif (!$user_logged_in): ?>
    <div style="background:#fff8e1;border:1px solid #f4b324;border-radius:10px;padding:0.85rem 1.25rem;margin-bottom:1.5rem;font-size:0.9rem;">
         <a href="login.php?redirect=planner.php"><strong>Login</strong></a> untuk menyimpan riwayat perjalananmu.
    </div>
    <?php endif; ?>

    <?php if ($view_itinerary && !empty($view_items)): ?>
    <div class="planner-card" style="margin-bottom:2rem;">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;">
            <div>
                <h3 style="margin:0;"><?php echo esc($view_itinerary['title']); ?></h3>
                <p style="color:#7d8165;font-size:0.85rem;margin-top:0.2rem;">Mulai: <?php echo date('d M Y', strtotime($view_itinerary['travel_date'])); ?></p>
            </div>
            <a href="planner.php" class="btn btn-sm btn-outline">← Kembali</a>
        </div>
        <?php $cur_day=0; $total_cost=0;
        foreach ($view_items as $idx => $item):
            $total_cost += $item['entrance_fee'] + $item['meal_cost'] + $item['parking_fee'];
            if ($item['day_number'] !== $cur_day): $cur_day = $item['day_number']; ?>
                <div class="timeline-day-label">Hari <?php echo $cur_day; ?></div>
            <?php endif; ?>
            <div class="timeline-visual-item">
                <div class="tvi-line"></div><div class="tvi-dot"></div>
                <div class="tvi-content">
                    <div class="tvi-time"><?php echo $item['time_slot']; ?></div>
                    <div class="tvi-title"><?php echo esc($item['place_name']); ?></div>
                    <div class="tvi-loc"><?php echo esc($item['location']); ?></div>
                    <?php if (!empty($item['notes'])): ?><div class="tvi-note"> <?php echo esc($item['notes']); ?></div><?php endif; ?>
                    <?php if (!empty($item['checklist'])): ?>
                        <div class="tvi-checklist"><?php foreach(explode("\n",$item['checklist']) as $cl): if(trim($cl)): ?><span>☑ <?php echo esc(trim($cl)); ?></span><?php endif; endforeach; ?></div>
                    <?php endif; ?>
                    <?php if (isset($view_items[$idx+1]) && $view_items[$idx+1]['day_number'] == $cur_day): ?>
                        <div class="tvi-travel-gap">Perjalanan ~<?php echo $item['travel_time_after'] ?? 30; ?> menit ke destinasi berikutnya</div>
                    <?php endif; ?>
                    <a href="place.php?id=<?php echo $item['place_id']; ?>" class="tvi-link">Lihat detail →</a>
                </div>
            </div>
        <?php endforeach; ?>
        <div style="margin-top:1.5rem;padding-top:1rem;border-top:1px solid #e8e5d8;font-size:0.88rem;color:#7d8165;">
            Estimasi biaya destinasi: <strong style="color:#0A261D;"><?php echo format_rupiah($total_cost); ?></strong>
        </div>
    </div>
    <?php endif; ?>

    <div class="grid grid-2">
        <div>
            <form method="POST" action="" class="planner-card" id="plannerForm">
                <div class="form-group">
                    <label class="form-label">Judul Perjalanan</label>
                    <input type="text" name="title" class="form-control" value="<?php echo esc($itinerary['title'] ?? 'Perjalanan ke Yogyakarta'); ?>" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Tanggal Mulai</label>
                    <input type="date" name="travel_date" class="form-control" value="<?php echo $itinerary['travel_date'] ?? date('Y-m-d'); ?>" required>
                </div>

                <div class="grid grid-2" style="gap:0.75rem;margin-bottom:1rem;">
                    <div class="form-group" style="margin:0;">
                        <label class="form-label">Filter Kategori</label>
                        <select id="filterCat" class="form-control" style="font-size:0.85rem;">
                            <option value="">Semua Kategori</option>
                            <?php foreach ($categories as $cat): ?>
                                <option value="<?php echo $cat['id']; ?>"><?php echo esc($cat['name']); ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label class="form-label">Filter Lokasi</label>
                        <select id="filterLoc" class="form-control" style="font-size:0.85rem;">
                            <option value="">Semua Lokasi</option>
                            <?php foreach ($locations as $loc): ?>
                                <option value="<?php echo esc($loc); ?>"><?php echo esc($loc); ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Pilih Destinasi</label>
                    <div id="destinationList" style="max-height:420px;overflow-y:auto;border:1px solid #e8e5d8;border-radius:12px;background:#fff;">
                        <?php foreach ($places_by_cat as $cat_id => $catData): ?>
                        <div class="dest-category-group" data-cat="<?php echo $cat_id; ?>">
                            <div class="dest-cat-header"><?php echo esc($catData['label']); ?></div>
                            <?php foreach ($catData['places'] as $place):
                                $pid = $place['id'];
                                $checked = $itinerary ? in_array((string)$pid, array_map('strval', array_column(array_column($itinerary['items'],'place'),'id'))) : false;
                            ?>
                            <div class="dest-item-wrap" data-cat="<?php echo $cat_id; ?>" data-loc="<?php echo esc($place['location']); ?>">
                                <label class="dest-item" style="margin-bottom:0;">
                                    <input type="checkbox" name="places[]" value="<?php echo $pid; ?>" class="dest-checkbox" <?php echo $checked?'checked':''; ?>>
                                    <span class="checkmark"></span>
                                    <div>
                                        <strong><?php echo esc($place['name']); ?></strong>
                                        <div style="color:#7d8165;font-size:0.78rem;"><?php echo esc($place['location']); ?></div>
                                    </div>
                                </label>
                                <div class="dest-inputs" style="<?php echo $checked?'':'display:none;'; ?>margin-top:0.5rem;padding:0.5rem 0.5rem 0.75rem 2rem;background:#f9f9f7;border-top:1px dashed #e8e5d8;">
                                    <div style="display:grid;grid-template-columns:70px 90px 1fr;gap:0.4rem;margin-bottom:0.4rem;">
                                        <div>
                                            <div style="font-size:0.7rem;color:#7d8165;margin-bottom:2px;">Hari ke-</div>
                                            <input type="number" name="days[<?php echo $pid; ?>]" class="form-control" min="1" value="1" style="padding:0.3rem 0.5rem;font-size:0.82rem;">
                                        </div>
                                        <div>
                                            <div style="font-size:0.7rem;color:#7d8165;margin-bottom:2px;">Jam mulai</div>
                                            <input type="time" name="times[<?php echo $pid; ?>]" class="form-control" value="09:00" style="padding:0.3rem 0.5rem;font-size:0.82rem;">
                                        </div>
                                        <div>
                                            <div style="font-size:0.7rem;color:#7d8165;margin-bottom:2px;">Jeda ke destinasi berikutnya (mnt)</div>
                                            <input type="number" name="travel_times[<?php echo $pid; ?>]" class="form-control" min="0" value="30" style="padding:0.3rem 0.5rem;font-size:0.82rem;">
                                        </div>
                                    </div>
                                    <div style="margin-bottom:0.4rem;">
                                        <div style="font-size:0.7rem;color:#7d8165;margin-bottom:2px;">Catatan umum</div>
                                        <input type="text" name="notes[<?php echo $pid; ?>]" class="form-control" placeholder="Info penting, jam buka, tips..." style="padding:0.3rem 0.5rem;font-size:0.82rem;">
                                    </div>
                                    <div>
                                        <div style="font-size:0.7rem;color:#7d8165;margin-bottom:2px;">Checklist (satu item per baris)</div>
                                        <textarea name="checklists[<?php echo $pid; ?>]" class="form-control" placeholder="Beli tiket online&#10;Bawa kamera&#10;Siapkan uang tunai" rows="2" style="padding:0.3rem 0.5rem;font-size:0.82rem;resize:vertical;"></textarea>
                                    </div>
                                </div>
                            </div>
                            <?php endforeach; ?>
                        </div>
                        <?php endforeach; ?>
                    </div>
                </div>

                <div style="display:flex;gap:0.75rem;flex-wrap:wrap;">
                    <button type="submit" name="build_itinerary" class="btn btn-outline" style="flex:1;">Preview</button>
                    <?php if ($user_logged_in): ?>
                        <button type="submit" name="save_itinerary" class="btn btn-accent" style="flex:1;">Simpan</button>
                    <?php else: ?>
                        <a href="login.php?redirect=planner.php" class="btn btn-accent" style="flex:1;text-align:center;">Login untuk Simpan</a>
                    <?php endif; ?>
                </div>
            </form>
        </div>

        <div>
            <?php if ($itinerary && !empty($itinerary['items'])): ?>
                <div class="planner-card">
                    <h3 style="margin-bottom:0.25rem;"><?php echo esc($itinerary['title']); ?></h3>
                    <p style="color:#7d8165;font-size:0.85rem;margin-bottom:1.5rem;">Mulai: <?php echo date('d M Y', strtotime($itinerary['travel_date'])); ?></p>
                    <?php $cur_day=0; $total_cost=0; $items=$itinerary['items'];
                    foreach ($items as $idx => $item):
                        $total_cost += $item['place']['entrance_fee'] + $item['place']['meal_cost'] + $item['place']['parking_fee'];
                        if ($item['day'] !== $cur_day): $cur_day = $item['day']; ?>
                            <div class="timeline-day-label">Hari <?php echo $cur_day; ?></div>
                        <?php endif; ?>
                        <div class="timeline-visual-item">
                            <div class="tvi-line"></div><div class="tvi-dot"></div>
                            <div class="tvi-content">
                                <div class="tvi-time"><?php echo $item['time']; ?></div>
                                <div class="tvi-title"><?php echo esc($item['place']['name']); ?></div>
                                <div class="tvi-loc"><?php echo esc($item['place']['location']); ?></div>
                                <?php if ($item['note']): ?><div class="tvi-note"> <?php echo esc($item['note']); ?></div><?php endif; ?>
                                <?php if ($item['checklist']): ?>
                                    <div class="tvi-checklist"><?php foreach(explode("\n",$item['checklist']) as $cl): if(trim($cl)): ?><span>☑ <?php echo esc(trim($cl)); ?></span><?php endif; endforeach; ?></div>
                                <?php endif; ?>
                                <?php if (isset($items[$idx+1]) && $items[$idx+1]['day'] == $cur_day): ?>
                                    <div class="tvi-travel-gap">Jeda ~<?php echo $item['travel_time']; ?> menit ke destinasi berikutnya</div>
                                <?php endif; ?>
                                <a href="place.php?id=<?php echo $item['place']['id']; ?>" class="tvi-link">Lihat detail →</a>
                            </div>
                        </div>
                    <?php endforeach; ?>
                    <div style="margin-top:1.5rem;padding-top:1rem;border-top:1px solid #e8e5d8;font-size:0.88rem;color:#7d8165;">
                        Estimasi biaya destinasi: <strong style="color:#0A261D;"><?php echo format_rupiah($total_cost); ?></strong>
                    </div>
                </div>
            <?php else: ?>
                <div class="planner-card" style="text-align:center;color:#7d8165;min-height:200px;display:flex;flex-direction:column;justify-content:center;align-items:center;">
                    <div style="font-size:3rem;opacity:0.2;margin-bottom:1rem;"></div>
                    <p>Pilih destinasi dan klik <strong>Preview</strong> untuk melihat itinerary dalam bentuk timeline visual.</p>
                </div>
            <?php endif; ?>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.dest-checkbox').forEach(cb => {
        cb.addEventListener('change', function() {
            this.closest('.dest-item-wrap').querySelector('.dest-inputs').style.display = this.checked ? 'block' : 'none';
        });
    });
    const filterCat = document.getElementById('filterCat');
    const filterLoc = document.getElementById('filterLoc');
    function applyFilters() {
        const cat = filterCat.value;
        const loc = filterLoc.value.toLowerCase();
        document.querySelectorAll('.dest-category-group').forEach(group => {
            let vis = false;
            group.querySelectorAll('.dest-item-wrap').forEach(item => {
                const show = (!cat || item.dataset.cat === cat) && (!loc || item.dataset.loc.toLowerCase().includes(loc));
                item.style.display = show ? '' : 'none';
                if (show) vis = true;
            });
            group.style.display = vis ? '' : 'none';
        });
    }
    filterCat.addEventListener('change', applyFilters);
    filterLoc.addEventListener('change', applyFilters);
});
</script>

<?php require_once 'includes/footer.php'; ?>