import 'dart:convert';

import 'package:babylon/constraints.dart';
import 'package:babylon/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String agentCode = "";
  String userName = "";
  String password = "";
  bool loading = false;
  bool loginResult;

  login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://ibeapi.mobile.it4t.in/api/login'),
    );
    request.fields.addAll({
      'username': userName,
      'password': password,
      'agentcode': agentCode,
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(data);
      if (data.substring(2, 3) == "R") {
        //login failed
        setState(() {
          loading = false;
          loginResult = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login failed"),
          ),
        );
      } else {
        var body = jsonDecode(data);
        if (body["token"] != null || body["token"] != "") {
          prefs.setString('token', body['token']);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login successfull"),
            ),
          );
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
        }
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Container(
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
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 38.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "LOGIN",
                  style: TextStyle(
                    color: primaryColor,
                    fontFamily: 'Montserrat-Bold',
                    fontSize: 26.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    left: 32.0,
                    right: 32.0,
                  ),
                  child: Container(
                    height: 50.0,
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
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
                        hintText: 'Agent code',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      onChanged: (val) {
                        if (mounted) {
                          setState(() {
                            agentCode = val;
                          });
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    left: 32.0,
                    right: 32.0,
                  ),
                  child: Container(
                    height: 50.0,
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
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
                        hintText: 'User name',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      onChanged: (val) {
                        if (mounted) {
                          setState(() {
                            userName = val;
                          });
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    left: 32.0,
                    right: 32.0,
                  ),
                  child: Container(
                    height: 50.0,
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
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
                        hintText: 'password',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      onChanged: (val) {
                        if (mounted) {
                          setState(() {
                            password = val;
                          });
                        }
                      },
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: Color(0xFF0080ff),
                      fontFamily: 'Montserrat-Medium',
                      fontSize: 15.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight / 4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                  ),
                  child: MaterialButton(
                    color: primaryColor,
                    onPressed: () async {
                      if (agentCode != "" || userName != "" || password != "") {
                        login();
                        setState(() {
                          loading = true;
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "LOGIN",
                            style: TextStyle(
                              fontFamily: 'Montserrat-Bold',
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            "Back to home page",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat-Medium',
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
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
