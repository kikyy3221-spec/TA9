
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/sensor_cubit.dart';
import '../models/pembacaan_sensor.dart';
import '../widgets/sensor_card.dart';

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  // Fungsi untuk mengedit data sensor
  void _editData(
    BuildContext context,
    PembacaanSensor sensor,
  ) {
    final controller = TextEditingController(
      text: sensor.nilai.toString(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Pembacaan Sensor'),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Nilai Sensor',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                controller.dispose();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nilaiBaru = double.tryParse(
                  controller.text,
                );

                if (nilaiBaru == null || nilaiBaru < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Masukkan nilai sensor yang valid!',
                      ),
                    ),
                  );
                  return;
                }

                final dataBaru = PembacaanSensor(
                  id: sensor.id,
                  jenisSensor: sensor.jenisSensor,
                  nilai: nilaiBaru,
                  lokasiPos: sensor.lokasiPos,
                  waktu: sensor.waktu,
                );

                await context
                    .read<SensorCubit>()
                    .ubahData(dataBaru);

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }

                controller.dispose();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus data sensor
  void _hapusData(
    BuildContext context,
    PembacaanSensor sensor,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Data'),
          content: const Text(
            'Apakah Anda yakin ingin menghapus data sensor ini?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await context
                    .read<SensorCubit>()
                    .hapusData(sensor.id);

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Sensor'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      body: BlocBuilder<SensorCubit, SensorState>(
        builder: (context, state) {
          final daftarSensor = state.daftarSensor;

          // Tampilan ketika belum ada data
          if (daftarSensor.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada riwayat pembacaan sensor',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          // Menampilkan daftar riwayat sensor
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: daftarSensor.length,
            itemBuilder: (context, index) {
              final sensor = daftarSensor[index];

              return SensorCard(
                sensor: sensor,
                onEdit: () {
                  _editData(context, sensor);
                },
                onDelete: () {
                  _hapusData(context, sensor);
                },
              );
            },
          );
        },
      ),
    );
  }
}
