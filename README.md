# SpaceNews Core - Advanced International News Portal

Aplikasi Flutter berita antariksa internasional, dibuat sesuai spesifikasi tugas remedial PAB.

## Fitur Utama
- Splash Screen dengan delay 3 detik + session check (SharedPreferences)
- Autentikasi: Register, Login, Forgot Password (Firebase Authentication)
- Welcome Page setelah registrasi
- Home Page dengan BottomNavigationBar 4 menu: Home, Favorite, Notification, Profile
- Dashboard: Headline banner + feed berita dari Spaceflight News API
- Detail Page artikel dengan tombol Favorite (tersimpan ke Firebase Firestore collection `favorites`)
- Halaman Favorite realtime dari Firestore
- Halaman Notifikasi (membaca collection `notifications`)
- Halaman Profile dinamis dari Firestore + Log Out (clear session + sign out + reset navigasi)

## Struktur Project
```
lib/
 ├─ main.dart
 ├─ firebase_options.dart       # WAJIB diganti via flutterfire configure
 ├─ models/
 │   └─ article.dart
 ├─ services/
 │   ├─ api_service.dart        # Konsumsi REST API Spaceflight News
 │   ├─ auth_service.dart       # Firebase Authentication
 │   ├─ firestore_service.dart  # Firestore (favorites, profile, notifications)
 │   └─ local_storage_service.dart  # SharedPreferences (session)
 ├─ screens/
 │   ├─ splash_screen.dart
 │   ├─ register_screen.dart        # Halaman Daftar
 │   ├─ login_screen.dart
 │   ├─ forgot_password_screen.dart
 │   ├─ welcome_screen.dart
 │   ├─ home_screen.dart            # Scaffold + BottomNavigationBar
 │   ├─ dashboard_tab.dart          # Isi tab Home
 │   ├─ detail_screen.dart
 │   ├─ favorite_screen.dart
 │   ├─ notification_screen.dart
 │   └─ profile_screen.dart
 └─ widgets/
     └─ news_card.dart
```

## Cara Menjalankan

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Setup Firebase (WAJIB)
Project ini membutuhkan Firebase project Anda sendiri (Authentication + Firestore aktif).

1. Buat project di [Firebase Console](https://console.firebase.google.com)
2. Aktifkan **Authentication > Sign-in method > Email/Password**
3. Aktifkan **Firestore Database** (mode test/production sesuai kebutuhan)
4. Install FlutterFire CLI lalu jalankan konfigurasi otomatis:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   Perintah ini akan otomatis membuat ulang `lib/firebase_options.dart`,
   `android/app/google-services.json`, dan `ios/Runner/GoogleService-Info.plist`
   sesuai project Firebase yang Anda pilih.

5. (Karena project minimal ini belum menyertakan folder `android/` dan `ios/` native,
   generate dahulu dengan `flutter create .` di root folder ini sebelum
   menjalankan `flutterfire configure`, agar platform folder tersedia.)

### 3. Firestore Security Rules (contoh dasar untuk development)
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /favorites/{docId} {
      allow read, write: if request.auth != null;
    }
    match /notifications/{docId} {
      allow read: if true;
      allow write: if false; // isi manual via Firebase Console untuk demo
    }
  }
}
```

### 4. Jalankan aplikasi
```bash
flutter run
```

## Catatan Pengerjaan Sesuai Ketentuan Soal
- Logo aplikasi: ganti ikon roket di `splash_screen.dart`, `register_screen.dart`,
  dan `login_screen.dart` dengan gambar logo dari Freepik (keyword "E-Commerce")
  sesuai instruksi soal — taruh file di `assets/images/logo.png` lalu update widget
  `Image.asset('assets/images/logo.png')`.
- Endpoint REST API yang digunakan: `https://api.spaceflightnewsapi.net/v4/articles/?limit=20`
- Backend: Firebase Authentication, Firebase Firestore, SharedPreferences (local storage)
- Setelah selesai, upload source code ke GitHub lalu kirimkan link-nya sesuai instruksi
  pengumpulan pada soal.

## Dependencies Utama
- firebase_core, firebase_auth, cloud_firestore
- shared_preferences
- http
- cached_network_image, intl
