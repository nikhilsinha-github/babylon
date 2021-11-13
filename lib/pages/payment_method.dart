import 'dart:convert';

import 'package:babylon/auth/auth_landing_page.dart';
import 'package:babylon/constraints.dart';
import 'package:babylon/models/confirmedBookingModel.dart';
import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/booking_confirmation.dart';
import 'package:babylon/pages/bookings.dart';
import 'package:babylon/pages/branches.dart';
import 'package:babylon/pages/card_payment.dart';
import 'package:babylon/pages/profile.dart';
import 'package:babylon/pages/reports.dart';
import 'package:babylon/pages/users.dart';
import 'package:babylon/svgIcons.dart';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethod extends StatefulWidget {
  final String sessionId;
  final String refNo;
  final String amt;
  final String title;
  final String firstName;
  final String middleName;
  final String lastName;
  final String dob;
  final String email;
  final String passportNumber;
  final String dialingCode;
  final String phoneNo;
  const PaymentMethod({
    Key key,
    this.sessionId,
    this.refNo,
    this.amt,
    this.title,
    this.firstName,
    this.middleName,
    this.lastName,
    this.dob,
    this.email,
    this.passportNumber,
    this.dialingCode,
    this.phoneNo,
  }) : super(key: key);

  @override
  _PaymentMethodState createState() => _PaymentMethodState(
        this.sessionId,
        this.refNo,
        this.amt,
        this.title,
        this.firstName,
        this.middleName,
        this.lastName,
        this.dob,
        this.email,
        this.passportNumber,
        this.dialingCode,
        this.phoneNo,
      );
}

class _PaymentMethodState extends State<PaymentMethod> {
  bool showDrawer = false;
  int index = 1;
  bool loading = false;
  String token = "";
  bool accept = false;
  List payment_method = ["Credit Card", "Wallet", "Hold PNR"];

