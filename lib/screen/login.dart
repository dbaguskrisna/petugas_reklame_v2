import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _user_id = "";
  String _user_password = "";
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    void doLogin() async {
      String? _token = await FirebaseMessaging.instance.getToken();

      final response = await http
          .post(Uri.parse("http://10.0.2.2:8000/api/login_petugas"), body: {
        'username': _user_id,
        'password': _user_password,
        'token': _token
      });

      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("user_id", json['data'][0]['nama_petugas']);
          prefs.setString("username", json['data'][0]['username']);
          prefs.setString("status", json['data'][0]['status']);
          prefs.setString(
              "id_petugas", json['data'][0]['id_petugas_wastib'].toString());
          main();
        } else {
          SnackBar snackBar = SnackBar(
              content:
                  Text("Login gagal, Silahkan Check Username dan Password"));
          snackbarKey.currentState?.showSnackBar(snackBar);
        }
      } else {
        print("failed to read API");
      }
    }

    return MaterialApp(
        scaffoldMessengerKey: snackbarKey,
        home: Scaffold(
            body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Image.asset('assets/image/logo.png')),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'VERSI PETUGAS',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Silahkan login untuk masuk aplikasi',
                    style: TextStyle(fontSize: 15),
                  )),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  onChanged: (v) {
                    _user_id = v;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon masukkan username';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  onChanged: (v) {
                    _user_password = v;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon masukkan password';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: Text('Login'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        doLogin();
                      }
                    },
                  )),
            ],
          ),
        )));
  }
}
