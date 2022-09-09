import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:petugas_ereklame/screen/berkas_belum_diverifikasi.dart';
import 'package:petugas_ereklame/screen/berkas_dicabut.dart';
import 'package:petugas_ereklame/screen/berkas_kurang.dart';
import 'package:petugas_ereklame/screen/berkas_sudah_diverifikasi.dart';
import 'package:petugas_ereklame/screen/lihat_detail_data_survey.dart';
import 'package:petugas_ereklame/screen/login.dart';
import 'package:petugas_ereklame/screen/lokasi_reklame.dart';
import 'package:petugas_ereklame/screen/main_page.dart';
import 'package:petugas_ereklame/screen/main_page_2.dart';
import 'package:petugas_ereklame/screen/masukkan_data_survey.dart';
import 'package:petugas_ereklame/screen/profile_wastib.dart';
import 'package:shared_preferences/shared_preferences.dart';
//firebase pacakge
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'class/data_survey.dart';

String active_user = "";
String active_username = "";
String id_wastib = "";

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
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
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
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
    }

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
        "/profile-wastib": (context) => ProfileWastib(),
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
  List<DataSurveys> listDataSurvey = [];

  bacaData() {
    listDataSurvey.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var mov in json['data']) {
        DataSurveys pm = DataSurveys.fromJson(mov);
        listDataSurvey.add(pm);
      }
      setState(() {});
    });
  }

  Future<String> fetchData() async {
    final response =
        await http.post(Uri.parse("http://10.0.2.2:8000/api/read_data_survey"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  void deleteDataSurvey(int id_survey) async {
    print("id reklame" + id_survey.toString());
    final response = await http
        .post(Uri.parse("http://10.0.2.2:8000/api/delete_data_survey"), body: {
      'id_survey': id_survey.toString(),
    });

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sukses Menghapus Data Reklame')));
        bacaData();
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal Menghapus Data Reklame')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  void initState() {
    super.initState();
    bacaData();
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
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    prefs.remove("username");
    main();
  }

  String constructFCMPayload(String? token) {
    return jsonEncode({
      'to': token,
      "collapse_key": "type_a",
      "notification": {
        "body": "Swastyastu jik !",
        "title": "Notifikasi eReklame"
      },
      "data": {
        "body": "Body of Your Notification in Data",
        "title": "Title of Your Notification in Title",
        "key_1": "Value for key_1",
        "key_2": "Value for key_2"
      }
    });
  }

  Future<void> sendPushMessage(String _token) async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAAOLaYo3U:APA91bGvi8w0CPrwkf7f_Z0KgLob7t9wjbveJK3lSHnsFx36QPe9U3VKf3uh6jJleelnTfSLuvvqnExHWxtZGLY3Q50Eiu5101smjicMaViyhtE06UGLhLLGWJdB8CK1_SDgusw4T62h"
        },
        body: constructFCMPayload(_token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Data Survey Reklame"),
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
                leading: Icon(Icons.document_scanner),
                title: Text('Data Survey Reklmae'),
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
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
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              child: DaftarPopMovie(listDataSurvey),
            ),
          ],
        ));
  }

  Widget DaftarPopMovie(PopMovs) {
    if (PopMovs != null) {
      return ListView.builder(
          padding: EdgeInsets.all(5),
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
                            listDataSurvey[index].no_formulir.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Peringatan'),
                                      content: Text(
                                          'Apakah yakin ingin menghapus data survey ini ? '),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteDataSurvey(
                                                listDataSurvey[index]
                                                    .id_survey);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ));
                          },
                          icon: Icon(Icons.delete, size: 20))
                    ],
                  ),
                  subtitle: Text(
                    'Tanggal Survey : ' + listDataSurvey[index].tanggal_survey,
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
                              builder: (context) => (LihatDetailDataSurvey(
                                  id_survey: listDataSurvey[index].id_survey)),
                            ),
                          );
                        },
                        child: Text("Lihat Detail Survey"))
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
