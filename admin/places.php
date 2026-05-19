<?php
require_once '../includes/functions.php';
require_admin();

$page_title = 'Kelola Destinasi';

// Handle actions
if (isset($_GET['action']) && isset($_GET['id'])) {
    $action = $_GET['action'];
    $id = (int)$_GET['id'];

    if ($action === 'approve') {
        $pdo->prepare("UPDATE places SET status='approved' WHERE id=?")->execute([$id]);
        set_flash('success', 'Destinasi berhasil diapprove.');
    } elseif ($action === 'reject') {
        $pdo->prepare("UPDATE places SET status='rejected' WHERE id=?")->execute([$id]);
        set_flash('success', 'Destinasi berhasil direject.');
    } elseif ($action === 'delete') {
        $pdo->prepare("DELETE FROM places WHERE id=?")->execute([$id]);
        set_flash('success', 'Destinasi berhasil dihapus.');
    }
    header("Location: places.php");
    exit;
}

// Handle edit fasilitas
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['save_facilities'])) {
    $edit_id = (int)($_POST['place_id'] ?? 0);
    $facilities_allowed = ['toilet','parkir','wifi','mushola','restoran','atm','aksesibilitas','area_foto','penginapan','souvenir','pemandu','camping','kolam_renang','pertolongan'];
    $selected = $_POST['facilities'] ?? [];
    $clean = array_values(array_intersect($selected, $facilities_allowed));
    $json = !empty($clean) ? json_encode($clean) : null;
    $pdo->prepare("UPDATE places SET facilities=? WHERE id=?")->execute([$json, $edit_id]);
    set_flash('success', 'Fasilitas berhasil diperbarui.');
    header("Location: places.php");
    exit;
}

// Filter
$status_filter = $_GET['status'] ?? 'all';
if ($status_filter !== 'all') {
    $stmt = $pdo->prepare("SELECT p.*, c.`name` as category_name, u.username as submitter_username FROM places p JOIN categories c ON p.category_id = c.id LEFT JOIN users u ON p.submitted_by = u.id WHERE p.status = ? ORDER BY p.created_at DESC");
    $stmt->execute([$status_filter]);
    $places = $stmt->fetchAll();
} else {
    $stmt = $pdo->query("SELECT p.*, c.`name` as category_name, u.username as submitter_username FROM places p JOIN categories c ON p.category_id = c.id LEFT JOIN users u ON p.submitted_by = u.id ORDER BY p.created_at DESC");
    $places = $stmt->fetchAll();
}

$all_facilities = [
    'toilet'        => ['label' => 'Toilet',           'icon' => 'fa-solid fa-restroom'],
    'parkir'        => ['label' => 'Area Parkir',       'icon' => 'fa-solid fa-square-parking'],
    'wifi'          => ['label' => 'WiFi',              'icon' => 'fa-solid fa-wifi'],
    'mushola'       => ['label' => 'Mushola',           'icon' => 'fa-solid fa-mosque'],
    'restoran'      => ['label' => 'Restoran/Warung',   'icon' => 'fa-solid fa-utensils'],
    'atm'           => ['label' => 'ATM',               'icon' => 'fa-solid fa-credit-card'],
    'aksesibilitas' => ['label' => 'Ramah Difabel',     'icon' => 'fa-solid fa-wheelchair'],
    'area_foto'     => ['label' => 'Spot Foto',         'icon' => 'fa-solid fa-camera'],
    'penginapan'    => ['label' => 'Penginapan',        'icon' => 'fa-solid fa-hotel'],
    'souvenir'      => ['label' => 'Toko Souvenir',     'icon' => 'fa-solid fa-bag-shopping'],
    'pemandu'       => ['label' => 'Pemandu Wisata',    'icon' => 'fa-solid fa-compass'],
    'camping'       => ['label' => 'Area Camping',      'icon' => 'fa-solid fa-tent'],
    'kolam_renang'  => ['label' => 'Kolam Renang',      'icon' => 'fa-solid fa-person-swimming'],
    'pertolongan'   => ['label' => 'P3K / Klinik',      'icon' => 'fa-solid fa-kit-medical'],
];

require_once '../includes/header.php';
?>

