import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class DataSurvey extends StatefulWidget {
  const DataSurvey({Key? key}) : super(key: key);

  @override
  State<DataSurvey> createState() => _DataSurveyState();
}

class _DataSurveyState extends State<DataSurvey> {
  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    main();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Petugas Wastib"),
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
              child: Text(''),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile-wastib');
              },
            ),
            ListTile(
              leading: Icon(Icons.pin_drop),
              title: Text('Lokasi Reklame'),
              onTap: () {
                Navigator.pushNamed(context, '/lokasi-reklame');
              },
            ),
            ListTile(
              leading: Icon(Icons.file_copy),
              title: Text('Masukkan Data Survey'),
              onTap: () {
                Navigator.pushNamed(context, '/data-survey');
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
        children: [
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Text("Masukkan Hasil Survey",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(10, 5, 20, 0),
              child: Text('Masukkan Nomor Formulir : ',
                  style: TextStyle(fontSize: 14))),
          Container(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Nomor Formulir', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: Text('Berita Acara : ', style: TextStyle(fontSize: 14))),
          Container(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Berita Acara',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: ElevatedButton(
                child: Text("Masukkan Data"),
                onPressed: () {},
              )),
        ],
      ),
    );
  }
}
