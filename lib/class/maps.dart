import 'dart:convert';

class Maps {
  int id_history;
  int id_reklame;
  String no_formulir;
  String latitude;
  String longtitude;
  int status;

  Maps(
      {required this.id_history,
      required this.id_reklame,
      required this.no_formulir,
      required this.latitude,
      required this.longtitude,
      required this.status});

  factory Maps.fromJson(Map<String, dynamic> json) {
    print(json['latitude']);
    return Maps(
        id_history: json['id_history_xy'],
        id_reklame: json['id_reklame'],
        no_formulir: json['no_formulir'],
        latitude: json['latitude'].toString(),
        longtitude: json['longtitude'].toString(),
        status: json['status']);
  }
}
