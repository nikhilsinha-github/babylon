import 'dart:convert';

import 'package:babylon/constraints.dart';
import 'package:babylon/main.dart';
import 'package:babylon/models/branchesDataModel.dart';
import 'package:babylon/models/cityModel.dart';
import 'package:babylon/models/countryModel.dart';
import 'package:babylon/models/rolesModel.dart';
import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/bookings.dart';
import 'package:babylon/pages/branches.dart';
import 'package:babylon/pages/profile.dart';
import 'package:babylon/pages/reports.dart';
import 'package:babylon/pages/users.dart';
import 'package:babylon/svgIcons.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  var _formKey = GlobalKey<FormState>();

  String token = "";
  bool showDrawer = false;
  String _title = "";
  String _firstName = "";
  String _middleName = "";
  String _lastName = "";
  String _agentRoleId = "";
  String _agentBranchId = "";
  String _phone = "";
  String _email = "";
  String _loginId = "";
  String _loginPassword = "";
  String _mobile = "";
  String _dob = "";
  String _address = "";
  String _countryCode = "";
  String _countryName = "";
  String _cityCode = "";
  String _cityName = "";
  String _state = "";
  String _postCode = "";
  bool loading = false;
  List<RolesModel> roles = List<RolesModel>();
  List<BranchesDataModel> branches = List<BranchesDataModel>();
  List<CityModel> cityCodeList = List<CityModel>();
  List<CountryModel> countryCodeList = List<CountryModel>();
  String agentRole = "";
  String agentBranch = "";
  bool pickDate = false;
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
    getRoles().then((value) {
      if (mounted) {
        setState(() {
          roles.addAll(value);
        });
      }
    });
    getBranchData().then((value) {
      if (mounted) {
        setState(() {
          branches.addAll(value);
        });
      }
    });
  }

  getRoles() async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET', Uri.parse('http://ibeapi.mobile.it4t.in/api/company/roles'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var dataItems = List<RolesModel>();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      for (var i in body) {
        dataItems.add(RolesModel.fromJson(i));
      }
    } else {
      print(response.reasonPhrase);
    }

    return dataItems;
  }

  getBranchData() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest(
        'GET', Uri.parse('http://ibeapi.mobile.it4t.in/api/company/branches'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var dataItems = List<BranchesDataModel>();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      for (var i in body) {
        dataItems.add(BranchesDataModel.fromJson(i));
      }
    } else {
      print(response.reasonPhrase);
    }

    return dataItems;
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

  addUser() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'POST', Uri.parse('http://ibeapi.mobile.it4t.in/api/company/users'));
    request.body = json.encode({
      "Title": "$_title",
      "FirstName": "$_firstName",
      "MiddleName": "$_middleName",
      "LastName": "$_lastName",
      "AgentRoleId": "$_agentRoleId",
      "AgentBranchId": "$_agentBranchId",
      "Phone": "$_phone",
      "Mobile": "$_mobile",
      "Email": "$_email",
      "LoginId": "$_loginId",
      "LoginPassword": "$_loginPassword",
      "DOB": "$_dob",
      "Address": "$_address",
      "CountryCode": "$_countryCode",
      "CityCode": "$_cityCode",
      "State": "$_state",
      "PostCode": "$_postCode",
      "Status": "1",
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(data);
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
        MaterialPageRoute(builder: (context) => Users()),
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

  selectAgentRole() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: roles.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                setState(
                  () {
                    _agentRoleId = roles[index].agentRoleId;
                    agentRole = roles[index].name;
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  roles[index].name,
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

  selectAgentBranch() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: branches.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                setState(
                  () {
                    _agentBranchId = branches[index].agentBranchId;
                    agentBranch = branches[index].name;
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  branches[index].name,
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
      print(countryCodeList);
    }
    if (_countryName != "" && _countryName != null) {
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
      appBar: showDrawer || pickDate
          ? AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.black87,
            )
          : AppBar(
              backgroundColor: Colors.black87,
              title: Text(
                "ADD USER",
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
        child: pickDate
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.black87,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                "Pick a date",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  pickDate = false;
                                });
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      SfDateRangePicker(
                        todayHighlightColor: Colors.transparent,
                        onSelectionChanged: (val) {
                          setState(() {
                            _dob = val.value.toString().substring(0, 10);
                            pickDate = false;
                          });
                        },
                        selectionMode: DateRangePickerSelectionMode.single,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 50.0,
                      horizontal: 20.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            color: primaryColor,
                            onPressed: () {
                              setState(() {
                                pickDate = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "DONE",
                                style: TextStyle(
                                  fontFamily: 'Montserrat-Medium',
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Stack(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            builder: (context) =>
                                                AgencyInfo()));
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
                                      showDrawer = !showDrawer;
                                    });
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Title"),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Container(
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _title != "" && _title != null
                                              ? Text(
                                                  _title,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                  ),
                                                )
                                              : Text(
                                                  "",
                                                ),
                                          DropdownButton(
                                            icon: Icon(
                                              Icons.expand_more,
                                            ),
                                            items: ['Mr', 'Mrs', 'Miss'].map(
                                              (val) {
                                                return DropdownMenuItem<String>(
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
                                                  _title = val;
                                                },
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Text("First Name"),
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
                                          _firstName = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Text("Middle Name"),
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
                                          _middleName = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Text("Last Name"),
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
                                          _lastName = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Text("Agent Role"),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: GestureDetector(
                                    onTap: selectAgentRole,
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            agentRole != "" && agentRole != null
                                                ? Text(
                                                    agentRole,
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                    ),
                                                  )
                                                : Text(
                                                    "",
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text("Agent Branch"),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: GestureDetector(
                                    onTap: selectAgentBranch,
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            agentBranch != "" &&
                                                    agentBranch != null
                                                ? Text(
                                                    agentBranch,
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                    ),
                                                  )
                                                : Text(
                                                    "",
                                                  ),
                                          ],
                                        ),
                                      ),
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
                                      initialValue: _phone ?? "",
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
                                          _phone = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Text("Mobile"),
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
                                      initialValue: _mobile ?? "",
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
                                          _mobile = val;
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
                                      initialValue: _email ?? "",
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
                                Text("LoginId"),
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
                                          _loginId = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Text("Login Password"),
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
                                          _loginPassword = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Text("DOB"),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        pickDate = true;
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
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
                                              setState(() {
                                                pickDate = true;
                                              });
                                            },
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                pickDate = true;
                                              });
                                            },
                                            child: _dob != "" && _dob != null
                                                ? Center(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          pickDate = true;
                                                        });
                                                      },
                                                      child: Text(_dob),
                                                    ),
                                                  )
                                                : Text(
                                                    "D.O.B",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
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
                                    child: TextFormField(
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
                                          _address = val;
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
                                    child: TextFormField(
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
                                          _state = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Text("Post code"),
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
                                          _postCode = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 25.0,
                                  ),
                                  child: SizedBox(
                                    width: screenWidth,
                                    child: MaterialButton(
                                      color: Color.fromRGBO(
                                        249,
                                        190,
                                        6,
                                        1,
                                      ),
                                      onPressed: () {
                                        if (_firstName == null ||
                                            _firstName == "" ||
                                            _lastName == null ||
                                            _lastName == "" ||
                                            _agentRoleId == null ||
                                            _agentRoleId == "" ||
                                            _agentBranchId == null ||
                                            _agentBranchId == "" ||
                                            _mobile == null ||
                                            _mobile == "" ||
                                            _loginId == null ||
                                            _loginId == "" ||
                                            _loginPassword == null ||
                                            _loginPassword == "" ||
                                            _address == null ||
                                            _address == "" ||
                                            _countryCode == null ||
                                            _countryCode == "" ||
                                            _countryName == null ||
                                            _countryName == "" ||
                                            _cityName == null ||
                                            _cityName == "" ||
                                            _cityCode == null ||
                                            _cityCode == "") {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "All fields should be filled")));
                                        } else {
                                          addUser();
                                          setState(() {
                                            loading = true;
                                          });
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("SAVE"),
                                      ),
                                    ),
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
      ),
    );
  }
}
