<?php
$page_title = 'Budget Calculator';
require_once 'includes/functions.php';

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

$budget_result = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['calculate'])) {
    $selected = $_POST['places'] ?? [];
    $people = (int)($_POST['people'] ?? 1);
    $days   = (int)($_POST['days'] ?? 1);
    $transport     = (float)($_POST['transport'] ?? 0);
    $accommodation = (float)($_POST['accommodation'] ?? 0);

    $breakdown = ['entrance'=>0,'parking'=>0,'meals'=>0,'transport'=>$transport,'accommodation'=>$accommodation,'details'=>[]];
    foreach ($selected as $place_id) {
        foreach ($all_places as $place) {
            if ($place['id'] == $place_id) {
                $breakdown['entrance'] += ($place['entrance_fee'] * $people);
                $breakdown['parking']  += ($place['parking_fee'] * $days);
                $breakdown['meals']    += ($place['meal_cost'] * $people * $days);
                $breakdown['details'][] = $place;
                break;
            }
        }
    }
    $breakdown['total'] = $breakdown['entrance'] + $breakdown['parking'] + $breakdown['meals'] + $breakdown['transport'] + $breakdown['accommodation'];
    $budget_result = $breakdown;
}

require_once 'includes/header.php';
?>

<div class="container planner-page">
    <div class="section-header">
        <h2>Budget Calculator</h2>
        <p>Hitung estimasi biaya perjalanan wisatamu</p>
    </div>

    <div class="grid grid-2">
        <div>
            <form id="budgetForm" method="POST" action="" class="planner-card">
                <div class="grid grid-2">
                    <div class="form-group">
                        <label class="form-label">Jumlah Orang</label>
                        <input type="number" name="people" class="form-control" value="2" min="1" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Durasi (Hari)</label>
                        <input type="number" name="days" class="form-control" value="2" min="1" required>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Transportasi (Total Rp)</label>
                    <input type="number" name="transport" class="form-control" value="500000" min="0">
                </div>
                <div class="form-group">
                    <label class="form-label">Akomodasi (Total Rp)</label>
                    <input type="number" name="accommodation" class="form-control" value="400000" min="0">
                </div>

                <!-- Filter -->
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
                    <div id="destinationList" style="max-height:340px;overflow-y:auto;border:1px solid #e8e5d8;border-radius:12px;background:#fff;">
                        <?php foreach ($places_by_cat as $cat_id => $catData): ?>
                        <div class="dest-category-group" data-cat="<?php echo $cat_id; ?>">
                            <div class="dest-cat-header"><?php echo esc($catData['label']); ?></div>
                            <?php foreach ($catData['places'] as $place): ?>
                            <div class="dest-item-wrap" data-cat="<?php echo $cat_id; ?>" data-loc="<?php echo esc($place['location']); ?>">
                                <label class="dest-item">
                                    <input type="checkbox" name="places[]" value="<?php echo $place['id']; ?>"
                                        data-entrance="<?php echo $place['entrance_fee']; ?>"
                                        data-parking="<?php echo $place['parking_fee']; ?>"
                                        data-meal="<?php echo $place['meal_cost']; ?>">
                                    <span class="checkmark"></span>
                                    <div>
                                        <strong><?php echo esc($place['name']); ?></strong>
                                        <div style="color:#7d8165;font-size:0.78rem;">
                                            <?php echo esc($place['location']); ?> &bull;
                                            Tiket: <?php echo format_rupiah($place['entrance_fee']); ?> | Makan: <?php echo format_rupiah($place['meal_cost']); ?>
                                        </div>
                                    </div>
                                </label>
                            </div>
                            <?php endforeach; ?>
                        </div>
                        <?php endforeach; ?>
                    </div>
                </div>

                <button type="submit" name="calculate" class="btn btn-emerald btn-block">Hitung Budget</button>
            </form>
        </div>

        <div id="resultContainer">
            <!-- Live preview card -->
            <div class="budget-summary glass-card" id="liveCard" style="margin-bottom:1.5rem; color:#333;">
                <div style="font-size:0.9rem;opacity:0.9;margin-bottom:0.5rem; color:#333;">Estimasi Total Biaya (Live)</div>
                <div class="budget-total price-highlight" id="totalDisplay" style="color:#2ab7a9; font-weight:bold; font-size:2rem; margin-bottom:1rem;">Rp 0</div>
                <div class="budget-breakdown" id="liveBreakdown" style="color:#555;">
                    <div class="budget-item"><div class="budget-item-label">Tiket Masuk</div><div class="budget-item-value" id="liveEntrance">Rp 0</div></div>
                    <div class="budget-item"><div class="budget-item-label">Parkir</div><div class="budget-item-value" id="liveParking">Rp 0</div></div>
                    <div class="budget-item"><div class="budget-item-label">Makan</div><div class="budget-item-value" id="liveMeals">Rp 0</div></div>
                    <div class="budget-item"><div class="budget-item-label">Transport</div><div class="budget-item-value" id="liveTransport">Rp 0</div></div>
                    <div class="budget-item"><div class="budget-item-label">Akomodasi</div><div class="budget-item-value" id="liveAccom">Rp 0</div></div>
                </div>
            </div>

            <?php if ($budget_result): ?>
            <div class="planner-card">
                <h4 style="margin-bottom:1rem;">Detail Destinasi Terpilih</h4>
                <?php foreach ($budget_result['details'] as $d): ?>
                <div style="padding:0.75rem 0;border-bottom:1px solid #f5f3eb;">
                    <strong><?php echo esc($d['name']); ?></strong>
                    <span style="font-size:0.75rem;color:#7d8165;background:#f5f3eb;border-radius:4px;padding:0.1rem 0.4rem;margin-left:0.4rem;"><?php echo esc($d['category_name']); ?></span>
                    <p style="font-size:0.85rem;color:#7d8165;margin-top:0.25rem;">
                        Tiket: <?php echo format_rupiah($d['entrance_fee']); ?> | Parkir: <?php echo format_rupiah($d['parking_fee']); ?> | Makan: <?php echo format_rupiah($d['meal_cost']); ?>
                    </p>
                </div>
                <?php endforeach; ?>
            </div>
            <?php endif; ?>
        </div>
    </div>
