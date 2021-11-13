import 'dart:convert';

import 'package:babylon/main.dart';
import 'package:babylon/models/flightCheckoutModel.dart';
import 'package:babylon/pages/additionalMarkup.dart';
import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/bookings.dart';
import 'package:babylon/pages/branches.dart';
import 'package:babylon/pages/extraLuggage.dart';
import 'package:babylon/pages/fareBreakup.dart';
import 'package:babylon/pages/fareRules.dart';
import 'package:babylon/generalFunctions.dart';
import 'package:babylon/pages/profile.dart';
import 'package:babylon/pages/reports.dart';
import 'package:babylon/pages/travelerDetail.dart';
import 'package:babylon/svgIcons.dart';
import 'package:babylon/pages/users.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FlightDetails extends StatefulWidget {
  final String sessionId;
  final String refNo;
  final List rsegment;
  final String amt;
  final Map api;
  final String currency;

  const FlightDetails({
    Key key,
    this.sessionId,
    this.refNo,
    this.rsegment,
    this.amt,
    this.api,
    this.currency,
  }) : super(key: key);
  @override
  _FlightDetailsState createState() => _FlightDetailsState(
        this.sessionId,
        this.refNo,
        this.rsegment,
        this.amt,
        this.api,
        this.currency,
      );
}

class _FlightDetailsState extends State<FlightDetails> {
  String token = "";
  bool loading = false;
  bool showDrawer = false;
  var genFunc = GenFunc();

