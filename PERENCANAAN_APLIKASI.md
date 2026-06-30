# Perencanaan Aplikasi Flutter: Absensi PPKD B6

Berdasarkan struktur dari file Postman Collection yang Anda miliki, berikut adalah rancangan perencanaan (blueprint) untuk membangun aplikasi Flutter Anda.

## 1. Analisis Endpoint API (Fitur Aplikasi)

Dari Postman, kita memiliki 9 endpoints utama yang menentukan fitur-fitur pada aplikasi:

**A. Autentikasi (Auth)**
- `POST /api/register` : Mendaftarkan pengguna baru (Butuh Nama, Email, Password, Jenis Kelamin, Batch ID, Training ID).
- `POST /api/login` : Masuk ke aplikasi dan mendapatkan akses token.

**B. Manajemen Profil (Profile)**
- `GET /api/profile` : Menampilkan data profil user yang sedang login.
- `PUT /api/profile` : Mengubah data profil dasar (nama, email, jenis kelamin, dll).
- `PUT /api/profile/photo` : Mengubah foto profil.

**C. Data Pelatihan & Batch (Public Data)**
- `GET /api/trainings` : Menampilkan daftar seluruh program pelatihan.
- `GET /api/trainings/{id}` : Menampilkan detail dari pelatihan tertentu.
- `GET /api/batches` : Menampilkan daftar angkatan (batch) yang tersedia.

**D. Master Data (Admin/Global)**
- `GET /api/users` : Menampilkan daftar semua pengguna.

---

## 2. Rencana Layar Aplikasi (UI / Screens)

Berdasarkan fitur di atas, aplikasi setidaknya membutuhkan layar-layar berikut:

1. **Splash Screen**: Layar awal saat aplikasi dibuka, berfungsi untuk mengecek apakah user sudah memiliki token (sudah login) atau belum.
2. **Login Screen**: Halaman form login (Email & Password).
3. **Register Screen**: Halaman form registrasi (Input lengkap sesuai payload register).
4. **Main/Dashboard Screen (Bottom Navigation Bar)**:
   - **Tab Home**: Menampilkan daftar *Training* dan *Batch*.
   - **Tab Users**: Menampilkan daftar semua user (bisa dibatasi jika hanya untuk admin).
   - **Tab Profile**: Menampilkan detail profil saat ini.
5. **Training Detail Screen**: Halaman khusus ketika salah satu *Training* di-klik.
6. **Edit Profile Screen**: Halaman form untuk update teks data profil.
7. **Edit Photo Screen/Modal**: Dialog atau halaman khusus untuk upload/ganti foto profil.

---

## 3. Pilihan Teknologi & Packages (`pubspec.yaml`)

Agar pengembangan berjalan lancar dan modern, ini adalah rekomendasi packages (libraries) yang akan digunakan:

- **State Management**: `provider` atau `get` (pilih salah satu, GetX seringkali lebih mudah untuk pemula, namun Provider lebih disarankan secara resmi).
- **HTTP / API Service**: `dio` atau `http`. Rekomendasi: `dio` (lebih mudah menangani token, interceptor, dan upload file).
- **Local Storage**: `shared_preferences` (untuk menyimpan token login agar user tidak perlu login berulang kali).
- **Image Picker**: `image_picker` (untuk mengambil foto profil dari galeri/kamera).
- **Tambahan UI**: 
  - `cached_network_image` (untuk menampilkan foto profil dari URL server).
  - `flutter_spinkit` atau bawaan `CircularProgressIndicator` untuk loading state.

---

## 4. Struktur Folder (Direktori)

Gunakan pendekatan yang terstruktur agar kode rapi (berbasis fitur atau arsitektur standar MVC/MVVM). Berikut contoh struktur *Clean Feature-First*:

```text
lib/
│
├── core/
│   ├── api/          # Konfigurasi Dio/Http dan Base URL
│   ├── theme/        # Konfigurasi warna, fonts, app bar
│   └── constants/    # Teks statis, URL konstan
│
├── data/
│   ├── models/       # Class representasi JSON (User, Training, Batch)
│   └── services/     # Tempat menembak endpoint ke server (AuthService, ProfileService)
│
├── ui/
│   ├── auth/         # LoginScreen, RegisterScreen
│   ├── home/         # HomeScreen, Widget list training
│   ├── profile/      # ProfileScreen, EditProfileScreen
│   └── splash/       # SplashScreen
│
└── main.dart         # Entry point aplikasi
```

---

## 5. Langkah Pengerjaan Berikutnya (Roadmap)

Jika Anda ingin mulai menulis kodenya, kita bisa kerjakan dengan urutan bertahap:

1. **Tahap 1: Setup & Konfigurasi**
   - Menambahkan package di `pubspec.yaml`.
   - Setup Base URL API dan Service Network (`dio`).
   
2. **Tahap 2: Model & Layanan Data (Data Layer)**
   - Membuat model Dart dari JSON Postman (User, Training, Batch).
   - Membuat API service (contoh: fungsi `login`, `register`, `getTrainings`).

3. **Tahap 3: Fitur Autentikasi**
   - Membangun UI Login dan Register.
   - Menyambungkan UI dengan API Service.
   - Menyimpan token login ke `shared_preferences`.

4. **Tahap 4: Dashboard & Profile**
   - Membuat navigasi bawah (Bottom Navigation Bar).
   - Memanggil `GET /api/trainings` di Home.
   - Menampilkan `GET /api/profile` di tab Profile.

5. **Tahap 5: Fitur Lanjutan**
   - Upload Image (Edit Photo).
   - Detail Training & Users List.
