import 'package:flutter/material.dart';
import 'package:petugas_ereklame/screen/berkas_belum_diverifikasi.dart';
import 'package:petugas_ereklame/screen/berkas_dicabut.dart';
import 'package:petugas_ereklame/screen/berkas_kurang.dart';
import 'package:petugas_ereklame/screen/berkas_sudah_diverifikasi.dart';
import 'package:petugas_ereklame/screen/login.dart';
import 'package:petugas_ereklame/screen/lokasi_reklame.dart';
import 'package:petugas_ereklame/screen/main_page.dart';
import 'package:petugas_ereklame/screen/main_page_2.dart';
import 'package:petugas_ereklame/screen/masukkan_data_survey.dart';
import 'package:petugas_ereklame/screen/profile_wastib.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";
String active_username = "";
String id_wastib = "";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(Login());
    else {
      active_user = result;
      checkUsername().then((String result2) {
        if (result2 == '')
          active_username = "username not found";
        else {
          active_username = result2;
        }
      });
      checkStatus().then((String status) {
        if (status == 'wastib') {
          checkIdWastib().then((String id) {
            id_wastib = id;
            print("WASTIB");
            runApp(MyApp());
          });
        } else {
          print("VERIFIKATOR");
          runApp(MainPageVerifikator());
        }
      });
    }
  });
}

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

Future<String> checkUsername() async {
  final prefs = await SharedPreferences.getInstance();
  String username = prefs.getString("username") ?? '';
  return username;
}

Future<String> checkStatus() async {
  final prefs = await SharedPreferences.getInstance();
  String status = prefs.getString("status") ?? '';
  return status;
}

Future<String> checkIdWastib() async {
  final prefs = await SharedPreferences.getInstance();
  String status = prefs.getString("id_petugas") ?? '';
  return status;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        "/lokasi-reklame": (context) => LokasiReklame(),
        "/data-survey": (context) => DataSurvey(),
        "/main-page-wastib": (context) => MainPageWastib(),
        "/main-page-verifikator": (context) => MainPageVerifikator(),
        "/berkas-belum-diverifikasi": (context) => BerkasBelumDiVerifikasi(),
        "/berkas-sudah-diverifikasi": (context) => BerkasSudahDiVerifikasi(),
        "/berkas-kurang": (context) => BerkasKurang(),
        "/berkas-di-cabut": (context) => BerkasDiCabut(),
        "/profile-wastib": (context) => ProfileWastib()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    prefs.remove("username");
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Hello, Wastib"),
          ],
        ),
      ),
    );
  }
}
