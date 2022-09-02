import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../class/data_survey.dart';
import '../class/detail_data_survey.dart';

class LihatDetailDataSurvey extends StatefulWidget {
  final int id_survey;
  LihatDetailDataSurvey({Key? key, required this.id_survey}) : super(key: key);

  @override
  State<LihatDetailDataSurvey> createState() => _LihatDetailDataSurveyState();
}

class _LihatDetailDataSurveyState extends State<LihatDetailDataSurvey> {
  DetailDataSurvey? detailDataSurvey;

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      print(json['data'][0]);
      detailDataSurvey = DetailDataSurvey.fromJson(json['data'][0]);
      setState(() {});
    });
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/detail_survey_reklame"),
        body: {'id_survey': widget.id_survey.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (detailDataSurvey == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Detail Data Survey"),
          ),
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.blue,
              size: 80,
            ),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(title: Text("Detail Data Survey")),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nomor Formulir Reklame : ' +
                        detailDataSurvey!.no_formulir.toString(),
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
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                initialValue: detailDataSurvey!.email,
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nama Pemohon',
                ),
                initialValue: detailDataSurvey!.nama,
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Alamat',
                ),
                initialValue: detailDataSurvey!.alamat,
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nomor Telp',
                ),
                initialValue: detailDataSurvey!.no_telp_perusahaan.toString(),
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nama Perusahaan',
                ),
                initialValue: detailDataSurvey!.nama_perusahaan,
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Alamat Perusahaan',
                ),
                initialValue: detailDataSurvey!.alamat_perusahaan,
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'NPWPD',
                ),
                initialValue: detailDataSurvey!.npwpd,
                enabled: false,
              ),
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
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nama Jalan',
                ),
                initialValue: detailDataSurvey!.nama_jalan,
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nomor Jalan',
                ),
                initialValue: detailDataSurvey!.nomor_jalan.toString(),
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tahun Pendirian',
                ),
                initialValue: detailDataSurvey!.tahun_pendirian.toString(),
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Kecamatan',
                ),
                initialValue: detailDataSurvey!.kecamatan,
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                initialValue: detailDataSurvey!.kelurahan,
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Detail Lokasi',
                ),
                initialValue: detailDataSurvey!.detail_lokasi,
                enabled: false,
              ),
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
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tahun Pajak',
                ),
                initialValue: detailDataSurvey!.tahun_pajak.toString(),
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tanggal Permohonan',
                ),
                initialValue: detailDataSurvey!.tgl_permohonan,
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Jenis Reklame',
                ),
                initialValue: detailDataSurvey!.jenis_reklame,
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Jenis Produk',
                ),
                initialValue: detailDataSurvey!.jenis_produk,
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Lokasi Penempatan',
                ),
                initialValue: detailDataSurvey!.lokasi_penempatan,
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Status Tanah',
                ),
                initialValue: detailDataSurvey!.nama_status_tanah,
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Letak Reklame',
                ),
                initialValue: detailDataSurvey!.letak,
                enabled: false,
              ),
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
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Sudut Pandang',
                ),
                initialValue: detailDataSurvey!.sudut_pandang.toString(),
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Panjang Reklame',
                ),
                initialValue:
                    detailDataSurvey!.panjang_reklame.toString() + " m",
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Lebar Reklame',
                ),
                initialValue: detailDataSurvey!.lebar_reklame.toString() + " m",
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Luas Reklame',
                ),
                initialValue:
                    detailDataSurvey!.luas_reklame.toString() + " m\u00B2 ",
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Luas Reklame',
                ),
                initialValue:
                    detailDataSurvey!.tinggi_reklame.toString() + " m",
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Teks Reklame',
                ),
                initialValue: detailDataSurvey!.teks,
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Data Survey Reklame',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tanggal Survey ',
                ),
                initialValue:
                    detailDataSurvey!.luas_reklame.toString() + " m\u00B2 ",
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Berita Acara',
                ),
                initialValue: detailDataSurvey!.berita,
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Gambar Kondisi Reklame: ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.network(
                      'http://10.0.2.2:80//eReklame//eReklame//public//data_file/' +
                          detailDataSurvey!.gambar)),
            ),
          ],
        ),
      );
    }
  }
}
