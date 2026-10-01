# 🎮 Apipi Adventure (Game 1 Kelas C)

Sebuah game 2D Platformer retro bernuansa pixel art yang dibangun menggunakan **Godot Engine 4**. Menampilkan petualangan seru **Mask Dude** melewati berbagai rintangan, mengumpulkan buah, mengalahkan monster, dan menaklukkan puncak benteng akhir!

![Apipi Adventure Banner](Apipi%20Adventure.jpg)

---

## ✨ Fitur Utama

- **Karakter & Animasi Lengkap:**
  - Karakter utama **Mask Dude** dengan animasi halus: *Idle*, *Run*, *Jump*, *Double Jump*, dan *Fall*.
  - **Mekanika Double Jump:** Mampu melompat dua kali di udara untuk mencapai platform tinggi atau melewati jurang lebar.

- **Sistem 3 Nyawa & Game Over:**
  - Pemain memiliki **3 Nyawa (Hearts: ❤️❤️❤️)** yang terpampang di HUD.
  - Jika terkena musuh atau duri, nyawa berkurang 1 dan karakter respawn di **Checkpoint** terakhir dengan efek kedip kebal sesaat (*invulnerability*).
  - Jika 3 nyawa habis (**Game Over**), posisi pemain, titik checkpoint, dan skor akan di-reset kembali ke titik awal panggung.

- **Musuh & Mekanisme Serangan (Stomp):**
  - **Rock Head Monster:** Monster batu berpatroli dengan mata berkedip.
  - Jika diinjak dari atas (*stomp*), monster akan gepeng dan kalah, memberi **+200 Skor**, serta memantulkan pemain ke udara.
  - Jika bersentuhan dari samping atau bawah, musuh akan melukai pemain dan mengurangi nyawa.

- **Sistem Poin & Buah Interaktif:**
  - Ragam buah nusantara: Apel, Pisang, Ceri, Kiwi, Melon, Jeruk, Nanas, dan Stroberi bernilai 100 - 500 poin.
  - Efek animasi *pop-up & fade-out* serta efek suara koin saat buah berhasil dikumpulkan.

- **Rintangan & Perangkap Dinamis:**
  - **Trampolin:** Melontarkan pemain tinggi melewati tebing terjal.
  - **Moving Platform:** Balok berjalan penyeberang jurang otomatis.
  - **Spiked Ball (Pendulum):** Bola duri yang berayun pada rantai.
  - **Gergaji Berputar (Saw):** Rintangan bergerak aktif di antara celah platform.
  - **Semburan Api (Fire Trap):** Perangkap api berkala.
  - **Batu Penghantam (Rock Head Stomper):** Menghantam ke bawah secara berkala.

- **Audio & Sound Effects (SFX):**
  - Efek suara *retro 16-bit* untuk aksi **Lompat**, **Double Jump** (nada lebih tinggi), **Ambil Buah**, dan **Injak Musuh**.
  - Background music (BGM).

- **Multi-Platform & Mobile Ready:**
  - **Layar Adaptif:** Tampilan otomatis menyesuaikan rasio layar modern, termasuk rasio 16:9 pada **iPhone SE Gen 2** tanpa distorsi.
  - **On-Screen Touch Controls:** Tombol virtual sentuh (D-Pad Kiri/Kanan, Tombol Lompat besar, dan Tombol Reset) responsif untuk smartphone (Android & iOS).
  - **Parallax Background:** Latar belakang bergerak mulus (*seamless*) mengikuti arah kamera.

---

## 🕹️ Kontrol Permainan

### Keyboard (PC / Laptop)
| Aksi | Tombol Pilihan 1 | Tombol Pilihan 2 |
| :--- | :--- | :--- |
| **Gerak Kiri** | `A` | `← (Panah Kiri)` |
| **Gerak Kanan** | `D` | `→ (Panah Kanan)` |
| **Lompat** | `W` / `Space` | `↑ (Panah Atas)` |
| **Double Jump** | Tekan lompat lagi di udara | Tekan lompat lagi di udara |
| **Respawn Manual** | `R` | - |

