import 'package:babylon/main.dart';
import 'package:flutter/material.dart';

class Passenger extends StatefulWidget {
  final int tripNum;
  final String p1;
  final String dCitC;
  final String dConC;
  final String p2;
  final String aCitC;
  final String aConC;
  final DateTime departureDate;
  final DateTime arrivalDate;

  final int adt;
  final int chd;
  final int inf;
  final int tc;
  const Passenger({
    Key key,
    this.tripNum,
    this.p1,
    this.dCitC,
    this.dConC,
    this.p2,
    this.aCitC,
    this.aConC,
    this.departureDate,
    this.arrivalDate,
    this.adt,
    this.chd,
    this.inf,
    this.tc,
  }) : super(key: key);
  @override
  _PassengerState createState() => _PassengerState(
        this.tripNum,
        this.p1,
        this.dCitC,
        this.dConC,
        this.p2,
        this.aCitC,
        this.aConC,
        this.departureDate,
        this.arrivalDate,
        this.adt,
        this.chd,
        this.inf,
        this.tc,
      );
}

class _PassengerState extends State<Passenger> {
  final tripNum;
  final p1;
  final dCitC;
  final dConC;
  final p2;
  final aCitC;
  final aConC;
  final departureDate;
  final arrivalDate;

  final adt;
  final chd;
  final inf;
  final tc;

  _PassengerState(
    this.tripNum,
    this.p1,
    this.dCitC,
    this.dConC,
    this.p2,
    this.aCitC,
    this.aConC,
    this.departureDate,
    this.arrivalDate,
    this.adt,
    this.chd,
    this.inf,
    this.tc,
  );
  int adult = 0;
  int child = 0;
  int infant = 0;

  @override
  void initState() {
    super.initState();
    adult = adt;
    child = chd;
    infant = inf;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Column(
            children: [
              Container(
                width: screenWidth,
                color: Colors.black87,
                height: 75,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Passenger",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Adult",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text("(Age +12)"),
                trailing: Container(
                  width: 115,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          size: 28,
                        ),
                        onPressed: () {
                          if (adult != 1) {
                            setState(() {
                              adult = adult - 1;
                            });
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          "$adult",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          size: 28,
                          color: Color.fromRGBO(249, 190, 6, 1),
                        ),
                        onPressed: () {
                          if (adult < 9) {
                            setState(() {
                              adult = adult + 1;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Child",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text("(Age 2-12)"),
                trailing: Container(
                  width: 115,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            size: 28,
                          ),
                          onPressed: () {
                            if (child != 0) {
                              setState(() {
                                child = child - 1;
                              });
                            }
                          }),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          "$child",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          size: 28,
                          color: Color.fromRGBO(249, 190, 6, 1),
                        ),
                        onPressed: () {
                          if (child < 8) {
                            setState(() {
                              child = child + 1;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Infant",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text("(Age 0-2)"),
                trailing: Container(
                  width: 115,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            size: 28,
                          ),
                          onPressed: () {
                            if (infant != 0) {
                              setState(() {
                                infant = infant - 1;
                              });
                            }
                          }),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          "$infant",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          size: 28,
                          color: Color.fromRGBO(249, 190, 6, 1),
                        ),
                        onPressed: () {
                          if (infant < 4) {
                            setState(() {
                              infant = infant + 1;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              color: Color.fromRGBO(249, 190, 6, 1),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      tripNum,
                      p1,
                      p2,
                      dCitC,
                      aCitC,
                      dConC,
                      aConC,
                      departureDate,
                      arrivalDate,
                      adult,
                      child,
                      infant,
                      tc,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 90,
                  right: 90,
                ),
                child: Text(
                  "DONE",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
