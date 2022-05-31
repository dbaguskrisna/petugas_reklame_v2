import 'package:flutter/material.dart';
import 'package:petugas_ereklame/screen/profile_wastib.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'berkas_belum_diverifikasi.dart';
import 'berkas_dicabut.dart';
import 'berkas_kurang.dart';
import 'berkas_sudah_diverifikasi.dart';
import 'login.dart';
import 'lokasi_reklame.dart';
import 'main_page.dart';
import 'masukkan_data_survey.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Petugas Verifikator"),
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
                  Navigator.pushNamed(context, '/lokasi-reklame');
                },
              ),
              ListTile(
                leading: Icon(Icons.checklist),
                title: Text('Berkas Sudah di Verifikasi'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.exposure_minus_1),
                title: Text('Berkas Kurang'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.remove_circle),
                title: Text('Berkas di Cabut'),
                onTap: () {},
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Hello, Verifikator"),
            ],
          ),
        ),
      ),
    );
  }
}