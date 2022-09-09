import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:petugas_ereklame/class/detail_reklame.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../class/upload_file.dart';

class LihatDetailReklameSudahDiverifikasi extends StatefulWidget {
  final int reklame_id;
  const LihatDetailReklameSudahDiverifikasi(
      {Key? key, required this.reklame_id})
      : super(key: key);

  @override
  State<LihatDetailReklameSudahDiverifikasi> createState() =>
      _LihatDetailBelumDiverifikasiState();
}

class _LihatDetailBelumDiverifikasiState
    extends State<LihatDetailReklameSudahDiverifikasi> {
  DetailReklame? detailReklames;
  List<UploadFiles> listUpload = [];
  TextEditingController alasan = new TextEditingController();
  @override
  void initState() {
    super.initState();
    bacaData();
    bacaDataBerkas();
  }

  bacaDataBerkas() {
    listUpload.clear();
    Future<String> data = fetchDataUpload();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var mov in json['data']) {
        UploadFiles pm = UploadFiles.fromJson(mov);
        listUpload.add(pm);
      }
      setState(() {});
    });
  }

  Future<String> fetchDataUpload() async {
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/read_upload_reklame"),
        body: {'id_reklame': widget.reklame_id.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
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

  void downloadDataBerkas(int id_upload) async {
    final response = await http
        .post(Uri.parse("http://10.0.2.2:8000/api/download_file"), body: {
      'id_upload': id_upload.toString(),
    });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      openFile(
          url: 'http://10.0.2.2:80//eReklame//eReklame//public//data_file/' +
              json['data'],
          filename: 'lalala');
    } else {
      print("Failed to read API");
    }
  }

  Future openFile({required String url, String? filename}) async {
    String name = "aaa";
    print(url);
    final file = await downloadFile(url, name);
    if (file == null) {
      print("halo");
    } else {
      print('Path:${file.path}');

      OpenFile.open(file.path);
    }
  }

  Future<File?> downloadFile(String url, String name) async {
    print("download file");
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    final response = await Dio().get(url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ));

    final raf = file.openSync(mode: FileMode.write);
    print(response.data);
    raf.writeFromSync(response.data);
    await raf.close();

    return file;
  }

  void cabutBerkas() async {
    if (alasan.text == '' || alasan.text == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
              'Tidak dapat mencabut berkas, Silahkan isi alasan terlebih dahulu')));
    } else {
      final response = await http
          .put(Uri.parse("http://10.0.2.2:8000/api/cabut_berkas"), body: {
        'id_reklame': widget.reklame_id.toString(),
        'alasan': alasan.text
      });
      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Sukses Mencabut Berkas')));
          sendPushMessage(
              detailReklames!.token, detailReklames!.no_formulir.toString());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Nomor Formulir Tidak di Temukan')));
        }
      } else {
        print("Failed to read API");
      }
    }
  }

  String constructFCMPayloadTerverifikasi(String? token, String? noReklame) {
    return jsonEncode({
      'to': token,
      "collapse_key": "type_a",
      "notification": {
        "body": "Reklame dengan Nomor Formulir : $noReklame di Cabut",
        "title": "Notifikasi eReklame"
      },
    });
  }

  Future<void> sendPushMessage(String _token, String noReklame) async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAAOLaYo3U:APA91bGvi8w0CPrwkf7f_Z0KgLob7t9wjbveJK3lSHnsFx36QPe9U3VKf3uh6jJleelnTfSLuvvqnExHWxtZGLY3Q50Eiu5101smjicMaViyhtE06UGLhLLGWJdB8CK1_SDgusw4T62h"
        },
        body: constructFCMPayloadTerverifikasi(_token, noReklame),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (detailReklames == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Detail Berkas Sudah di Verifikasi"),
          ),
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.blue,
              size: 80,
            ),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Detail Berkas Sudah di Verifikasi"),
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
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                initialValue: detailReklames!.email,
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
                  initialValue: detailReklames!.nama,
                  enabled: false,
                )),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Alamat',
                ),
                initialValue: detailReklames!.alamat,
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
                initialValue: detailReklames!.no_hp.toString(),
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
                initialValue: detailReklames!.nama_perusahaan,
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
                initialValue: detailReklames!.alamat_perusahaan,
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
                initialValue: detailReklames!.npwpd,
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
                initialValue: detailReklames!.nama_jalan,
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
                initialValue: detailReklames!.nomor_jalan.toString(),
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
                initialValue: detailReklames!.tahun_pendirian.toString(),
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
                initialValue: detailReklames!.kecamatan,
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Kelurahan',
                ),
                initialValue: detailReklames!.kelurahan,
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
                initialValue: detailReklames!.detail_lokasi,
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
                initialValue: detailReklames!.tahun_pajak.toString(),
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
                initialValue: detailReklames!.tgl_permohonan,
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
                initialValue: detailReklames!.email,
                enabled: false,
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
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Jenis Produk',
                ),
                initialValue: detailReklames!.jenis_produk,
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
                initialValue: detailReklames!.lokasi_penempatan,
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
                initialValue: detailReklames!.nama_status_tanah,
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
                initialValue: detailReklames!.letak,
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
                  labelText: 'Sudut Pandang Reklame',
                ),
                initialValue: detailReklames!.sudut_pandang.toString(),
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
                initialValue: detailReklames!.panjang_reklame.toString() + " m",
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
                initialValue: detailReklames!.lebar_reklame.toString() + " m",
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
                initialValue:
                    detailReklames!.luas_reklame.toString() + " m" + '\u00B2',
                enabled: false,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tinggi Reklame',
                ),
                initialValue: detailReklames!.tinggi_reklame.toString() + " m",
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
                initialValue: detailReklames!.teks,
                enabled: false,
              ),
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
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text('TIPE BERKAS'),
                    ),
                    DataColumn(
                      label: Text('ACTION'),
                    ),
                  ],
                  rows: List.generate(listUpload.length, (index) {
                    String nama_berkas = listUpload[index].jenis_berkas;

                    return DataRow(cells: [
                      DataCell(Text(nama_berkas)),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.download),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Peringatan'),
                                content: Text(
                                    'Apakah Anda Akan Mendownload Data Berkas ?' +
                                        listUpload[index].id_upload.toString()),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      downloadDataBerkas(
                                          listUpload[index].id_upload);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ]);
                  }),
                ),
              ),
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
                      title: const Text(
                          'Apakah anda yakin akan mencabut berkas ini?'),
                      content: TextFormField(
                        controller: alasan,
                        decoration: InputDecoration(
                            hintText:
                                ("Silahkan Tulis Alasan Pencabutan Berkas")),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            cabutBerkas();
                          },
                          child: const Text('Cabut Berkas'),
                        ),
                      ],
                    ),
                  ),
                  child: const Text('Cabut Berkas'),
                )),
          ],
        ),
      );
    }
  }
}
