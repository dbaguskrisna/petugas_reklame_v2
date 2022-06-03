import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class DataSurvey extends StatefulWidget {
  const DataSurvey({Key? key}) : super(key: key);

  @override
  State<DataSurvey> createState() => _DataSurveyState();
}

class _DataSurveyState extends State<DataSurvey> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController nomorFormulir = TextEditingController();
  TextEditingController beritaAcara = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    main();
  }

  Future<String> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("user_id") ?? '';
    return user_id;
  }

  void submit() async {
    final response = await http
        .post(Uri.parse("http://10.0.2.2:8000/api/insert_data_survey"), body: {
      'no_formulir': nomorFormulir.text,
      'id_petugas': id_wastib,
      'tanggal_survey': dateinput.text,
      'berita_acara': beritaAcara.text
    });

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menambah Data')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nomor Formulir Tidak di Temukan')));
      }
    } else {
      print("Failed to read API");
    }
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
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Text("Masukkan Hasil Survey",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 20, 0),
                  child: Text('Masukkan Nomor Formulir : ',
                      style: TextStyle(fontSize: 14))),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: nomorFormulir,
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
                  child: Text('Tanggal : ', style: TextStyle(fontSize: 14))),
              Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller:
                        dateinput, //editing controller of this TextField
                    decoration: InputDecoration(
                        prefix: Icon(Icons.calendar_today),
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        print(pickedDate);
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate);
                        setState(() {
                          dateinput.text = formattedDate;
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                  )),
              Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child:
                      Text('Berita Acara : ', style: TextStyle(fontSize: 14))),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: beritaAcara,
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        submit();
                        print(dateinput.text);
                        print(beritaAcara.text);
                        print(nomorFormulir.text);
                      }
                    },
                  )),
            ],
          ),
        ));
  }
}
