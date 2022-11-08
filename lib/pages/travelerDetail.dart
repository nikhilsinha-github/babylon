import 'dart:convert';

import 'package:babylon/main.dart';
import 'package:babylon/models/countryModel.dart';
import 'package:babylon/pages/date_picker.dart';
import 'package:babylon/pages/payment_method.dart';
import 'package:babylon/svgIcons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TravelerDetail extends StatefulWidget {
  final String sessionId;
  final String refNo;
  final String amount;
  final bool passportReq;
  final bool dobReq;
  final bool hesCodeReq;
  final bool idCardReq;
  final bool contactDetailsReq;
  final List paymentMethods;
  final List passengers;
  final String markup;
  final List travelerDetailsRecorded;
  final String baseFare;
  final String taxFee;
  final String total;
  const TravelerDetail({
    Key key,
    this.sessionId,
    this.refNo,
    this.amount,
    this.passportReq,
    this.dobReq,
    this.hesCodeReq,
    this.idCardReq,
    this.contactDetailsReq,
    this.paymentMethods,
    this.passengers,
    this.markup,
    this.travelerDetailsRecorded,
    this.baseFare,
    this.taxFee,
    this.total,
  }) : super(key: key);

  @override
  _TravelerDetailState createState() => _TravelerDetailState(
        this.sessionId,
        this.refNo,
        this.amount,
        this.passportReq,
        this.dobReq,
        this.hesCodeReq,
        this.idCardReq,
        this.contactDetailsReq,
        this.paymentMethods,
        this.passengers,
        this.markup,
        this.travelerDetailsRecorded,
        this.baseFare,
        this.taxFee,
        this.total,
      );
}

class _TravelerDetailState extends State<TravelerDetail> {
  String token = "";
  bool showDrawer = false;
  String dob = "";
  String expiryDate = "";
  List<CountryModel> countryCodeList = List<CountryModel>();

  int pl = 0;
  List travelers = [];
  List travelersDetails = [];
  bool showAllBoxes = false;
  bool showDOBPicker = false;
  bool showExpDatePicker = false;
  bool proceed = false;

