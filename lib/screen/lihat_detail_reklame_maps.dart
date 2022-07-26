import 'dart:convert';

import 'package:flutter/material.dart';

import '../class/detail_reklame.dart';
import 'package:http/http.dart' as http;

class LihatDetailReklameMaps extends StatefulWidget {
  int reklame_id;

  LihatDetailReklameMaps({Key? key, required this.reklame_id})
      : super(key: key);

  @override
  State<LihatDetailReklameMaps> createState() => _LihatDetailReklameMapsState();
}

class _LihatDetailReklameMapsState extends State<LihatDetailReklameMaps> {
  DetailReklame? detailReklames;

  @override
  void initState() {
    super.initState();
    bacaData();
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
        title: Text("Detail Reklame"),
      ),
      body: ListView(children: <Widget>[
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
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tgl Berkalu Reklame : ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
              )),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                detailReklames!.tgl_awal + " s/d " + detailReklames!.tgl_akhir,
                style: TextStyle(fontSize: 14),
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
                'Tinggi Reklame : ' + detailReklames!.tinggi_reklame.toString(),
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
        )
      ]),
    );
  }
}
