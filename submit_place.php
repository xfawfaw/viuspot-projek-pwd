<?php
$page_title = 'Usulkan Destinasi';
require_once 'includes/functions.php';

// Wajib login sebelum mengusulkan tempat
if (!is_logged_in()) {
    set_flash('error', 'Kamu harus login terlebih dahulu untuk mengusulkan destinasi.');
    header('Location: login.php?redirect=submit_place.php');
    exit;
}

$categories = get_categories($pdo);
$error = '';

// Konfigurasi upload foto
define('UPLOAD_DIR',      __DIR__ . '/assets/img/user_uploads/');
define('UPLOAD_URL',      'user_uploads/');          // relatif terhadap assets/img/
define('UPLOAD_MAX_BYTES', 5 * 1024 * 1024);         // 5 MB
define('UPLOAD_ALLOWED',  ['image/jpeg', 'image/png', 'image/webp', 'image/gif']);
define('UPLOAD_EXT_MAP',  ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp', 'image/gif' => 'gif']);

// Buat direktori upload jika belum ada
if (!is_dir(UPLOAD_DIR)) {
    mkdir(UPLOAD_DIR, 0775, true);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name           = trim($_POST['name'] ?? '');
    $category_id    = (int)($_POST['category_id'] ?? 0);
    $location       = trim($_POST['location'] ?? '');
    $description    = trim($_POST['description'] ?? '');
    $entrance_fee   = (float)($_POST['entrance_fee'] ?? 0);
    $parking_fee    = (float)($_POST['parking_fee'] ?? 0);
    $meal_cost      = (float)($_POST['meal_cost'] ?? 0);
    $latitude       = trim($_POST['latitude'] ?? '');
    $longitude      = trim($_POST['longitude'] ?? '');

    // Fasilitas: ambil dari checkbox array lalu encode ke JSON
    $facilities_selected = $_POST['facilities'] ?? [];
    $facilities_allowed  = ['toilet','parkir','wifi','mushola','restoran','atm','aksesibilitas','area_foto','penginapan','souvenir','pemandu','camping','kolam_renang','pertolongan'];
    $facilities_clean    = array_values(array_intersect($facilities_selected, $facilities_allowed));
    $facilities_json     = !empty($facilities_clean) ? json_encode($facilities_clean) : null;

    // Validasi field wajib
    if (empty($name) || empty($location) || empty($description) || $category_id === 0) {
        $error = 'Nama, kategori, lokasi, dan deskripsi wajib diisi.';
    } else {
        // ---- Proses upload foto ----
        $image_url = null;

        if (!empty($_FILES['photo']['name'])) {
            $file   = $_FILES['photo'];
            $fsize  = $file['size'];
            $ftmp   = $file['tmp_name'];
            $fname  = $file['name'];

            // Validasi: tidak ada error dari PHP
            if ($file['error'] !== UPLOAD_ERR_OK) {
                $error = 'Terjadi kesalahan saat mengunggah foto (kode: ' . $file['error'] . ').';
            }
            // Validasi ukuran
            elseif ($fsize > UPLOAD_MAX_BYTES) {
                $error = 'Ukuran foto maksimal 5 MB. Foto yang kamu upload ' . round($fsize / 1024 / 1024, 2) . ' MB.';
            }
            // Validasi tipe MIME (via finfo, bukan extension)
            else {
                $finfo    = new finfo(FILEINFO_MIME_TYPE);
                $mime     = $finfo->file($ftmp);
                if (!in_array($mime, UPLOAD_ALLOWED)) {
                    $error = 'Tipe file tidak didukung. Gunakan JPG, PNG, WEBP, atau GIF.';
                } else {
                    // Generate nama file unik
                    $ext      = UPLOAD_EXT_MAP[$mime];
                    $filename = 'place_' . time() . '_' . bin2hex(random_bytes(5)) . '.' . $ext;
                    $dest     = UPLOAD_DIR . $filename;

                    if (!move_uploaded_file($ftmp, $dest)) {
                        $error = 'Gagal menyimpan foto. Pastikan direktori uploads dapat ditulis.';
                    } else {
                        // image_url disimpan sebagai path relatif dari assets/img/
                        $image_url = UPLOAD_URL . $filename;
                    }
                }
            }
        }

        // Lanjutkan simpan ke DB jika tidak ada error
        if (empty($error)) {
            $user_id = get_user_id() ?: null;
            $stmt = $pdo->prepare("
                INSERT INTO places
                    (name, category_id, location, description, entrance_fee, parking_fee, meal_cost,
                     facilities, latitude, longitude, image_url, status, submitted_by)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending', ?)
            ");
            $stmt->execute([
                $name, $category_id, $location, $description,
                $entrance_fee, $parking_fee, $meal_cost,
                $facilities_json, $latitude, $longitude,
                $image_url,
                $user_id
            ]);

            set_flash('success', 'Destinasi berhasil diajukan! Admin akan meninjau usulanmu.');
            header("Location: index.php");
            exit;
        }
    }
}

require_once 'includes/header.php';
?>

<style>
.photo-upload-area {
    border: 2px dashed #c8c4b0;
    border-radius: 10px;
    padding: 2rem;
    text-align: center;
    cursor: pointer;
    transition: all 0.2s;
    background: #fafaf5;
    position: relative;
}
.photo-upload-area:hover, .photo-upload-area.dragover {
    border-color: #2ab7a9;
    background: #f0faf9;
}
.photo-upload-area input[type="file"] {
    position: absolute; inset: 0; opacity: 0; cursor: pointer; width: 100%; height: 100%;
}
.photo-upload-icon { font-size: 2.5rem; color: #ccc; margin-bottom: 0.5rem; }
.photo-upload-area:hover .photo-upload-icon { color: #2ab7a9; }
.photo-preview {
    display: none;
    margin-top: 1rem;
}
.photo-preview img {
    max-height: 200px; border-radius: 8px; max-width: 100%;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}
.photo-info {
    font-size: 0.78rem; color: #7d8165; margin-top: 0.5rem;
}
</style>

<div class="container">
    <div class="section-header">
        <h2>Usulkan Destinasi Baru</h2>
        <p>Bantu kami memperkaya database wisata Indonesia. Destinasi akan ditinjau oleh admin sebelum ditampilkan.</p>
    </div>

    <div style="max-width:700px; margin:0 auto;">
        <?php if ($error): ?>
            <div class="alert alert-error"><?php echo $error; ?></div>
        <?php endif; ?>

        <form method="POST" action="" enctype="multipart/form-data" style="background:#fff; padding:2rem; border-radius:8px; border:1px solid #e8e5d8;">
            <div class="form-group">
                <label class="form-label">Nama Destinasi *</label>
                <input type="text" name="name" class="form-control" value="<?php echo esc($_POST['name'] ?? ''); ?>" required>
            </div>

            <div class="form-group">
                <label class="form-label">Kategori *</label>
                <select name="category_id" class="form-control" required>
                    <option value="">-- Pilih Kategori --</option>
                    <?php foreach ($categories as $cat): ?>
                        <option value="<?php echo $cat['id']; ?>" <?php echo (isset($_POST['category_id']) && $_POST['category_id'] == $cat['id']) ? 'selected' : ''; ?>>
                            <?php echo esc($cat['name']); ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Lokasi *</label>
                <input type="text" name="location" class="form-control" placeholder="Contoh: Yogyakarta, DI Yogyakarta" value="<?php echo esc($_POST['location'] ?? ''); ?>" required>
            </div>

            <div class="form-group">
                <label class="form-label">Deskripsi *</label>
                <textarea name="description" class="form-control" rows="4" required><?php echo esc($_POST['description'] ?? ''); ?></textarea>
            </div>

            <!-- ====== UPLOAD FOTO ====== -->
            <div class="form-group">
                <label class="form-label" style="display:block; margin-bottom:0.5rem; font-weight:600;">
                    <i class="ti ti-photo" style="margin-right:5px;"></i> Foto Destinasi
                    <small style="font-weight:400; color:#7d8165; display:block; margin-top:0.2rem;">
                        Opsional · Format JPG, PNG, WEBP, GIF · Maks. 5 MB
                    </small>
                </label>
                <div class="photo-upload-area" id="uploadArea" onclick="document.getElementById('photoInput').click()">
                    <input type="file" name="photo" id="photoInput" accept="image/jpeg,image/png,image/webp,image/gif">
                    <div class="photo-upload-icon"><i class="ti ti-cloud-upload"></i></div>
                    <p style="font-weight:600; color:#7d8165; margin:0 0 0.25rem;">Klik atau seret foto ke sini</p>
                    <p class="photo-info">JPG, PNG, WEBP, GIF — maks. 5 MB</p>
                    <div class="photo-preview" id="photoPreview">
                        <img id="previewImg" src="" alt="Preview">
                        <p class="photo-info" id="previewName"></p>
                    </div>
                </div>
                <button type="button" id="removePhoto" onclick="removePhotoPreview()" 
                        style="display:none; margin-top:0.5rem; font-size:0.8rem; color:#e45858; background:none; border:none; cursor:pointer;">
                    ✕ Hapus foto
                </button>
            </div>
            <!-- ====== END UPLOAD FOTO ====== -->

            <div class="grid grid-3">
                <div class="form-group">
                    <label class="form-label">Tiket Masuk (Rp)</label>
                    <input type="number" name="entrance_fee" class="form-control" min="0" value="<?php echo (int)($_POST['entrance_fee'] ?? 0); ?>">
                </div>
                <div class="form-group">
                    <label class="form-label">Parkir (Rp)</label>
                    <input type="number" name="parking_fee" class="form-control" min="0" value="<?php echo (int)($_POST['parking_fee'] ?? 0); ?>">
                </div>
                <div class="form-group">
                    <label class="form-label">Estimasi Makan (Rp)</label>
                    <input type="number" name="meal_cost" class="form-control" min="0" value="<?php echo (int)($_POST['meal_cost'] ?? 0); ?>">
                </div>
            </div>

            <!-- FASILITAS -->
            <div class="form-group">
                <label class="form-label" style="display:block; margin-bottom:0.75rem; font-weight:600;">
                    <i class="ti ti-star" style="margin-right:5px;"></i> Fasilitas Tersedia
                    <small style="font-weight:400; color:#7d8165; display:block; margin-top:0.25rem;">Centang semua fasilitas yang tersedia di destinasi ini</small>
                </label>
                <div style="display:grid; grid-template-columns: repeat(auto-fill, minmax(180px,1fr)); gap:0.6rem; background:#f7f6f0; padding:1rem; border-radius:8px; border:1px solid #e8e5d8;">
                    <?php
                    $facility_options = [
                        'toilet'        => ['label' => 'Toilet Umum',           'icon' => '🚻'],
                        'parkir'        => ['label' => 'Area Parkir',            'icon' => '🅿️'],
                        'wifi'          => ['label' => 'WiFi Gratis',            'icon' => '📶'],
                        'mushola'       => ['label' => 'Mushola/Masjid',         'icon' => '🕌'],
                        'restoran'      => ['label' => 'Restoran / Warung',      'icon' => '🍽️'],
                        'atm'           => ['label' => 'ATM / Money Changer',    'icon' => '💳'],
                        'aksesibilitas' => ['label' => 'Ramah Difabel',          'icon' => '♿'],
                        'area_foto'     => ['label' => 'Spot Foto Instagramable','icon' => '📸'],
                        'penginapan'    => ['label' => 'Penginapan Terdekat',    'icon' => '🏨'],
                        'souvenir'      => ['label' => 'Toko Souvenir',          'icon' => '🛍️'],
                        'pemandu'       => ['label' => 'Pemandu Wisata',         'icon' => '🧭'],
                        'camping'       => ['label' => 'Area Camping',           'icon' => '⛺'],
                        'kolam_renang'  => ['label' => 'Kolam Renang',           'icon' => '🏊'],
                        'pertolongan'   => ['label' => 'P3K / Klinik',           'icon' => '🏥'],
                    ];
                    $selected_facs = $_POST['facilities'] ?? [];
                    foreach ($facility_options as $key => $opt):
                    ?>
                    <label style="display:flex; align-items:center; gap:0.5rem; cursor:pointer; padding:0.4rem 0.6rem; border-radius:6px; transition:background 0.15s;" 
                           onmouseover="this.style.background='#edfaf8'" onmouseout="this.style.background='transparent'">
                        <input type="checkbox" name="facilities[]" value="<?php echo $key; ?>" style="width:16px; height:16px; accent-color:#2ab7a9;"
                               <?php echo in_array($key, $selected_facs) ? 'checked' : ''; ?>>
                        <span><?php echo $opt['icon']; ?> <?php echo $opt['label']; ?></span>
                    </label>
                    <?php endforeach; ?>
                </div>
            </div>

            <div class="grid grid-2">
                <div class="form-group">
                    <label class="form-label">Latitude</label>
                    <input type="text" name="latitude" class="form-control" placeholder="-7.7956" value="<?php echo esc($_POST['latitude'] ?? ''); ?>">
                </div>
                <div class="form-group">
                    <label class="form-label">Longitude</label>
                    <input type="text" name="longitude" class="form-control" placeholder="110.3695" value="<?php echo esc($_POST['longitude'] ?? ''); ?>">
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-block">Ajukan Destinasi</button>
        </form>
    </div>
</div>

<script>
const photoInput   = document.getElementById('photoInput');
const previewImg   = document.getElementById('previewImg');
const previewName  = document.getElementById('previewName');
const photoPreview = document.getElementById('photoPreview');
const removeBtn    = document.getElementById('removePhoto');
const uploadArea   = document.getElementById('uploadArea');

const MAX_BYTES = 5 * 1024 * 1024;
const ALLOWED   = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];

photoInput.addEventListener('change', handleFile);

// Drag & drop
uploadArea.addEventListener('dragover', e => { e.preventDefault(); uploadArea.classList.add('dragover'); });
uploadArea.addEventListener('dragleave', () => uploadArea.classList.remove('dragover'));
uploadArea.addEventListener('drop', e => {
    e.preventDefault();
    uploadArea.classList.remove('dragover');
    if (e.dataTransfer.files.length > 0) {
        // Ganti input file via DataTransfer
        try {
            const dt = new DataTransfer();
            dt.items.add(e.dataTransfer.files[0]);
            photoInput.files = dt.files;
        } catch(err) {}
        handleFile({ target: { files: e.dataTransfer.files } });
    }
});

function handleFile(e) {
    const file = e.target.files[0];
    if (!file) return;

    if (!ALLOWED.includes(file.type)) {
        alert('Tipe file tidak didukung. Gunakan JPG, PNG, WEBP, atau GIF.');
        photoInput.value = '';
        return;
    }
    if (file.size > MAX_BYTES) {
        alert('Ukuran foto melebihi 5 MB (' + (file.size / 1024 / 1024).toFixed(2) + ' MB).');
        photoInput.value = '';
        return;
    }

    const reader = new FileReader();
    reader.onload = ev => {
        previewImg.src   = ev.target.result;
        previewName.textContent = file.name + ' (' + (file.size / 1024).toFixed(0) + ' KB)';
        photoPreview.style.display = 'block';
        removeBtn.style.display    = 'inline-block';
    };
    reader.readAsDataURL(file);
}

function removePhotoPreview() {
    photoInput.value         = '';
    photoPreview.style.display = 'none';
    removeBtn.style.display    = 'none';
    previewImg.src             = '';
}
</script>

<?php require_once 'includes/footer.php'; ?>