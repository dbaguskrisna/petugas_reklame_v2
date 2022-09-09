class ProfileWastibs {
  int id_petugas_wastib;
  String nama_petugas;
  String username;
  String password;
  String status;
  String nomor_handphone;
  String alamat;

  ProfileWastibs(
      {required this.id_petugas_wastib,
      required this.nama_petugas,
      required this.username,
      required this.password,
      required this.status,
      required this.nomor_handphone,
      required this.alamat});

  factory ProfileWastibs.fromJson(Map<String, dynamic> json) {
    return ProfileWastibs(
        id_petugas_wastib: json['id_petugas_wastib'],
        nama_petugas: json['nama_petugas'],
        username: json['username'],
        password: json['password'],
        status: json['status'],
        nomor_handphone: json['nomor_handphone'],
        alamat: json['alamat']);
  }
}
