import 'dart:convert';

import 'package:babylon/constraints.dart';
import 'package:babylon/main.dart';
import 'package:babylon/models/gdsSupplierModel.dart';
import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/bookingDetails.dart';
import 'package:babylon/pages/bookings.dart';
import 'package:babylon/pages/branches.dart';
import 'package:babylon/generalFunctions.dart';
import 'package:babylon/pages/profile.dart';
import 'package:babylon/pages/reports.dart';
import 'package:babylon/svgIcons.dart';
import 'package:babylon/pages/users.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImportPNR extends StatefulWidget {
  final String pnr;
  final String gDSSupplier;
  final String gDSSupplierId;
  const ImportPNR({
    Key key,
    this.pnr,
    this.gDSSupplier,
    this.gDSSupplierId,
  }) : super(key: key);

  @override
  _ImportPNRState createState() => _ImportPNRState(
        this.pnr,
        this.gDSSupplier,
        this.gDSSupplierId,
      );
}

class _ImportPNRState extends State<ImportPNR> {
  String token = "";
  bool loading = false;
  bool showDrawer = false;
  var genFunc = GenFunc();
  List paymentMethodListToSend = [];
  String sessionId = "";
  String aroe = "";
  String cc = "";
  String refNo = "";
  String currency = "";
  List paxList = [];
  List pricing = [];
  List rsegment = [];
  String _pnr = "";
  String _gDSSupplier = "";
  String _gDSSupplierId = "";
  Color cardTextColor = Color(0xFF707070);
  List<GdsSupplierModel> gdsSupplierList = List<GdsSupplierModel>();
  String markup = "0";
  bool pnrExists = false;
  String pnrToDisplay = "";
  String bookingRef = "";
  String dateOfBooking = "";
  String origin = "";
  String destination = "";
  TextEditingController markupController = TextEditingController();

  final pnr;
  final gDSSuppler;
  final gDSSupplierId;
  _ImportPNRState(
    this.pnr,
    this.gDSSuppler,
    this.gDSSupplierId,
  );

