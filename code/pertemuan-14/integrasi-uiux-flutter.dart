// ============================================================================
// PAB — Pertemuan 14: Integrasi Project dan Penyempurnaan UI/UX — Demo
// ============================================================================
//
// Tujuan:
//   Menunjukkan alur terintegrasi, tema yang konsisten, tata letak responsif,
//   dan keadaan antarmuka (memuat, kosong, gagal, dan berhasil).
//
// Cara menjalankan:
//   flutter pub get
//   flutter analyze
//   flutter run -d chrome
//   flutter run -d <id_perangkat>    (emulator Android)
//
// Catatan:
//   Data demo disimpan di memori. Ganti LayananPengajuan dengan service project
//   Anda tanpa mengubah struktur halaman.
// ============================================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiPengajuan());
}

/// Status satu pengajuan ruang.
enum StatusPengajuan {
  menunggu('Menunggu'),
  disetujui('Disetujui'),
  ditolak('Ditolak');

  const StatusPengajuan(this.label);

  final String label;
}

/// Model data pengajuan ruang.
class Pengajuan {
  const Pengajuan({
    required this.id,
    required this.judul,
    required this.ruang,
    required this.status,
  });

  final String id;
  final String judul;
  final String ruang;
  final StatusPengajuan status;
}

/// Sumber data demo yang meniru service pada project.
class LayananPengajuan {
  /// Mengambil daftar pengajuan dengan penundaan singkat.
  Future<List<Pengajuan>> ambilDaftar() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const [
      Pengajuan(
        id: 'PGJ-01',
        judul: 'Rapat koordinasi akademik',
        ruang: 'R-201',
        status: StatusPengajuan.menunggu,
      ),
      Pengajuan(
        id: 'PGJ-02',
        judul: 'Seminar proposal',
        ruang: 'Aula',
        status: StatusPengajuan.disetujui,
      ),
      Pengajuan(
        id: 'PGJ-03',
        judul: 'Latihan presentasi',
        ruang: 'R-105',
        status: StatusPengajuan.ditolak,
      ),
    ];
  }
}

/// Aplikasi demo yang menyediakan tema dan halaman daftar.
class AplikasiPengajuan extends StatelessWidget {
  const AplikasiPengajuan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Candidate Release',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const HalamanDaftarPengajuan(),
    );
  }
}

/// Halaman daftar yang menggabungkan filter, daftar, dan ringkasan rilis.
class HalamanDaftarPengajuan extends StatefulWidget {
  const HalamanDaftarPengajuan({super.key});

  @override
  State<HalamanDaftarPengajuan> createState() => _HalamanDaftarPengajuanState();
}

class _HalamanDaftarPengajuanState extends State<HalamanDaftarPengajuan> {
  final LayananPengajuan _layanan = LayananPengajuan();
  List<Pengajuan> _daftar = const <Pengajuan>[];
  StatusPengajuan? _filter;
  bool _memuat = true;
  String? _pesanError;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  /// Memuat daftar dan menampilkan pesan bila permintaan gagal.
  Future<void> _muatData() async {
    setState(() {
      _memuat = true;
      _pesanError = null;
    });
    try {
      final hasil = await _layanan.ambilDaftar();
      if (!mounted) return;
      setState(() {
        _daftar = hasil;
        _memuat = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _pesanError = 'Daftar pengajuan belum dapat dimuat. Periksa koneksi lalu coba lagi.';
        _memuat = false;
      });
    }
  }

