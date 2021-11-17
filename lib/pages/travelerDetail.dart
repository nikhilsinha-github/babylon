import 'package:babylon/main.dart';
import 'package:babylon/pages/date_picker.dart';
import 'package:babylon/pages/payment_method.dart';
import 'package:babylon/svgIcons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

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
  final String dobSelected;
  final String expDate;
  final List passengers;
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
    this.dobSelected,
    this.expDate,
    this.passengers,
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
        this.dobSelected,
        this.expDate,
        this.passengers,
      );
}

class _TravelerDetailState extends State<TravelerDetail> {
  bool showDrawer = false;
  String title = "Mr";
  String firstName = "";
  String middleName = "";
  String lastName = "";
  String dob = "";
  String email = "";
  String dialingCode = "";
  String phoneNo = "";
  String passportNumber = "";
  String country;
  String expiryDate = "";
  String nationality = "";
  Map m = {
    "sessionId": "",
    "refNo": "",
    "amount": "",
    "passportReq": "",
    "dobReq": "",
    "hesCodeReq": "",
    "idCardReq": "",
    "contactDetailsReq": "",
    "paymentMethods": "",
    "dobSelected": "",
    "expDate": "",
    "passengers": "",
  };
  int pl = 0;
  bool showAllBoxes = false;
  bool showDOBPicker = false;
  bool showExpDatePicker = false;

  final sessionId;
  final refNo;
  final amount;
  final passportReq;
  final dobReq;
  final hesCodeReq;
  final idCardReq;
  final contactDetailsReq;
  final paymentMethods;
  final dobSelected;
  final expDate;
  final passengers;
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
    this.dobSelected,
    this.expDate,
    this.passengers,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (passportReq) {
      setState(() {
        showAllBoxes = true;
      });
    }
    if (dobSelected != null || dobSelected != "") {
      setState(() {
        dob = dobSelected;
      });
    }
    if (expDate != null || expDate != "") {
      setState(() {
        expiryDate = expDate;
      });
    }
    for (var i = 0; i < passengers.length; i++) {
      setState(() {
        pl = pl + int.parse(passengers[i]["PC"]);
      });
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(pl, (i) {
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
                              "Traveler 1 (${passengers[i]["PT"]})",
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
                                              title,
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
                                                    title = val;
                                                  },
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'First Name*',
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          firstName = val;
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
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 5,
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Middle Name',
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          middleName = val;
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
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Last Name*',
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          lastName = val;
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
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: dob != "" ? 0 : 10,
                                        ),
                                        child: dob != "" && dob != null
                                            ? Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DatePicker(
                                                          field: "dob",
                                                          sessionId: sessionId,
                                                          refNo: refNo,
                                                          amount: amount,
                                                          passportReq:
                                                              passportReq,
                                                          dobReq: dobReq,
                                                          hesCodeReq:
                                                              hesCodeReq,
                                                          idCardReq: idCardReq,
                                                          contactDetailsReq:
                                                              contactDetailsReq,
                                                          paymentMethods:
                                                              paymentMethods,
                                                          dobSelected: dob,
                                                          expDate: expiryDate,
                                                          passengers:
                                                              passengers,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(DateFormat(
                                                          "dd MMM yyyy")
                                                      .format(
                                                          DateTime.parse(dob))
                                                      .toString()),
                                                ),
                                              )
                                            : Row(
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
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DatePicker(
                                                            field: "dob",
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
                                                            dobSelected: dob,
                                                            expDate: expiryDate,
                                                            passengers:
                                                                passengers,
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
                                                            dobSelected: dob,
                                                            expDate: expiryDate,
                                                            passengers:
                                                                passengers,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Text.rich(
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
                                                              color: Colors.red,
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
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Email Address*',
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          email = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          showAllBoxes
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 5,
                                        ),
                                        child: Container(
                                          width: 140,
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: contactDetailsReq
                                                  ? 'Country Code*'
                                                  : 'Country Code',
                                            ),
                                            onChanged: (val) {
                                              setState(() {
                                                dialingCode = val;
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
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Phone Number',
                                            ),
                                            onChanged: (val) {
                                              setState(() {
                                                phoneNo = val;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          showAllBoxes
                              ? Padding(
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
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: passportReq
                                                  ? 'Passport Number*'
                                                  : 'Passport Number',
                                            ),
                                            onChanged: (val) {
                                              setState(() {
                                                passportNumber = val;
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
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    country != null &&
                                                            country != ""
                                                        ? Text(
                                                            country,
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                            ),
                                                          )
                                                        : Container(),
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
                                                            country = val;
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
                          showAllBoxes
                              ? Padding(
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
                                                left: expiryDate != "" ? 0 : 10,
                                              ),
                                              child: expiryDate != "" &&
                                                      expiryDate != null
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
                                                                field: "expiry",
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
                                                                dobSelected:
                                                                    dob,
                                                                expDate:
                                                                    expiryDate,
                                                                passengers:
                                                                    passengers,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Text(DateFormat(
                                                                "dd MMM yyyy")
                                                            .format(
                                                                DateTime.parse(
                                                                    expiryDate))
                                                            .toString()),
                                                      ),
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
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
                                                                  field:
                                                                      "expiry",
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
                                                                  dobSelected:
                                                                      dob,
                                                                  expDate:
                                                                      expiryDate,
                                                                  passengers:
                                                                      passengers,
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
                                                                  field:
                                                                      "expiry",
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
                                                                  dobSelected:
                                                                      dob,
                                                                  expDate:
                                                                      expiryDate,
                                                                  passengers:
                                                                      passengers,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Text(
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
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5,
                                            right: 10,
                                          ),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Nationality',
                                            ),
                                            onChanged: (val) {
                                              setState(() {
                                                lastName = val;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
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
                    }).toList(),
                  ),
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
                          if (firstName != "" && lastName != "" ||
                              dob != "" ||
                              email != "") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentMethod(
                                  sessionId: sessionId,
                                  refNo: refNo,
                                  amt: amount,
                                  title: title,
                                  firstName: firstName,
                                  middleName: middleName,
                                  lastName: lastName,
                                  dob: dob,
                                  email: email,
                                  dialingCode: dialingCode,
                                  phoneNo: phoneNo,
                                  passportNumber: passportNumber,
                                  paymentMethods: paymentMethods,
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
