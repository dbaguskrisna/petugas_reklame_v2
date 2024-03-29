import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petugas_ereklame/class/reklame.dart';
import 'package:petugas_ereklame/screen/lihat_detail_belum_diverifikasi.dart';
import 'package:petugas_ereklame/screen/lihat_detail_reklame_sudah_diverifikasi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class BerkasSudahDiVerifikasi extends StatefulWidget {
  const BerkasSudahDiVerifikasi({Key? key}) : super(key: key);

  @override
  State<BerkasSudahDiVerifikasi> createState() =>
      _BerkasSudahDiVerifikasiState();
}

class _BerkasSudahDiVerifikasiState extends State<BerkasSudahDiVerifikasi> {
  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    prefs.remove("username");
    main();
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  bacaData() {
    Reklames.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      print(json['data']);
      for (var mov in json['data']) {
        Reklame pm = Reklame.fromJson(mov);
        Reklames.add(pm);
      }
      setState(() {});
    });
  }

  Future<String> fetchData() async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/api/read_reklame_sudah_di_verifikasi"),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  List<Reklame> Reklames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Berkas Sudah di Verifikasi"),
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(),
                  child: Column(
                    children: [
                      Image.asset('assets/image/logo.png'),
                      Text("Petugas Reklame")
                    ],
                  )),
              ListTile(
                leading: Icon(Icons.close),
                title: Text('Berkas Belum di Verifikasi'),
                onTap: () {
                  Navigator.pushNamed(context, '/berkas-belum-diverifikasi');
                },
              ),
              ListTile(
                leading: Icon(Icons.checklist),
                title: Text('Berkas Sudah di Verifikasi'),
                onTap: () {
                  Navigator.pushNamed(context, '/berkas-sudah-diverifikasi');
                },
              ),
              ListTile(
                leading: Icon(Icons.exposure_minus_1),
                title: Text('Berkas Belum Lengkap'),
                onTap: () {
                  Navigator.pushNamed(context, '/berkas-kurang');
                },
              ),
              ListTile(
                leading: Icon(Icons.remove_circle),
                title: Text('Berkas di Cabut'),
                onTap: () {
                  Navigator.pushNamed(context, '/berkas-di-cabut');
                },
              ),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Log Out'),
                onTap: () {
                  doLogout();
                },
              ),
            ],
          ),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              child: DaftarPopMovie(Reklames),
            ),
          ],
        ));
  }

  Widget DaftarPopMovie(PopMovs) {
    if (PopMovs != null) {
      return ListView.builder(
          itemCount: PopMovs.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nomor Formulir : ' +
                            Reklames[index].no_formulir.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  subtitle: Text(
                    'Status Pengajuan : ' +
                        statusPengajuan(Reklames[index].status),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  (LihatDetailReklameSudahDiverifikasi(
                                      reklame_id: Reklames[index].id_reklame)),
                            ),
                          );
                        },
                        child: Text("Lihat Detail"))
                  ],
                ),
              ],
            ));
          });
    } else {
      return CircularProgressIndicator();
    }
  }

  String statusPengajuan(int status) {
    if (status == 2) {
      return "Berkas di Terima";
    } else {
      return "Berkas di Terima";
    }
  }
}
