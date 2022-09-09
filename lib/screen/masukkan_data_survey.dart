import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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
  File? _image = null;

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    main();
  }

  /// Get from gallery
  _imgGaleri() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }

  /// Get from Camera
  _imgKamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Colors.white,
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      tileColor: Colors.white,
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galeri'),
                      onTap: () {
                        _imgGaleri();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Kamera'),
                    onTap: () {
                      _imgKamera();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<String> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("user_id") ?? '';
    return user_id;
  }

  void submit() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:8000/api/insert_data_survey'));
    request.files.add(
        await http.MultipartFile.fromPath('file', _image!.path.toString()));
    print(active_username);
    request.fields.addAll({
      'no_formulir': nomorFormulir.text,
      'id_petugas': id_wastib,
      'tanggal_survey': dateinput.text,
      'berita_acara': beritaAcara.text
    });

    var res = await request.send();
    var responseJSON = await http.Response.fromStream(res);
    print(res.statusCode);
    if (res.statusCode == 200) {
      Map json = jsonDecode(responseJSON.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sukses Menambahkan Data Survey')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Gagal Menambahkan Data Survey Silahkan Cek Kembali Nomor Formulir yang Anda Masukkan')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

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
                      return 'Textbox tidak boleh kosong';
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
                        return 'Textbox tidak boleh kosong';
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
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: TextFormField(
                  controller: beritaAcara,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Berita Acara',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Textbox tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 20, 0),
                  child: Text('Masukkan Gambar Reklame : ',
                      style: TextStyle(fontSize: 14))),
              Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: _image == null
                          ? Image.network(
                              "https://cdn-icons-png.flaticon.com/512/685/685685.png",
                              height: 150,
                            )
                          : Image.file(_image!))),
              Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: ElevatedButton(
                    child: Text("Masukkan Data"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_image == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Silahkan Masukkan Foto Kondisi Reklame Terkini')));
                        } else {
                          submit();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Tidak dapat menambahkan data survey, silahkan lengkapi form data survey')));
                      }
                    },
                  )),
            ],
          ),
        ));
  }
}
