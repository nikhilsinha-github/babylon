import 'dart:convert';

import 'package:babylon/main.dart';
import 'package:babylon/models/flightInfoModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Departure extends StatefulWidget {
  final int tripNum;
  final String arrivalPlace;
  final String aCitC;
  final String aConC;
  final DateTime departureDate;
  final DateTime arrivalDate;
  final int adt;
  final int chd;
  final int inf;
  final int tc;

  const Departure({
    Key key,
    this.tripNum,
    this.arrivalPlace,
    this.aCitC,
    this.aConC,
    this.departureDate,
    this.arrivalDate,
    this.adt,
    this.chd,
    this.inf,
    this.tc,
  }) : super(key: key);

  @override
  _DepartureState createState() => _DepartureState(
        this.tripNum,
        this.arrivalPlace,
        this.aCitC,
        this.aConC,
        this.departureDate,
        this.arrivalDate,
        this.adt,
        this.chd,
        this.inf,
        this.tc,
      );
}

class _DepartureState extends State<Departure> {
  final tripNum;
  final arrivalPlace;
  final aCitC;
  final aConC;
  final departureDate;
  final arrivalDate;
  final adt;
  final chd;
  final inf;
  final tc;
  _DepartureState(
    this.tripNum,
    this.arrivalPlace,
    this.aCitC,
    this.aConC,
    this.departureDate,
    this.arrivalDate,
    this.adt,
    this.chd,
    this.inf,
    this.tc,
  );
  String selectedPlace = "";
  String place = "";
  List<FlightInfo> items = List<FlightInfo>();

  getDetails(pre) async {
    var headers = {
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiZDUxOWIxOTlkNDI5ZTdiNGM3Y2FjZTM4ODk1MzQxMmE1YTRkYjYyNGI3MzM5MjJhYzc5NDc1YjYxNjFmZDllZmQ2YTI0Y2YyNjBhMWI4NmQiLCJpYXQiOjE2MjU2NjIzMjcsIm5iZiI6MTYyNTY2MjMyNywiZXhwIjoxNjU3MTk4MzI3LCJzdWIiOiIzNCIsInNjb3BlcyI6W119.m0ZWYeSJao_lTeP701QAtnKtvjFNLg_CkXKOpJVKb3FLTzK1qHVvJZM63WTJlI1H1PDhzcII5uolLcTXHmPWWiBAZTwDjo7FBZg_TgCG1Gf0fAA8WmlnHTmf-4EclFX1-XRUVcrCi_NV6NkLXl4lhqJEZCgCd8-8LEA3EWXIqJS9YUZ9yCqCPL4w3Q6Rz1iL8STlRolmJVj_4npTKFv3NY01R0UMFgYajzPTrFF5XQWmzIXcRxVrmX0wNf11ou01P2KtshjOL-mSdNog_p0vSRR5CRAMm0Q0a1zANbn2WMAy7q8utq9UwQ0mzosxtpgVnnHJxWCvMf2EF4DB_To5nDUq0WX8i-JBLM4gu9aiWK6Jp-1nQHl5xjssIOdfVxhwRnyHhg5QdV6omgMzgMOAfnlGEpFG1BDkXcUqVzttkX2GLeNenvRiljKa0R1x0hl5FIQmQWYqHJgDJWrCGTymjeH574A5nAH4-biQsuHp5tKCDHoy4KZuWhqJGUfCuT-1fvmfSlfRZyrdae_m8tabDVB72YVdQwhrckv_c6s26X3oaQAiCsUdOrz8hXZ2ff-04g0RP9VDFX7pCRbInusuet-BgDQK2lBb-jNjP-IstzJYaNEFcNMJWxQONT8cLvsK69oDXKqzGPeWvng-J3cu92Ie90mZA9gGWf25T1S3cqc'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://ibeapi.mobile.it4t.in/api/static/airports'));
    request.fields.addAll({'prefix': '$pre'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var dataItems = List<FlightInfo>();

    if (response.statusCode == 200) {
      var body = await response.stream.bytesToString();

      var listItems = jsonDecode(body)["Items"];
      for (var data in listItems) {
        dataItems.add(FlightInfo.fromJson(data));
      }
    } else {
      print(response.reasonPhrase);
    }
    return dataItems;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            color: Colors.black87,
            height: 75,
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Departure",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 20,
              left: 10,
              right: 10,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color.fromRGBO(249, 190, 6, 1),
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(Icons.flight_takeoff),
                title: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  onChanged: (val) {
                    setState(() {
                      place = val;
                    });
                    getDetails("$place").then((value) {
                      setState(() {
                        items = [];
                        items.addAll(value);
                      });
                    });
                  },
                ),
              ),
            ),
          ),
          Container(
            height: screenHeight - 200,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPlace =
                          "${items[index].airportCode} - ${items[index].cityName}";
                    });
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            tripNum,
                            selectedPlace,
                            arrivalPlace,
                            "${items[index].cityCode}",
                            "$aCitC",
                            "${items[index].countryCode}#${items[index].cityCode}#${items[index].airportCode}#AS",
                            "$aConC",
                            departureDate,
                            arrivalDate,
                            adt,
                            chd,
                            inf,
                            tc,
                          ),
                        ),
                        (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      bottom: 25,
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "${items[index].airportCode} - ",
                            style: TextStyle(
                              //color: Colors.grey[400],
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: "${items[index].cityName} - ",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: "${items[index].airportName}",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
