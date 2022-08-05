import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:petugas_ereklame/class/maps.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';

import 'lihat_detail_reklame_maps.dart';

class LokasiReklame extends StatefulWidget {
  const LokasiReklame({Key? key}) : super(key: key);

  @override
  State<LokasiReklame> createState() => _LokasiReklameState();
}

class _LokasiReklameState extends State<LokasiReklame> {
  var locationMessage = "";

  List<Maps> listMaps = [];
  String _txtCari = "";

  LatLng marker = LatLng(0, 0);

  List<Marker> lisMarkers = [];
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    prefs.remove("username");
    main();
  }

  @override
  initState() {
    super.initState();
    bacaData();
  }

  bacaData() {
    listMaps.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);

      for (var mov in json['data']) {
        Maps pm = Maps.fromJson(mov);
        listMaps.add(pm);
      }
      setState(() {
        addMaps();
      });
    });
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/search"),
        body: {'no_reklame': _txtcari});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  void addMaps() {
    print("halo ini add maps");
    lisMarkers.clear();
    listMaps.forEach((Maps maps) {
      lisMarkers.add(
        Marker(
          //add second marker
          markerId: MarkerId(maps.id_reklame.toString()),
          position: LatLng(double.parse(maps.latitude),
              double.parse(maps.longtitude)), //position of marker
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "Nomor Formulir : " +
                                    maps.no_formulir.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("Tgl Berkaku : " +
                                  maps.tgl_berlaku_awal +
                                  " s/d " +
                                  maps.tgl_berlaku_akhir),
                              Text("Status : " + checkStatus(maps.status)),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Align(
                                  child: ElevatedButton(
                                      child: Text('Lihat Detail'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                (LihatDetailReklameMaps(
                                                    reklame_id:
                                                        maps.id_reklame)),
                                          ),
                                        );
                                      }),
                                ),
                              )
                            ],
                          ),
                        ),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ],
                ),
                LatLng(
                  double.parse(maps.latitude),
                  double.parse(maps.longtitude),
                ));
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(
              checkBitMapColor(maps.status)), //Icon for Marker
        ),
      );
    });
  }

  double checkBitMapColor(int status) {
    if (status == 0) {
      return BitmapDescriptor.hueBlue;
    } else if (status == 1) {
      return BitmapDescriptor.hueGreen;
    } else {
      return BitmapDescriptor.hueRed;
    }
  }

  String checkStatus(int status) {
    if (status == 0) {
      return "Dalam Proses Permohonan";
    } else if (status == 1) {
      return "Aktif";
    } else {
      return "Tidak Aktif";
    }
  }

  String _txtcari = "";

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-7.253142, 112.7236701),
    zoom: 10.000,
  );

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
              labelText: "Masukkan Nomor Lokasi",
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(color: Colors.white),
            onFieldSubmitted: (value) {
              _txtcari = value;
              print(_txtcari);
              bacaData();
            },
          ),
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
        body: Stack(children: <Widget>[
          GoogleMap(
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) async {
              _customInfoWindowController.googleMapController = controller;
            },
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            markers: Set<Marker>.of(lisMarkers),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 130,
            width: 300,
            offset: 50,
          ),
        ]));
  }
}
