import 'dart:convert';

class Maps {
  int id_history;
  int id_reklame;
  String no_formulir;
  String latitude;
  String longtitude;
  int status;
  String tgl_berlaku_awal;
  String tgl_berlaku_akhir;

  Maps({
    required this.id_history,
    required this.id_reklame,
    required this.no_formulir,
    required this.latitude,
    required this.longtitude,
    required this.status,
    required this.tgl_berlaku_akhir,
    required this.tgl_berlaku_awal,
  });

  factory Maps.fromJson(Map<String, dynamic> json) {
    print(json['latitude']);
    return Maps(
      id_history: json['id_titik_lokasi'],
      id_reklame: json['id_reklame'],
      no_formulir: json['no_formulir'],
      latitude: json['latitude'].toString(),
      longtitude: json['longtitude'].toString(),
      status: json['status'],
      tgl_berlaku_akhir: json['tgl_berlaku_akhir'] == null
          ? "0000-00-00"
          : json['tgl_berlaku_akhir'],
      tgl_berlaku_awal: json['tgl_berlaku_awal'] == null
          ? "0000-00-00"
          : json['tgl_berlaku_awal'],
    );
  }
}
