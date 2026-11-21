
import 'package:flutter_bloc/flutter_bloc.dart';

import '../helpers/hive_helper.dart';
import '../helpers/pengaturan_helper.dart';
import '../models/pembacaan_sensor.dart';

class SensorState {
  final List<PembacaanSensor> daftarSensor;
  final double batasWaspada;
  final double batasSiaga;

  const SensorState({
    this.daftarSensor = const [],
    this.batasWaspada = 50.0,
    this.batasSiaga = 80.0,
  });

  String get status {
    if (daftarSensor.isEmpty) {
      return 'Belum Ada Data';
    }

    final nilaiTerbaru = daftarSensor.first.nilai;

    if (nilaiTerbaru >= batasSiaga) {
      return 'Siaga';
    } else if (nilaiTerbaru >= batasWaspada) {
      return 'Waspada';
    }

    return 'Aman';
  }

  SensorState copyWith({
    List<PembacaanSensor>? daftarSensor,
    double? batasWaspada,
    double? batasSiaga,
  }) {
    return SensorState(
      daftarSensor: daftarSensor ?? this.daftarSensor,
      batasWaspada: batasWaspada ?? this.batasWaspada,
      batasSiaga: batasSiaga ?? this.batasSiaga,
    );
  }
}

class SensorCubit extends Cubit<SensorState> {
  SensorCubit() : super(const SensorState());

  Future<void> muatData() async {
    final data = HiveHelper.instance.ambilSemuaPembacaan();

    final waspada =
        await PengaturanHelper.ambilBatasWaspada();

    final siaga =
        await PengaturanHelper.ambilBatasSiaga();

    emit(
      state.copyWith(
        daftarSensor: data,
        batasWaspada: waspada,
        batasSiaga: siaga,
      ),
    );
  }

  // Menambahkan pembacaan sensor
  Future<void> tambahData({
    required String jenisSensor,
    required double nilai,
    required String lokasiPos,
  }) async {
    final data = PembacaanSensor(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      jenisSensor: jenisSensor,
      nilai: nilai,
      lokasiPos: lokasiPos,
      waktu: DateTime.now(),
    );

    await HiveHelper.instance.tambahPembacaan(data);
    await muatData();
  }

  // Mengubah pembacaan sensor
  Future<void> ubahData(PembacaanSensor data) async {
    await HiveHelper.instance.ubahPembacaan(data);
    await muatData();
  }

  // Menghapus pembacaan sensor
  Future<void> hapusData(String id) async {
    await HiveHelper.instance.hapusPembacaan(id);
    await muatData();
  }

  // Menyimpan pengaturan ambang batas
  Future<void> simpanPengaturan({
    required double waspada,
    required double siaga,
  }) async {
    await PengaturanHelper.simpanAmbangBatas(
      waspada,
      siaga,
    );

    await muatData();
  }
}