  final sessionId;
  final refNo;
  final rsegment;
  final amt;
  final api;
  final currency;
  _FlightDetailsState(
    this.sessionId,
    this.refNo,
    this.rsegment,
    this.amt,
    this.api,
    this.currency,
  );

  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        token = prefs.getString('token');
      });
    }
  }

  flightCheckout() async {
    var headers = {
      'Authorization': 'Bearer $token',
      'SessionID': '$sessionId',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://ibeapi.mobile.it4t.in/api/flight/checkout'));
    request.fields.addAll({
      'OfferID': '$refNo',
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(data);
      var body = jsonDecode(data);
      var dataInJson = FlightCheckoutModel.fromJson(body);
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(dataInJson.message["Desc"]),
        ),
      );
      if (dataInJson.message["Code"] == "SUCCESS") {
        //booking confirmed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TravelerDetail(
              sessionId: sessionId,
              refNo: refNo,
              amount: amt,
            ),
          ),
        );
      }
      //booking not confirmed
      else {}
    } else {
      print(response.reasonPhrase);
    }
  }

  getDelayTime(String delayTime, String layoverPlace) {
    var hr = "";
    var min = "";
    if (delayTime.substring(1, 2) == ":") {
      hr = delayTime.substring(0, 1);
      min = delayTime.substring(2, 4);
    } else {
      hr = delayTime.substring(0, 2);
      min = delayTime.substring(3, 5);
    }

    return Text(
      hr + "hr " + min + "min " + "Layover in $layoverPlace",
      style: TextStyle(
        color: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          (showDrawer)
              ? Container(
                  width: screenWidth,
                  height: screenHeight,
                  color: Colors.black,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          right: 10,
                          bottom: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Logo
                            Padding(
                              padding: EdgeInsets.only(
                                left: 25,
                              ),
                              child: Container(
                                child: Image.asset(
                                  "assets/images/babylon logo - white-03.png",
                                ),
                              ),
                            ),
                            //close icon
                            IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed: () {
                                setState(() {
                                  showDrawer = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  1,
                                  "Country, City, Airport",
                                  "Country, City, Airport",
                                  "",
                                  "",
                                  "",
                                  "",
                                  DateTime(2000),
                                  DateTime(2000),
                                  1,
                                  0,
                                  0,
                                  0,
                                ),
                              ),
                              (route) => false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.speed,
                              color: Colors.white,
                            ),
                            title: Text(
                              "Dashboard",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        indent: 32,
                        endIndent: 32,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Bookings()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                            ),
                            title: Text(
                              "Bookings",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        indent: 32,
                        endIndent: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Reports()));
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.equalizer_rounded,
                              color: Colors.white,
                            ),
                            title: Text(
                              "Reports",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        indent: 32,
                        endIndent: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile()));
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                            ),
                            title: Text(
                              "My Profile",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        indent: 32,
                        endIndent: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AgencyInfo()));
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.info_outline,
                              color: Colors.white,
                            ),
                            title: Text(
                              "Agency Information",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        indent: 32,
                        endIndent: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Branches()));
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.speed,
                              color: Colors.white,
                            ),
                            title: Text(
                              "Branch Management",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        indent: 32,
                        endIndent: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Users()));
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.speed,
                              color: Colors.white,
                            ),
                            title: Text(
                              "User Management",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        indent: 32,
                        endIndent: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          title: Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        indent: 32,
                        endIndent: 32,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  whiteCurrency,
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Currency",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.expand_more,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              child: VerticalDivider(
                                color: Colors.grey,
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  metroLanguage,
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Language",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.expand_more,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  height: screenHeight,
                  child: Stack(
                    children: [
                      //header
                      Container(
                        height: 75,
                        width: screenWidth,
                        color: Colors.black87,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Image.asset(
                                "assets/images/babylon logo - white-03.png"),
                            IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    showDrawer = true;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      //body
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 75,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: rsegment.length + 1,
                          itemBuilder: (context, index) {
                            return index != rsegment.length
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Card(
                                      child: Column(
                                        children: [
                                          //Row 1
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                //Column 1
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(rsegment[index]
                                                              ["Org"] +
                                                          "-" +
                                                          rsegment[index]
                                                              ["Dest"]),
                                                      Text(DateFormat(
                                                              "EEE, dd MMM")
                                                          .format(DateTime.parse(
                                                              rsegment[index][
                                                                          "GSeg"]
                                                                      ["ASeg"]
                                                                  [0]["DDat"]))
                                                          .toString()),
                                                    ]),
                                                //Column 2
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    genFunc.getDuration(
                                                        rsegment[index]["GSeg"]
                                                            ["Dur"]),
                                                    Text((rsegment[index]["GSeg"]
                                                                        ["ASeg"]
                                                                    .length -
                                                                1)
                                                            .toString() +
                                                        " stop"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.grey,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: List.generate(
                                                  rsegment[index]["GSeg"]
                                                          ["ASeg"]
                                                      .length, (index1) {
                                                return Column(
                                                  children: [
                                                    Center(
                                                      child: Column(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                              "https://babylonxtra.com/images/flightimages/sm/sm${rsegment[index]["GSeg"]["ASeg"][0]["OC"]}.gif",
                                                            ),
                                                          ),
                                                          Text("Airways Name"),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(rsegment[index]
                                                                        ["GSeg"]
                                                                    ["ASeg"][
                                                                index1]["DApot"]),
                                                            Text(rsegment[index]
                                                                        ["GSeg"]
                                                                    ["ASeg"][
                                                                index1]["DTim"]),
                                                            Text(rsegment[index]
                                                                        ["GSeg"]
                                                                    ["ASeg"][
                                                                index1]["DDat"]),
                                                            Text("Terminal: " +
                                                                rsegment[index][
                                                                            "GSeg"]
                                                                        ["ASeg"]
                                                                    [
                                                                    index1]["DTer"]),
                                                          ],
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(rsegment[index]
                                                                        ["GSeg"]
                                                                    ["ASeg"][
                                                                index1]["AApot"]),
                                                            Text(rsegment[index]
                                                                        ["GSeg"]
                                                                    ["ASeg"][
                                                                index1]["ATim"]),
                                                            Text(rsegment[index]
                                                                        ["GSeg"]
                                                                    ["ASeg"][
                                                                index1]["ADat"]),
                                                            Text("Terminal: " +
                                                                rsegment[index][
                                                                            "GSeg"]
                                                                        ["ASeg"]
                                                                    [
                                                                    index1]["ATer"]),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    index1 !=
                                                            rsegment[index]["GSeg"]
                                                                        ["ASeg"]
                                                                    .length -
                                                                1
                                                        ? Container(
                                                            child: Column(
                                                              children: [
                                                                Divider(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                getDelayTime(
                                                                    DateFormat(
                                                                            "yyyy-MM-dd hh:mm")
                                                                        .parse(rsegment[index]["GSeg"]["ASeg"][index1 + 1]["DDat"] +
                                                                            " " +
                                                                            rsegment[index]["GSeg"]["ASeg"][index1 + 1][
                                                                                "DTim"])
                                                                        .difference(DateFormat("yyyy-MM-dd hh:mm").parse(rsegment[index]["GSeg"]["ASeg"][index1]["ADat"] +
                                                                            " " +
                                                                            rsegment[index]["GSeg"]["ASeg"][index1]["ATim"]))
                                                                        .toString(),
                                                                    rsegment[index]["GSeg"]["ASeg"][index1]["AApot"]),
                                                                Divider(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                );
                                              }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Card(
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              FareBreakup(
                                                                currency:
                                                                    currency,
                                                                baseFare:
                                                                    api["TBF"],
                                                                tax: api["TT"],
                                                                total:
                                                                    api["TGP"],
                                                              )));
                                                },
                                                child: Text("Fare Breakup"),
                                              ),
                                            ),
                                            Card(
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              FareRules()));
                                                },
                                                child: Text("Fare Rules"),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdditionalMarkup(
                                                              currency:
                                                                  currency,
                                                              baseFare:
                                                                  api["TBF"],
                                                              tax: api["TT"],
                                                              total: api["TGP"],
                                                            )));
                                              },
                                              icon: Icon(
                                                Icons.add_circle_rounded,
                                                color: Colors.yellow[700],
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdditionalMarkup(
                                                              currency:
                                                                  currency,
                                                              baseFare:
                                                                  api["TBF"],
                                                              tax: api["TT"],
                                                              total: api["TGP"],
                                                            )));
                                              },
                                              child: Text(
                                                "Add Additional Markup?",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ExtraLuggage()));
                                              },
                                              icon: Icon(
                                                Icons.add_circle_rounded,
                                                color: Colors.yellow[700],
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ExtraLuggage()));
                                              },
                                              child: Text(
                                                "Add Extra Luggage?",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 100,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: 20,
                                            bottom: 20,
                                            left: 20,
                                            right: 20,
                                          ),
                                          child: MaterialButton(
                                            color: Colors.yellow[700],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                loading = true;
                                              });
                                              flightCheckout();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      amt,
                                                      style: TextStyle(),
                                                    ),
                                                    Text("$currency"),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("SELECT"),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
          loading
              ? Container(
                  height: screenHeight,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Image.asset(
                    'assets/images/Group 3025.png',
                    height: screenHeight,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
