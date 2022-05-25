class Kecamatan {
  final int id_kecamatan;
  final String nama_kecamatan;

  Kecamatan({required this.id_kecamatan, required this.nama_kecamatan});

  factory Kecamatan.fromJson(Map<String, dynamic> json) {
    return Kecamatan(
      id_kecamatan: json['id_kecamatan'],
      nama_kecamatan: json['nama_kecamatan'],
    );
  }
}
