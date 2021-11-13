import 'dart:convert';

import 'package:babylon/main.dart';
import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/bookings.dart';
import 'package:babylon/pages/branches.dart';
import 'package:babylon/models/ledgerReportModel.dart';
import 'package:babylon/pages/profile.dart';
import 'package:babylon/svgIcons.dart';
import 'package:babylon/pages/users.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  String token = "";
  String currency = "";
  String remainingBalance = "";
  bool showDrawer = false;
  int index = 0;
  List<LedgerReportModel> items = List<LedgerReportModel>();

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
      getLedgerReport().then((value) {
        if (mounted) {
          setState(() {
            items = value;
          });
        }
      });
    }
    getBalance();
  }

  getBalance() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://ibeapi.mobile.it4t.in/api/company/remaingcreditlimit'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      print(body);
      if (mounted) {
        setState(() {
          currency = body["Currency"].toString();
          remainingBalance = body["RemaingCreditLimit"].toString();
        });
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  getLedgerReport() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://ibeapi.mobile.it4t.in/api/report/ledgers'));
    request.fields.addAll({'from': '2021-06-01', 'to': '2021-07-19'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var dataItems = List<LedgerReportModel>();

    if (response.statusCode == 200) {
      var body = await response.stream.bytesToString();
      var responseItems = jsonDecode(body);
      for (var data in responseItems) {
        dataItems.add(LedgerReportModel.fromJson(data));
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
      backgroundColor: Colors.grey[300],
      appBar: showDrawer
          ? AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.black87,
            )
          : AppBar(
              backgroundColor: Colors.black87,
              title: Text(
                "REPORTS",
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
      body: (showDrawer)
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
                        showDrawer = false;
                      });
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Bookings()));
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
                          showDrawer = !showDrawer;
                        });
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Profile()));
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Users()));
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
          : ListView(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 15.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 0;
                            });
                          },
                          child: Card(
                            child: Container(
                              decoration: index == 0
                                  ? BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    )
                                  : BoxDecoration(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18.0,
                                  horizontal: 20.0,
                                ),
                                child: Text(
                                  "Ledger Report",
                                  style: TextStyle(
                                    color:
                                        index == 0 ? Colors.black : Colors.grey,
                                    fontFamily: 'Montserrat-Bold',
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // setState(() {
                            //   index = 1;
                            // });
                          },
                          child: Card(
                            child: Container(
                              decoration: index == 1
                                  ? BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    )
                                  : BoxDecoration(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18.0,
                                  horizontal: 20.0,
                                ),
                                child: Text(
                                  "Sales Report",
                                  style: TextStyle(
                                    color:
                                        index == 1 ? Colors.black : Colors.grey,
                                    fontFamily: 'Montserrat-Bold',
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                index == 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      "BALANCE",
                                      style: TextStyle(),
                                    ),
                                    subtitle:
                                        Text(currency + " " + remainingBalance),
                                    trailing: CircleAvatar(
                                      radius: 28,
                                      backgroundColor:
                                          Color.fromRGBO(249, 190, 6, 1),
                                      child: Text(
                                        String.fromCharCodes(Runes('\u0024')),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: screenHeight / 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  //Bookign From
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        left: 15,
                                        right: 5,
                                      ),
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.solidCalendarAlt,
                                              color: Colors.black87,
                                            ),
                                            Text(
                                              "Booking (From)",
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  //Booking To
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        left: 5,
                                        right: 15,
                                      ),
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.solidCalendarAlt,
                                              color: Colors.black87,
                                            ),
                                            Text(
                                              "Booking (To)",
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //Search Box
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 20,
                                  bottom: 20,
                                  left: 15,
                                  right: 15,
                                ),
                                child: Container(
                                  width: screenWidth,
                                  child: MaterialButton(
                                    color: Color.fromRGBO(249, 190, 6, 1),
                                    onPressed: () {},
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 12,
                                        right: 12,
                                      ),
                                      child: Text(
                                        "SEARCH",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "Ledgers",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: screenHeight - 400,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0.0, 1.0), //(x,y)
                                              blurRadius: 6.0,
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                color: Colors.grey[800],
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Credit",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 28,
                                                      child: VerticalDivider(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Debit",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 28,
                                                      child: VerticalDivider(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Balance",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Colors.grey[300],
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "-2,912.23 " +
                                                              String.fromCharCodes(
                                                                  Runes(
                                                                      '\u0024')),
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 30,
                                                      child: VerticalDivider(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "0.00 " +
                                                              String.fromCharCodes(
                                                                  Runes(
                                                                      '\u0024')),
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 30,
                                                      child: VerticalDivider(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "0.00 " +
                                                              String.fromCharCodes(
                                                                  Runes(
                                                                      '\u0024')),
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Branch: Moonline Suli",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              Divider(),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Date & Time: 29 Aug 2020 - 13:52:47",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              Divider(),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            "Remarks: Booking Reference is: ",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: "300246",
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
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
                        ),
                      )
                    : Container(),
                index == 1 ? Container() : Container(),
              ],
            ),
    );
  }
}