  @override
  void initState() {
    super.initState();
    _pnr = pnr;
    _gDSSupplier = gDSSuppler;
    _gDSSupplierId = gDSSupplierId;
    getToken();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        token = prefs.getString('token');
      });
    }
    checkPNRexist();
  }

  checkPNRexist() async {
    setState(() {
      pnrExists = false;
      loading = true;
    });
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest('POST',
        Uri.parse('http://ibeapi.mobile.it4t.in/api/booking/pnrexists'));
    request.fields.addAll({'PNR': '$_pnr', 'GDSSupplier': '$_gDSSupplierId'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      print(body);
      if (body != "" || body != null) {
        if (body["PNRExists"]) {
          setState(() {
            pnrExists = true;
            pnrToDisplay = body["PNR"];
            bookingRef = body["BookingRef"];
            dateOfBooking = body["DateofBooking"];
            origin = body["Origin"];
            destination = body["Destination"];
          });
        } else {
          importPNR();
        }
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  importPNR() async {
    setState(() {
      loading = true;
    });
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest('POST',
        Uri.parse('http://ibeapi.mobile.it4t.in/api/booking/importpnr'));
    request.fields.addAll({'PNR': '$_pnr', 'GDSSupplier': '$_gDSSupplierId'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      print(body);
      if (body != "" || body != null) {
        setState(() {
          sessionId = body["SessionId"];
          aroe = body["AROE"].toString();
          cc = body["CC"];
          refNo = body["SRef"];
          currency = body["Currency"];
          paxList = body["Passengers"];
          pricing = body["CostingDetails"];
          rsegment = body["FlightSegments"];
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(body["Message"]["Desc"]),
          ),
        );
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  getGdsSupplier() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        token = prefs.getString('token');
      });
    }
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://ibeapi.mobile.it4t.in/api/company/supplierforimportpnr'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var dataItems = List<GdsSupplierModel>();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      print(body);
      for (var data in body) {
        dataItems.add(GdsSupplierModel.fromJson(data));
      }
    } else {
      print(response.reasonPhrase);
    }

    return dataItems;
  }

  selectGdsSupplier() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: gdsSupplierList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                setState(
                  () {
                    _gDSSupplier = gdsSupplierList[index].company;
                    _gDSSupplierId = gdsSupplierList[index].supplierId;
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  gdsSupplierList[index].company,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  savePNR() async {
    setState(() {
      loading = true;
    });
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest('POST',
        Uri.parse('http://ibeapi.mobile.it4t.in/api/booking/importpnrsave'));
    request.fields.addAll({
      "SessionId": sessionId,
      "Currency": currency,
      "AROE": aroe,
      "CC": cc,
      "PNR": _pnr,
      "Markup": markup
    });
    debugPrint("session id: " + sessionId);
    debugPrint("currency: " + currency);
    debugPrint("AROE: " + aroe);
    debugPrint("CC: " + cc);
    debugPrint("pnr: " + _pnr);
    debugPrint("markup: " + markup);

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      print(body);
      if (body != "" || body != null) {
        if (body["Code"] == "Success") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookingDetails(
                        bookingId: body["BookingRef"],
                      )));
        } else {
          Navigator.popUntil(context, (route) => false);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(body["Message"]),
          ),
        );
      }
    } else {
      print(response.reasonPhrase);
    }
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
                          left: 10,
                          right: 10,
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
              : pnrExists
                  ? Container(
                      height: screenHeight,
                      child: Stack(
                        children: [
                          //body
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 75,
                                  ),
                                  //PNR
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      color: Colors.white,
                                      child: TextFormField(
                                        initialValue: _pnr,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "PNR",
                                        ),
                                        onChanged: (val) {
                                          if (mounted) {
                                            setState(() {
                                              _pnr = val;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  //Supplier
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 15,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        selectGdsSupplier();
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: _gDSSupplier != "" &&
                                                        _gDSSupplier != null
                                                    ? Text(
                                                        _gDSSupplier,
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                        ),
                                                      )
                                                    : Text(
                                                        "",
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //Search
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 15,
                                    ),
                                    child: Container(
                                      width: screenWidth,
                                      child: MaterialButton(
                                        color: Color.fromRGBO(249, 190, 6, 1),
                                        onPressed: () {
                                          if (_pnr != null ||
                                              _pnr != "" ||
                                              _gDSSupplier != null ||
                                              _gDSSupplier != "") {
                                            checkPNRexist();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Please fill all the required fields"),
                                            ));
                                          }
                                        },
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
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                      left: 15,
                                      right: 15,
                                    ),
                                    child: Container(
                                      color: Colors.grey,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "PNR",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 60,
                                            child: VerticalDivider(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Booking Ref",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 60,
                                            child: VerticalDivider(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Date of booking",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 60,
                                            child: VerticalDivider(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Destination",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Montserrat',
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.grey[400],
                                          ),
                                          bottom: BorderSide(
                                            color: Colors.grey[400],
                                          ),
                                          left: BorderSide(
                                            color: Colors.grey[400],
                                          ),
                                          right: BorderSide(
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                              ),
                                              child: Text(
                                                pnrToDisplay,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            child: VerticalDivider(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              BookingDetails(
                                                                bookingId:
                                                                    bookingRef,
                                                              )));
                                                },
                                                child: Text(
                                                  bookingRef,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            child: VerticalDivider(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                              ),
                                              child: Text(
                                                dateOfBooking,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            child: VerticalDivider(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                              ),
                                              child: Text(
                                                origin + " - " + destination,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
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
                        ],
                      ),
                    )
                  : sessionId == ""
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
                      : Container(
                          height: screenHeight,
                          child: Stack(
                            children: [
                              //body
                              SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 75,
                                      ),
                                      //PNR
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          color: Colors.white,
                                          child: TextFormField(
                                            initialValue: _pnr,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "PNR",
                                            ),
                                            onChanged: (val) {
                                              if (mounted) {
                                                setState(() {
                                                  _pnr = val;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      //Supplier
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                          horizontal: 15,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            selectGdsSupplier();
                                          },
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: _gDSSupplier != "" &&
                                                            _gDSSupplier != null
                                                        ? Text(
                                                            _gDSSupplier,
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                            ),
                                                          )
                                                        : Text(
                                                            "",
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //Search
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 15,
                                        ),
                                        child: Container(
                                          width: screenWidth,
                                          child: MaterialButton(
                                            color:
                                                Color.fromRGBO(249, 190, 6, 1),
                                            onPressed: () {
                                              if (_pnr != null ||
                                                  _pnr != "" ||
                                                  _gDSSupplier != null ||
                                                  _gDSSupplier != "") {
                                                checkPNRexist();
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Please fill all the required fields"),
                                                ));
                                              }
                                            },
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
                                      //passenger
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 12,
                                        ),
                                        child: Card(
                                          child: ExpansionTile(
                                            leading: Icon(
                                              Icons.group_rounded,
                                              color: Colors.yellow[700],
                                            ),
                                            title: Text(
                                              "Travel(s) Details",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                  minHeight: 100,
                                                  maxHeight: 500,
                                                ),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: paxList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Card(
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Name :",
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          cardTextColor,
                                                                    ),
                                                                  ),
                                                                  Text(paxList[
                                                                          index]
                                                                      ["Name"]),
                                                                ],
                                                              ),
                                                            ),
                                                            Divider(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Phone Number :",
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          cardTextColor,
                                                                    ),
                                                                  ),
                                                                  Text(paxList[
                                                                          index]
                                                                      [
                                                                      "PhoneNo"]),
                                                                ],
                                                              ),
                                                            ),
                                                            Divider(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Passport Number :",
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          cardTextColor,
                                                                    ),
                                                                  ),
                                                                  Text(paxList[
                                                                          index]
                                                                      [
                                                                      "PassportNumber"]),
                                                                ],
                                                              ),
                                                            ),
                                                            Divider(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Date of birth :",
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          cardTextColor,
                                                                    ),
                                                                  ),
                                                                  Text(paxList[
                                                                          index]
                                                                      ["DOB"]),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //costing
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 12,
                                        ),
                                        child: Card(
                                          child: ExpansionTile(
                                            leading: Icon(
                                              FontAwesomeIcons.dollarSign,
                                              color: Colors.yellow[700],
                                              size: 20,
                                            ),
                                            title: Text(
                                              "Costing Details",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            children: [
                                              Container(
                                                color: Colors.grey,
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
                                                          "Pax type",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 60,
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
                                                          "Net Price",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 60,
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
                                                          "Gross Price",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 60,
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
                                                          "Profit",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: List.generate(
                                                    pricing.length, (index) {
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                              color: Colors
                                                                  .grey[400],
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
                                                                        .symmetric(
                                                                  horizontal:
                                                                      8.0,
                                                                ),
                                                                child: Text(
                                                                  pricing[index]
                                                                          [
                                                                          "PaxType"] ??
                                                                      "",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 50,
                                                              child:
                                                                  VerticalDivider(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      8.0,
                                                                ),
                                                                child: Text(
                                                                  pricing[index]
                                                                      [
                                                                      "NetPrice"],
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 50,
                                                              child:
                                                                  VerticalDivider(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      8.0,
                                                                ),
                                                                child: Text(
                                                                  pricing[index]
                                                                      [
                                                                      "GrossPrice"],
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              height: 50,
                                                              child:
                                                                  VerticalDivider(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      8.0,
                                                                ),
                                                                child: Text(
                                                                  pricing[index]
                                                                          [
                                                                          "Profit"]
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      index ==
                                                              pricing.length - 1
                                                          ? Column(
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border(
                                                                      top:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .grey[400],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8.0,
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Text(
                                                                                "Additional markup",
                                                                                style: TextStyle(
                                                                                  fontSize: 12.0,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                              Text(
                                                                                "+ $markup $currency markup",
                                                                                style: TextStyle(
                                                                                  fontSize: 12.0,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            VerticalDivider(
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8.0,
                                                                          ),
                                                                          child:
                                                                              TextField(
                                                                            controller:
                                                                                markupController,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              border: OutlineInputBorder(),
                                                                            ),
                                                                            onChanged:
                                                                                (val) {
                                                                              if (val == "") {
                                                                                setState(() {
                                                                                  markup = "0";
                                                                                });
                                                                              } else {
                                                                                setState(() {
                                                                                  markup = val;
                                                                                });
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            VerticalDivider(
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: Padding(
                                                                            padding: const EdgeInsets.symmetric(
                                                                              horizontal: 8.0,
                                                                            ),
                                                                            child: MaterialButton(
                                                                              color: Colors.grey[400],
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  markup = "0";
                                                                                  markupController.text = "0";
                                                                                });
                                                                              },
                                                                              child: Text("Clear"),
                                                                            )),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border(
                                                                      top:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .grey[400],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8.0,
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            "Grand total",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12.0,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            VerticalDivider(
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8.0,
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            pricing[index]["NetPrice"],
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12.0,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            VerticalDivider(
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8.0,
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            (double.parse(pricing[index]["GrossPrice"]) + (double.parse(markup) * paxList.length)).toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12.0,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            VerticalDivider(
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8.0,
                                                                          ),
                                                                          child: markup == "0"
                                                                              ? Text(
                                                                                  pricing[index]["Profit"].toString(),
                                                                                  style: TextStyle(
                                                                                    fontSize: 12.0,
                                                                                  ),
                                                                                  textAlign: TextAlign.center,
                                                                                )
                                                                              : Text(
                                                                                  ((double.parse(pricing[index]["GrossPrice"]) + (double.parse(markup) * paxList.length)) - double.parse(pricing[index]["NetPrice"])).toString(),
                                                                                  style: TextStyle(
                                                                                    fontSize: 12.0,
                                                                                  ),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Container(),
                                                    ],
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //rsegment
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 12,
                                        ),
                                        child: Card(
                                          child: ExpansionTile(
                                            leading: Icon(
                                              FontAwesomeIcons.plane,
                                              color: Colors.yellow[700],
                                              size: 20,
                                            ),
                                            title: Text(
                                              "Flight Itinerary",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Card(
                                                  elevation:
                                                      rsegment.length == 1
                                                          ? 0
                                                          : 5,
                                                  child: Column(
                                                    children: [
                                                      SingleChildScrollView(
                                                        child: Column(
                                                          children:
                                                              List.generate(
                                                            rsegment.length,
                                                            (index) {
                                                              return Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              rsegment[index]["DepartureAirportCode"],
                                                                              style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16.0,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              rsegment[index]["DepartureTime"],
                                                                              style: TextStyle(
                                                                                color: cardTextColor,
                                                                                fontFamily: 'Montserrat-Bold',
                                                                                fontSize: 18.0,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              DateFormat("EEE, dd MMM").format(DateTime.parse(rsegment[index]["DepartureDate"])),
                                                                              style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontSize: 12.0,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              "Terminal: " + rsegment[index]["DepartureTerminal"],
                                                                              style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontSize: 12.0,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          children: [
                                                                            Text(
                                                                              rsegment[index]["ArrivalAirportCode"],
                                                                              style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16.0,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              rsegment[index]["ArrivalTime"],
                                                                              style: TextStyle(
                                                                                color: cardTextColor,
                                                                                fontFamily: 'Montserrat-Bold',
                                                                                fontSize: 18.0,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              DateFormat("EEE, dd MMM").format(DateTime.parse(rsegment[index]["ArrivalDate"])),
                                                                              style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontSize: 12.0,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              "Terminal: " + rsegment[index]["ArrivalTerminal"],
                                                                              style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontSize: 12.0,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  index !=
                                                                          rsegment.length -
                                                                              1
                                                                      ? Column(
                                                                          children: [
                                                                            Divider(
                                                                              color: Colors.red,
                                                                            ),
                                                                            Text("Long stopover",
                                                                                style: TextStyle(
                                                                                  color: Colors.red,
                                                                                )),
                                                                            Divider(
                                                                              color: Colors.red,
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : Container(),
                                                                ],
                                                              );
                                                            },
                                                          ),
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
                                      //Save Button
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: MaterialButton(
                                                color: primaryColor,
                                                onPressed: () {
                                                  savePNR();
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Text(
                                                    "SAVE",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //header
                              Container(
                                height: 75,
                                width: screenWidth,
                                color: Colors.black87,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
