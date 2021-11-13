import 'dart:convert';

import 'package:babylon/main.dart';
import 'package:babylon/pages/edit_user.dart';
import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/bookings.dart';
import 'package:babylon/pages/branches.dart';
import 'package:babylon/models/userModel.dart';
import 'package:babylon/pages/profile.dart';
import 'package:babylon/pages/reports.dart';
import 'package:babylon/svgIcons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  String token = "";
  bool showDrawer = false;
  int index = 0;
  int found = 1;
  List<UserModel> items = List<UserModel>();
  String agentRoleId = "";
  String agentBranchId = "";
  String phone = "";
  String mobile = "";
  String email = "";
  String loginId = "";
  String loginPassword = "";
  String dob = "";
  String address = "";
  String countryCode = "";
  String cityCode = "";
  String state = "";
  String postCode = "";
  String agentUserId = "";

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
      getUsersData().then((value) {
        if (mounted) {
          setState(() {
            items = value;
          });
        }
      });
    }
  }

  getUsersData() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET', Uri.parse('http://ibeapi.mobile.it4t.in/api/company/users'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var dataItems = List<UserModel>();

    if (response.statusCode == 200) {
      var body = await response.stream.bytesToString();
      if (body != "") {
        var listItems = jsonDecode(body);
        if (listItems.isNotEmpty) {
          for (var data in listItems) {
            dataItems.add(UserModel.fromJson(data));
          }
          if (mounted) {
            setState(() {
              found = 1;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              found = 0;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            found = 0;
          });
        }
      }
    } else {
      print(response.reasonPhrase);
    }

    return dataItems;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: showDrawer
          ? AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.black87,
            )
          : AppBar(
              backgroundColor: Colors.black87,
              title: Text(
                "USERS",
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
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 10.0,
                  left: 20.0,
                  right: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                    borderRadius: BorderRadius.circular(2),
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
                              padding: const EdgeInsets.symmetric(
                                vertical: 18.0,
                                horizontal: 20.0,
                              ),
                              child: Text(
                                "USERS",
                                style: TextStyle(
                                  color:
                                      index == 0 ? Colors.black : Colors.grey,
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
                    SizedBox(
                      width: 8.0,
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
                              padding: const EdgeInsets.symmetric(
                                vertical: 18.0,
                                horizontal: 20.0,
                              ),
                              child: Text(
                                "ROLES",
                                style: TextStyle(
                                  color:
                                      index == 1 ? Colors.black : Colors.grey,
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
                  ? Container(
                      height: screenHeight - 200,
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: ExpansionTile(
                                    title: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            radius: 5,
                                            backgroundColor: Colors.green,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            items[index].fullName,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    expandedCrossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    expandedAlignment: Alignment.centerLeft,
                                    children: [
                                      Divider(
                                        color: Colors.grey,
                                        thickness: 1,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 20,
                                        ),
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Name: ",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text: items[index].fullName,
                                                style: TextStyle(
                                                  fontFamily:
                                                      'Montserrat-Medium',
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 20,
                                        ),
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "User Name: ",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text: items[index].name,
                                                style: TextStyle(
                                                  fontFamily:
                                                      'Montserrat-Medium',
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 20,
                                        ),
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Location: ",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "Sulaymaniyah, Iraq",
                                                style: TextStyle(
                                                  fontFamily:
                                                      'Montserrat-Medium',
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 20,
                                        ),
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Mobile: ",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text: items[index].mobile,
                                                style: TextStyle(
                                                  fontFamily:
                                                      'Montserrat-Medium',
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 20,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Status: ",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                              ),
                                              child: CircleAvatar(
                                                radius: 5.0,
                                                backgroundColor: Colors.green,
                                              ),
                                            ),
                                            Text(
                                              items[index].status,
                                              style: TextStyle(
                                                fontFamily: 'Montserrat-Medium',
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text("View"),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        Icons.remove_red_eye,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditUser(
                                                          agentUserId:
                                                              items[index]
                                                                  .agentUserId,
                                                          title: items[index]
                                                              .fullName
                                                              .substring(
                                                                  0,
                                                                  items[index]
                                                                      .fullName
                                                                      .indexOf(
                                                                          ' ',
                                                                          2)),
                                                          firstName: items[
                                                                  index]
                                                              .fullName
                                                              .substring(
                                                                  items[index]
                                                                      .fullName
                                                                      .indexOf(
                                                                          ' ',
                                                                          2),
                                                                  items[index]
                                                                      .fullName
                                                                      .indexOf(
                                                                          ' ',
                                                                          3)),
                                                          middleName: items[
                                                                  index]
                                                              .fullName
                                                              .substring(
                                                                  items[index]
                                                                      .fullName
                                                                      .indexOf(
                                                                          ' ',
                                                                          3),
                                                                  items[index]
                                                                      .fullName
                                                                      .indexOf(
                                                                          ' ',
                                                                          4)),
                                                          lastName: items[index]
                                                              .fullName
                                                              .substring(
                                                                items[index]
                                                                    .fullName
                                                                    .indexOf(
                                                                        ' ', 4),
                                                              ),
                                                          email: items[index]
                                                              .email,
                                                          loginId: items[index]
                                                              .loginId,
                                                          mobile: items[index]
                                                              .mobile,
                                                          dob: items[index].dob,
                                                          agentRoleId: '',
                                                          agentBranchId: '',
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text("Edit"),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Icon(
                                                          Icons.edit,
                                                          color: Colors.grey,
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
                              ),
                              index == items.length - 1
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        left: 8,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditUser(
                                                agentUserId:
                                                    items[index].agentUserId,
                                                title: items[index]
                                                    .fullName
                                                    .substring(
                                                        0,
                                                        items[index]
                                                            .fullName
                                                            .indexOf(' ', 2)),
                                                firstName: items[index]
                                                    .fullName
                                                    .substring(
                                                        items[index]
                                                            .fullName
                                                            .indexOf(' ', 2),
                                                        items[index]
                                                            .fullName
                                                            .indexOf(' ', 3)),
                                                middleName: items[index]
                                                    .fullName
                                                    .substring(
                                                        items[index]
                                                            .fullName
                                                            .indexOf(' ', 3),
                                                        items[index]
                                                            .fullName
                                                            .indexOf(' ', 4)),
                                                lastName: items[index]
                                                    .fullName
                                                    .substring(
                                                      items[index]
                                                          .fullName
                                                          .indexOf(' ', 4),
                                                    ),
                                                email: items[index].email,
                                                loginId: items[index].loginId,
                                                mobile: items[index].mobile,
                                                dob: items[index].dob,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                radius: 18,
                                                backgroundColor: Color.fromRGBO(
                                                  249,
                                                  190,
                                                  6,
                                                  1,
                                                ),
                                                child: Center(
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditUser(
                                                            agentUserId: items[
                                                                    index]
                                                                .agentUserId,
                                                            title: items[index]
                                                                .fullName
                                                                .substring(
                                                                    0,
                                                                    items[index]
                                                                        .fullName
                                                                        .indexOf(
                                                                            ' ',
                                                                            2)),
                                                            firstName: items[
                                                                    index]
                                                                .fullName
                                                                .substring(
                                                                    items[index]
                                                                        .fullName
                                                                        .indexOf(
                                                                            ' ',
                                                                            2),
                                                                    items[index]
                                                                        .fullName
                                                                        .indexOf(
                                                                            ' ',
                                                                            3)),
                                                            middleName: items[index]
                                                                .fullName
                                                                .substring(
                                                                    items[index]
                                                                        .fullName
                                                                        .indexOf(
                                                                            ' ',
                                                                            3),
                                                                    items[index]
                                                                        .fullName
                                                                        .indexOf(
                                                                            ' ',
                                                                            4)),
                                                            lastName:
                                                                items[index]
                                                                    .fullName
                                                                    .substring(
                                                                      items[index]
                                                                          .fullName
                                                                          .indexOf(
                                                                              ' ',
                                                                              4),
                                                                    ),
                                                            email: items[index]
                                                                .email,
                                                            loginId:
                                                                items[index]
                                                                    .loginId,
                                                            mobile: items[index]
                                                                .mobile,
                                                            dob: items[index]
                                                                .dob,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "ADD NEW USER",
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat-Bold',
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          );
                        },
                      ),
                    )
                  : Container(),
              index == 1
                  ? Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ExpansionTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Admin",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                expandedCrossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Divider(
                                    color: Colors.grey[900],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 20,
                                      left: 20,
                                    ),
                                    child: Text(
                                      "Role Description",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text("View"),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.remove_red_eye,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text("Edit"),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ExpansionTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Branch Manager",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ExpansionTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Supervisor",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ExpansionTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Agent",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 15,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor:
                                        Color.fromRGBO(249, 190, 6, 1),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                  ),
                                  child: Text(
                                    "ADD NEW ROLE",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-Bold',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
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
              : Container(),
        ],
      ),
    );
  }
}