</div>

<style>
.dest-category-group { border-bottom:1px solid #f5f3eb; }
.dest-category-group:last-child { border-bottom:none; }
.dest-cat-header { padding:0.5rem 0.75rem; font-size:0.72rem; font-weight:700; letter-spacing:0.07em; text-transform:uppercase; color:var(--secondary); background:#f9f9f7; border-bottom:1px solid #f0ede0; position:sticky; top:0; z-index:1; }
.dest-item-wrap { border-bottom:1px solid #f5f3eb; padding:0.25rem 0.75rem; }
.dest-item-wrap:last-child { border-bottom:none; }
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('budgetForm');

    function formatRupiah(n) {
        return 'Rp ' + Math.round(n).toLocaleString('id-ID');
    }

    function calculateRealTime() {
        const people = parseInt(form.querySelector('[name="people"]').value) || 0;
        const days   = parseInt(form.querySelector('[name="days"]').value) || 0;
        const transport     = parseFloat(form.querySelector('[name="transport"]').value) || 0;
        const accommodation = parseFloat(form.querySelector('[name="accommodation"]').value) || 0;
        let entrance=0, parking=0, meals=0;
        form.querySelectorAll('[name="places[]"]:checked').forEach(cb => {
            entrance += (parseFloat(cb.dataset.entrance)||0) * people;
            parking  += (parseFloat(cb.dataset.parking)||0) * days;
            meals    += (parseFloat(cb.dataset.meal)||0) * people * days;
        });
        const total = entrance + parking + meals + transport + accommodation;
        document.getElementById('totalDisplay').innerText = formatRupiah(total);
        document.getElementById('liveEntrance').innerText = formatRupiah(entrance);
        document.getElementById('liveParking').innerText  = formatRupiah(parking);
        document.getElementById('liveMeals').innerText    = formatRupiah(meals);
        document.getElementById('liveTransport').innerText = formatRupiah(transport);
        document.getElementById('liveAccom').innerText    = formatRupiah(accommodation);
    }

    form.querySelectorAll('input').forEach(i => i.addEventListener('input', calculateRealTime));
    calculateRealTime();

    // Filter kategori & lokasi
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
