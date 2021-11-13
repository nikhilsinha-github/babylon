import 'package:babylon/auth/auth_landing_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  getToken();
  }

  getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(mounted){
      setState(() {
        token = prefs.getString('token');
      });
    }
    navigate();
  }

  navigate() async{
    
    Future.delayed(Duration(seconds: 2), () {
      if(token==null||token==""){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => AuthLandingPage(),
          ),
          (route) => false);
      }
      else{
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Image.asset('assets/images/Group 3025.png'),
      ),
    );
  }
}
