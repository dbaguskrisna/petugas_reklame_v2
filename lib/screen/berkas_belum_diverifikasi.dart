import 'dart:convert';
import 'package:petugas_ereklame/class/reklame.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petugas_ereklame/class/kecamatan.dart';

import '../main.dart';
import 'lihat_detail_belum_diverifikasi.dart';

class BerkasBelumDiVerifikasi extends StatefulWidget {
  const BerkasBelumDiVerifikasi({Key? key}) : super(key: key);

  @override
  State<BerkasBelumDiVerifikasi> createState() =>
      _BerkasBelumDiVerifikasiState();
}

class _BerkasBelumDiVerifikasiState extends State<BerkasBelumDiVerifikasi> {
  List<Reklame> Reklames = [];

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

  String _temp = 'waiting API respond…';

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
        Uri.parse("http://10.0.2.2:8000/api/read_reklame_belum_di_verifikasi"),
        body: {'user': active_username});
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
          title: Text("Berkas Belum di Verifikasi"),
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
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
                title: Text('Berkas Kurang'),
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
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Status Pengajuan : ' + Reklames[index].status.toString(),
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
                                  (LihatDetailBelumDiverifikasi(
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
}
