import 'dart:convert';

import 'package:babylon/models/gdsSupplierModel.dart';
import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/arrival.dart';
import 'package:babylon/auth/auth_landing_page.dart';
import 'package:babylon/pages/bookings.dart';
import 'package:babylon/pages/branches.dart';
import 'package:babylon/pages/calendar.dart';
import 'package:babylon/pages/departure.dart';
import 'package:babylon/pages/flightDetails.dart';
import 'package:babylon/pages/importPNR.dart';
import 'package:babylon/pages/passengers.dart';
import 'package:babylon/pages/profile.dart';
import 'package:babylon/pages/reports.dart';
import 'package:babylon/pages/searchPage.dart';
import 'package:babylon/splash_screen.dart';
import 'package:babylon/pages/travelClass.dart';
import 'package:babylon/pages/users.dart';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:babylon/svgIcons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Map<int, Color> color = {
    50: Color.fromRGBO(249, 190, 6, .1),
    100: Color.fromRGBO(249, 190, 6, .2),
    200: Color.fromRGBO(249, 190, 6, .3),
    300: Color.fromRGBO(249, 190, 6, .4),
    400: Color.fromRGBO(249, 190, 6, .5),
    500: Color.fromRGBO(249, 190, 6, .6),
    600: Color.fromRGBO(249, 190, 6, .7),
    700: Color.fromRGBO(249, 190, 6, .8),
    800: Color.fromRGBO(249, 190, 6, .9),
    900: Color.fromRGBO(249, 190, 6, 1),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Babylon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFf9be06, color),
        fontFamily: "Montserrat",
      ),
      home: SplashScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  final int trip;
  final String takeOffPlace;
  final String arrivalPlace;
  final String depCityCode;
  final String arrCityCode;
  final String depDet;
  final String arrDet;
  final DateTime departureDay;
  final DateTime arrivalDay;
  final int adt;
  final int chd;
  final int inf;
  final int coachCode;
  HomePage(
    this.trip,
    this.takeOffPlace,
    this.arrivalPlace,
    this.depCityCode,
    this.arrCityCode,
    this.depDet,
    this.arrDet,
    this.departureDay,
    this.arrivalDay,
    this.adt,
    this.chd,
    this.inf,
    this.coachCode,
  );
  @override
  _HomePageState createState() => _HomePageState(
        this.trip,
        this.takeOffPlace,
        this.arrivalPlace,
        this.depCityCode,
        this.arrCityCode,
        this.depDet,
        this.arrDet,
        this.departureDay,
        this.arrivalDay,
        this.adt,
        this.chd,
        this.inf,
        this.coachCode,
      );
}

class _HomePageState extends State<HomePage> {
  final trip;
  final takeOffPlace;
  final arrivalPlace;
  final depCityCode;
  final arrCityCode;
  final depDet;
  final arrDet;
  final departureDay;
  final arrivalDay;
  final adt;
  final chd;
  final inf;
  final coachCode;
  _HomePageState(
    this.trip,
    this.takeOffPlace,
    this.arrivalPlace,
    this.depCityCode,
    this.arrCityCode,
    this.depDet,
    this.arrDet,
    this.departureDay,
    this.arrivalDay,
    this.adt,
    this.chd,
    this.inf,
    this.coachCode,
  );

  String token = "";
  String currency = "";
  String remainingCreditLimit = "";
  bool showDrawer = false;
  bool expanded = false;
  int selected = 1;
  List items = [
    "One Way",
    "Round Trip",
    "Multi City",
    "Import PNR",
  ];
  String departureDate = "";
  String arrivalDate = "";
  List coach = [
    "Economy",
    "Premium",
    "Business",
    "First Class",
  ];
  List coachId = ["EC", "PE", "BC", "FC"];
  String pnr = "";
  String gDSSupplier = "";
  String gDSSupplierId = "";
  List<GdsSupplierModel> gdsSupplierList = List<GdsSupplierModel>();

  @override
  void initState() {
    super.initState();
    getDashboardData();
    selected = trip;
    if (departureDay != null) {
      departureDate = departureDay.toString().substring(0, 10);
    }
    if (arrivalDay != null) {
      arrivalDate = arrivalDay.toString().substring(0, 10);
    }
    getGdsSupplier().then((value) {
      if (mounted) {
        setState(() {
          gdsSupplierList.addAll(value);
        });
      }
    });
  }

