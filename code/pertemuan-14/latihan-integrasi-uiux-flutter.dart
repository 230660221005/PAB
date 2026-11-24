// ============================================================================
// PAB — Pertemuan 14: Latihan Integrasi dan UI/UX — TODO
// ============================================================================
//
// Tujuan:
//   Melatih tata letak responsif, konsistensi tema, keadaan antarmuka, dan
//   penyusunan checklist candidate release.
//
// Cara menjalankan:
//   flutter pub get
//   flutter analyze
//   flutter run -d chrome
//   flutter run -d <id_perangkat>    (emulator Android)
//
// TODO:
//   1. Tentukan dua kolom ketika lebar tersedia minimal 720 piksel.
//   2. Saring checklist berdasarkan kategori yang dipilih.
//   3. Perbarui status item melalui setState tanpa mengubah data awal.
//   4. Ganti warna tetap dengan warna dari ColorScheme.
//   5. Tampilkan ringkasan jumlah item selesai dan belum selesai.
// ============================================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiLatihan());
}

/// Item checklist kesiapan rilis.
class ItemRilis {
  const ItemRilis({
    required this.judul,
    required this.kategori,
    this.selesai = false,
  });

  final String judul;
  final String kategori;
  final bool selesai;

  /// Mengembalikan salinan item dengan status selesai yang diperbarui.
  ItemRilis denganStatus(bool nilaiBaru) {
    return ItemRilis(judul: judul, kategori: kategori, selesai: nilaiBaru);
  }
}

/// Aplikasi latihan yang menyediakan tema dan halaman checklist.
class AplikasiLatihan extends StatelessWidget {
  const AplikasiLatihan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latihan Candidate Release',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HalamanLatihan(),
    );
  }
}

/// Halaman latihan yang menampilkan checklist candidate release.
class HalamanLatihan extends StatefulWidget {
  const HalamanLatihan({super.key});

  @override
  State<HalamanLatihan> createState() => _HalamanLatihanState();
}

class _HalamanLatihanState extends State<HalamanLatihan> {
  final List<ItemRilis> _items = [
    const ItemRilis(
      judul: 'Alur utama dapat dijalankan dari awal sampai akhir',
      kategori: 'Integrasi',
      selesai: true,
    ),
    const ItemRilis(
      judul: 'Model data dipakai bersama oleh semua halaman',
      kategori: 'Integrasi',
    ),
    const ItemRilis(
      judul: 'Warna dan tipografi berasal dari tema aplikasi',
      kategori: 'UI/UX',
    ),
    const ItemRilis(
      judul: 'Tata letak diuji pada jendela sempit dan lebar untuk memastikan konten tidak terpotong',
      kategori: 'UI/UX',
    ),
    const ItemRilis(
      judul: 'Keadaan memuat, kosong, dan gagal tersedia',
      kategori: 'UI/UX',
      selesai: true,
    ),
    const ItemRilis(
      judul: 'Target sentuh minimal 48 x 48 piksel',
      kategori: 'Aksesibilitas',
    ),
    const ItemRilis(
      judul: 'Catatan rilis memuat versi dan batasan pengujian',
      kategori: 'Rilis',
    ),
  ];

  String _kategori = 'Semua';

  /// Mengembalikan item sesuai kategori yang dipilih.
  List<ItemRilis> get _itemTampil {
    // TODO 2: Saring item berdasarkan _kategori.
    return _items;
  }

  /// Menghitung jumlah item yang sudah selesai.
  int get _jumlahSelesai {
    // TODO 5: Hitung item dengan status selesai.
    return 0;
  }

  /// Mengubah status satu item tanpa mengubah objek lain.
  void _ubahStatus(ItemRilis item) {
    // TODO 3: Cari posisi item pada _items, lalu ganti dengan salinan
    // yang statusnya dibalik melalui method denganStatus.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checklist Candidate Release')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final duaKolom = _tentukanDuaKolom(constraints.maxWidth);
            return duaKolom ? _bangunDuaKolom() : _bangunSatuKolom();
          },
        ),
      ),
    );
  }

  /// TODO 1: Kembalikan `true` ketika lebar minimal 720 piksel.
  bool _tentukanDuaKolom(double lebar) {
    return false;
  }

  Widget _bangunSatuKolom() {
    return ListView(
      key: const Key('latihan-satu-kolom'),
      padding: const EdgeInsets.all(16),
      children: [
        _bangunPanelKategori(),
        const SizedBox(height: 16),
        _bangunProgres(),
        const SizedBox(height: 16),
        _bangunChecklist(),
      ],
    );
  }

  Widget _bangunDuaKolom() {
    return Row(
      key: const Key('latihan-dua-kolom'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 280,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _bangunPanelKategori(),
                const SizedBox(height: 16),
                _bangunProgres(),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _bangunChecklist(),
          ),
        ),
      ],
    );
  }

  Widget _bangunPanelKategori() {
    const kategori = ['Semua', 'Integrasi', 'UI/UX', 'Aksesibilitas', 'Rilis'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kategori', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final nama in kategori)
                  FilterChip(
                    label: Text(nama),
                    selected: _kategori == nama,
                    onSelected: (_) => setState(() => _kategori = nama),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bangunProgres() {
    final total = _items.length;
    final selesai = _jumlahSelesai;
    final nilai = total == 0 ? 0.0 : selesai / total;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progres rilis',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            // TODO 4: Ganti Colors.teal dengan warna dari ColorScheme.
            LinearProgressIndicator(value: nilai, color: Colors.teal),
            const SizedBox(height: 8),
            Text('$selesai dari $total item selesai'),
          ],
        ),
      ),
    );
  }

  Widget _bangunChecklist() {
    final data = _itemTampil;
    if (data.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Belum ada item pada kategori ini.'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < data.length; i++)
          Card(
            child: CheckboxListTile(
              value: data[i].selesai,
              onChanged: (_) => _ubahStatus(data[i]),
              title: Text(data[i].judul),
              subtitle: Text(data[i].kategori),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
      ],
    );
  }
}