<div class="container">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem; flex-wrap:wrap; gap:1rem;">
        <h2>Kelola Destinasi</h2>
        <div style="display:flex; gap:0.5rem;">
            <a href="places.php?status=all" class="btn btn-sm <?php echo $status_filter=='all'?'btn-primary':'btn-outline'; ?>">Semua</a>
            <a href="places.php?status=pending" class="btn btn-sm <?php echo $status_filter=='pending'?'btn-primary':'btn-outline'; ?>">Pending</a>
            <a href="places.php?status=approved" class="btn btn-sm <?php echo $status_filter=='approved'?'btn-primary':'btn-outline'; ?>">Approved</a>
            <a href="places.php?status=rejected" class="btn btn-sm <?php echo $status_filter=='rejected'?'btn-primary':'btn-outline'; ?>">Rejected</a>
        </div>
    </div>

    <div class="table-responsive">
        <table class="data-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nama</th>
                    <th>Kategori</th>
                    <th>Lokasi</th>
                    <th>Fasilitas</th>
                    <th>Diajukan Oleh</th>
                    <th>Status</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($places as $place): 
                    $facs = !empty($place['facilities']) ? json_decode($place['facilities'], true) : [];
                    if (!is_array($facs)) $facs = [];
                ?>
                <tr>
                    <td><?php echo $place['id']; ?></td>
                    <td><strong><?php echo esc($place['name']); ?></strong></td>
                    <td><?php echo esc($place['category_name']); ?></td>
                    <td><?php echo esc($place['location']); ?></td>
                    <td>
                        <?php if (!empty($facs)): ?>
                            <div style="display:flex; flex-wrap:wrap; gap:3px; max-width:150px;">
                                <?php foreach ($facs as $f): ?>
                                    <span title="<?php echo ucfirst($f); ?>" style="font-size:0.95rem;"><?php echo $all_facilities[$f]['icon'] ?? '✓'; ?></span>
                                <?php endforeach; ?>
                            </div>
                        <?php else: ?>
                            <span style="color:#ccc; font-size:0.8rem;">Belum diisi</span>
                        <?php endif; ?>
                        <button onclick="openFacilityModal(<?php echo $place['id']; ?>, '<?php echo esc(htmlspecialchars(json_encode($facs), ENT_QUOTES)); ?>')" 
                            class="btn btn-sm btn-outline" style="margin-top:4px; font-size:0.7rem; padding:2px 8px;">✏️ Edit</button>
                    </td>
                    <td>
                        <?php if (!empty($place['submitter_username'])): ?>
                            👤 <?php echo esc($place['submitter_username']); ?>
                        <?php else: ?>
                            <span style="color:#aaa;">— Admin</span>
                        <?php endif; ?>
                    </td>
                    <td><span class="status-badge status-<?php echo $place['status']; ?>"><?php echo ucfirst($place['status']); ?></span></td>
                    <td>
                        <?php if ($place['status'] === 'pending'): ?>
                            <a href="?action=approve&id=<?php echo $place['id']; ?>" class="btn btn-accent btn-sm">Approve</a>
                            <a href="?action=reject&id=<?php echo $place['id']; ?>" class="btn btn-danger btn-sm">Reject</a>
                        <?php endif; ?>
                        <a href="?action=delete&id=<?php echo $place['id']; ?>" class="btn btn-danger btn-sm" onclick="return confirm('Hapus destinasi ini?')">Hapus</a>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal Edit Fasilitas -->
<div id="facilityModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.5); z-index:9999; align-items:center; justify-content:center;">
    <div style="background:#fff; border-radius:12px; padding:2rem; width:90%; max-width:560px; max-height:90vh; overflow-y:auto;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.25rem;">
            <h3 style="margin:0;">Edit Fasilitas</h3>
            <button onclick="closeFacilityModal()" style="background:none; border:none; font-size:1.5rem; cursor:pointer; color:#aaa;">×</button>
        </div>
        <form method="POST">
            <input type="hidden" name="place_id" id="modal_place_id">
            <div style="display:grid; grid-template-columns:repeat(auto-fill, minmax(160px,1fr)); gap:0.5rem; margin-bottom:1.5rem;">
                <?php foreach ($all_facilities as $key => $opt): ?>
                <label style="display:flex; align-items:center; gap:0.5rem; cursor:pointer; padding:0.5rem; border-radius:6px; border:1px solid #e8e5d8; background:#f7f6f0; transition:all 0.15s;"
                       onmouseover="this.style.borderColor='#2ab7a9'" onmouseout="this.style.borderColor='#e8e5d8'">
                    <input type="checkbox" name="facilities[]" value="<?php echo $key; ?>" 
                           id="fac_<?php echo $key; ?>" style="width:15px;height:15px;accent-color:#2ab7a9;">
                    <?php echo $opt['icon']; ?> <span style="font-size:0.82rem;"><?php echo $opt['label']; ?></span>
                </label>
                <?php endforeach; ?>
            </div>
            <div style="display:flex; gap:0.75rem; justify-content:flex-end;">
                <button type="button" onclick="closeFacilityModal()" class="btn btn-outline">Batal</button>
                <button type="submit" name="save_facilities" class="btn btn-primary">Simpan Fasilitas</button>
            </div>
        </form>
    </div>
</div>

<script>
function openFacilityModal(placeId, facilitiesJson) {
    document.getElementById('modal_place_id').value = placeId;
    // Reset all checkboxes
    document.querySelectorAll('#facilityModal input[type=checkbox]').forEach(cb => cb.checked = false);
    // Parse and check saved facilities
    try {
        const facs = JSON.parse(facilitiesJson);
        if (Array.isArray(facs)) {
            facs.forEach(f => {
                const cb = document.getElementById('fac_' + f);
                if (cb) cb.checked = true;
            });
        }
    } catch(e) {}
    document.getElementById('facilityModal').style.display = 'flex';
}
function closeFacilityModal() {
    document.getElementById('facilityModal').style.display = 'none';
}
// Close on backdrop click
document.getElementById('facilityModal').addEventListener('click', function(e) {
    if (e.target === this) closeFacilityModal();
});
</script>

<?php require_once '../includes/footer.php'; ?>
