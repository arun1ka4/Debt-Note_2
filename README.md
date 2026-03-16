<h1 align="center"> DebtNote - Pencatat Hutang </h1>

## Dibuat Oleh
Nama: Nayla Lelyanggraheni Hutomo  
Mata Kuliah: Pemrograman Berbasis Web 

---

## ✨Table of Content
- [Deskripsi](#Deskripsi)
- [Fitur](#fitur)
- [Widget yang digunakan](#Widget-yang-Digunakan)
- [UI aplikasi](#UI-Aplikasi)

---

## 📌Deskripsi
Debtnote adalah aplikasi sederhana yang ditujukan bagi pelaku UMKM dengan tujuan mencatat hutang dari pelanggan.

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

## 📱Widget yang Digunakan

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
| `SnackBar` | Notifikasi pesan sukses/gagal |
| `IconButton` | Tombol logout |
| `TextButton.icon` | Tombol edit dan hapus |
| `GestureDetector` | Navigasi ke halaman register/login |

---
## Teknologi yang Digunakan

- **Flutter** — Framework UI
- **Supabase** — Backend as a Service (database & autentikasi)
- **flutter_dotenv** — Menyimpan konfigurasi sensitif di file `.env`
- **intl** — Format tanggal dan mata uang

---

## 🎨UI Aplikasi