  getDashboardData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        token = prefs.getString('token');
      });
    }
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://ibeapi.mobile.it4t.in/api/company/remaingcreditlimit'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      print(body);
      if (mounted) {
        setState(() {
          currency = body["Currency"].toString();
          remainingCreditLimit = body["RemaingCreditLimit"].toString();
        });
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  getGdsSupplier() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        token = prefs.getString('token');
      });
    }
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://ibeapi.mobile.it4t.in/api/company/supplierforimportpnr'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var dataItems = List<GdsSupplierModel>();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var body = jsonDecode(data);
      print(body);
      for (var data in body) {
        dataItems.add(GdsSupplierModel.fromJson(data));
      }
    } else {
      print(response.reasonPhrase);
    }

    return dataItems;
  }

  selectGdsSupplier() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: gdsSupplierList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                setState(
                  () {
                    gDSSupplier = gdsSupplierList[index].company;
                    gDSSupplierId = gdsSupplierList[index].supplierId;
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  gdsSupplierList[index].company,
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.black87,
                  height: 180,
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
                              "assets/images/babylon logo - white-03.png"),
                        ),
                      ),
                      //2nd logo
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showDrawer = true;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 25,
                          ),
                          child: Container(
                            child: Image.asset("assets/images/Ellipse 1.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 50,
                    left: 15,
                    right: 15,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey[400],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: (expanded)
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          CustomCheckBox(
                                            value: selected == 0 ? true : false,
                                            shouldShowBorder: true,
                                            borderColor: Colors.white,
                                            checkedFillColor: Colors.white,
                                            checkedIcon: Icons.done,
                                            checkedIconColor:
                                                Colors.yellow[700],
                                            borderRadius: 5,
                                            borderWidth: 2,
                                            checkBoxSize: 20,
                                            onChanged: (val) {
                                              setState(() {
                                                selected = 0;
                                                expanded = false;
                                              });
                                            },
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selected = 0;
                                                expanded = false;
                                              });
                                            },
                                            child: Text(
                                              items[0],
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: (selected == 0)
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CustomCheckBox(
                                            value: selected == 1 ? true : false,
                                            shouldShowBorder: true,
                                            borderColor: Colors.white,
                                            checkedFillColor: Colors.white,
                                            checkedIcon: Icons.done,
                                            checkedIconColor:
                                                Colors.yellow[700],
                                            borderRadius: 5,
                                            borderWidth: 2,
                                            checkBoxSize: 20,
                                            onChanged: (val) {
                                              setState(() {
                                                selected = 1;
                                                expanded = false;
                                              });
                                            },
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selected = 1;
                                                expanded = false;
                                              });
                                            },
                                            child: Text(
                                              items[1],
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: (selected == 1)
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CustomCheckBox(
                                            value: selected == 2 ? true : false,
                                            shouldShowBorder: true,
                                            borderColor: Colors.white,
                                            checkedFillColor: Colors.white,
                                            checkedIcon: Icons.done,
                                            checkedIconColor:
                                                Colors.yellow[700],
                                            borderRadius: 5,
                                            borderWidth: 2,
                                            checkBoxSize: 20,
                                            onChanged: (val) {
                                              setState(() {
                                                selected = 2;
                                                expanded = false;
                                              });
                                            },
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selected = 2;
                                                expanded = false;
                                              });
                                            },
                                            child: Text(
                                              items[2],
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: (selected == 2)
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CustomCheckBox(
                                            value: selected == 3 ? true : false,
                                            shouldShowBorder: true,
                                            borderColor: Colors.white,
                                            checkedFillColor: Colors.white,
                                            checkedIcon: Icons.done,
                                            checkedIconColor:
                                                Colors.yellow[700],
                                            borderRadius: 5,
                                            borderWidth: 2,
                                            checkBoxSize: 20,
                                            onChanged: (val) {
                                              setState(() {
                                                selected = 3;
                                                expanded = false;
                                              });
                                            },
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selected = 3;
                                                expanded = false;
                                              });
                                            },
                                            child: Text(
                                              items[3],
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: (selected == 3)
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.expand_less,
                                    color: Colors.grey[600],
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      expanded = false;
                                    });
                                  },
                                )
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                expanded = true;
                              });
                            },
                            child: ListTile(
                              leading: Padding(
                                padding: EdgeInsets.only(
                                  top: 7,
                                ),
                                child: icon2,
                              ),
                              title: Text(
                                items[selected],
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.expand_more,
                                  color: Colors.grey[600],
                                  size: 32,
                                ),
                                onPressed: () {
                                  setState(() {
                                    expanded = true;
                                  });
                                },
                              ),
                            ),
                          ),
                  ),
                ),
                //Departure city
                selected != 3
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: 15,
                          left: 15,
                          right: 15,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Departure(
                                  tripNum: selected,
                                  arrivalPlace: arrivalPlace,
                                  aCitC: arrCityCode,
                                  aConC: arrDet,
                                  departureDate: DateTime.parse(departureDate),
                                  arrivalDate: DateTime.parse(arrivalDate),
                                  adt: adt,
                                  chd: chd,
                                  inf: inf,
                                  tc: coachCode,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey[400],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                "assets/images/flight_takeoff.png",
                                color: takeOffPlace == "Country, City, Airport"
                                    ? Colors.grey[600]
                                    : Colors.black,
                              ),
                              title: Text(
                                "$takeOffPlace",
                                style: TextStyle(
                                  color:
                                      takeOffPlace == "Country, City, Airport"
                                          ? Colors.grey[600]
                                          : Colors.black,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.expand_more,
                                  color: Colors.grey[600],
                                  size: 32,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Departure(
                                        tripNum: selected,
                                        arrivalPlace: arrivalPlace,
                                        aCitC: arrCityCode,
                                        aConC: arrDet,
                                        departureDate:
                                            DateTime.parse(departureDate),
                                        arrivalDate:
                                            DateTime.parse(arrivalDate),
                                        adt: adt,
                                        chd: chd,
                                        inf: inf,
                                        tc: coachCode,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          color: Colors.white,
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "PNR",
                            ),
                            onChanged: (val) {
                              if (mounted) {
                                setState(() {
                                  pnr = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                //Arrival city
                selected != 3
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: 15,
                          left: 15,
                          right: 15,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Arrival(
                                  tripNum: selected,
                                  departurePlace: takeOffPlace,
                                  dCitC: depCityCode,
                                  dConC: depDet,
                                  departureDate: DateTime.parse(departureDate),
                                  arrivalDate: DateTime.parse(arrivalDate),
                                  adt: adt,
                                  chd: chd,
                                  inf: inf,
                                  tc: coachCode,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey[400],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                'assets/images/flight_landing.png',
                                color: takeOffPlace == "Country, City, Airport"
                                    ? Colors.grey[600]
                                    : Colors.black,
                              ),
                              title: Text(
                                "$arrivalPlace",
                                style: TextStyle(
                                  color:
                                      arrivalPlace == "Country, City, Airport"
                                          ? Colors.grey[600]
                                          : Colors.black,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.expand_more,
                                  color: Colors.grey[600],
                                  size: 32,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Arrival(
                                        tripNum: selected,
                                        departurePlace: takeOffPlace,
                                        dCitC: depCityCode,
                                        dConC: depDet,
                                        departureDate:
                                            DateTime.parse(departureDate),
                                        arrivalDate:
                                            DateTime.parse(arrivalDate),
                                        adt: adt,
                                        chd: chd,
                                        inf: inf,
                                        tc: coachCode,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 15,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            selectGdsSupplier();
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        gDSSupplier != "" && gDSSupplier != null
                                            ? Text(
                                                gDSSupplier,
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
                //Dates
                selected != 3
                    ? Container(
                        width: screenWidth,
                        child: Row(
                          children: [
                            //Departure Date
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Calendar(
                                        tripNum: selected,
                                        p1: takeOffPlace,
                                        dCitC: depCityCode,
                                        dConC: depDet,
                                        p2: arrivalPlace,
                                        aCitC: arrCityCode,
                                        aConC: arrDet,
                                        departureDate:
                                            DateTime.parse(departureDate),
                                        arrivalDate:
                                            DateTime.parse(arrivalDate),
                                        returnDate: "Departure Date",
                                        adt: adt,
                                        chd: chd,
                                        inf: inf,
                                        tc: coachCode,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    left: 15,
                                    right: 5,
                                  ),
                                  child: Container(
                                    height: 50,
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
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FaIcon(
                                            FontAwesomeIcons.solidCalendarAlt,
                                            color:
                                                (departureDay == DateTime(2000))
                                                    ? Colors.grey
                                                    : Colors.black87,
                                          ),
                                        ),
                                        (departureDay == DateTime(2000))
                                            ? Text(
                                                "Departure date",
                                                style: TextStyle(
                                                  color: Colors.grey[400],
                                                ),
                                              )
                                            : Text(DateFormat("dd MMM yyyy")
                                                .format(DateTime.parse(
                                                    departureDate))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //Return date
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (selected != 0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Calendar(
                                          tripNum: selected,
                                          p1: takeOffPlace,
                                          dCitC: depCityCode,
                                          dConC: depDet,
                                          p2: arrivalPlace,
                                          aCitC: arrCityCode,
                                          aConC: arrDet,
                                          departureDate:
                                              DateTime.parse(departureDate),
                                          arrivalDate:
                                              DateTime.parse(arrivalDate),
                                          returnDate: "Arrival Date",
                                          adt: adt,
                                          chd: chd,
                                          inf: inf,
                                          tc: coachCode,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    left: 5,
                                    right: 15,
                                  ),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: selected == 0
                                            ? Colors.grey[200]
                                            : Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FaIcon(
                                            FontAwesomeIcons.solidCalendarAlt,
                                            color: selected == 0
                                                ? Colors.grey[200]
                                                : ((arrivalDay ==
                                                        DateTime(2000))
                                                    ? Colors.grey
                                                    : Colors.black87),
                                          ),
                                        ),
                                        selected == 0
                                            ? Text(
                                                "Return date",
                                                style: TextStyle(
                                                  color: Colors.grey[200],
                                                ),
                                              )
                                            : ((arrivalDay == DateTime(2000))
                                                ? Text(
                                                    "Return date",
                                                    style: TextStyle(
                                                      color: Colors.grey[400],
                                                    ),
                                                  )
                                                : Text(DateFormat("dd MMM yyyy")
                                                    .format(DateTime.parse(
                                                        arrivalDate)))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                //passenger & travel class
                selected != 3
                    ? Container(
                        width: screenWidth,
                        child: Row(
                          children: [
                            //passenger
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 15,
                                  right: 5,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Passenger(
                                          tripNum: selected,
                                          p1: takeOffPlace,
                                          dCitC: depCityCode,
                                          dConC: depDet,
                                          p2: arrivalPlace,
                                          aCitC: arrCityCode,
                                          aConC: arrDet,
                                          departureDate:
                                              DateTime.parse(departureDate),
                                          arrivalDate:
                                              DateTime.parse(arrivalDate),
                                          adt: adt,
                                          chd: chd,
                                          inf: inf,
                                          tc: coachCode,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 50,
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
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.group,
                                            color: (adt + chd + inf) == 0
                                                ? Colors.grey[600]
                                                : Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "${(adt + chd + inf).toString()} Passenger",
                                          style: TextStyle(
                                            color: (adt + chd + inf) == 0
                                                ? Colors.grey[600]
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //Economy
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 5,
                                  right: 15,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TravelClass(
                                          tripNum: selected,
                                          p1: takeOffPlace,
                                          dCitC: depCityCode,
                                          dConC: depDet,
                                          p2: arrivalPlace,
                                          aCitC: arrCityCode,
                                          aConC: arrDet,
                                          departureDate:
                                              DateTime.parse(departureDate),
                                          arrivalDate:
                                              DateTime.parse(arrivalDate),
                                          adt: adt,
                                          chd: chd,
                                          inf: inf,
                                          tc: coachCode,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 50,
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
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.card_travel),
                                        ),
                                        Text(
                                          "${coach[coachCode]}",
                                          style: TextStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                //search
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 15,
                    right: 15,
                  ),
                  child: Container(
                    width: screenWidth,
                    child: MaterialButton(
                      color: Color.fromRGBO(249, 190, 6, 1),
                      onPressed: () {
                        if (selected == 0) {
                          if (depCityCode != "" &&
                              depDet != "" &&
                              arrCityCode != "" &&
                              arrDet != "" &&
                              departureDate != "2000-01-01" &&
                              (adt != 0 || chd != 0 || inf != 0)) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchPage(
                                  tripType: items[selected],
                                  depCity: depCityCode,
                                  depCon: depDet,
                                  arrCity: arrCityCode,
                                  arrCon: arrDet,
                                  depDate: departureDate,
                                  adt: adt,
                                  chd: chd,
                                  inf: inf,
                                  tc: coachId[coachCode],
                                  tcIndex: coachCode,
                                  currency: currency,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please fill all the fields"),
                            ));
                          }
                        }
                        if (selected == 1) {
                          if (depCityCode != "" &&
                              depDet != "" &&
                              arrCityCode != "" &&
                              arrDet != "" &&
                              departureDate != "2000-01-01" &&
                              arrivalDate != "2000-01-01" &&
                              (adt != 0 || chd != 0 || inf != 0)) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchPage(
                                  tripType: items[selected],
                                  depCity: depCityCode,
                                  depCon: depDet,
                                  arrCity: arrCityCode,
                                  arrCon: arrDet,
                                  depDate: departureDate,
                                  arrDate: arrivalDate,
                                  adt: adt,
                                  chd: chd,
                                  inf: inf,
                                  tc: coachId[coachCode],
                                  tcIndex: coachCode,
                                  currency: currency,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Please fill all the required fields"),
                            ));
                          }
                        }
                        if (selected == 3) {
                          if (pnr != null ||
                              pnr != "" ||
                              gDSSupplier != null ||
                              gDSSupplier != "") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImportPNR(
                                  pnr: pnr,
                                  gDSSupplier: gDSSupplier,
                                  gDSSupplierId: gDSSupplierId,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Please fill all the required fields"),
                            ));
                          }
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 12,
                          right: 12,
                        ),
                        child: Text(
                          "SEARCH",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //+550 Airlines
                Container(
                  height: 310,
                  width: screenWidth,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                    ),
                    child: Image.asset(
                      "assets/images/550-airlines.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                //Announcement
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                  ),
                  child: Card(
                    child: Container(
                      height: 400,
                      width: screenWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 32,
                              left: 20,
                            ),
                            child: Text(
                              "ANNOUNCEMENT",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            height: 340,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Up-to-date COVID-19 related passenger travel restrictions",
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      Text(
                                        "As the aviation industry is recoupling from the COVID-19 crisis, all avaition stakeholders want to ensure that they have access...",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 20,
                                          bottom: 20,
                                        ),
                                        child: Divider(
                                          color: Colors.grey,
                                          height: 10,
                                          endIndent: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "New restriction by Amman Aiport",
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      Text(
                                        "As the aviation industry is recoupling from the COVID-19 crisis, all avaition stakeholders want to ensure that they have access...",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 20,
                                          bottom: 20,
                                        ),
                                        child: Divider(
                                          color: Colors.grey,
                                          height: 10,
                                          endIndent: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Turkish Airlines operating with 13 weekly flights from Iraq",
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      Text(
                                        "Starting from October Turkish airlines started its direct flights from Iraqi airports to Istanbul airport by 7 weekly flights from",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 20,
                                          bottom: 20,
                                        ),
                                        child: Divider(
                                          color: Colors.grey,
                                          height: 10,
                                          endIndent: 10,
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 8,
                  ),
                  child: Container(
                    width: screenWidth,
                    child: Image.asset(
                      "assets/images/ewewe.png",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ],
            ),
            //Balance box
            Padding(
              padding: EdgeInsets.only(
                top: 140,
                left: 10,
                right: 10,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "BALANCE",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      currency + " " + remainingCreditLimit,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  trailing: CircleAvatar(
                    radius: 28,
                    backgroundColor: Color.fromRGBO(249, 190, 6, 1),
                    child: Text(
                      String.fromCharCodes(Runes('\u0024')),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenHeight / 25,
                      ),
                    ),
                  ),
                ),
              ),
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
                            if (mounted) {
                              setState(() {
                                showDrawer = false;
                              });
                            }
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
                        GestureDetector(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove('token');
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuthLandingPage()),
                                (route) => false);
                          },
                          child: Padding(
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
                : Container(),
          ],
        ),
      ),
    );
  }
}
