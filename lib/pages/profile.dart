import 'dart:convert';

import 'package:babylon/main.dart';
import 'package:babylon/models/profileModel.dart';
import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/bookings.dart';
import 'package:babylon/pages/branches.dart';
import 'package:babylon/models/activityModel.dart';
import 'package:babylon/pages/reports.dart';
import 'package:babylon/svgIcons.dart';
import 'package:babylon/pages/users.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var _formKey = GlobalKey<FormState>();

  String token = "";
  bool showDrawer = false;
  int index = 0;
  List<ProfileModel> profileItems = List<ProfileModel>();
  List<ActivityModel> items = List<ActivityModel>();
  bool profileFound = false;
  String firstName = "";
  String middleName = "";
  String lastName = "";
  String email = "";
  String oldPass = "";
  String newPass = "";
  String confirmPass = "";
  bool emailValidated = true;

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
      getActivity().then((value) {
        if (mounted) {
          setState(() {
            items = value;
          });
        }
      });
    }
    if (profileItems.isEmpty) {
      getProfile().then((value) {
        if (mounted) {
          setState(() {
            profileItems = value;
            profileFound = true;
            firstName = profileItems[0].firstName;
            middleName = profileItems[0].middleName;
            lastName = profileItems[0].lastName;
            email = profileItems[0].email;
          });
        }
      });
    }
  }

  getProfile() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET',
        Uri.parse('http://ibeapi.mobile.it4t.in/api/company/userprofile'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var dataItems = List<ProfileModel>();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      dataItems.add(ProfileModel.fromJson(body));
    } else {
      print(response.reasonPhrase);
    }

    return dataItems;
  }

  updateProfile() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest('POST',
        Uri.parse('http://ibeapi.mobile.it4t.in/api/company/userprofile'));
    request.fields.addAll({
      'Title': ' Mr',
      'FirstName': '$firstName',
      'MiddleName': '$middleName',
      'LastName': '$lastName',
      'Mobile': ' 7897620770',
      'Email': '$email',
      'DOB': ' 01-04-2009',
      'CountryCode': ' IN',
      'CityCode': ' 151615',
      'Address': ' sector63',
      'State': ' up',
      'PostCode': ' 201301'
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(body["Response"]["Message"]),
        ),
      );
    } else {
      print(response.reasonPhrase);
    }
  }

  getActivity() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET',
        Uri.parse('http://ibeapi.mobile.it4t.in/api/report/userhistory'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var dataItems = List<ActivityModel>();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      for (var data in body) {
        dataItems.add(ActivityModel.fromJson(data));
      }
    } else {
      print(response.reasonPhrase);
    }

    return dataItems;
  }

  changePassword() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest('POST',
        Uri.parse('http://ibeapi.mobile.it4t.in/api/company/changepassword'));
    request.fields.addAll({
      'oldpass': '$oldPass',
      'newpass': '$newPass',
      'cpass': '$confirmPass'
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(body["Response"]["Message"]),
        ),
      );
    } else {
      print(response.reasonPhrase);
    }
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
                "PROFILE",
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
      body: Form(
        key: _formKey,
        child: (showDrawer)
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
                            showDrawer = !showDrawer;
                          });
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
            : ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                index = 0;
                              });
                            },
                            child: Card(
                              elevation: 0,
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
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  child: Text(
                                    "Profile",
                                    style: TextStyle(
                                      color: index == 0
                                          ? Colors.black
                                          : Colors.grey,
                                      fontFamily: 'Montserrat-Bold',
                                      fontSize: 16.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                index = 1;
                              });
                            },
                            child: Card(
                              elevation: 0,
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
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  child: Text(
                                    "Password",
                                    style: TextStyle(
                                      color: index == 1
                                          ? Colors.black
                                          : Colors.grey,
                                      fontFamily: 'Montserrat-Bold',
                                      fontSize: 16.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                index = 2;
                              });
                            },
                            child: Card(
                              elevation: 0,
                              child: Container(
                                decoration: index == 2
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
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  child: Text(
                                    "Activity",
                                    style: TextStyle(
                                      color: index == 2
                                          ? Colors.black
                                          : Colors.grey,
                                      fontFamily: 'Montserrat-Bold',
                                      fontSize: 16.0,
                                    ),
                                    textAlign: TextAlign.center,
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
                      ? profileFound == false
                          ? Container(
                              height: screenHeight - 200,
                              child: Center(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: Image.asset(
                                    "assets/images/Group 3025.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                        bottom: 10,
                                      ),
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 50,
                                            backgroundColor:
                                                Color.fromRGBO(249, 190, 6, 1)
                                                    .withOpacity(0.2),
                                          ),
                                          Positioned(
                                            bottom: 1,
                                            right: 1,
                                            child: Container(
                                              child: CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Color.fromRGBO(
                                                    249, 190, 6, 1),
                                                child: Center(
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      size: 18,
                                                      color: Colors.black,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "First Name",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: TextFormField(
                                          initialValue: firstName,
                                          textAlignVertical:
                                              TextAlignVertical.bottom,
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
                                            hintText: firstName,
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                          onChanged: (val) {
                                            setState(() {
                                              firstName = val;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Middle Name",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: TextFormField(
                                          initialValue: middleName,
                                          textAlignVertical:
                                              TextAlignVertical.bottom,
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
                                            hintText: middleName,
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                          onChanged: (val) {
                                            setState(() {
                                              middleName = val;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "last Name",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: TextFormField(
                                          initialValue: lastName,
                                          textAlignVertical:
                                              TextAlignVertical.bottom,
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
                                            hintText: lastName,
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                          onChanged: (val) {
                                            setState(() {
                                              lastName = val;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Email",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 8.0,
                                      ),
                                      child: Container(
                                        height: emailValidated ? 40 : 60.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: TextFormField(
                                          initialValue: email ?? "",
                                          textAlignVertical:
                                              TextAlignVertical.top,
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
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          onChanged: (val) {
                                            setState(() {
                                              email = val;
                                              _formKey.currentState.validate();
                                            });
                                          },
                                          validator: (String _email) {
                                            if (EmailValidator.validate(
                                                    _email) ==
                                                true) {
                                              if (mounted) {
                                                setState(() {
                                                  emailValidated = true;
                                                });
                                              }
                                              return null;
                                            } else {
                                              setState(() {
                                                emailValidated = false;
                                              });
                                              return "Please enter a valid email address";
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                        bottom: 20,
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: MaterialButton(
                                              color: Color.fromRGBO(
                                                  249, 190, 6, 1),
                                              onPressed: () {
                                                if (firstName == null ||
                                                    firstName == "" ||
                                                    middleName == null ||
                                                    middleName == "" ||
                                                    lastName == null ||
                                                    lastName == "" ||
                                                    email == null ||
                                                    email == "") {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "All fields should be filled"),
                                                  ));
                                                } else {
                                                  updateProfile();
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 16.0,
                                                ),
                                                child: Text(
                                                  "UPDATE PROFILE",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Montserrat-Bold',
                                                    fontSize: 16.0,
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
                            )
                      : Container(),
                  index == 1
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 20,
                                  ),
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.grey[800],
                                    child: CircleAvatar(
                                      radius: 58,
                                      backgroundColor: Colors.white54,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Current Password",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: TextField(
                                      //obscureText: true,
                                      //obscuringCharacter: "*",
                                      textAlignVertical:
                                          TextAlignVertical.center,
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
                                          oldPass = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "New Password",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: TextField(
                                      obscureText: true,
                                      obscuringCharacter: "*",
                                      textAlignVertical:
                                          TextAlignVertical.center,
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
                                          newPass = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Confirm New Password",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: TextField(
                                      obscureText: true,
                                      obscuringCharacter: "*",
                                      textAlignVertical:
                                          TextAlignVertical.center,
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
                                          confirmPass = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: MaterialButton(
                                          color: Color.fromRGBO(249, 190, 6, 1),
                                          onPressed: () {
                                            if (oldPass == null ||
                                                oldPass == "" ||
                                                newPass == null ||
                                                newPass == "" ||
                                                confirmPass == null ||
                                                confirmPass == "") {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "All fields should be filled")));
                                            } else {
                                              changePassword();
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 15,
                                              bottom: 15,
                                            ),
                                            child: Text(
                                              "CHANGE PASSWORD",
                                              style: TextStyle(
                                                fontFamily: 'Montserrat-Bold',
                                                fontSize: 16.0,
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
                        )
                      : Container(),
                  index == 2
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 40,
                                  bottom: 20,
                                ),
                                child: Text(
                                  "Login IP History",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                height: screenHeight,
                                child: ListView.builder(
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "IP",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                items[index].ip,
                                                style: TextStyle(),
                                              ),
                                            ),
                                            Divider(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Date & Time",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: items[index].loginTime !=
                                                      null
                                                  ? Text(items[index].loginTime)
                                                  : Container(),
                                            ),
                                            Divider(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Location",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(items[index].city +
                                                  ", " +
                                                  items[index].country),
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
                        )
                      : Container(),
                ],
              ),
      ),
    );
  }
}
