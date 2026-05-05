<?php
$page_title = 'Viuspot Planner';
require_once 'includes/functions.php';

$categories = get_categories($pdo);
$all_places = [];
$stmt = $pdo->query("SELECT * FROM places WHERE status='approved' ORDER BY `name` ASC");
$all_places = $stmt->fetchAll();

// Handle form submission
$itinerary = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['build_itinerary'])) {
    $title = trim($_POST['title'] ?? 'Perjalanan Saya');
    $travel_date = $_POST['travel_date'] ?? date('Y-m-d');
    $selected = $_POST['places'] ?? [];
    $times = $_POST['times'] ?? [];
    $days = $_POST['days'] ?? [];
    $notes = $_POST['notes'] ?? [];

    // Build structured itinerary
    $itinerary = [
        'title' => $title,
        'travel_date' => $travel_date,
        'items' => []
    ];

    foreach ($selected as $place_id) {
        $place = null;
        foreach ($all_places as $p) {
            if ($p['id'] == $place_id) { $place = $p; break; }
        }
        if ($place) {
            $itinerary['items'][] = [
                'place' => $place,
                'day' => (int)($days[$place_id] ?? 1),
                'time' => esc($times[$place_id] ?? '09:00'),
                'note' => esc($notes[$place_id] ?? '')
            ];
        }
    }

    // Sort by day then time
    usort($itinerary['items'], function($a, $b) {
        if ($a['day'] === $b['day']) return strcmp($a['time'], $b['time']);
        return $a['day'] - $b['day'];
    });
}

require_once 'includes/header.php';
?>

<div class="container planner-page">
    <div class="section-header">
        <h2>Viuspot Planner</h2>
        <p>Buat jadwal perjalanan harianmu dengan destinasi pilihan</p>
    </div>

    <div class="grid grid-2">
        <div>
            <form method="POST" action="" class="planner-card">
                <div class="form-group">
                    <label class="form-label">Judul Perjalanan</label>
                    <input type="text" name="title" class="form-control" value="Perjalanan ke Yogyakarta" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Tanggal Mulai</label>
                    <input type="date" name="travel_date" class="form-control" value="<?php echo date('Y-m-d'); ?>" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Pilih Destinasi</label>
                    <div style="max-height:300px; overflow-y:auto; border:1px solid #e8e5d8; border-radius:6px; padding:0.75rem;">
                        <?php foreach ($all_places as $place): $id = $place['id']; ?>
                            <div style="padding:0.75rem 0; border-bottom:1px solid #f5f3eb;">
                                <label class="dest-item">
                                    <input type="checkbox" name="places[]" value="<?php echo $id; ?>" id="place_<?php echo $id; ?>">
                                    <span class="checkmark"></span>
                                    <strong><?php echo esc($place['name']); ?></strong> 
                                    <div style="color:#7d8165; font-size:0.8rem;"><?php echo esc($place['location']); ?></div>
                                </label>
                                
                                <div style="display:grid; grid-template-columns: 1fr 1fr 2fr; gap:0.5rem; margin-left:1.5rem;">
                                    <input type="number" name="days[<?php echo $place['id']; ?>]" class="form-control" placeholder="Hari" min="1" value="1" style="padding:0.4rem; font-size:0.85rem;">
                                    <input type="time" name="times[<?php echo $place['id']; ?>]" class="form-control" value="09:00" style="padding:0.4rem; font-size:0.85rem;">
                                    <input type="text" name="notes[<?php echo $place['id']; ?>]" class="form-control" placeholder="Catatan..." style="padding:0.4rem; font-size:0.85rem;">
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                </div>

                <button type="submit" name="build_itinerary" class="btn btn-accent btn-block" style="border-radius:12px;">Buat Itinerary</button>
            </form>
        </div>

        <div>
            <?php if ($itinerary): ?>
                <div class="planner-card">
                    <h3 style="margin-bottom:0.5rem;"><?php echo esc($itinerary['title']); ?></h3>
                    <p style="color:#7d8165; font-size:0.9rem; margin-bottom:1.5rem;">Tanggal: <?php echo $itinerary['travel_date']; ?></p>

                    <div class="timeline">
                        <?php 
                        $current_day = 0;
                        foreach ($itinerary['items'] as $item): 
                            if ($item['day'] !== $current_day):
                                $current_day = $item['day'];
                        ?>
                            <div style="margin:1rem 0 1rem 0; font-weight:700; color:#0f625c; font-size:1.2rem;">Hari <?php echo $current_day; ?></div>
                        <?php endif; ?>
                            <div class="clean-timeline-item">
                                <div class="timeline-time"><?php echo $item['time']; ?></div>
                                <div class="timeline-title"><?php echo esc($item['place']['name']); ?></div>
                                <p style="font-size:0.85rem; color:#7d8165; margin-top:0.25rem;"><?php echo esc($item['place']['location']); ?></p>
                                <?php if ($item['note']): ?>
                                    <p style="font-size:0.85rem; color:#5a6b57; font-style:italic; margin-top:0.25rem;">"<?php echo $item['note']; ?>"</p>
                                <?php endif; ?>
                                <a href="place.php?id=<?php echo $item['place']['id']; ?>" style="font-size:0.8rem;">Lihat detail &rarr;</a>
                            </div>
                        <?php endforeach; ?>
                    </div>

                    <div style="margin-top:1.5rem; padding-top:1rem; border-top:1px solid #e8e5d8;">
                        <p style="font-size:0.85rem; color:#7d8165;">Estimasi total biaya: 
                            <strong style="color:#2e3b2c;">
                                <?php 
                                $total = 0;
                                foreach ($itinerary['items'] as $item) {
                                    $total += ($item['place']['entrance_fee'] + $item['place']['parking_fee'] + $item['place']['meal_cost']);
                                }
                                echo format_rupiah($total);
                                ?>
                            </strong>
                        </p>
                    </div>
                </div>
            <?php else: ?>
                <div class="planner-card" style="text-align:center; color:#7d8165;">
                    <p>Pilih destinasi dari form di kiri untuk membuat itinerary perjalananmu.</p>
                    <p style="font-size:0.85rem; margin-top:0.5rem;">Itinerary akan ditampilkan dalam bentuk timeline yang rapi.</p>
                </div>
            <?php endif; ?>
        </div>
    </div>
</div>

<?php require_once 'includes/footer.php'; ?>
