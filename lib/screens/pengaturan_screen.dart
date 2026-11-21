
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/sensor_cubit.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() =>
      _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _waspadaController;
  late final TextEditingController _siagaController;

  @override
  void initState() {
    super.initState();

    final state = context.read<SensorCubit>().state;

    _waspadaController = TextEditingController(
      text: state.batasWaspada.toString(),
    );

    _siagaController = TextEditingController(
      text: state.batasSiaga.toString(),
    );
  }

  @override
  void dispose() {
    _waspadaController.dispose();
    _siagaController.dispose();
    super.dispose();
  }

  Future<void> simpanPengaturan() async {
    if (!_formKey.currentState!.validate()) return;

    final waspada = double.parse(_waspadaController.text);
    final siaga = double.parse(_siagaController.text);

    if (siaga <= waspada) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Batas Siaga harus lebih besar dari batas Waspada',
          ),
        ),
      );
      return;
    }

    await context.read<SensorCubit>().simpanPengaturan(
      waspada: waspada,
      siaga: siaga,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pengaturan berhasil disimpan'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Ambang Batas'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Atur Ambang Batas Status Sensor',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nilai sensor akan dibandingkan dengan ambang batas '
                'berikut untuk menentukan status kondisi.',
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _waspadaController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Batas Waspada',
                  suffixText: 'nilai',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.warning_amber,
                    color: Colors.orange,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      double.tryParse(value) == null ||
                      double.parse(value) < 0) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _siagaController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Batas Siaga',
                  suffixText: 'nilai',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      double.tryParse(value) == null ||
                      double.parse(value) < 0) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: simpanPengaturan,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan Pengaturan'),
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
      ),
    );
  }
}
