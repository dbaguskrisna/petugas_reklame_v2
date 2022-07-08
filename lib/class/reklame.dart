import 'dart:convert';

class Reklame {
  int id_reklame;
  int id_jenis_reklame;
  int id_user;
  int id_jenis_produk;
  int id_lokasi_penempatan;
  int id_status_tanah;
  int id_letak_reklame;
  String tahun_pendirian;
  String kecamatan;
  String kelurahan;
  int tahun_pajak;
  String tgl_permohonan;
  int sudut_pandang;
  String nama_jalan;
  int nomor_jalan;
  String detail_lokasi;
  int panjang_reklame;
  int lebar_reklame;
  int luas_reklame;
  int tinggi_reklame;
  String teks;
  String no_formulir;
  int status_pengajuan;
  int status;

  Reklame(
      {required this.id_reklame,
      required this.id_jenis_reklame,
      required this.id_user,
      required this.id_jenis_produk,
      required this.id_lokasi_penempatan,
      required this.id_status_tanah,
      required this.id_letak_reklame,
      required this.tahun_pendirian,
      required this.kecamatan,
      required this.kelurahan,
      required this.tahun_pajak,
      required this.tgl_permohonan,
      required this.sudut_pandang,
      required this.nama_jalan,
      required this.nomor_jalan,
      required this.detail_lokasi,
      required this.panjang_reklame,
      required this.lebar_reklame,
      required this.luas_reklame,
      required this.tinggi_reklame,
      required this.teks,
      required this.no_formulir,
      required this.status_pengajuan,
      required this.status});

  factory Reklame.fromJson(Map<String, dynamic> json) {
    return Reklame(
        id_reklame: json['id_reklame'],
        id_jenis_reklame: json['id_jenis_reklame'],
        id_user: json['id_user'],
        id_jenis_produk: json['id_jenis_produk'],
        id_lokasi_penempatan: json['id_lokasi_penempatan'],
        id_status_tanah: json['id_status_tanah'],
        id_letak_reklame: json['id_letak_reklame'],
        tahun_pendirian: json['tahun_pendirian'],
        kecamatan: json['kecamatan'],
        kelurahan: json['kelurahan'],
        tahun_pajak: json['tahun_pajak'],
        tgl_permohonan: json['tgl_permohonan'],
        sudut_pandang: json['sudut_pandang'],
        nama_jalan: json['nama_jalan'],
        nomor_jalan: json['nomor_jalan'],
        detail_lokasi: json['detail_lokasi'],
        panjang_reklame: json['panjang_reklame'],
        lebar_reklame: json['lebar_reklame'],
        luas_reklame: json['luas_reklame'],
        tinggi_reklame: json['tinggi_reklame'],
        teks: json['teks'],
        no_formulir: json['no_formulir'],
        status_pengajuan: json['status_pengajuan'],
        status: json['status']);
  }
}