  final sessionId;
  final refNo;
  final amount;
  final passportReq;
  final dobReq;
  final hesCodeReq;
  final idCardReq;
  final contactDetailsReq;
  final paymentMethods;
  final passengers;
  final markup;
  final travelerDetailsRecorded;
  final baseFare;
  final taxFee;
  final total;
  _TravelerDetailState(
    this.sessionId,
    this.refNo,
    this.amount,
    this.passportReq,
    this.dobReq,
    this.hesCodeReq,
    this.idCardReq,
    this.contactDetailsReq,
    this.paymentMethods,
    this.passengers,
    this.markup,
    this.travelerDetailsRecorded,
    this.baseFare,
    this.taxFee,
    this.total,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    print(baseFare);
    print(taxFee);
    print(total);
    if (passportReq) {
      setState(() {
        showAllBoxes = true;
      });
    }
    for (var i = 0; i < passengers.length; i++) {
      setState(() {
        pl = pl + int.parse(passengers[i]["PC"]);
      });
    }
    for (var i = 0; i < passengers.length; i++) {
      for (var j = 0; j < int.parse(passengers[i]["PC"]); j++) {
        travelers.add(passengers[i]["PT"]);
      }
    }
    if (travelerDetailsRecorded == null) {
      for (var i = 0; i < pl; i++) {
        travelersDetails.add({
          "Type": "",
          "PaxRef": "SH1",
          "Title": "Mr",
          "FirstName": "",
          "MiddleName": "",
          "LastName": "",
          "DOB": "",
          "DocType": "PP",
          "DocNumber": "",
          "DocExpiry": "",
          "DocIssuingCountry": "",
          "Nationality": "",
          "EmailId": "",
          "Phone": "",
          "DialingCode": "",
          "InfAsso": ""
        });
      }
    } else {
      setState(() {
        travelersDetails = travelerDetailsRecorded;
      });
    }
    if (travelersDetails != null) {
      print(travelersDetails[0]["FirstName"]);
    }
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        token = prefs.getString('token');
      });
    }
  }

  countryCode() async {
    var dataItems = List<CountryModel>();
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var request = http.Request(
        'POST', Uri.parse('http://ibeapi.mobile.it4t.in/api/static/countries'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      print(body.runtimeType);
      for (var data in body) {
        dataItems.add(CountryModel.fromJson(data));
      }
    }

    return dataItems;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    if (countryCodeList.isEmpty) {
      countryCode().then((value) {
        if (mounted) {
          setState(() {
            countryCodeList.addAll(value);
          });
        }
      });
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: showDrawer
          ? AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.black87,
            )
          : AppBar(
              backgroundColor: Colors.black87,
              title: Text(
                "Traveler Detail",
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
                      Padding(
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
              : Container(
                  height: screenHeight,
                  child: ListView.builder(
                      itemCount: pl,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                                left: 10,
                              ),
                              child: Text(
                                "Traveler 1 (${travelers[index]})",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 8,
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                    ),
                                    child: Container(
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              travelersDetails[index]["Title"],
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            DropdownButton(
                                              icon: Icon(
                                                Icons.expand_more,
                                              ),
                                              items: [
                                                'Mr',
                                                'Mrs',
                                              ].map(
                                                (val) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: val,
                                                    child: Text(
                                                      val,
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).toList(),
                                              onChanged: (val) {
                                                setState(
                                                  () {
                                                    travelersDetails[index]
                                                        ["Title"] = val;
                                                  },
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: TextFormField(
                                        initialValue: travelersDetails[index]
                                            ["FirstName"],
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'First Name*',
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            travelersDetails[index]
                                                ["FirstName"] = val;
                                            travelersDetails[index]["Type"] =
                                                travelers[index];
                                            travelersDetails[index]["PaxRef"] =
                                                "SH" + (index + 1).toString();
                                          });
                                          print(travelersDetails);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 5,
                                      ),
                                      child: TextFormField(
                                        initialValue: travelersDetails[index]
                                            ["MiddleName"],
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Middle Name',
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            travelersDetails[index]
                                                ["MiddleName"] = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 10,
                                      ),
                                      child: TextFormField(
                                        initialValue: travelersDetails[index]
                                            ["LastName"],
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Last Name*',
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            travelersDetails[index]
                                                ["LastName"] = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                              ),
                              child: Row(
                                children: [
                                  //Dob
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 5,
                                      ),
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: travelersDetails[index]
                                                        ["DOB"] !=
                                                    ""
                                                ? 0
                                                : 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              IconButton(
                                                icon: FaIcon(
                                                  FontAwesomeIcons.calendarAlt,
                                                  color: Colors.grey,
                                                ),
                                                onPressed: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DatePicker(
                                                        field: "dob",
                                                        i: index,
                                                        sessionId: sessionId,
                                                        refNo: refNo,
                                                        amount: amount,
                                                        passportReq:
                                                            passportReq,
                                                        dobReq: dobReq,
                                                        hesCodeReq: hesCodeReq,
                                                        idCardReq: idCardReq,
                                                        contactDetailsReq:
                                                            contactDetailsReq,
                                                        paymentMethods:
                                                            paymentMethods,
                                                        passengers: passengers,
                                                        travelerDetailsRecorded:
                                                            travelersDetails,
                                                        markup: markup,
                                                        baseFare: baseFare,
                                                        taxFee: taxFee,
                                                        total: total,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DatePicker(
                                                        field: "dob",
                                                        i: index,
                                                        sessionId: sessionId,
                                                        refNo: refNo,
                                                        amount: amount,
                                                        passportReq:
                                                            passportReq,
                                                        dobReq: dobReq,
                                                        hesCodeReq: hesCodeReq,
                                                        idCardReq: idCardReq,
                                                        contactDetailsReq:
                                                            contactDetailsReq,
                                                        paymentMethods:
                                                            paymentMethods,
                                                        passengers: passengers,
                                                        travelerDetailsRecorded:
                                                            travelersDetails,
                                                        markup: markup,
                                                        baseFare: baseFare,
                                                        taxFee: taxFee,
                                                        total: total,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: travelersDetails[index]
                                                                ["DOB"] !=
                                                            "" &&
                                                        dob != null
                                                    ? Center(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator
                                                                .pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        DatePicker(
                                                                  field: "dob",
                                                                  i: index,
                                                                  sessionId:
                                                                      sessionId,
                                                                  refNo: refNo,
                                                                  amount:
                                                                      amount,
                                                                  passportReq:
                                                                      passportReq,
                                                                  dobReq:
                                                                      dobReq,
                                                                  hesCodeReq:
                                                                      hesCodeReq,
                                                                  idCardReq:
                                                                      idCardReq,
                                                                  contactDetailsReq:
                                                                      contactDetailsReq,
                                                                  paymentMethods:
                                                                      paymentMethods,
                                                                  passengers:
                                                                      passengers,
                                                                  travelerDetailsRecorded:
                                                                      travelersDetails,
                                                                  markup:
                                                                      markup,
                                                                  baseFare:
                                                                      baseFare,
                                                                  taxFee:
                                                                      taxFee,
                                                                  total: total,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Text(DateFormat(
                                                                  "dd MMM yyyy")
                                                              .format(DateTime.parse(
                                                                  travelersDetails[
                                                                          index]
                                                                      ["DOB"]))
                                                              .toString()),
                                                        ),
                                                      )
                                                    : Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  "Date of Birth",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: dobReq
                                                                  ? "*"
                                                                  : "",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
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
                                    ),
                                  ),
                                  //Email
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 10,
                                      ),
                                      child: TextFormField(
                                        initialValue: travelersDetails[index]
                                            ["EmailId"],
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Email Address*',
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            travelersDetails[index]["EmailId"] =
                                                val;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Dialing Code & Phone Number
                            showAllBoxes
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        //Dialing Code
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 5,
                                          ),
                                          child: Container(
                                            width: 140,
                                            child: TextFormField(
                                              initialValue:
                                                  travelersDetails[index]
                                                      ["DialingCode"],
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: contactDetailsReq
                                                    ? 'Country Code*'
                                                    : 'Country Code',
                                              ),
                                              onChanged: (val) {
                                                setState(() {
                                                  travelersDetails[index]
                                                      ["DialingCode"] = val;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        //Phone number
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                              right: 10,
                                            ),
                                            child: TextFormField(
                                              initialValue:
                                                  travelersDetails[index]
                                                      ["Phone"],
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Phone Number',
                                              ),
                                              onChanged: (val) {
                                                setState(() {
                                                  travelersDetails[index]
                                                      ["Phone"] = val;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            // Passport Number & Issuing Country
                            showAllBoxes
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        //Passport Number
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 5,
                                            ),
                                            child: TextFormField(
                                              initialValue:
                                                  travelersDetails[index]
                                                      ["DocNumber"],
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: passportReq
                                                    ? 'Passport Number*'
                                                    : 'Passport Number',
                                              ),
                                              onChanged: (val) {
                                                setState(() {
                                                  travelersDetails[index]
                                                      ["DocNumber"] = val;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        //Issuing Country
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                              right: 10,
                                            ),
                                            child: Container(
                                                height: 60.0,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      travelersDetails[index][
                                                                      "DocIssuingCountry"] !=
                                                                  null &&
                                                              travelersDetails[
                                                                          index]
                                                                      [
                                                                      "DocIssuingCountry"] !=
                                                                  ""
                                                          ? Text(
                                                              travelersDetails[
                                                                      index][
                                                                  "DocIssuingCountry"],
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                              ),
                                                            )
                                                          : Text(
                                                              "Issuing country",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                      DropdownButton(
                                                        icon: Icon(
                                                          Icons.expand_more,
                                                        ),
                                                        items:
                                                            countryCodeList.map(
                                                          (val) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: val
                                                                  .countryCode,
                                                              child: Text(
                                                                val.countryCode,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).toList(),
                                                        onChanged: (val) {
                                                          setState(
                                                            () {
                                                              travelersDetails[
                                                                          index]
                                                                      [
                                                                      "DocIssuingCountry"] =
                                                                  val;
                                                            },
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            //Expiry Date & Nationality
                            showAllBoxes
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        //Expiry date
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 5,
                                            ),
                                            child: Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: travelersDetails[index]
                                                              ["DocExpiry"] !=
                                                          ""
                                                      ? 0
                                                      : 10,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    IconButton(
                                                      icon: FaIcon(
                                                        FontAwesomeIcons
                                                            .calendarAlt,
                                                        color: Colors.grey,
                                                      ),
                                                      onPressed: () {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    DatePicker(
                                                              field: "expiry",
                                                              i: index,
                                                              sessionId:
                                                                  sessionId,
                                                              refNo: refNo,
                                                              amount: amount,
                                                              passportReq:
                                                                  passportReq,
                                                              dobReq: dobReq,
                                                              hesCodeReq:
                                                                  hesCodeReq,
                                                              idCardReq:
                                                                  idCardReq,
                                                              contactDetailsReq:
                                                                  contactDetailsReq,
                                                              paymentMethods:
                                                                  paymentMethods,
                                                              passengers:
                                                                  passengers,
                                                              travelerDetailsRecorded:
                                                                  travelersDetails,
                                                              markup: markup,
                                                              baseFare:
                                                                  baseFare,
                                                              taxFee: taxFee,
                                                              total: total,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    DatePicker(
                                                              field: "expiry",
                                                              i: index,
                                                              sessionId:
                                                                  sessionId,
                                                              refNo: refNo,
                                                              amount: amount,
                                                              passportReq:
                                                                  passportReq,
                                                              dobReq: dobReq,
                                                              hesCodeReq:
                                                                  hesCodeReq,
                                                              idCardReq:
                                                                  idCardReq,
                                                              contactDetailsReq:
                                                                  contactDetailsReq,
                                                              paymentMethods:
                                                                  paymentMethods,
                                                              passengers:
                                                                  passengers,
                                                              travelerDetailsRecorded:
                                                                  travelersDetails,
                                                              markup: markup,
                                                              baseFare:
                                                                  baseFare,
                                                              taxFee: taxFee,
                                                              total: total,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: travelersDetails[
                                                                          index]
                                                                      [
                                                                      "DocExpiry"] !=
                                                                  "" &&
                                                              travelersDetails[
                                                                          index]
                                                                      [
                                                                      "DocExpiry"] !=
                                                                  null
                                                          ? Center(
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  Navigator
                                                                      .pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              DatePicker(
                                                                        field:
                                                                            "expiry",
                                                                        i: index,
                                                                        sessionId:
                                                                            sessionId,
                                                                        refNo:
                                                                            refNo,
                                                                        amount:
                                                                            amount,
                                                                        passportReq:
                                                                            passportReq,
                                                                        dobReq:
                                                                            dobReq,
                                                                        hesCodeReq:
                                                                            hesCodeReq,
                                                                        idCardReq:
                                                                            idCardReq,
                                                                        contactDetailsReq:
                                                                            contactDetailsReq,
                                                                        paymentMethods:
                                                                            paymentMethods,
                                                                        passengers:
                                                                            passengers,
                                                                        travelerDetailsRecorded:
                                                                            travelersDetails,
                                                                        markup:
                                                                            markup,
                                                                        baseFare:
                                                                            baseFare,
                                                                        taxFee:
                                                                            taxFee,
                                                                        total:
                                                                            total,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                child: Text(DateFormat(
                                                                        "dd MMM yyyy")
                                                                    .format(DateTime.parse(
                                                                        travelersDetails[index]
                                                                            [
                                                                            "DocExpiry"]))
                                                                    .toString()),
                                                              ),
                                                            )
                                                          : Text(
                                                              "Expiry Date",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        //Nationality
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                              right: 10,
                                            ),
                                            child: Container(
                                                height: 60.0,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      travelersDetails[index][
                                                                      "Nationality"] !=
                                                                  null &&
                                                              travelersDetails[
                                                                          index]
                                                                      [
                                                                      "Nationality"] !=
                                                                  ""
                                                          ? Text(
                                                              travelersDetails[
                                                                      index][
                                                                  "Nationality"],
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                              ),
                                                            )
                                                          : Text(
                                                              "Nationality",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                      DropdownButton(
                                                        icon: Icon(
                                                          Icons.expand_more,
                                                        ),
                                                        items:
                                                            countryCodeList.map(
                                                          (val) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: val
                                                                  .countryCode,
                                                              child: Text(
                                                                val.countryCode,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).toList(),
                                                        onChanged: (value) {
                                                          setState(
                                                            () {
                                                              travelersDetails[
                                                                          index]
                                                                      [
                                                                      "Nationality"] =
                                                                  value;
                                                            },
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            //Expand or not button
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Color.fromRGBO(249, 190, 6, 1),
                                    child: IconButton(
                                      icon: Icon(
                                        showAllBoxes
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          showAllBoxes = !showAllBoxes;
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 250,
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          showAllBoxes = true;
                                        });
                                      },
                                      child: Text(
                                        "Optional Passport Details & Other Preferences",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 40,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        color: Color.fromRGBO(249, 190, 6, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onPressed: () {
                          for (var i = 0; i < pl; i++) {
                            if (travelersDetails[i]["FirstName"] != "" &&
                                travelersDetails[i]["LastName"] != "" &&
                                travelersDetails[i]["DOB"] != "" &&
                                travelersDetails[i]["Email"] != "") {
                              setState(() {
                                proceed = true;
                              });
                            } else {
                              setState(() {
                                proceed = false;
                              });
                            }
                          }
                          if (proceed == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentMethod(
                                  sessionId: sessionId,
                                  refNo: refNo,
                                  amt: amount,
                                  paymentMethods: paymentMethods,
                                  markup: markup,
                                  travelersDetails: travelersDetails,
                                  baseFare: baseFare,
                                  taxFee: taxFee,
                                  total: total,
                                ),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "DONE",
                            style: TextStyle(
                              fontSize: 18,
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
        ],
      ),
    );
  }
}
