
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/sensor_cubit.dart';
import 'riwayat_screen.dart';
import 'pengaturan_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nilaiController = TextEditingController();
  final _lokasiController = TextEditingController();

  String jenisSensor = 'Ketinggian Air';

  @override
  void dispose() {
    _nilaiController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }

  Color warnaStatus(String status) {
    switch (status) {
      case 'Siaga':
        return Colors.red;
      case 'Waspada':
        return Colors.orange;
      case 'Aman':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  Future<void> simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    await context.read<SensorCubit>().tambahData(
      jenisSensor: jenisSensor,
      nilai: double.parse(_nilaiController.text),
      lokasiPos: _lokasiController.text.trim(),
    );

    _nilaiController.clear();
    _lokasiController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pembacaan sensor berhasil disimpan'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SensorCubit, SensorState>(
      builder: (context, state) {
        final dataTerbaru = state.daftarSensor.isNotEmpty
            ? state.daftarSensor.first
            : null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Peringatan Dini Bencana'),
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: warnaStatus(state.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      state.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard Sensor',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pantau pembacaan sensor dan status kondisi terkini.',
                ),
                const SizedBox(height: 18),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pembacaan Terbaru',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (dataTerbaru == null)
                          const Text('Belum ada pembacaan sensor.')
                        else ...[
                          Text(
                            dataTerbaru.jenisSensor,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${dataTerbaru.nilai}',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          Text('Lokasi: ${dataTerbaru.lokasiPos}'),
                          Text(
                            'Waktu: ${dataTerbaru.waktu}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Tambah Pembacaan Sensor',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: jenisSensor,
                        decoration: const InputDecoration(
                          labelText: 'Jenis Sensor',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Ketinggian Air',
                            child: Text('Ketinggian Air'),
                          ),
                          DropdownMenuItem(
                            value: 'Pergeseran Tanah',
                            child: Text('Pergeseran Tanah'),
                          ),
                          DropdownMenuItem(
                            value: 'Curah Hujan',
                            child: Text('Curah Hujan'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              jenisSensor = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nilaiController,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Nilai Sensor',
                          hintText: 'Contoh: 65',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nilai sensor wajib diisi';
                          }
                          if (double.tryParse(value) == null ||
                              double.parse(value) < 0) {
                            return 'Masukkan angka yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _lokasiController,
                        decoration: const InputDecoration(
                          labelText: 'Lokasi Pos Pemantauan',
                          hintText: 'Contoh: Pos Sungai A',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Lokasi wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: simpanData,
                          icon: const Icon(Icons.save),
                          label: const Text('Simpan Pembacaan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RiwayatScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.history),
                        label: const Text('Riwayat Sensor'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const PengaturanScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.settings),
                        label: const Text('Pengaturan'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
