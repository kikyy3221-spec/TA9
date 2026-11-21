
import 'package:shared_preferences/shared_preferences.dart';

class PengaturanHelper {
  static const String keyWaspada = 'batas_waspada';
  static const String keySiaga = 'batas_siaga';

  static Future<double> ambilBatasWaspada() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(keyWaspada) ?? 50.0;
  }

  static Future<double> ambilBatasSiaga() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(keySiaga) ?? 80.0;
  }

  static Future<void> simpanAmbangBatas(
    double waspada,
    double siaga,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(keyWaspada, waspada);
    await prefs.setDouble(keySiaga, siaga);
  }
}
