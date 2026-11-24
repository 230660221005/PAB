# Panduan Pengerjaan Tugas 14 — Integrasi Project dan Candidate Release

Dokumen ini adalah kerangka pengerjaan mahasiswa, bukan contoh jawaban. Gunakan project yang sama dengan Tugas 1–13.

## 1. Berkas yang Dikumpulkan

```text
tugas-14/
├── ringkasan-integrasi.md
├── checklist-uiux.md
├── catatan-rilis.md
├── skenario-uji-penerima.md
├── bukti-build/
├── README.md
└── refleksi.md
```

Simpan tangkapan layar atau catatan hasil build pada `bukti-build/`. Jangan menyimpan token, kredensial, atau data pribadi.

## 2. Ringkasan Integrasi

Jelaskan alur utama yang sudah digabungkan.

| Bagian | Isi |
|:-------|:----|
| Nama alur | |
| Halaman yang terlibat | |
| Model data yang dipakai | |
| Status yang dipakai | |
| Fitur yang terintegrasi | |
| Batasan yang masih ada | |

Sertakan diagram alur singkat. Tandai data yang berpindah antarhalaman dan `id` yang dipakai untuk membuka detail.

## 3. Checklist UI/UX

| No. | Pemeriksaan | Sebelum | Sesudah | Bukti |
|:---:|:------------|:--------|:--------|:------|
| 1 | Warna dan tipografi dari tema | | | |
| 2 | Hierarki judul, informasi, dan aksi | | | |
| 3 | Tata letak pada lebar 400 piksel | | | |
| 4 | Tata letak pada lebar 900 piksel | | | |
| 5 | Keadaan memuat, kosong, dan gagal | | | |
| 6 | Target sentuh minimal 48 piksel | | | |
| 7 | Label ikon dan kontras teks | | | |

Isi kolom "Sebelum" dan "Sesudah" dengan kondisi nyata, bukan perkiraan.

## 4. Catatan Rilis

| Bagian | Isi |
|:-------|:----|
| Versi | contoh: `1.0.0-rc.1` |
| Tanggal build | |
| Target | web dan emulator Android |
| Fitur utama | |
| Perbaikan pada versi ini | |
| Batasan pengujian | |
| Cara menjalankan | |
| Versi Flutter dan Dart | |

## 5. Skenario Uji Penerima

Buat minimal enam langkah yang dapat dijalankan orang lain tanpa penjelasan tambahan.

| Langkah | Tindakan | Hasil yang diharapkan | Hasil aktual | Status |
|:--------|:---------|:----------------------|:-------------|:------:|
| 1 | Buka aplikasi | | | |
| 2 | | | | |
| 3 | | | | |
| 4 | | | | |
| 5 | | | | |
| 6 | | | | |

## 6. Bukti Build dan Pemeriksaan

- [ ] `flutter pub get` dijalankan.
- [ ] `flutter analyze` dijalankan dan hasilnya dicatat.
- [ ] `flutter test` dijalankan jika test tersedia.
- [ ] Aplikasi dijalankan pada emulator Android.
- [ ] `flutter build apk --release` dijalankan dan hasilnya dicatat.
- [ ] APK dipasang pada emulator dan alur utama diuji kembali.
- [ ] Hasil build dapat dijalankan atau dipasang.
- [ ] Batasan pengujian ditulis apa adanya.

Jika Android SDK atau emulator belum siap, selesaikan instalasi mengikuti [Panduan Lengkap PAB](../panduan/Panduan-Lengkap-PAB.md). Jangan menulis klaim pengujian Android yang belum dijalankan.

## 7. Pemeriksaan Sebelum Pull Request

- [ ] Branch aktif menggunakan NIM mahasiswa.
- [ ] Folder tugas bernama `tugas-14/`.
- [ ] Minimal tiga fitur terintegrasi dalam satu alur.
- [ ] Model data dan status dipakai bersama.
- [ ] Minimal tiga perbaikan UI/UX dicatat.
- [ ] Tata letak diuji pada dua ukuran lebar.
- [ ] Catatan rilis dan skenario uji penerima tersedia.
- [ ] README, refleksi, dan deklarasi AI tersedia.
- [ ] Pull Request dibuat ke `main`.
