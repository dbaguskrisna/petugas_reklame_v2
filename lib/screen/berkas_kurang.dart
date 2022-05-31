import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class BerkasKurang extends StatefulWidget {
  const BerkasKurang({Key? key}) : super(key: key);

  @override
  State<BerkasKurang> createState() => _BerkasKurangState();
}

class _BerkasKurangState extends State<BerkasKurang> {
  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    prefs.remove("username");
    main();
  }

  List list = ["Halo 1", "Halo 2", "Halo 3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Berkas Kurang"),
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
