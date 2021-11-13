import 'dart:convert';

import 'package:babylon/main.dart';
import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/bookings.dart';
import 'package:babylon/pages/branches.dart';
import 'package:babylon/pages/profile.dart';
import 'package:babylon/pages/reports.dart';
import 'package:babylon/svgIcons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditUser extends StatefulWidget {
  final String agentUserId;
  final String title;
  final String firstName;
  final String middleName;
  final String lastName;
  final String agentRoleId;
  final String agentBranchId;
  final String phone;
  final String email;
  final String loginId;
  final String loginPassword;
  final String mobile;
  final String dob;
  final String address;
  final String countryCode;
  final String cityCode;
  final String state;
  final String postCode;
  final String status;

  const EditUser({
    Key key,
    this.agentUserId,
    this.title,
    this.firstName,
    this.middleName,
    this.lastName,
    this.agentRoleId,
    this.agentBranchId,
    this.phone,
    this.email,
    this.loginId,
    this.loginPassword,
    this.mobile,
    this.dob,
    this.address,
    this.countryCode,
    this.cityCode,
    this.state,
    this.postCode,
    this.status,
  }) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState(
        this.agentUserId,
        this.title,
        this.firstName,
        this.middleName,
        this.lastName,
        this.agentRoleId,
        this.agentBranchId,
        this.phone,
        this.email,
        this.loginId,
        this.loginPassword,
        this.mobile,
        this.dob,
        this.address,
        this.countryCode,
        this.cityCode,
        this.state,
        this.postCode,
        this.status,
      );
}

class _EditUserState extends State<EditUser> {
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
  String _cityCode = "";
  String _state = "";
  String _postCode = "";
  bool loading = false;

  final agentUserId;
  final title;
  final firstName;
  final middleName;
  final lastName;
  final agentRoleId;
  final agentBranchId;
  final phone;
  final email;
  final loginId;
  final loginPassword;
  final mobile;
  final dob;
  final address;
  final countryCode;
  final cityCode;
  final state;
  final postCode;
  final status;
  _EditUserState(
    this.agentUserId,
    this.title,
    this.firstName,
    this.middleName,
    this.lastName,
    this.agentRoleId,
    this.agentBranchId,
    this.phone,
    this.email,
    this.loginId,
    this.loginPassword,
    this.mobile,
    this.dob,
    this.address,
    this.countryCode,
    this.cityCode,
    this.state,
    this.postCode,
    this.status,
  );

  @override
  void initState() {
    super.initState();
    getToken();
    _title = title;
    _firstName = firstName;
    _middleName = middleName;
    _lastName = lastName;
    _agentRoleId = agentRoleId;
    _agentBranchId = agentBranchId;
    _phone = phone;
    _email = email;
    _loginId = loginId;
    _loginPassword = loginPassword;
    _mobile = mobile;
    _dob = dob;
    _address = address;
    _countryCode = countryCode;
    _cityCode = cityCode;
    _state = state;
    _postCode = postCode;
    print(agentRoleId);
    print(agentBranchId);
    print(agentUserId);
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        token = prefs.getString('token');
      });
    }
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
      "AgentUserId": "$agentUserId",
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(data);
      // var body = jsonDecode(data);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(body["Response"]["Message"]),
      //   ),
      // );
      setState(() {
        loading = false;
      });
    } else {
      print(response.reasonPhrase);
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
                "EDIT USER",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Montserrat-Bold'),
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
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextFormField(
                              initialValue: _title,
                              textAlignVertical: TextAlignVertical.top,
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
                                  _title = val;
                                });
                              },
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
                              initialValue: _firstName,
                              textAlignVertical: TextAlignVertical.top,
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
                              initialValue: _middleName,
                              textAlignVertical: TextAlignVertical.top,
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
                              initialValue: _lastName,
                              textAlignVertical: TextAlignVertical.top,
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
                                  _lastName = val;
                                });
                              },
                            ),
                          ),
                        ),
                        Text("Agent Role Id"),
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
                              initialValue: _agentRoleId,
                              keyboardType: TextInputType.number,
                              textAlignVertical: TextAlignVertical.top,
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
                                  _agentRoleId = val;
                                });
                              },
                            ),
                          ),
                        ),
                        Text("Agent Branch Id"),
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
                              initialValue: _agentRoleId,
                              keyboardType: TextInputType.number,
                              textAlignVertical: TextAlignVertical.top,
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
                                  _agentBranchId = val;
                                });
                              },
                            ),
                          ),
                        ),
                        Text("Phone"),
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
                              initialValue: _phone,
                              keyboardType: TextInputType.number,
                              textAlignVertical: TextAlignVertical.top,
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
                                  _phone = val;
                                });
                              },
                            ),
                          ),
                        ),
                        Text("Mobile"),
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
                              initialValue: _mobile,
                              keyboardType: TextInputType.number,
                              textAlignVertical: TextAlignVertical.top,
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
                                  _mobile = val;
                                });
                              },
                            ),
                          ),
                        ),
                        Text("Email"),
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
                              initialValue: _email,
                              textAlignVertical: TextAlignVertical.top,
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
                                  _email = val;
                                });
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
                              initialValue: _loginId,
                              textAlignVertical: TextAlignVertical.top,
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
                              initialValue: _loginPassword,
                              textAlignVertical: TextAlignVertical.top,
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
                                  _loginPassword = val;
                                });
                              },
                            ),
                          ),
                        ),
                        Text("DOB"),
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
                              initialValue: _dob,
                              keyboardType: TextInputType.number,
                              textAlignVertical: TextAlignVertical.bottom,
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
                                hintText: 'DD-MM-YYYY',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _dob = val;
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
                            child: TextFormField(
                              initialValue: _address,
                              textAlignVertical: TextAlignVertical.top,
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
                                  _address = val;
                                });
                              },
                            ),
                          ),
                        ),
                        Text("CountryCode"),
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
                              initialValue: _countryCode,
                              textAlignVertical: TextAlignVertical.top,
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
                                  _countryCode = val;
                                });
                              },
                            ),
                          ),
                        ),
                        Text("City Code"),
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
                              initialValue: _cityCode,
                              keyboardType: TextInputType.number,
                              textAlignVertical: TextAlignVertical.top,
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
                                  _cityCode = val;
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
                            child: TextFormField(
                              initialValue: _state,
                              textAlignVertical: TextAlignVertical.top,
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
                              initialValue: _postCode,
                              textAlignVertical: TextAlignVertical.top,
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
                                addUser();
                                setState(() {
                                  loading = true;
                                });
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
    );
  }
}
