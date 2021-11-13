import 'package:babylon/auth/login_page.dart';
import 'package:babylon/constraints.dart';
import 'package:babylon/svgIcons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthLandingPage extends StatefulWidget {
  @override
  _AuthLandingPageState createState() => _AuthLandingPageState();
}

class _AuthLandingPageState extends State<AuthLandingPage> {
  bool showMenu = false;
  bool showAboutUs = false;
  bool showPartnership = false;
  bool showLanguage = false;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 0.0,
      ),
      body: showMenu
          ? Container(
              height: screenHeight,
              color: Colors.black,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/images/babylon logo - white-03.png',
                            height: 50,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                showMenu = false;
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 40.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showAboutUs = !showAboutUs;
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              "About us",
                              style: TextStyle(
                                color:
                                    showAboutUs ? primaryColor : Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Icon(
                              showAboutUs
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: showAboutUs ? primaryColor : Colors.white,
                              size: 35.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        color: Colors.grey,
                        indent: 15.0,
                        endIndent: 15.0,
                      ),
                    ),
                    showAboutUs
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: 25.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 20.0,
                                  ),
                                  child: Text(
                                    'Who we are',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Divider(
                                    color: Colors.grey,
                                    endIndent: 22.0,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 20.0,
                                  ),
                                  child: Text(
                                    'Why us?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Divider(
                                    color: Colors.grey,
                                    endIndent: 22.0,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 20.0,
                                  ),
                                  child: Text(
                                    'Terms & Locations',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Divider(
                                    color: Colors.grey,
                                    endIndent: 22.0,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 20.0,
                                  ),
                                  child: Text(
                                    'Partners & Events',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Divider(
                                    color: Colors.grey,
                                    endIndent: 22.0,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Blog",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 8.0,
                      ),
                      child: Divider(
                        color: Colors.grey,
                        indent: 15.0,
                        endIndent: 15.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 25.0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showPartnership = !showPartnership;
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              "Partnership",
                              style: TextStyle(
                                color: showPartnership
                                    ? primaryColor
                                    : Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Icon(
                              showPartnership
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color:
                                  showPartnership ? primaryColor : Colors.white,
                              size: 35.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        color: Colors.grey,
                        indent: 15.0,
                        endIndent: 15.0,
                      ),
                    ),
                    showPartnership
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: 25.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 20.0,
                                  ),
                                  child: Text(
                                    'Stream by babylon',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Divider(
                                    color: Colors.grey,
                                    endIndent: 22.0,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 20.0,
                                  ),
                                  child: Text(
                                    'Become a GSA',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Divider(
                                    color: Colors.grey,
                                    endIndent: 22.0,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 20.0,
                                  ),
                                  child: Text(
                                    'Go franchising',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Divider(
                                    color: Colors.grey,
                                    endIndent: 22.0,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Gallery",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 8.0,
                      ),
                      child: Divider(
                        color: Colors.grey,
                        indent: 15.0,
                        endIndent: 15.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Contact us",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 8.0,
                      ),
                      child: Divider(
                        color: Colors.grey,
                        indent: 15.0,
                        endIndent: 15.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 25.0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showLanguage = !showLanguage;
                          });
                        },
                        child: Row(
                          children: [
                            metroLanguage,
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Language",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Icon(
                              showLanguage
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: Colors.white,
                              size: 35.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        color: Colors.grey,
                        indent: 15.0,
                        endIndent: 15.0,
                      ),
                    ),
                    showLanguage
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'En',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: 'Montserrat-Bold',
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              Container(
                                height: 32.0,
                                child: VerticalDivider(
                                  color: Colors.grey,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Ar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat-Bold',
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              Container(
                                height: 32.0,
                                child: VerticalDivider(
                                  color: Colors.grey,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Tr',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat-Bold',
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 800.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/home-header.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                  'assets/images/babylon logo - white-03.png'),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    showMenu = true;
                                  });
                                },
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 32.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 140.0,
                        ),
                        Text(
                          "THE PLATFORM WHERE",
                          style: TextStyle(
                            color: primaryColor,
                            fontFamily: 'Montserrat-Bold',
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "BEST AIRFARE PRICES LAND",
                          style: TextStyle(
                            color: primaryColor,
                            fontFamily: 'Montserrat-Bold',
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Divider(
                          color: primaryColor,
                          thickness: 0.8,
                          indent: 20.0,
                          endIndent: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                            left: 10.0,
                            right: 10.0,
                          ),
                          child: Text(
                            "A state of the Art Travel technology that unites all airlines with access to lowest fares possible in one single platform. Global, yet Local.",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight / 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 60.0,
                            right: 60.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: MaterialButton(
                                  color: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                        ),
                                        Text(
                                          "LOGIN",
                                          style: TextStyle(
                                            fontFamily: 'Montserrat-Bold',
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: MaterialButton(
                                  color: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  onPressed: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 10.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person_add,
                                        ),
                                        Text(
                                          "REGISTER",
                                          style: TextStyle(
                                            fontFamily: 'Montserrat-Bold',
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
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
                ],
              ),
            ),
    );
  }
}
