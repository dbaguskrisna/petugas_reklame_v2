import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:petugas_ereklame/main.dart';
import 'package:petugas_ereklame/screen/lihat_detail_belum_diverifikasi.dart';
import 'package:petugas_ereklame/screen/main_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../class/reklame.dart';
import 'berkas_belum_diverifikasi.dart';
import 'berkas_dicabut.dart';
import 'berkas_kurang.dart';
import 'berkas_sudah_diverifikasi.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main2() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

class MainPageVerifikator extends StatefulWidget {
  MainPageVerifikator({Key? key}) : super(key: key);

  @override
  State<MainPageVerifikator> createState() => _MainPageVerifikatorState();
}

class _MainPageVerifikatorState extends State<MainPageVerifikator> {
  List<Reklame> Reklames = [];

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    prefs.remove("username");
    main();
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(
        context,
        '/message',
      );
    });

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
    String statusPengajuan(int statusPengajuan) {
      if (statusPengajuan == 1) {
        return "Menunggu Verifikasi";
      } else {
        return "belum di ajukan";
      }
    }

    Widget DaftarPopMovie(PopMovs) {
      if (PopMovs != null) {
        return ListView.builder(
            padding: EdgeInsets.only(bottom: 90),
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
                            print('halo');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    (LihatDetailBelumDiverifikasi(
                                        reklame_id:
                                            Reklames[index].id_reklame)),
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
}
