<?php
$page_title = 'Budget Calculator';
require_once 'includes/functions.php';

$all_places = [];
$stmt = $pdo->query("SELECT * FROM places WHERE status='approved' ORDER BY `name` ASC");
$all_places = $stmt->fetchAll();

$budget_result = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['calculate'])) {
    $selected = $_POST['places'] ?? [];
    $people = (int)($_POST['people'] ?? 1);
    $days = (int)($_POST['days'] ?? 1);
    $transport = (float)($_POST['transport'] ?? 0);
    $accommodation = (float)($_POST['accommodation'] ?? 0);

    $breakdown = [
        'entrance' => 0,
        'parking' => 0,
        'meals' => 0,
        'transport' => $transport,
        'accommodation' => $accommodation,
        'details' => []
    ];

    foreach ($selected as $place_id) {
        foreach ($all_places as $place) {
            if ($place['id'] == $place_id) {
                $breakdown['entrance'] += ($place['entrance_fee'] * $people);
                $breakdown['parking'] += ($place['parking_fee'] * $days);
                $breakdown['meals'] += ($place['meal_cost'] * $people * $days);
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

                <div class="form-group">
                    <label class="form-label">Pilih Destinasi</label>
                    <div style="max-height:300px; overflow-y:auto; border:1px solid #e8e5d8; border-radius:12px; padding:0.75rem; background: #fff;">
                        <?php foreach ($all_places as $place): ?>
                            <label class="dest-item">
                                <input type="checkbox" name="places[]" value="<?php echo $place['id']; ?>" id="bp_<?php echo $place['id']; ?>"
                                        data-entrance="<?php echo $place['entrance_fee']; ?>"
                                        data-parking="<?php echo $place['parking_fee']; ?>"
                                        data-meal="<?php echo $place['meal_cost']; ?>">
                                <span class="checkmark"></span>
                                <strong><?php echo esc($place['name']); ?></strong>
                                <div style="color:#7d8165; font-size:0.8rem;">
                                    Tiket: <?php echo format_rupiah($place['entrance_fee']); ?> | Makan: <?php echo format_rupiah($place['meal_cost']); ?>
                                </div>
                            </label>
                        <?php endforeach; ?>
                    </div>
                </div>

                <button type="submit" name="calculate" class="btn btn-emerald btn-block">Hitung Budget</button>
            </form>
        </div>

        <div id="resultContainer">
            <?php if ($budget_result): ?>
                <div class="budget-summary glass-card" style="background: var(--hero-gradient);">
                    <div style="font-size:0.9rem; opacity:0.9; margin-bottom:0.5rem;">Estimasi Total Biaya</div>
                    <div class="budget-total price-highlight" id="totalDisplay"><?php echo format_rupiah($budget_result['total']); ?></div>

                    <div class="budget-breakdown">
                        <div class="budget-item">
                            <div class="budget-item-label">Tiket Masuk</div>
                            <div class="budget-item-value"><?php echo format_rupiah($budget_result['entrance']); ?></div>
                        </div>
                        <div class="budget-item">
                            <div class="budget-item-label">Parkir</div>
                            <div class="budget-item-value"><?php echo format_rupiah($budget_result['parking']); ?></div>
                        </div>
                        <div class="budget-item">
                            <div class="budget-item-label">Makan</div>
                            <div class="budget-item-value"><?php echo format_rupiah($budget_result['meals']); ?></div>
                        </div>
                        <div class="budget-item">
                            <div class="budget-item-label">Transport</div>
                            <div class="budget-item-value"><?php echo format_rupiah($budget_result['transport']); ?></div>
                        </div>
                        <div class="budget-item">
                            <div class="budget-item-label">Akomodasi</div>
                            <div class="budget-item-value"><?php echo format_rupiah($budget_result['accommodation']); ?></div>
                        </div>
                    </div>
                </div>

                <div class="planner-card" style="margin-top:1.5rem;">
                    <h4 style="margin-bottom:1rem;">Detail Destinasi</h4>
                    <?php foreach ($budget_result['details'] as $d): ?>
                        <div style="padding:0.75rem 0; border-bottom:1px solid #f5f3eb;">
                            <strong><?php echo esc($d['name']); ?></strong>
                            <p style="font-size:0.85rem; color:#7d8165; margin-top:0.25rem;">
                                Tiket: <?php echo format_rupiah($d['entrance_fee']); ?> | 
                                Parkir: <?php echo format_rupiah($d['parking_fee']); ?> | 
                                Makan: <?php echo format_rupiah($d['meal_cost']); ?>
                            </p>
                        </div>
                    <?php endforeach; ?>
                </div>
            <?php else: ?>
                <div class="glass-card" style="text-align:center; color:#7d8165; min-height: 200px; display: flex; flex-direction: column; justify-content: center;">
                    <div style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.2;">💰</div>
                    <p>Isi form di kiri dan pilih destinasi untuk melihat estimasi biaya perjalanan.</p>
                </div>
            <?php endif; ?>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('budgetForm');
    const inputs = form.querySelectorAll('input');
    const totalDisplay = document.getElementById('totalDisplay');

    function formatRupiah(amount) {
        return 'Rp ' + amount.toLocaleString('id-ID');
    }

    function calculateRealTime() {
        const people = parseInt(form.querySelector('[name="people"]').value) || 0;
        const days = parseInt(form.querySelector('[name="days"]').value) || 0;
        const transport = parseFloat(form.querySelector('[name="transport"]').value) || 0;
        const accommodation = parseFloat(form.querySelector('[name="accommodation"]').value) || 0;
        
        let entrance = 0, parking = 0, meals = 0;
        
        form.querySelectorAll('[name="places[]"]:checked').forEach(cb => {
            entrance += (parseFloat(cb.dataset.entrance) || 0) * people;
            parking += (parseFloat(cb.dataset.parking) || 0) * days;
            meals += (parseFloat(cb.dataset.meal) || 0) * people * days;
        });

        const total = entrance + parking + meals + transport + accommodation;
        
        // If the result display exists, update it live
        if (totalDisplay) {
            totalDisplay.innerText = formatRupiah(total);
        }
    }

    inputs.forEach(input => {
        input.addEventListener('input', calculateRealTime);
    });
    
    calculateRealTime();
});
</script>

<?php require_once 'includes/footer.php'; ?>
