
import 'package:hive_flutter/hive_flutter.dart';
import '../models/pembacaan_sensor.dart';

class HiveHelper {
  HiveHelper._privateConstructor();

  static final HiveHelper instance =
      HiveHelper._privateConstructor();

  static const String boxName = 'pembacaanSensorBox';

  late Box<PembacaanSensor> pembacaanBox;

  Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PembacaanSensorAdapter());
    }

    pembacaanBox =
        await Hive.openBox<PembacaanSensor>(boxName);
  }

  Future<void> tambahPembacaan(
      PembacaanSensor data) async {
    await pembacaanBox.put(data.id, data);
  }

  List<PembacaanSensor> ambilSemuaPembacaan() {
    final data = pembacaanBox.values.toList();

    data.sort(
      (a, b) => b.waktu.compareTo(a.waktu),
    );

    return data;
  }

  Future<void> ubahPembacaan(
      PembacaanSensor data) async {
    await pembacaanBox.put(data.id, data);
  }

  Future<void> hapusPembacaan(String id) async {
    await pembacaanBox.delete(id);
  }
}
