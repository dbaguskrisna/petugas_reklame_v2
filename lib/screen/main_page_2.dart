import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petugas_ereklame/main.dart';
import 'package:petugas_ereklame/screen/lihat_detail_belum_diverifikasi.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../class/reklame.dart';
import 'berkas_belum_diverifikasi.dart';
import 'berkas_dicabut.dart';
import 'berkas_kurang.dart';
import 'berkas_sudah_diverifikasi.dart';
import 'package:http/http.dart' as http;

class MainPageVerifikator extends StatefulWidget {
  const MainPageVerifikator({Key? key}) : super(key: key);

  @override
  State<MainPageVerifikator> createState() => _MainPageVerifikatorState();
}

class _MainPageVerifikatorState extends State<MainPageVerifikator> {
  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    prefs.remove("username");
    main();
  }

  List<Reklame> Reklames = [];

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
      for (var mov in json['data']) {
        print(json['data']);
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
    return MaterialApp(
      routes: {
        "/berkas-belum-diverifikasi": (context) => MainPageVerifikator(),
        "/berkas-sudah-diverifikasi": (context) => BerkasSudahDiVerifikasi(),
        "/berkas-kurang": (context) => BerkasKurang(),
        "/berkas-di-cabut": (context) => BerkasDiCabut(),
      },
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text("Berkas Belum Di Verifikasi"),
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
          ),
        ),
      ),
    );
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
                    'Status Pengajuan : ' +
                        statusPengajuan(Reklames[index].status_pengajuan),
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

  String statusPengajuan(int statusPengajuan) {
    if (statusPengajuan == 1) {
      return "Menunggu Verifikasi";
    } else {
      return "belum di ajukan";
    }
  }
}
