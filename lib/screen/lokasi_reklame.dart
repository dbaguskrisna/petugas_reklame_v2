import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:petugas_ereklame/class/maps.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LokasiReklame extends StatefulWidget {
  const LokasiReklame({Key? key}) : super(key: key);

  @override
  State<LokasiReklame> createState() => _LokasiReklameState();
}

class _LokasiReklameState extends State<LokasiReklame> {
  List<Maps> listMaps = [];
  String _txtCari = "";

  LatLng marker = LatLng(0, 0);

  List<Marker> lisMarkers = [];

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
    listMaps.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      print(json['data']);
      for (var mov in json['data']) {
        Maps pm = Maps.fromJson(mov);
        listMaps.add(pm);
      }
      setState(() {
        addMaps();
      });
    });
  }

  void addMaps() {
    listMaps.forEach((Maps maps) {
      lisMarkers.add(Marker(
          width: 70.0,
          height: 70.0,
          point: LatLng(
              double.parse(maps.latitude), double.parse(maps.longtitude)),
          builder: (ctx) => Container(
              child: IconButton(
                  icon: Icon(Icons.location_on),
                  color: Colors.red,
                  onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text('Notifikasi'),
                            content: Text("Reklame dengan Nomor Formulir" +
                                maps.no_formulir.toString()),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Keluar'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('Yakin'),
                              ),
                            ],
                          ))))));
    });
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/read_maps_petugas"),
        body: {'user': active_username});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  String _txtcari = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            decoration: const InputDecoration(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              labelText: "Cari Lokasi",
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(color: Colors.white),
            onFieldSubmitted: (value) {
              _txtcari = value;
              //bacaData();
            },
          ),
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
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(-7.334962, 112.8011705),
            zoom: 13.0,
            onTap: (tapPosition, point) {
              marker = point;
              setState(() {});
            },
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(markers: lisMarkers),
          ],
        ));
  }
}
