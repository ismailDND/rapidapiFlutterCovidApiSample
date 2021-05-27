import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

main() {
  var keyMyhome = PageStorageKey("myApp");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: myApp(
      key: keyMyhome,
    ),
  ));
}

class myApp extends StatefulWidget {
  const myApp({Key key}) : super(key: key);

  @override
  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  List<coronas> dyn;

  Widget build(BuildContext context) {
    getValue();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Corona API - Test APP",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: getValue(),
        builder: (context, value) {
          if (value.data != null) {
            dyn = value.data as List;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Toplam vaka " + dyn[0].toplamHasta.toString()),
                  Text("Toplam iyileşenler " + dyn[0].iylesenler.toString()),
                  Text("Toplam kritik hasta " +
                      dyn[0].kritikHastalar.toString()),
                  Text("Toplam ölüm " + dyn[0].olumler.toString()),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.black,
                color: Colors.grey,
              )),
            );
          }
        },
      ),
    );
  }

  Future<List<coronas>> getValue() async {
    Map<String, String> bodyKeys = {
      "x-rapidapi-key": "535000541dmsh462e866b36beb42p19106fjsn02cd46928b27",
      "x-rapidapi-host": "covid-19-data.p.rapidapi.com"
    };

    var url = Uri.parse(
      "https://covid-19-data.p.rapidapi.com/totals?format=json",
    );

    var Getres = await http.get(url, headers: bodyKeys);

    List<coronas> jsonEd = (json.decode(Getres.body) as List)
        .map((e) => coronas.toJson(e))
        .toList();
    return jsonEd;
  }
}

class coronas {
  factory coronas.toJson(Map<Object, Object> map) {
    return coronas(
        iylesenler: map["recovered"],
        kritikHastalar: map["critical"],
        olumler: map["deaths"],
        toplamHasta: map["confirmed"]);
  }

  int olumler;
  int kritikHastalar;
  int iylesenler;
  int toplamHasta;

  coronas(
      {this.olumler, this.kritikHastalar, this.iylesenler, this.toplamHasta});
}