  /// Mengembalikan daftar sesuai filter yang dipilih.
  List<Pengajuan> get _daftarTampil {
    final filter = _filter;
    if (filter == null) return _daftar;
    return _daftar.where((item) => item.status == filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengajuan Ruang'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang daftar',
            onPressed: _muatData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final duaKolom = constraints.maxWidth >= 720;
            final panel = _bangunPanelFilter();
            final isi = _bangunIsi();

            if (!duaKolom) {
              return ListView(
                key: const Key('tata-letak-satu-kolom'),
                padding: const EdgeInsets.all(16),
                children: [
                  panel,
                  const SizedBox(height: 16),
                  isi,
                  const SizedBox(height: 16),
                  const KartuRilis(),
                ],
              );
            }

            return Row(
              key: const Key('tata-letak-dua-kolom'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        panel,
                        const SizedBox(height: 16),
                        const KartuRilis(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: isi,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _bangunPanelFilter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('Semua'),
                  selected: _filter == null,
                  onSelected: (_) => setState(() => _filter = null),
                ),
                for (final status in StatusPengajuan.values)
                  FilterChip(
                    label: Text(status.label),
                    selected: _filter == status,
                    onSelected: (_) => setState(() => _filter = status),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bangunIsi() {
    if (_memuat) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Memuat pengajuan...'),
            ],
          ),
        ),
      );
    }

    final pesanError = _pesanError;
    if (pesanError != null) {
      return KartuPesan(
        icon: Icons.cloud_off,
        judul: 'Data belum tersedia',
        pesan: pesanError,
        labelAksi: 'Coba lagi',
        onAksi: _muatData,
      );
    }

    final data = _daftarTampil;
    if (data.isEmpty) {
      return KartuPesan(
        icon: Icons.inbox_outlined,
        judul: 'Belum ada pengajuan',
        pesan:
            'Ubah filter atau tambahkan pengajuan baru untuk melihat daftar.',
        labelAksi: 'Tampilkan semua',
        onAksi: () => setState(() => _filter = null),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${data.length} pengajuan ditampilkan',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        for (final item in data) ...[
          KartuPengajuan(pengajuan: item, onTap: () => _bukaDetail(item)),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  void _bukaDetail(Pengajuan pengajuan) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => HalamanDetailPengajuan(pengajuan: pengajuan),
      ),
    );
  }
}

/// Kartu pengajuan pada daftar.
class KartuPengajuan extends StatelessWidget {
  const KartuPengajuan({
    super.key,
    required this.pengajuan,
    required this.onTap,
  });

  final Pengajuan pengajuan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Text(pengajuan.id.substring(pengajuan.id.length - 2)),
        ),
        title: Text(pengajuan.judul),
        subtitle: Text('${pengajuan.id} • Ruang ${pengajuan.ruang}'),
        trailing: LabelStatus(status: pengajuan.status),
      ),
    );
  }
}

/// Label status yang memakai warna dari tema aplikasi.
class LabelStatus extends StatelessWidget {
  const LabelStatus({super.key, required this.status});

  final StatusPengajuan status;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final (Color latar, Color teks) = switch (status) {
      StatusPengajuan.menunggu => (
        skema.secondaryContainer,
        skema.onSecondaryContainer,
      ),
      StatusPengajuan.disetujui => (
        skema.primaryContainer,
        skema.onPrimaryContainer,
      ),
      StatusPengajuan.ditolak => (skema.errorContainer, skema.onErrorContainer),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: latar,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(status.label, style: TextStyle(color: teks, fontSize: 12)),
    );
  }
}

/// Kartu informasi versi candidate release.
class KartuRilis extends StatelessWidget {
  const KartuRilis({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ringkasan rilis', style: tema.textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text('Versi 1.0.0-rc.1'),
            const SizedBox(height: 4),
            const Text(
              'Alur utama terintegrasi; verifikasi mencakup web dan emulator Android.',
            ),
            const SizedBox(height: 8),
            Text(
              'Target: web dan Android • Status: candidate release',
              style: tema.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu pesan untuk keadaan kosong atau gagal memuat data.
class KartuPesan extends StatelessWidget {
  const KartuPesan({
    super.key,
    required this.icon,
    required this.judul,
    required this.pesan,
    required this.labelAksi,
    required this.onAksi,
  });

  final IconData icon;
  final String judul;
  final String pesan;
  final String labelAksi;
  final VoidCallback onAksi;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 12),
            Text(judul, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(pesan, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onAksi, child: Text(labelAksi)),
          ],
        ),
      ),
    );
  }
}

/// Halaman detail yang tetap terbaca pada lebar jendela sempit maupun lebar.
class HalamanDetailPengajuan extends StatelessWidget {
  const HalamanDetailPengajuan({super.key, required this.pengajuan});

  final Pengajuan pengajuan;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pengajuan')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(pengajuan.judul, style: tema.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: LabelStatus(status: pengajuan.status),
                ),
                const SizedBox(height: 16),
                BarisInformasi(label: 'ID pengajuan', nilai: pengajuan.id),
                BarisInformasi(label: 'Ruang', nilai: pengajuan.ruang),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pengingat dikirim ke pemohon.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: const Text('Kirim pengingat'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Baris pasangan label dan nilai pada halaman detail.
class BarisInformasi extends StatelessWidget {
  const BarisInformasi({super.key, required this.label, required this.nilai});

  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(nilai)),
        ],
      ),
    );
  }
}
