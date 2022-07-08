import 'dart:convert';

import 'package:flutter/cupertino.dart';

class DataSurveys {
  int id_survey;
  String no_formulir;
  String tahun_pendirian;
  int status;
  int id_petugas;
  String tanggal_survey;
  String berita_acara;
  String gambar;

  DataSurveys(
      {required this.id_survey,
      required this.no_formulir,
      required this.tahun_pendirian,
      required this.status,
      required this.id_petugas,
      required this.tanggal_survey,
      required this.berita_acara,
      required this.gambar});

  factory DataSurveys.fromJson(Map<String, dynamic> json) {
    return DataSurveys(
        id_survey: json['id_survey'],
        no_formulir: json['no_formulir'],
        tahun_pendirian: json['tahun_pendirian'],
        status: json['status'],
        id_petugas: json['id_petugas'],
        tanggal_survey: json['tanggal_survey'],
        berita_acara: json['berita_acara'],
        gambar: json['gambar']);
  }
}
