import 'dart:convert';

import 'package:babylon/main.dart';
import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/bookings.dart';
import 'package:babylon/pages/profile.dart';
import 'package:babylon/pages/reports.dart';
import 'package:babylon/pages/users.dart';
import 'package:babylon/svgIcons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditMarkup extends StatefulWidget {
  final String markupId;
  final String productType;
  final String markup;
  final String markupType;
  final String name;
  const EditMarkup({
    Key key,
    this.markupId,
    this.productType,
    this.markup,
    this.markupType,
    this.name,
  }) : super(key: key);

  @override
  _EditMarkupState createState() => _EditMarkupState(
        this.markupId,
        this.productType,
        this.markup,
        this.markupType,
        this.name,
      );
}

class _EditMarkupState extends State<EditMarkup> {
  String token = "";
  bool loading = false;
  bool showDrawer = false;
  String _productType = "";
  String _markup = "";
  String _markupType = "";
  String _name = "";

  final markupId;
  final productType;
  final markup;
  final markupType;
  final name;

  _EditMarkupState(
    this.markupId,
    this.productType,
    this.markup,
    this.markupType,
    this.name,
  );

  @override
  void initState() {
    super.initState();
    _productType = productType;
    _markup = markup;
    _markupType = markupType;
    _name = name;
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

  editMarkup() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://ibeapi.mobile.it4t.in/api/company/markups'));
    request.fields.addAll({
      'MarkupId': markupId,
      'AgentBranchId': '38',
      'Markup': markup,
      'MarkupType': markupType,
      'Status': '1'
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      var body = jsonDecode(res);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(body["Response"]["Message"])));
      setState(() {
        loading = false;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: showDrawer
          ? AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.black87,
            )
          : AppBar(
              backgroundColor: Colors.black87,
              title: Text(
                "EDIT BRANCH",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat-Bold',
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: 32,
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
                            showDrawer = false;
                          });
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
                              showDrawer = !showDrawer;
                            });
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
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Product type"),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: Container(
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextFormField(
                              initialValue: _productType,
                              textAlignVertical: TextAlignVertical.top,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _productType = val;
                                });
                              },
                            ),
                          ),
                        ),
                        Text("Markup"),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: Container(
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextFormField(
                              initialValue: _markup,
                              textAlignVertical: TextAlignVertical.top,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _markup = val;
                                });
                              },
                            ),
                          ),
                        ),
                        Text("Markup type"),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: Container(
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextFormField(
                              initialValue: _markupType,
                              textAlignVertical: TextAlignVertical.top,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _markupType = val;
                                });
                              },
                            ),
                          ),
                        ),
                        Text("Name"),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: Container(
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextFormField(
                              initialValue: _name,
                              textAlignVertical: TextAlignVertical.top,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _name = val;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth,
                          child: MaterialButton(
                            color: Color.fromRGBO(
                              249,
                              190,
                              6,
                              1,
                            ),
                            onPressed: () {
                              editMarkup();
                              setState(() {
                                loading = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "UPDATE",
                                style: TextStyle(
                                  fontFamily: 'montserrat-Bold',
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
