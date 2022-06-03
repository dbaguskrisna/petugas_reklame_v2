import 'package:flutter/material.dart';

class LihatDetailBerkasDicabut extends StatefulWidget {
  final int reklame_id;
  const LihatDetailBerkasDicabut({Key? key, required this.reklame_id})
      : super(key: key);

  @override
  State<LihatDetailBerkasDicabut> createState() =>
      _LihatDetailBerkasDicabutState();
}

class _LihatDetailBerkasDicabutState extends State<LihatDetailBerkasDicabut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reklame Dicabut"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Data Pemohon',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nama Pemohon : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Alamat : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nomor Telp : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nama Perusahaan : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Alamat : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'NPWPD : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Form Detail Titik Reklame',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nama Jalan : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nomor Jalan : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'RT : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'RW : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tahun Pendirian : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kecamatan : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kelurahan : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Detail Lokasi : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Data Objek Reklame',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tahun Pajak : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tanggal Permohonan : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Jenis Reklame : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Jenis Produk : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Lokasi Penempatan : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Status Tanah : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Letak Reklame : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Atribut Reklame Lainnya',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sudut Pandang Reklame : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Panjang Reklame : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Lebar Reklame : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Luas Reklame : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tinggi Reklame : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Teks Reklame : ',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Berkas Reklame',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nama Berkas',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Action : ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ElevatedButton(
                  onPressed: () {}, child: Text("Berkas Sudah di Verifikasi"))),
          Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Berkas Belum Lengkap Verifikasi"))),
          Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: ElevatedButton(
                  onPressed: () {}, child: Text("Berkas Sudah di Kembalikan"))),
        ],
      ),
    );
  }
}
