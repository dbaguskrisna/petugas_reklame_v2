import 'package:flutter/material.dart';

import '../main.dart';

class Verifikator extends StatefulWidget {
  const Verifikator({Key? key}) : super(key: key);

  @override
  State<Verifikator> createState() => _VerifikatorState();
}

class _VerifikatorState extends State<Verifikator> {
  List list = ["Halo 1", "Halo 2", "Halo 3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Masukkan Data Survey"),
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
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.album),
                    title: Text(list[index]),
                    subtitle:
                        Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: const Text('BUY TICKETS'),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        child: const Text('LISTEN'),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
