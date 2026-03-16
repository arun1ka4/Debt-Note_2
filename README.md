<h1 align="center"> DebtNote - Pencatat Hutang </h1>

## Dibuat Oleh
Nama: Nayla Lelyanggraheni Hutomo  
Mata Kuliah: Pemrograman Berbasis Web 

---

## ✨Table of Content
- [Deskripsi](#Deskripsi) 
- [Teknologi](#Teknologi)
- [Struktur Project](#Struktur-Project)
- [Struktur Database](#Struktur-Database)
- [Fitur](#fitur)
- [Widget](#Widget)
- [UI aplikasi](#UI-Aplikasi)

---

## 📌Deskripsi
Debtnote adalah aplikasi sederhana yang ditujukan bagi pelaku UMKM dengan tujuan mencatat hutang dari pelanggan.

---

## 🛠️Teknologi

- **Flutter** — Framework UI
- **Supabase** — Backend as a Service (database & autentikasi)
- **flutter_dotenv** — Menyimpan konfigurasi sensitif di file `.env`
- **intl** — Format tanggal dan mata uang

---

## 🗃️Struktur Project
```
lib/
├── models/
│   └── debt_model.dart
├── pages/
│   ├── login_page.dart
│   ├── register_page.dart
│   ├── home_page.dart
│   └── form_page.dart
└── main.dart
```

---


## 📂Struktur Database

### Tabel `users`
| Kolom | Tipe | Keterangan |
|---|---|---|
| id | int8 | Primary key |
| auth_id | uuid | Relasi ke Supabase Auth |
| nama_usaha | text | Nama usaha pengguna |

### Tabel `debt`
| Kolom | Tipe | Keterangan |
|---|---|---|
| id | int8 | Primary key |
| user_id | int8 | Foreign key ke tabel users |
| nama | text | Nama penghutang |
| jumlah | int8 | Jumlah hutang |
| tanggal_hutang | date | Tanggal hutang dibuat |
| tanggal_jatuh_tempo | date | Tanggal jatuh tempo hutang |

---

## ⚙️Fitur

| Fitur | Deskripsi |
|:---------:|---------|
| Register | User dapat membuat akun di mana email tidak boleh sama |
| Login | User dapat masuk mengakses aplikasi dengan login |
| Total Hutang | Menampilkan total nominal hutang seluruh pelanggan |
| Create | Menambah data hutang baru terdiri dari nama penghutang, jumlah hutang, tanggal hutang dan jatuh tempo |
| Read | Menampilkan data hutang dalam bentuk daftar |
| Update | Mengubah data hutang dengan menekan salah satu data lalu klik tombol edit |
| Delete | Menghapus data hutang dengan menekan salah satu data lalu klik tombol delete |

---

## 📱Widget

| Widget | Kegunaan |
|---|---|
| `Scaffold` | Struktur dasar halaman |
| `AppBar` | Bar navigasi atas |
| `ListView.builder` | Menampilkan daftar hutang secara dinamis |
| `Card` | Tampilan item hutang |
| `InkWell` | Efek ripple saat card ditekan |
| `FloatingActionButton` | Tombol tambah hutang |
| `TextFormField` | Input form (nama, jumlah, tanggal) |
| `Form` | Wrapper validasi form |
| `ElevatedButton` | Tombol simpan dan login/register |
| `Container` | Layout dan styling summary card |
| `Column` & `Row` | Susunan widget secara vertikal dan horizontal |
| `SingleChildScrollView` | Scroll pada halaman form |
| `CircularProgressIndicator` | Indikator loading |
| `SnackBar` | Notifikasi pesan berhasil/gagal |
| `IconButton` | Tombol logout |
| `TextButton.icon` | Tombol edit dan hapus |
| `GestureDetector` | Navigasi ke halaman register/login |

---

## 🎨UI Aplikasi

### Login Page

<img width="400" height="auto" alt="Image" src="https://github.com/user-attachments/assets/e7d149b9-2b23-4c6b-83c5-da5ea7821374" />

### Register Page

<img width="400" height="auto" alt="Image" src="https://github.com/user-attachments/assets/2c3d628c-fa6b-4a53-bab0-80edc798fbf7" />

### Home Page

<img width="400" height="auto" alt="Image" src="https://github.com/user-attachments/assets/4358ad97-bf45-4c65-baed-65139e2a98be" />

### Form Page

<img width="400" height="auto" alt="Image" src="https://github.com/user-attachments/assets/27eb7305-8e05-4531-8cc6-67f220d6ec8a" />

<img width="400" height="auto" alt="Image" src="https://github.com/user-attachments/assets/f652be75-23ae-44ff-9d93-132fac5c1d0f" />
