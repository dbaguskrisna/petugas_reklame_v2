import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petugas_ereklame/class/detail_reklame.dart';
import 'package:petugas_ereklame/class/reklame.dart';

class LihatDetailBelumDiverifikasi extends StatefulWidget {
  final int reklame_id;
  const LihatDetailBelumDiverifikasi({Key? key, required this.reklame_id})
      : super(key: key);

  @override
  State<LihatDetailBelumDiverifikasi> createState() =>
      _LihatDetailBelumDiverifikasiState();
}

class _LihatDetailBelumDiverifikasiState
    extends State<LihatDetailBelumDiverifikasi> {
  DetailReklame? detailReklames;

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  void submitBerkasSudahLengkap() async {
    final response = await http.put(
        Uri.parse(
            "http://10.0.2.2:8000/api/update_status_reklame_belum_diverifikasi"),
        body: {
          'id_reklame': widget.reklame_id.toString(),
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menambah Data')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nomor Formulir Tidak di Temukan')));
      }
    } else {
      print("Failed to read API");
    }
  }

  void submitBerkasBelumLengkap() async {
    final response = await http.put(
        Uri.parse(
            "http://10.0.2.2:8000/api/update_status_reklame_berkas_kurang"),
        body: {
          'id_reklame': widget.reklame_id.toString(),
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menambah Data')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nomor Formulir Tidak di Temukan')));
      }
    } else {
      print("Failed to read API");
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      print(json['data'][0]);
      detailReklames = DetailReklame.fromJson(json['data'][0]);
      setState(() {});
    });
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/read_reklame_detail"),
        body: {'id_reklame': widget.reklame_id.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reklame Belum di Verifikasi"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nomor Formulir Reklame : ' +
                      detailReklames!.no_formulir.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Data Pemohon : ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email : ' + detailReklames!.email,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nama Pemohon : ' + detailReklames!.nama,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Alamat : ' + detailReklames!.alamat,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nomor Telp : ' + detailReklames!.no_hp.toString(),
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nama Perusahaan : ' + detailReklames!.nama_perusahaan,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Alamat : ' + detailReklames!.alamat,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'NPWPD : ' + detailReklames!.npwpd,
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
                  'Nama Jalan : ' + detailReklames!.nama_jalan,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nomor Jalan : ' + detailReklames!.nomor_jalan.toString(),
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
                  'Tahun Pendirian : ' +
                      detailReklames!.tahun_pendirian.toString(),
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kecamatan : ' + detailReklames!.kecamatan,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kelurahan : ' + detailReklames!.kelurahan,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Detail Lokasi : ' + detailReklames!.detail_lokasi,
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
                  'Tahun Pajak : ' + detailReklames!.tahun_pajak.toString(),
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tanggal Permohonan : ' +
                      detailReklames!.tgl_permohonan.toString(),
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
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                detailReklames!.jenis_reklame,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Jenis Produk : ' + detailReklames!.jenis_produk,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Lokasi Penempatan : ' + detailReklames!.lokasi_penempatan,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Status Tanah : ' + detailReklames!.nama_status_tanah,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Letak Reklame : ' + detailReklames!.letak,
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
                  'Sudut Pandang Reklame : ' +
                      detailReklames!.sudut_pandang.toString(),
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Panjang Reklame : ' +
                      detailReklames!.panjang_reklame.toString(),
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Lebar Reklame : ' + detailReklames!.lebar_reklame.toString(),
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Luas Reklame : ' + detailReklames!.luas_reklame.toString(),
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tinggi Reklame : ' +
                      detailReklames!.tinggi_reklame.toString(),
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Teks Reklame : ' + detailReklames!.teks,
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
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Peringatan'),
                    content: const Text(
                        'Apakah anda yakin ingin memverifikasi berkas ini ?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          submitBerkasSudahLengkap();
                        },
                        child: const Text('Yakin'),
                      ),
                    ],
                  ),
                ),
                child: const Text('Bekas Lengkap'),
              )),
          Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ElevatedButton(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Peringatan'),
                    content: const Text(
                        'Apakah anda yakin akan melakukan pengembalian pada berkas ini?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          submitBerkasBelumLengkap();
                        },
                        child: const Text('Berkas'),
                      ),
                    ],
                  ),
                ),
                child: const Text('Bekas Belum Lengkap'),
              )),
        ],
      ),
    );
  }
}
