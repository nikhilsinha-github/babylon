import 'dart:convert';
import 'dart:math';

import 'package:babylon/main.dart';
import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/bookingDetails.dart';
import 'package:babylon/pages/branches.dart';
import 'package:babylon/models/bookingsModel.dart';
import 'package:babylon/pages/profile.dart';
import 'package:babylon/pages/reports.dart';
import 'package:babylon/svgIcons.dart';
import 'package:babylon/pages/users.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bookings extends StatefulWidget {
  @override
  _BookingsState createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  String token = "";
  bool showDrawer = false;
  int index = 0;
  bool filter = false;
  String sessionID = "";
  String storedSessionID = "";
  List<BookingsModel> items = List<BookingsModel>();
  List ai = [];
  int found = 1;
  Color cardTextColor = Color(0xFF707070);

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
    if (items.isEmpty) {
      getBookingData().then((value) {
        if (mounted) {
          setState(() {
            items = value;
          });
        }
      });
    }
  }

  generateDigits(min, max) {
    int n;
    n = min + Random().nextInt(max - min);
    return n;
  }

  generateID() {
    String genNum = "";
    for (var i = 0; i < 4; i++) {
      if (i < 3) {
        genNum = genNum + generateDigits(10000, 99999).toString();
      }
      if (i == 3) {
        genNum = genNum + generateDigits(1000, 9999).toString();
      }
    }
    return genNum;
  }

  getBookingData() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://ibeapi.mobile.it4t.in/api/report/bookings/'));
    request.fields.addAll({
      'bookref': ' ',
      'paxname': '',
      'contactno': '',
      'email': '',
      'pnr': '',
      'status': 'ALL ',
      'tripdatefrom': '',
      'tripdateto': '',
      'bookingdatefrom': '',
      'bookingdateto': ''
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var dataItems = List<BookingsModel>();

    if (response.statusCode == 200) {
      var body = await response.stream.bytesToString();
      if (body != "") {
        var listItems = jsonDecode(body);
        ai = listItems;
        if (ai.isNotEmpty) {
          for (var data in listItems) {
            dataItems.add(BookingsModel.fromJson(data));
          }
          if (mounted) {
            setState(() {
              found = 1;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              found = 0;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            found = 0;
          });
        }
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
      backgroundColor: Colors.grey[200],
      appBar: showDrawer
          ? AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.black87,
              elevation: 0,
            )
          : AppBar(
              backgroundColor: Colors.black87,
              elevation: 0,
              title: Text(
                "BOOKINGS",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat-Bold',
                  fontSize: 20.0,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: 32.0,
                  ),
                  onPressed: () {
                    setState(() {
                      showDrawer = !showDrawer;
                    });
                  },
                ),
              ],
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            filter = !filter;
                          });
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text("Booking Filter"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.tune_rounded,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "My Bookings",
                  style: TextStyle(
                    fontFamily: 'Montserrat-Bold',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: screenHeight - 210,
                child: found == 0
                    ? Center(
                        child: Container(
                          height: screenHeight - 150,
                          child: Text("Sorry!! No results found."),
                        ),
                      )
                    : items.length == 0
                        ? Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.asset(
                                "assets/images/Group 3025.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookingDetails(
                                          bookingId: items[index].bookingRef,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 12,
                                                    bottom: 12,
                                                    left: 8,
                                                    right: 8,
                                                  ),
                                                  child: Text(
                                                    "Lead Pax: " +
                                                        items[index].leadPax,
                                                    style: TextStyle(
                                                      color: cardTextColor,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(
                                                        color: Colors.grey[400],
                                                      ),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 12,
                                                      bottom: 12,
                                                      left: 8,
                                                      right: 8,
                                                    ),
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                "Booking Ref.: ",
                                                            style: TextStyle(
                                                              color:
                                                                  cardTextColor,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: items[index]
                                                                .bookingRef,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Text(
                                                          "Status: " +
                                                              items[index]
                                                                  .status,
                                                          style: TextStyle(
                                                            color:
                                                                cardTextColor,
                                                            fontSize: items[index]
                                                                        .status ==
                                                                    "UnConfirmed"
                                                                ? 13
                                                                : 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 20.0),
                                                      child: CircleAvatar(
                                                        radius: 5,
                                                        backgroundColor: items[
                                                                        index]
                                                                    .status ==
                                                                "Confirmed"
                                                            ? Colors.green
                                                            : items[index]
                                                                        .status ==
                                                                    "UnConfirmed"
                                                                ? Colors
                                                                    .yellow[800]
                                                                : Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(
                                                        color: Colors.grey[400],
                                                      ),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 12,
                                                      bottom: 12,
                                                      left: 8,
                                                      right: 8,
                                                    ),
                                                    child: Text(
                                                      "Supplier Ref.: " +
                                                          items[index]
                                                              .supplierRef,
                                                      style: TextStyle(
                                                        color: cardTextColor,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 12,
                                                    bottom: 12,
                                                    left: 8,
                                                    right: 8,
                                                  ),
                                                  child: Text(
                                                    "Created: " +
                                                        DateFormat(
                                                                "dd MMM yyyy")
                                                            .format(DateTime
                                                                .parse(items[
                                                                        index]
                                                                    .created)),
                                                    style: TextStyle(
                                                      color: cardTextColor,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide(
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 12,
                                                    bottom: 12,
                                                    left: 8,
                                                    right: 8,
                                                  ),
                                                  child: Text(
                                                    "Payment: " +
                                                        items[index]
                                                            .paymentStatus,
                                                    style: TextStyle(
                                                      color: cardTextColor,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 12,
                                                  bottom: 12,
                                                  left: 8,
                                                  right: 8,
                                                ),
                                                child: Text(
                                                  "Deadline: " +
                                                      DateFormat("dd MMM yyyy")
                                                          .format(DateTime
                                                              .parse(items[
                                                                      index]
                                                                  .deadline)),
                                                  style: TextStyle(
                                                    color: cardTextColor,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
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
          filter ? Container() : Container(),
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
                          setState(() {
                            showDrawer = false;
                          });
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
                          setState(() {
                            showDrawer = !showDrawer;
                          });
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
                            setState(() {
                              showDrawer = false;
                            });
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
                            setState(() {
                              showDrawer = false;
                            });
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
                            setState(() {
                              showDrawer = false;
                            });
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
                            setState(() {
                              showDrawer = false;
                            });
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
                            setState(() {
                              showDrawer = false;
                            });
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
              : Container(),
        ],
      ),
    );
  }
}
