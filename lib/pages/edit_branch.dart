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
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';

class EditBranch extends StatefulWidget {
  final String branchId;
  const EditBranch({
    Key key,
    this.branchId,
  }) : super(key: key);

  @override
  _EditBranchState createState() => _EditBranchState(this.branchId);
}

class _EditBranchState extends State<EditBranch> {
  var _formKey = GlobalKey<FormState>();

  String token = "";
  bool loading = false;
  bool showDrawer = false;
  String _name = '';
  String _address = '';
  String _cityCode = '';
  String _cityName = '';
  String _state = '';
  String _countryCode = '';
  String _countryName = '';
  String _postCode = '';
  String _phone = '';
  String _email = '';
  Map branchData;
  List<CityModel> cityCodeList = List<CityModel>();
  List<CountryModel> countryCodeList = List<CountryModel>();
  bool emailValidated = true;

  final branchId;

  _EditBranchState(
    this.branchId,
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
    getSingleBranch();
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
    request.fields.addAll({'CountryCode': '$_countryCode'});

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

  getSingleBranch() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest(
        'GET',
        Uri.parse(
            'http://ibeapi.mobile.it4t.in/api/company/branches?BranchId=$branchId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      setState(() {
        branchData = body[0];
        _name = branchData["Name"] ?? "";
        _address = branchData["Address"] ?? "";
        _state = branchData["State"] ?? "";
        _countryCode = branchData["CountryCode"] ?? "";
        _countryName = branchData["CountryName"] ?? "";
        _cityCode = branchData["CityCode"] ?? "";
        _postCode = branchData["PostCode"] ?? "";
        _phone = branchData["Phone"] ?? "";
        _email = branchData["Email"] ?? "";
        _cityName = branchData["CityName"] ?? "";
      });
      print(branchData);
    } else {
      print(response.reasonPhrase);
    }
  }

  editBranch() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://ibeapi.mobile.it4t.in/api/company/branches'));
    request.fields.addAll({
      'BranchId': '$branchId',
      'Name': '$_name',
      'Address': '$_address',
      'State': '$_state',
      'CountryCode': '$_countryCode',
      'CityCode': '$_cityCode',
      'Postcode': '$_postCode',
      'Phone': '$_phone',
      'Email': '$_email',
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      var body = jsonDecode(res);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(body["Response"]["Message"])));
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
                    _countryName = countryCodeList[index].countryName;
                    _countryCode = countryCodeList[index].countryCode;
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
                    _cityName = cityCodeList[index].cityName;
                    _cityCode = cityCodeList[index].cityCode;
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
    if (_countryName != "" || _countryName != null) {
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
                "EDIT BRANCH",
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
                    child: branchData != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
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
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: TextFormField(
                                        initialValue: _name ?? "",
                                        textAlignVertical:
                                            TextAlignVertical.top,
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
                                            _name = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Text("Phone Number"),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                    ),
                                    child: Container(
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: TextFormField(
                                        initialValue: _phone ?? "",
                                        maxLength: 15,
                                        keyboardType: TextInputType.number,
                                        textAlignVertical:
                                            TextAlignVertical.top,
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
                                            _phone = val;
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
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: TextFormField(
                                        initialValue: _email ?? "",
                                        textAlignVertical:
                                            TextAlignVertical.top,
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
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            _email = val;
                                            _formKey.currentState.validate();
                                          });
                                        },
                                        validator: (String _email) {
                                          if (EmailValidator.validate(_email) ==
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
                                  Text("Address"),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Container(
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: TextFormField(
                                        initialValue: _address ?? "",
                                        textAlignVertical:
                                            TextAlignVertical.top,
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
                                            _address = val;
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
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: TextFormField(
                                        initialValue: _state ?? "",
                                        textAlignVertical:
                                            TextAlignVertical.top,
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
                                            _state = val;
                                          });
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: _countryName != "" &&
                                                        _countryName != null
                                                    ? Text(
                                                        _countryName,
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
                                        selectCity();
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: _cityName != "" &&
                                                        _cityName != null
                                                    ? Text(
                                                        _cityName,
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
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: TextFormField(
                                        initialValue: _postCode ?? "",
                                        textAlignVertical:
                                            TextAlignVertical.top,
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
                                            _postCode = val;
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
                                        editBranch();
                                        setState(() {
                                          loading = true;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          "SAVE",
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
                          )
                        : Container(
                            height: screenHeight,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: Image.asset(
                              'assets/images/Group 3025.png',
                              height: screenHeight,
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
