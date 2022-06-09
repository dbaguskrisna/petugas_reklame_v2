import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petugas_ereklame/class/profile_wastib.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class ProfileWastib extends StatefulWidget {
  const ProfileWastib({Key? key}) : super(key: key);

  @override
  State<ProfileWastib> createState() => _ProfileWastibState();
}

class _ProfileWastibState extends State<ProfileWastib> {
  static ProfileWastibs? profileWastibs;

  final nama_lengkap =
      TextEditingController(text: profileWastibs?.nama_petugas);
  final nomor_handphone =
      TextEditingController(text: profileWastibs?.nomor_handphone.toString());
  final alamat = TextEditingController(text: profileWastibs?.alamat);
  final _formKey = GlobalKey<FormState>();

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

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      print(json['data'][0]);
      profileWastibs = ProfileWastibs.fromJson(json['data'][0]);
      setState(() {});
    });
  }

  Future<String> fetchData() async {
    print(active_username);
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/read_petugas_wastib"),
        body: {'username': active_username});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Petugas Wastib"),
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
              child: Text("Petugas Wastib",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(10, 5, 20, 0),
                child: Text('Nama Lengkap : ', style: TextStyle(fontSize: 14))),
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Masukkan Nama Lengkap',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: nama_lengkap,
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child:
                    Text('Nomor Handphone : ', style: TextStyle(fontSize: 14))),
            Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Nomor Handphone',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: nomor_handphone,
                    ),
                  ],
                )),
            Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Text('Alamat : ', style: TextStyle(fontSize: 14))),
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Masukkan Alamat',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: alamat,
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: ElevatedButton(
                  child: Text("Update Profile"),
                  onPressed: () {},
                )),
          ],
        ),
      ),
    );
  }
}
