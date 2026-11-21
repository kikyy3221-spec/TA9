
import 'package:hive/hive.dart';

class PembacaanSensor {
  final String id;
  final String jenisSensor;
  final double nilai;
  final String lokasiPos;
  final DateTime waktu;

  PembacaanSensor({
    required this.id,
    required this.jenisSensor,
    required this.nilai,
    required this.lokasiPos,
    required this.waktu,
  });
}

class PembacaanSensorAdapter extends TypeAdapter<PembacaanSensor> {
  @override
  final int typeId = 0;

  @override
  PembacaanSensor read(BinaryReader reader) {
    reader.readByte();

    final id = reader.readString();
    final jenisSensor = reader.readString();
    final nilai = reader.readDouble();
    final lokasiPos = reader.readString();
    final waktu = DateTime.fromMillisecondsSinceEpoch(
      reader.readInt(),
    );

    return PembacaanSensor(
      id: id,
      jenisSensor: jenisSensor,
      nilai: nilai,
      lokasiPos: lokasiPos,
      waktu: waktu,
    );
  }

  @override
  void write(BinaryWriter writer, PembacaanSensor obj) {
    writer
      ..writeByte(5)
      ..writeString(obj.id)
      ..writeString(obj.jenisSensor)
      ..writeDouble(obj.nilai)
      ..writeString(obj.lokasiPos)
      ..writeInt(obj.waktu.millisecondsSinceEpoch);
  }
}
