import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petugas_ereklame/class/kecamatan.dart';

class BerkasBelumDiVerifikasi extends StatefulWidget {
  const BerkasBelumDiVerifikasi({Key? key}) : super(key: key);

  @override
  State<BerkasBelumDiVerifikasi> createState() =>
      _BerkasBelumDiVerifikasiState();
}

class _BerkasBelumDiVerifikasiState extends State<BerkasBelumDiVerifikasi> {
  List<Kecamatan> listKecamatan = [];

  String _temp = 'waiting API respond…';
  Future<String> fetchData() async {
    final response =
        await http.get(Uri.parse("http://10.0.2.2:8000/api/master_kecamatan"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    listKecamatan.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var mov in json["data"]) {
        Kecamatan pm = Kecamatan.fromJson(mov);
        listKecamatan.add(pm);
      }
      setState(() {
        _temp = listKecamatan[1].nama_kecamatan;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
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
                  Navigator.pushNamed(context, '/');
                },
              ),
            ],
          ),
        ),
        body: Center(
            child: ListView.builder(
                itemCount: listKecamatan.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return new Card(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.movie, size: 50),
                        title: GestureDetector(
                            child: Text(
                                listKecamatan[index].id_kecamatan.toString()),
                            onTap: () {}),
                        subtitle: Column(
                          children: [
                            Text(listKecamatan[index].nama_kecamatan),
                            ElevatedButton(
                                onPressed: () {}, child: Text("Add to cart"))
                          ],
                        ),
                      ),
                    ],
                  ));
                })));
  }
}
