import 'package:babylon/auth/auth_landing_page.dart';
import 'package:babylon/constraints.dart';
import 'package:babylon/main.dart';
import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/bookings.dart';
import 'package:babylon/pages/branches.dart';
import 'package:babylon/pages/profile.dart';
import 'package:babylon/pages/reports.dart';
import 'package:babylon/pages/users.dart';
import 'package:babylon/svgIcons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingConfirmation extends StatefulWidget {
  final String bookingRef;
  final String status;
  final Map bookingInfo;
  final String paymentMethod;
  const BookingConfirmation({
    Key key,
    this.bookingRef,
    this.status,
    this.bookingInfo,
    this.paymentMethod,
  }) : super(key: key);

  @override
  _BookingConfirmationState createState() => _BookingConfirmationState(
        this.bookingRef,
        this.status,
        this.bookingInfo,
        this.paymentMethod,
      );
}

class _BookingConfirmationState extends State<BookingConfirmation> {
  bool showDrawer = false;
  int index = 0;

  final bookingRef;
  final status;
  final bookingInfo;
  final paymentMethod;
  _BookingConfirmationState(
    this.bookingRef,
    this.status,
    this.bookingInfo,
    this.paymentMethod,
  );

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
                "Confirmation",
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
                          showDrawer = false;
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Reports()));
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 40.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Booking Confirmed",
                        style: TextStyle(
                          fontFamily: "Montserrat-Bold",
                          fontSize: 16.0,
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
                                  "Thank you for booking with us! Your booking reference number for further communication is  "),
                          TextSpan(
                            text: "$bookingRef ",
                            style: TextStyle(
                              fontFamily: "Montserrat-Bold",
                              color: Color(0xFF707070),
                            ),
                          ),
                          TextSpan(
                              text:
                                  "An email has been sent to your provided email address."),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: "Payment method: "),
                                TextSpan(
                                  text: "$paymentMethod",
                                  style: TextStyle(
                                    fontFamily: "Montserrat-Bold",
                                    color: Color(0xFF707070),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: "Reservation Status: "),
                                TextSpan(
                                  text: "On Hold",
                                  style: TextStyle(
                                    fontFamily: "Montserrat-Bold",
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Icon(Icons.error_sharp),
                      Text(
                        "Pending Payment",
                        style: TextStyle(
                          fontFamily: "Montserrat-Bold",
                          color: Color(0xFF707070),
                          fontSize: 16.0,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Price Breakup",
                    style: TextStyle(
                      fontFamily: "Montserrat-Bold",
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Base Fare"),
                      Text(" 288.83"),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Base Fare"),
                      Text(" 288.83"),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Amount",
                        style: TextStyle(
                          color: Color(0xFF707070),
                          fontFamily: "Montserrat-Bold",
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        " 288.83",
                        style: TextStyle(
                          color: Color(0xFF707070),
                          fontFamily: "Montserrat-Bold",
                          fontSize: 16.0,
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
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Booking Detail",
                              style: TextStyle(
                                color: Color(0xFF707070),
                                fontSize: 16.0,
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
                  Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          color: primaryColor,
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()),
                                (route) => false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 18.0,
                              horizontal: 10.0,
                            ),
                            child: Text(
                              "GO TO DASHBOARD",
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
    );
  }
}
