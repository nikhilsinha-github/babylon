import 'package:babylon/main.dart';
import 'package:flutter/material.dart';
import 'package:custom_check_box/custom_check_box.dart';

class TravelClass extends StatefulWidget {
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

  const TravelClass({
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
  _TravelClassState createState() => _TravelClassState(
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

class _TravelClassState extends State<TravelClass> {
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
  _TravelClassState(
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
  bool shouldCheck = false;
  int index = 0;

  @override
  void initState() {
    super.initState();
    index = tc;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Column(
            children: [
              Container(
                width: screenWidth,
                height: 75,
                color: Colors.black87,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Travel Class",
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
                leading: CustomCheckBox(
                  value: index == 0 ? true : false,
                  shouldShowBorder: true,
                  borderColor: Colors.yellow[700],
                  checkedFillColor: Colors.white,
                  checkedIcon: Icons.circle,
                  checkedIconColor: Colors.yellow[700],
                  borderRadius: 50,
                  borderWidth: 2,
                  checkBoxSize: 20,
                  onChanged: (val) {
                    //do your stuff here
                    setState(() {
                      index = 0;
                    });
                  },
                ),
                title: GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 0;
                    });
                  },
                  child: Text(
                    "Economy",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: CustomCheckBox(
                  value: index == 1 ? true : false,
                  shouldShowBorder: true,
                  borderColor: Colors.yellow[700],
                  checkedFillColor: Colors.white,
                  checkedIcon: Icons.circle,
                  checkedIconColor: Colors.yellow[700],
                  borderRadius: 50,
                  borderWidth: 2,
                  checkBoxSize: 20,
                  onChanged: (val) {
                    //do your stuff here
                    setState(() {
                      index = 1;
                    });
                  },
                ),
                title: GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 1;
                    });
                  },
                  child: Text(
                    "Premium",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: CustomCheckBox(
                  value: index == 2 ? true : false,
                  shouldShowBorder: true,
                  borderColor: Colors.yellow[700],
                  checkedFillColor: Colors.white,
                  checkedIcon: Icons.circle,
                  checkedIconColor: Colors.yellow[700],
                  borderRadius: 50,
                  borderWidth: 2,
                  checkBoxSize: 20,
                  onChanged: (val) {
                    //do your stuff here
                    setState(() {
                      index = 2;
                    });
                  },
                ),
                title: GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 2;
                    });
                  },
                  child: Text(
                    "Business",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: CustomCheckBox(
                  value: index == 3 ? true : false,
                  shouldShowBorder: true,
                  borderColor: Colors.yellow[700],
                  checkedFillColor: Colors.white,
                  checkedIcon: Icons.circle,
                  checkedIconColor: Colors.yellow[700],
                  borderRadius: 50,
                  borderWidth: 2,
                  checkBoxSize: 20,
                  onChanged: (val) {
                    //do your stuff here
                    setState(() {
                      index = 3;
                    });
                  },
                ),
                title: GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 3;
                    });
                  },
                  child: Text(
                    "First Class",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              color: Colors.yellow[700],
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
                      adt,
                      chd,
                      inf,
                      index,
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