  final sessionId;
  final refNo;
  final amt;
  final title;
  final firstName;
  final middleName;
  final lastName;
  final dob;
  final email;
  final passportNumber;
  final dialingCode;
  final phoneNo;
  _PaymentMethodState(
    this.sessionId,
    this.refNo,
    this.amt,
    this.title,
    this.firstName,
    this.middleName,
    this.lastName,
    this.dob,
    this.email,
    this.passportNumber,
    this.dialingCode,
    this.phoneNo,
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

  confirmBooking() async {
    var headers = {
      'SessionID': '$sessionId',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('http://ibeapi.mobile.it4t.in/api/flight/flightbooking'));
    request.body = json.encode({
      "BookingRequest": {
        "OfferID": "$refNo",
        "TotalOfferPrice": "",
        "PaymentMethod": "CA",
        "SpotMarkup": "20",
        "Passenger": [
          {
            "Type": "ADT",
            "PaxRef": "SH1",
            "Title": "$title",
            "FirstName": "$firstName",
            "MiddleName": "$middleName",
            "LastName": "$lastName",
            "DOB": "$dob",
            "DocType": "PP",
            "DocNumber": "$passportNumber",
            "DocExpiry": "2020-09-25",
            "DocIssuingCountry": "IN",
            "Nationality": "IN",
            "EmailId": "$email",
            "Phone": "$phoneNo",
            "DialingCode": "$dialingCode",
            "InfAsso": ""
          }
        ]
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(data);
      var body = jsonDecode(data);
      var dataInJson = ConfirmedBookingModel.fromJson(body);
      setState(() {
        loading = false;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmation(
            bookingRef: dataInJson.bookingRef,
            status: dataInJson.queueStatus,
            bookingInfo: dataInJson.bookingInfo,
            paymentMethod: payment_method[index],
          ),
        ),
        (route) => false,
      );
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: showDrawer
          ? AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.black87,
            )
          : AppBar(
              backgroundColor: Colors.black87,
              title: Text(
                "FORM OF PAYMENT",
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
                          if (mounted) {
                            setState(() {
                              showDrawer = false;
                            });
                          }
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
                      GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('token');
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthLandingPage()),
                              (route) => false);
                        },
                        child: Padding(
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
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 25.0,
                    horizontal: 20.0,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 15.0,
                          ),
                          child: Text(
                            'Payment',
                            style: TextStyle(
                              fontFamily: 'Montserrat-Bold',
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomCheckBox(
                              value: index == 0 ? true : false,
                              shouldShowBorder: true,
                              borderColor: Colors.yellow[700],
                              checkedFillColor: Colors.white,
                              checkedIcon: Icons.circle,
                              checkedIconColor: Colors.yellow[700],
                              borderRadius: 50,
                              borderWidth: 2,
                              checkBoxSize: 20,
                              onChanged: (val) {
                                //do your stuff here
                                setState(() {
                                  index = 0;
                                });
                              },
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    index = 0;
                                  });
                                },
                                child: Text(
                                  "Credit Card or Debit Card",
                                  style: TextStyle(
                                    color: Color(0xFF707070),
                                    fontFamily: 'Montserrat-Bold',
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 50.0,
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        'You will be redirected to a payment gateway to pay '),
                                TextSpan(
                                  text: '$amt TL',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomCheckBox(
                              value: index == 1 ? true : false,
                              shouldShowBorder: true,
                              borderColor: Colors.yellow[700],
                              checkedFillColor: Colors.white,
                              checkedIcon: Icons.circle,
                              checkedIconColor: Colors.yellow[700],
                              borderRadius: 50,
                              borderWidth: 2,
                              checkBoxSize: 20,
                              onChanged: (val) {
                                //do your stuff here
                                setState(() {
                                  index = 1;
                                });
                              },
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    index = 1;
                                  });
                                },
                                child: Text(
                                  "Wallet",
                                  style: TextStyle(
                                    color: Color(0xFF707070),
                                    fontFamily: 'Montserrat-Bold',
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 50.0,
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: 'Your current balance is '),
                                TextSpan(
                                  text: '2,450.45 TL',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomCheckBox(
                              value: index == 2 ? true : false,
                              shouldShowBorder: true,
                              borderColor: Colors.yellow[700],
                              checkedFillColor: Colors.white,
                              checkedIcon: Icons.circle,
                              checkedIconColor: Colors.yellow[700],
                              borderRadius: 50,
                              borderWidth: 2,
                              checkBoxSize: 20,
                              onChanged: (val) {
                                //do your stuff here
                                setState(() {
                                  index = 2;
                                });
                              },
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    index = 2;
                                  });
                                },
                                child: Text(
                                  "Hold PNR (Pay later)",
                                  style: TextStyle(
                                    color: Color(0xFF707070),
                                    fontFamily: 'Montserrat-Bold',
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Policies and Terms & Conditions',
                                style: TextStyle(
                                  fontFamily: 'Montserrat-Bold',
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "Please confirm that the names of travelers are accurate.",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "Please also confirm that the dates and times of flight departures are accurate. Tickets are non-transferable and name change on tickets is not permitted. Ticket cost for most airlines is non-refundable (See Fare Rules) and our service fees are non-refundable. All our service fees and taxes are included in the total ticket cost. Date and routing changes will be subject to airline penalties and our service fees. Fares are not guaranteed until ticketed.",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomCheckBox(
                                    value: accept ? true : false,
                                    shouldShowBorder: true,
                                    borderColor: Colors.yellow[800],
                                    checkedFillColor: Colors.white,
                                    checkedIcon: Icons.check,
                                    checkedIconColor: Colors.yellow[800],
                                    borderRadius: 5,
                                    borderWidth: 2,
                                    checkBoxSize: 20,
                                    onChanged: (val) {
                                      //do your stuff here
                                      setState(() {
                                        accept = !accept;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          accept = !accept;
                                        });
                                      },
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "I agree that I have read and accepted Babylon Booking's ",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "Terms and Conditions",
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {},
                                            ),
                                            TextSpan(
                                              text: " and ",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {},
                                            ),
                                            TextSpan(
                                              text: "Privacy Policy.",
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MaterialButton(
                                      color: primaryColor,
                                      onPressed: () {
                                        if (accept) {
                                          setState(() {
                                            loading = true;
                                          });
                                          index == 0
                                              ? Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CardPayment(),
                                                  ),
                                                  (route) => false)
                                              : confirmBooking();
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 18.0,
                                          horizontal: 10.0,
                                        ),
                                        child: Text(
                                          "CONFIRM BOOKING",
                                          style: TextStyle(
                                            fontFamily: 'Montserrat-Bold',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                            ],
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
