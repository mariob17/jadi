# StudyTracker

StudyTracker adalah satu aplikasi Flutter untuk mengatur tugas kuliah dan
belajar. Seluruh inti project sudah digabungkan ke satu project Flutter di
folder ini; folder starter terpisah tidak diperlukan untuk menjalankannya.

Untuk rangkuman UTS dengan penjelasan pemula tentang alur, file, metode, dan
cara menjalankan aplikasi, lihat [RANGKUMAN_UTS.md](./RANGKUMAN_UTS.md).

## Menjalankan aplikasi

Pastikan Flutter sudah terpasang, lalu dari folder project jalankan:

```bash
flutter pub get
flutter run
```

Untuk menjalankan pemeriksaan otomatis:

```bash
flutter analyze
flutter test
```

## Kemampuan aplikasi

1. **Tambah tugas dengan validasi** — nama harus diisi dan minimal 3 karakter.
   Form juga menerima catatan, kategori, prioritas, dan tenggat opsional.
2. **Filter dan pencarian** — tampilkan semua, tugas yang belum selesai, atau
   tugas yang sudah selesai; filter kategori dan cari kata pada judul/catatan.
3. **Tandai selesai** — kotak centang mengubah status dan ringkasan progres.
4. **Edit tugas** — ubah detail tugas yang ada dan simpan kembali.
5. **Hapus tugas** — aplikasi meminta konfirmasi sebelum menghapus.

Tambahan yang dipelajari: widget reusable, animasi progres, tema Material 3,
layout daftar/kartu yang menyesuaikan lebar layar, model data Dart, dan
serialisasi JSON pada model.

## Penjelasan untuk pemula

- `lib/main.dart` adalah pintu masuk aplikasi. File ini menyalakan Flutter dan
  memilih halaman utama serta tema warna.
- `lib/models/study_task.dart` adalah bentuk/cetakan data satu tugas, seperti
  kartu identitas yang memiliki judul, kategori, prioritas, dan status.
- `lib/screens/home_screen.dart` menampilkan daftar. File ini juga menyimpan
  daftar tugas sementara dan mengatur pencarian, filter, perubahan status,
  navigasi form, serta konfirmasi hapus.
- `lib/screens/task_form_screen.dart` menampilkan form. Saat tombol simpan
  ditekan, pemeriksaan judul dijalankan dahulu. Data valid dikirim kembali ke
  halaman utama.
- `lib/widgets/` berisi potongan tampilan yang dipakai ulang: kartu tugas dan
  ringkasan progres.
- `lib/theme/app_theme.dart` menyimpan pengaturan tampilan umum agar warna dan
  bentuk input konsisten.
- `test/widget_test.dart` menguji tampilan utama, validasi form, dan alur
  tambah/edit/filter/toggle/hapus secara otomatis.

### Alur satu tugas

Tekan **Tambah tugas** → isi form → aplikasi memeriksa judul → tekan **Simpan
tugas** → form mengirim data ke halaman utama → tugas muncul pada daftar.
Untuk edit, halaman utama mengirim tugas lama ke form terlebih dahulu. Untuk
hapus, dialog konfirmasi harus disetujui. Filter hanya menyembunyikan tugas
dari tampilan; filter tidak menghapus atau mengubah datanya.

## Struktur project

```text
lib/
  main.dart
  models/study_task.dart
  screens/home_screen.dart
  screens/task_form_screen.dart
  theme/app_theme.dart
  widgets/progress_summary.dart
  widgets/task_card.dart
test/
  widget_test.dart
```

## Catatan penyimpanan dan pengumpulan

Versi ini menyimpan perubahan di memori selama aplikasi berjalan. Data contoh
akan muncul lagi setelah aplikasi dimulai ulang; penyimpanan permanen/database
belum dibuat. Jangan menyebut data sudah tersimpan permanen.

### Keterangan source code untuk UTS

Source code yang tersedia untuk dikumpulkan adalah kondisi project saat ini:
aplikasi gabungan yang sudah memiliki lima fitur inti dan dapat diperiksa
dengan `flutter analyze` serta `flutter test`. Source aplikasinya berada di
folder `lib/`, sedangkan pengujian alurnya berada di `test/`.

Project ini disusun dengan bantuan AI selama percakapan ini. Jadi, jangan
mengklaim bahwa file-file tersebut adalah rekaman atau salinan persis proses
live coding mandiri. Folder starter awal sudah dihapus atas permintaan, maka
versi awal yang mungkin belum selesai tidak lagi tersedia di workspace ini
untuk dilampirkan sebagai source terpisah.

Project ini menggabungkan inti materi P01–P07: dasar Flutter, model Dart,
navigasi, struktur folder, form, widget reusable, dan layout responsif.
Rubrik penilaian tidak ditemukan sebagai lampiran di workspace, sehingga
implementasi ini mengikuti lima kemampuan yang disebutkan pada instruksi.

Lampiran rubrik dan tautan rekaman video belum tersedia di workspace ini.
Rekam demo maksimal 5 menit dan unggah ke layanan yang diminta dosen sebelum
mengisi tautan. Urutan demo yang disarankan:

1. Tambah tugas dengan judul kosong (tunjukkan pesan validasi), lalu isi data
   valid dan simpan.
2. Gunakan filter status/kategori dan pencarian untuk menemukan tugas.
3. Tandai tugas selesai, lalu tunjukkan progres berubah.
4. Edit judul atau detail dan simpan.
5. Hapus tugas, lalu konfirmasi penghapusan.
