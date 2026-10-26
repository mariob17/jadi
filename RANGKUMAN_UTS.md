# Rangkuman UTS — StudyTracker

Mata kuliah: **Pemrograman Perangkat Bergerak**  
Project: **StudyTracker**, aplikasi untuk mencatat dan mengelola tugas belajar.

Dokumen ini menjelaskan project dengan bahasa sederhana. Istilah teknis tetap
dicantumkan agar bisa dipelajari dan disebutkan saat presentasi.

## 1. Gambaran sederhana

Bayangkan StudyTracker seperti buku catatan tugas kuliah di ponsel. Pengguna
bisa menambahkan tugas, mencari dan menyaring daftar, menandai tugas selesai,
mengubah tugas, atau menghapusnya.

Aplikasi ini dibuat menggunakan **Flutter**. Flutter adalah alat untuk
membuat tampilan aplikasi, sedangkan bahasa pemrograman yang digunakan adalah
**Dart**.

## 2. Apa yang bisa dilakukan?

1. **Tambah tugas:** isi nama, lalu tambahkan catatan, kategori, prioritas,
   atau tenggat bila diperlukan.
2. **Validasi:** nama tugas harus diisi dan sedikitnya terdiri dari tiga
   karakter. Jika belum benar, aplikasi memberi pesan dan tidak menyimpan
   form.
3. **Cari dan filter:** cari tugas lewat kata pada nama/catatan, tampilkan
   semua tugas, tugas yang belum selesai, atau tugas selesai, dan pilih
   kategori.
4. **Tandai selesai:** centang kotak pada kartu tugas. Jumlah tugas selesai
   dan progress bar ikut berubah.
5. **Edit:** buka form dari tombol edit, ubah isinya, lalu simpan perubahan.
6. **Hapus:** tekan tombol hapus dan setujui dialog konfirmasi untuk
   menghilangkan tugas.

## 3. Alur aplikasi

### Saat aplikasi dibuka

`main.dart` menjalankan aplikasi Flutter, menerapkan tema, lalu menampilkan
`HomeScreen`. Halaman utama menampilkan contoh tugas, ringkasan progres,
pencarian, filter, dan tombol tambah.

### Saat menambah tugas

1. Pengguna menekan **Tambah tugas**.
2. Halaman utama membuka form `TaskFormScreen`.
3. Pengguna mengisi nama tugas dan pilihan lainnya.
4. Saat **Simpan tugas** ditekan, form memeriksa nama tugas.
5. Jika nama kosong atau terlalu pendek, pesan kesalahan muncul dan data
   belum dikirim.
6. Jika valid, form membentuk objek `StudyTask` dan mengirimkannya kembali ke
   halaman utama.
7. Halaman utama menambahkan tugas itu ke daftar yang sedang ditampilkan.

### Saat mengubah tugas

Halaman utama mengirim tugas yang dipilih ke form edit. Form menampilkan isi
yang lama sebagai nilai awal. Setelah disimpan, halaman utama mengganti tugas
lama dengan hasil perubahan.

### Saat mencari, memfilter, atau menandai selesai

Pencarian dan filter memilih tugas mana yang terlihat di layar; keduanya tidak
menghapus data. Centang selesai mengubah status tugas dan memperbarui
ringkasan progres.

### Saat menghapus tugas

Dialog bertanya apakah pengguna yakin. Jika memilih **Batal**, tugas tetap ada.
Jika memilih **Hapus**, tugas dikeluarkan dari daftar.

## 4. Peta folder dan file

| File/folder | Penjelasan sederhana |
|---|---|
| `lib/main.dart` | Pintu masuk aplikasi: menyalakan aplikasi dan membuka halaman utama. |
| `lib/models/study_task.dart` | Cetakan data tugas: menentukan bahwa tugas punya nama, catatan, kategori, prioritas, tenggat, dan status. |
| `lib/screens/home_screen.dart` | Halaman utama: menyimpan daftar selama aplikasi terbuka dan mengatur tampilan serta aksi pengguna. |
| `lib/screens/task_form_screen.dart` | Halaman form untuk menambah atau mengedit tugas, termasuk pemeriksaan input. |
| `lib/widgets/task_card.dart` | Tampilan satu kartu tugas beserta tombol centang, edit, dan hapus. |
| `lib/widgets/progress_summary.dart` | Ringkasan banyaknya tugas selesai dan progress bar. |
| `lib/theme/app_theme.dart` | Aturan tampilan umum seperti warna, bentuk kartu, dan input. |
| `test/widget_test.dart` | Tes otomatis untuk memeriksa tampilan dan alur fitur. |
| `pubspec.yaml` | Identitas project, versi minimum Flutter/Dart, serta daftar paket yang digunakan. |

## 5. Istilah coding dengan analogi mudah

- **Widget:** bagian tampilan aplikasi. Contohnya tombol, teks, kartu tugas,
  atau satu halaman. Widget dapat disusun seperti balok-balok LEGO.
- **Model:** cetakan yang menentukan data apa saja yang dimiliki sebuah tugas.
  `StudyTask` adalah model untuk satu tugas.
- **State:** data yang dapat berubah ketika aplikasi digunakan, misalnya isi
  daftar, tugas yang selesai, atau filter yang dipilih.
- **`setState`:** cara memberi tahu Flutter bahwa state berubah dan layar perlu
  digambar ulang. Contohnya setelah tugas selesai dicentang.
