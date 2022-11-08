import 'dart:convert';

import 'package:babylon/main.dart';
import 'package:babylon/models/cityModel.dart';
import 'package:babylon/models/countryModel.dart';
import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/bookings.dart';
import 'package:babylon/pages/branches.dart';
import 'package:babylon/pages/profile.dart';
import 'package:babylon/pages/reports.dart';
import 'package:babylon/pages/users.dart';
import 'package:babylon/svgIcons.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddBranch extends StatefulWidget {
  @override
  _AddBranchState createState() => _AddBranchState();
}

class _AddBranchState extends State<AddBranch> {
  var _formKey = GlobalKey<FormState>();

  String token = "";
  String name = "";
  String address = "";
  String state = "";
  String phone = "";
  String email = "";
  String countryCode = "";
  String countryName = "";
  String cityCode = "";
  String cityName = "";
  String postCode = "";
  bool showDrawer = false;
  bool loading = false;
  List<CityModel> cityCodeList = List<CityModel>();
  List<CountryModel> countryCodeList = List<CountryModel>();
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
  }

  getcountryCodes() async {
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
      for (var data in body) {
        dataItems.add(CountryModel.fromJson(data));
      }
    }

    return dataItems;
  }

  getCity() async {
    var dataItems = List<CityModel>();
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://ibeapi.mobile.it4t.in/api/static/cities'));
    request.fields.addAll({'CountryCode': '$countryCode'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      for (var data in body) {
        dataItems.add(CityModel.fromJson(data));
      }
    }

    return dataItems;
  }

  addBranch() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://ibeapi.mobile.it4t.in/api/company/branches'));
    request.fields.addAll({
      'Name': '$name',
      'Address': '$address',
      'State': '$state',
      'CountryCode': '$countryCode',
      'CityCode': '$cityCode',
      'Postcode': '$postCode',
      'Phone': '$phone',
      'Email': '$email'
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
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Branches()),
      ).then((value) => setState(() {}));
    } else {
      print(response.reasonPhrase);
    }
  }

  selectCountry() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: countryCodeList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                setState(
                  () {
                    countryName = countryCodeList[index].countryName;
                    countryCode = countryCodeList[index].countryCode;
                    cityCodeList = [];
                  },
                );
                getCity().then((value) {
                  if (mounted) {
                    setState(() {
                      cityCodeList.addAll(value);
                    });
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  countryCodeList[index].countryName,
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

  selectCity() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: cityCodeList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                setState(
                  () {
                    cityName = cityCodeList[index].cityName;
                    cityCode = cityCodeList[index].cityCode;
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  cityCodeList[index].cityName,
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

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    if (countryCodeList.isEmpty) {
      getcountryCodes().then((value) {
        if (mounted) {
          setState(() {
            countryCodeList.addAll(value);
          });
        }
      });
    }
    if ((countryCode != null || countryCode != "") &&
        (cityCode != null || cityCode != "")) {
      if (cityCodeList.isEmpty) {
        getCity().then((value) {
          if (mounted) {
            setState(() {
              cityCodeList.addAll(value);
            });
          }
        });
      }
    }
    return Scaffold(
      appBar: showDrawer
          ? AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.black87,
            )
          : AppBar(
              backgroundColor: Colors.black87,
              title: Text(
                "ADD BRANCH",
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
      body: Form(
        key: _formKey,
        child: Stack(
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
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.top,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.start,
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
                                      name = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Text("Address"),
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
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.top,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.start,
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
                                      address = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Text("State"),
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
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.top,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.start,
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
                                      state = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Text("Phone"),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                              ),
                              child: Container(
                                height: 60.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: TextFormField(
                                  initialValue: phone ?? "",
                                  maxLength: 15,
                                  keyboardType: TextInputType.number,
                                  textAlignVertical: TextAlignVertical.top,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.start,
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
                                      phone = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Text("Email"),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: Container(
                                height: emailValidated ? 40 : 60.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: TextFormField(
                                  initialValue: email ?? "",
                                  textAlignVertical: TextAlignVertical.top,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.start,
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
                                    focusedErrorBorder: OutlineInputBorder(
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
                                  validator: (String email) {
                                    if (EmailValidator.validate(email) ==
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
                            Text("Country"),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  selectCountry();
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: countryName != "" &&
                                                  countryName != null
                                              ? Text(
                                                  countryName,
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
                            Text("City"),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (countryCode != null &&
                                      countryCode != "") {
                                    selectCity();
                                  }
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              cityName != "" && cityName != null
                                                  ? Text(
                                                      cityName,
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
                            Text("Postal Code"),
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
                                  initialValue: postCode,
                                  keyboardType: TextInputType.number,
                                  textAlignVertical: TextAlignVertical.top,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.start,
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
                                      postCode = val;
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
                                  if (name == null ||
                                      name == "" ||
                                      countryCode == null ||
                                      countryCode == "" ||
                                      countryName == null ||
                                      countryName == "" ||
                                      cityName == null ||
                                      cityName == "" ||
                                      cityCode == null ||
                                      cityCode == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "All fields should be filled")));
                                  } else {
                                    addBranch();
                                    setState(() {
                                      loading = true;
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    "ADD",
                                    style: TextStyle(
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
      ),
    );
  }
}
