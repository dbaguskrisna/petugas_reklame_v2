import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:petugas_ereklame/class/detail_reklame.dart';
import 'package:http/http.dart' as http;

import '../class/upload_file.dart';

class LihatDetailBerkasKurang extends StatefulWidget {
  final int reklame_id;

  LihatDetailBerkasKurang({Key? key, required this.reklame_id})
      : super(key: key);

  @override
  State<LihatDetailBerkasKurang> createState() =>
      _LihatDetailBerkasKurangState();
}

class _LihatDetailBerkasKurangState extends State<LihatDetailBerkasKurang> {
  DetailReklame? detailReklames;
  List<UploadFiles> listUpload = [];
  List<bool> listIsActived = [];
  TextEditingController alasan = new TextEditingController();
  int? id;
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
      print(json['data']);
      for (var mov in json['data']) {
        UploadFiles pm = UploadFiles.fromJson(mov);
        listUpload.add(pm);
        listIsActived.add(false);
      }
      setState(() {});
    });
  }

  void showNotification() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Tidak Dapat Memproses Data, Silahkan Cek Validasi Seluruh Data Terlebih Dahulu')));
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
            .showSnackBar(SnackBar(content: Text('Berkas Lengkap')));
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
          'alasan': alasan.text,
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

  String constructFCMPayloadTerverifikasi(
      String? token, String? noReklame, int? id) {
    return jsonEncode({
      'to': token,
      "collapse_key": "type_a",
      "notification": {
        "body": id == 1
            ? "Reklame Nomor : $noReklame Terverifikasi"
            : "Reklame Nomor : $noReklame Belum lengkap",
        "title": "Notifikasi eReklame"
      },
    });
  }

  Future<void> sendPushMessage(String _token, String noReklame, int id) async {
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
        body: constructFCMPayloadTerverifikasi(_token, noReklame, id),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  void downloadDataBerkas(int id_upload) async {
    final response = await http
        .post(Uri.parse("http://10.0.2.2:8000/api/download_file"), body: {
      'id_upload': id_upload.toString(),
    });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      print(json['data']);
    } else {
      print("Failed to read API");
    }
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    if (detailReklames == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Detail Reklame Berkas Belum Lengkap"),
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamed(context, '/berkas-kurang'),
          ),
          title: Text("Detail Reklame Belum Lengkap"),
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
                    'Alasan Berkas Belum Lengkap : ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    textAlign: TextAlign.center,
                  )),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Alasan Berkas Belum Lengkap',
                  ),
                  maxLines: 5,
                  initialValue: detailReklames!.alasan,
                  enabled: false,
                )),
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
                    DataColumn(label: Text("VERIFIKASI"))
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
                                    'Apakah Yakin Akan Menghapus Berkas ?' +
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
                      DataCell(Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: listIsActived[index],
                        onChanged: (bool? value) {
                          setState(() {
                            listIsActived[index] = value!;
                          });
                        },
                      ))
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
                            if (listIsActived.contains(false)) {
                              showNotification();
                            } else {
                              id = 1;
                              sendPushMessage(detailReklames!.token,
                                  detailReklames!.no_formulir.toString(), id!);
                              submitBerkasSudahLengkap();
                            }
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
                      title: const Text(
                          'Apakah anda yakin akan melakukan pengembalian pada berkas ini?'),
                      content: TextFormField(
                        controller: alasan,
                        decoration: InputDecoration(
                            hintText: ("Silahkan Tulis Alasan Pengembalian")),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Tidak'),
                        ),
                        TextButton(
                          onPressed: () {
                            id = 2;
                            sendPushMessage(detailReklames!.token,
                                detailReklames!.no_formulir.toString(), id!);
                            submitBerkasBelumLengkap();
                          },
                          child: const Text('Kembalikan'),
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
}