### Layar Sentuh (Mobile / Touchscreen)
- **D-Pad Kiri & Kanan:** Pojok kiri bawah layar (*support swipe / passby-press*).
- **Tombol Lompat:** Pojok kanan bawah layar.
- **Tombol R:** Pojok kanan atas untuk respawn cepat.

---

## 🛠️ Persyaratan & Cara Menjalankan

### Persyaratan
- **Godot Engine 4.x** (disarankan Godot 4.3 atau 4.7+)

### Menjalankan Proyek di Komputer Lokal
1. Clone repositori ini:
   ```bash
   git clone https://github.com/arifianilhamnrr/apipi-game.git
   ```
2. Buka aplikasi **Godot Engine**.
3. Pilih tombol **Import**, lalu arahkan ke folder repositori yang baru di-clone (pilih file `project.godot`).
4. Tekan tombol **Play (F5)** untuk langsung memainkan game!

---

## 📱 Panduan Export

### 1. Export ke Android (.apk)
1. Pasang Android SDK dan konfigurasi path di **Editor -> Editor Settings -> Export -> Android**.
2. Di Godot, buka **Project -> Export...**, pilih preset **Android**.
3. Klik **Export Project** untuk menghasilkan file `.apk`.

### 2. Export ke iOS / iPhone (.ipa)
> *Catatan: Pembuatan file `.ipa` membutuhkan komputer macOS dengan Xcode terpasang.*
1. Buka proyek ini di Godot versi macOS.
2. Buka **Project -> Export...**, pilih preset **iOS**, lalu pilih **Export Project** (menghasilkan folder Xcode).
3. Buka file `.xcodeproj` di **Xcode**.
4. Hubungkan iPhone (misalnya iPhone SE Gen 2), pilih perangkat Anda, dan jalankan (*Run*) untuk menginstal langsung ke ponsel.

### 3. Export ke Web (HTML5)
Game dapat diekspor ke format Web dan di-host di GitHub Pages / Vercel / Netlify. Pengguna Android maupun iPhone dapat memainkannya langsung melalui browser dengan kontrol sentuh yang sudah tersedia.

---

## 📁 Struktur Folder Proyek

```text
├── assets/
│   ├── Audio/            # Sound effects (jump, fruit, stomp, bgm)
│   ├── Background/       # Gambar latar belakang parallax
│   ├── Items/            # Buah-buahan, peti, dan pos bendera (checkpoint/finish)
│   ├── Main Characters/  # Spritesheet karakter utama & musuh
│   ├── TouchControls/    # Tekstur tombol sentuh mobile
│   └── Traps/            # Gerigi, trampolin, batu penghantam, duri
├── characters/
│   ├── mask_dude.gd      # Script logika pergerakan & nyawa karakter
│   └── mask_dude.tscn    # Scene karakter Mask Dude
├── scripts/
│   ├── background_layer.gd # Skrip kontrol latar belakang parallax
│   ├── checkpoint.gd     # Sistem bendera checkpoint
│   ├── enemy.gd          # AI patroli dan deteksi stomp musuh
│   ├── finish_flag.gd    # Garis akhir & pemicu kemenangan
│   ├── fruit.gd          # Logika pengambilan buah & skor
│   ├── hud.gd            # Tampilan antarmuka skor, buah, dan nyawa
│   ├── touch_controls.gd # Penyesuaian posisi tombol sentuh otomatis
│   └── ...
├── export_presets.cfg    # Konfigurasi preset export (Android & iOS)
├── node_2d.tscn          # Main level scene
└── project.godot         # Konfigurasi utama engine Godot
```

---

## 👤 Pembuat
**Arifian Ilham Nur Riandana**  
- GitHub: [@arifianilhamnrr](https://github.com/arifianilhamnrr)
