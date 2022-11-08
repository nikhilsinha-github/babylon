import 'dart:convert';

import 'package:babylon/main.dart';
import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/bookings.dart';
import 'package:babylon/pages/profile.dart';
import 'package:babylon/pages/reports.dart';
import 'package:babylon/pages/users.dart';
import 'package:babylon/svgIcons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditRoles extends StatefulWidget {
  final String roleId;
  const EditRoles({
    Key key,
    this.roleId,
  }) : super(key: key);

  @override
  _EditRolesState createState() => _EditRolesState(this.roleId);
}

class _EditRolesState extends State<EditRoles> {
  String token = "";
  bool showDrawer = false;
  bool loading = false;
  bool dataLoaded = false;
  String _roleName = "";
  String _roleDescription = "";
  List assignedMenus = [];
  bool administration = false;
  bool agenyInfo = false;
  bool branch = false;
  bool role = false;
  bool user = false;
  bool markup = false;
  bool bookings = false;
  bool myBookings = false;
  bool reports = false;
  bool ledgers = false;
  bool sales = false;

  final roleId;
  _EditRolesState(this.roleId);

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
    getRole();
  }

  getRole() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://ibeapi.mobile.it4t.in/api/company/roles?RoleId=$roleId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      if (body != "" && body != null) {
        setState(() {
          dataLoaded = true;
          _roleName = body["RoleDetails"]["Name"];
          _roleDescription = body["RoleDetails"]["Description"];
          assignedMenus = body["AssignedMenus"];
          for (var i in assignedMenus) {
            if (assignedMenus.contains(1)) {
              administration = true;
            }
            if (assignedMenus.contains(2)) {
              agenyInfo = true;
            }
            if (assignedMenus.contains(3)) {
              branch = true;
            }
            if (assignedMenus.contains(4)) {
              role = true;
            }
            if (assignedMenus.contains(5)) {
              user = true;
            }
            if (assignedMenus.contains(6)) {
              markup = true;
            }
            if (assignedMenus.contains(7)) {
              bookings = true;
            }
            if (assignedMenus.contains(8)) {
              myBookings = true;
            }
            if (assignedMenus.contains(9)) {
              reports = true;
            }
            if (assignedMenus.contains(10)) {
              ledgers = true;
            }
            if (assignedMenus.contains(11)) {
              sales = true;
            }
          }
        });
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  editRoles() async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('http://ibeapi.mobile.it4t.in/api/company/roles'));
    request.body = json.encode({
      "Name": "$_roleName",
      "Description": "$_roleDescription",
      "SaveMenu": assignedMenus
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
      appBar: showDrawer
          ? AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.black87,
            )
          : AppBar(
              backgroundColor: Colors.black87,
              title: Text(
                "EDIT ROLES",
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
              : (dataLoaded)
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Role Name"),
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
                                  initialValue: _roleName,
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
                                      //_productType = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Text("Role Description"),
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
                                  initialValue: _roleDescription,
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
                                      // _markup = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Text("Permissions:"),
                            //1
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              value: administration,
                              title: Text("Administration"),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (bool value) {
                                setState(() {
                                  administration = value;
                                });
                                if (administration) {
                                  assignedMenus.add(1);
                                } else {
                                  assignedMenus.remove(1);
                                }
                                print(assignedMenus);
                              },
                            ),
                            //2
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: agenyInfo,
                                title: Text("Agency Informations"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (bool value) {
                                  setState(() {
                                    agenyInfo = value;
                                  });
                                  if (agenyInfo) {
                                    assignedMenus.add(2);
                                  } else {
                                    assignedMenus.remove(2);
                                  }
                                },
                              ),
                            ),
                            //3
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: branch,
                                title: Text("Branch Management"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (bool value) {
                                  setState(() {
                                    branch = value;
                                  });
                                  if (branch) {
                                    assignedMenus.add(3);
                                  } else {
                                    assignedMenus.remove(3);
                                  }
                                },
                              ),
                            ),
                            //4
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: role,
                                title: Text("Role Management"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (bool value) {
                                  setState(() {
                                    role = value;
                                  });
                                  if (role) {
                                    assignedMenus.add(4);
                                  } else {
                                    assignedMenus.remove(4);
                                  }
                                },
                              ),
                            ),
                            //5
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: user,
                                title: Text("User Management"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (bool value) {
                                  setState(() {
                                    user = value;
                                  });
                                  if (user) {
                                    assignedMenus.add(5);
                                  } else {
                                    assignedMenus.remove(5);
                                  }
                                },
                              ),
                            ),
                            //6
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: markup,
                                title: Text("Markup Management"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (bool value) {
                                  setState(() {
                                    markup = value;
                                  });
                                  if (markup) {
                                    assignedMenus.add(6);
                                  } else {
                                    assignedMenus.remove(6);
                                  }
                                },
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            //7
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              value: bookings,
                              title: Text("Bookings"),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (bool value) {
                                setState(() {
                                  bookings = value;
                                });
                                if (bookings) {
                                  assignedMenus.add(7);
                                } else {
                                  assignedMenus.remove(7);
                                }
                              },
                            ),
                            //8
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: myBookings,
                                title: Text("My Bookings"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (bool value) {
                                  setState(() {
                                    myBookings = value;
                                  });
                                  if (myBookings) {
                                    assignedMenus.add(8);
                                  } else {
                                    assignedMenus.remove(8);
                                  }
                                },
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            //9
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              value: reports,
                              title: Text("Reports"),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (bool value) {
                                setState(() {
                                  reports = value;
                                });
                                if (reports) {
                                  assignedMenus.add(9);
                                } else {
                                  assignedMenus.remove(9);
                                }
                              },
                            ),
                            //10
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: ledgers,
                                title: Text("Ledgers"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (bool value) {
                                  setState(() {
                                    ledgers = value;
                                  });
                                  if (ledgers) {
                                    assignedMenus.add(10);
                                  } else {
                                    assignedMenus.remove(10);
                                  }
                                },
                              ),
                            ),
                            //11
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: sales,
                                title: Text("Sales"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (bool value) {
                                  setState(() {
                                    sales = value;
                                  });
                                  if (sales) {
                                    assignedMenus.add(11);
                                  } else {
                                    assignedMenus.remove(11);
                                  }
                                },
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
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
                                  editRoles();
                                  setState(() {
                                    loading = true;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    "UPDATE",
                                    style: TextStyle(
                                      fontFamily: 'montserrat-Bold',
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