- **Callback:** pesan dari widget anak kepada halaman induk bahwa pengguna
  melakukan sesuatu. Kartu tugas meminta halaman utama untuk mengubah status
  atau menghapus tugas, bukan mengubah daftar sendiri.
- **`async` dan `await`:** cara menunggu suatu proses yang memerlukan waktu,
  misalnya menunggu halaman form ditutup atau menunggu jawaban dialog.
- **`Navigator.push`:** membuka halaman lain. **`Navigator.pop`:** menutup
  halaman itu dan dapat mengirim hasilnya kembali.
- **Validasi:** pemeriksaan input sebelum data diterima, seperti petugas yang
  memeriksa formulir sudah diisi dengan benar.
- **Responsive layout:** susunan tampilan menyesuaikan lebar layar. Project
  memakai daftar pada layar sempit dan grid/kartu pada layar yang lebih lebar.
- **JSON:** bentuk teks yang umum dipakai untuk mewakili data. Model tugas
  memiliki `toJson` dan `fromJson` untuk mengubah data ke/dari bentuk itu;
  versi aplikasi saat ini belum mengirim data ke server.

## 6. Beberapa bagian kode penting

### Menyalakan aplikasi — `main.dart`

`main()` memanggil `runApp`, yaitu perintah Flutter untuk mulai menggambar
aplikasi. `StudyTrackerApp` menyiapkan `MaterialApp`, tema, dan `HomeScreen`.

### Memeriksa nama — `task_form_screen.dart`

Form memiliki `GlobalKey<FormState>`. Ketika tombol simpan ditekan, method
`_save()` meminta form menjalankan semua validator. Validator mengecek apakah
nama kosong atau kurang dari tiga karakter. Jika ada kesalahan, `_save()`
berhenti. Jika lolos, form membuat `StudyTask` dan mengirimkannya dengan
`Navigator.pop(context, task)`.

### Mengembalikan hasil form — `home_screen.dart`

Method `_openForm()` membuka halaman form menggunakan `Navigator.push` dan
menunggu hasilnya dengan `await`. Setelah form ditutup, hasil yang valid
ditambahkan ke daftar atau dipakai untuk mengganti tugas lama.

### Mengubah daftar dan layar — `setState`

Method seperti `_toggleTask()` dan `_deleteTask()` mengubah daftar tugas di
halaman utama. Perubahan dilakukan di dalam `setState`, supaya Flutter tahu
layar perlu diperbarui.

### Memilih tugas yang terlihat — `_visibleTasks`

`_visibleTasks` membandingkan setiap tugas dengan status filter, kategori, dan
kata pencarian. Hanya tugas yang cocok yang ditampilkan. Daftar aslinya tetap
ada, jadi mengganti filter tidak menghapus tugas.

### Meminta konfirmasi — `_deleteTask()`

`_deleteTask()` menampilkan dialog dan menunggu pilihan pengguna. Daftar hanya
diubah jika pengguna menyetujui penghapusan.

## 7. Metode dan susunan project

Project memakai pemisahan tanggung jawab (*separation of concerns*):

- **Model** mengurus bentuk data.
- **Screen** mengurus halaman dan alur interaksi.
- **Widget** mengurus bagian tampilan yang bisa dipakai ulang.
- **Theme** mengurus gaya visual bersama.
- **Test** memeriksa perilaku agar perubahan tidak mudah merusak fitur.

Pemisahan ini membantu pembaca mencari kode. Contoh: aturan nama tugas ada di
form, sedangkan bentuk data tugas ada di model.

Daftar tugas saat ini hanya disimpan di memori. Artinya, tugas yang dibuat saat
aplikasi dibuka akan hilang ketika aplikasi dimulai ulang. Database atau
penyimpanan permanen belum dibuat. Fitur JSON pada model hanya menunjukkan
cara mengubah bentuk data, bukan berarti aplikasi sudah memakai database atau
server.

## 8. Cara menjalankan dan menguji

Buka terminal pada folder project ini, lalu jalankan:

```powershell
flutter pub get
flutter run -d chrome
```

Untuk pemeriksaan:

```powershell
flutter analyze
flutter test
```

`flutter analyze` memeriksa potensi masalah dalam kode. `flutter test`
menjalankan tes otomatis. Tes yang tersedia memeriksa halaman utama, validasi
nama kosong, serta rangkaian tambah, edit, filter, toggle selesai, dan hapus.

## 9. Contoh ringkasan untuk presentasi

> “Project saya bernama StudyTracker, aplikasi Flutter untuk mencatat tugas
> belajar. Aplikasi memiliki form dengan validasi nama minimal tiga karakter,
> pencarian dan filter tugas, penanda selesai dengan ringkasan progres, fitur
> edit, dan hapus dengan konfirmasi. Saya memisahkan kode menjadi model untuk
> data, screen untuk halaman, widget untuk bagian tampilan, theme untuk gaya,
> dan test untuk memeriksa alurnya. Saat ini data masih disimpan sementara di
> memori, jadi belum tersimpan setelah aplikasi ditutup.”

Project ini disusun dengan bantuan AI; sesuaikan penjelasan presentasi dengan
pemahaman dan pengalaman menjalankan aplikasinya sendiri. Lampiran rubrik dan
video demo yang sudah diunggah belum tersedia di workspace.
