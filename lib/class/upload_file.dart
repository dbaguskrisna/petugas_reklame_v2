import 'dart:convert';

import 'package:flutter/cupertino.dart';

class UploadFiles {
  int id_upload;
  int id_user;
  int id_reklame;
  int id_berkas;
  String nama_berkas;
  String jenis_berkas;

  UploadFiles(
      {required this.id_upload,
      required this.id_user,
      required this.id_reklame,
      required this.id_berkas,
      required this.nama_berkas,
      required this.jenis_berkas});

  factory UploadFiles.fromJson(Map<String, dynamic> json) {
    return UploadFiles(
        id_upload: json['id_upload'],
        id_user: json['id_user'],
        id_reklame: json['id_reklame'],
        id_berkas: json['id_berkas'],
        nama_berkas:
            json['nama_berkas'] == null ? "kosong" : json['nama_berkas'],
        jenis_berkas: json['jenis_berkas']);
  }
}
