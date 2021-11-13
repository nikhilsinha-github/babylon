import 'package:babylon/main.dart';
import 'package:flutter/material.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  final int tripNum;
  final String p1;
  final String dCitC;
  final String dConC;
  final String p2;
  final String aCitC;
  final String aConC;
  final DateTime departureDate;
  final DateTime arrivalDate;
  final String returnDate;
  final int adt;
  final int chd;
  final int inf;
  final int tc;

  const Calendar({
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
    this.returnDate,
    this.adt,
    this.chd,
    this.inf,
    this.tc,
  }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState(
        this.tripNum,
        this.p1,
        this.dCitC,
        this.dConC,
        this.p2,
        this.aCitC,
        this.aConC,
        this.departureDate,
        this.arrivalDate,
        this.returnDate,
        this.adt,
        this.chd,
        this.inf,
        this.tc,
      );
}

class _CalendarState extends State<Calendar> {
  final tripNum;
  final p1;
  final dCitC;
  final dConC;
  final p2;
  final aCitC;
  final aConC;
  final departureDate;
  final arrivalDate;
  final returnDate;
  final adt;
  final chd;
  final inf;
  final tc;
  _CalendarState(
    this.tripNum,
    this.p1,
    this.dCitC,
    this.dConC,
    this.p2,
    this.aCitC,
    this.aConC,
    this.departureDate,
    this.arrivalDate,
    this.returnDate,
    this.adt,
    this.chd,
    this.inf,
    this.tc,
  );

  bool showDrawer = false;
  DateTime selectedDay = DateTime.now();
  DateTime prevDDate;
  DateTime prevADate;
  int r;

  @override
  void initState() {
    super.initState();
    if (returnDate == "Departure Date") {
      setState(() {
        r = 0;
      });
    }
    if (returnDate == "Arrival Date") {
      setState(() {
        r = 1;
      });
    }
    setState(() {
      prevDDate = departureDate;
      prevADate = arrivalDate;
    });
  }

  Widget weekText(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey, fontSize: 10),
      ),
    );
  }

  calendar() {
    if (r == 0) {
      return PagedVerticalCalendar(
        /// customize the month header look by adding a week indicator
        monthBuilder: (context, month, year) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 2,
                  left: 20,
                ),
                child: Text(
                  DateFormat('MMMM yyyy').format(DateTime(year, month)),
                  style: Theme.of(context).textTheme.bodyText1.copyWith(),
                ),
              ),
              Divider(
                indent: 10,
                endIndent: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    weekText('Mon'),
                    weekText('Tue'),
                    weekText('Wed'),
                    weekText('Thu'),
                    weekText('Fri'),
                    weekText('Sat'),
                    weekText('Sun'),
                  ],
                ),
              ),
            ],
          );
        },
        dayBuilder: (context, date) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: ((date == prevDDate) || date == selectedDay)
                    ? Color.fromRGBO(249, 190, 2, 1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  DateFormat('d').format(date),
                  style: TextStyle(
                    color: ((date == prevDDate) || date == selectedDay)
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
        onDayPressed: (date) {
          setState(() {
            selectedDay = date;
            prevDDate = null;
          });
        },
      );
    } else {
      return PagedVerticalCalendar(
        startDate: departureDate,

        /// customize the month header look by adding a week indicator
        monthBuilder: (context, month, year) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 2,
                  left: 20,
                ),
                child: Text(
                  DateFormat('MMMM yyyy').format(DateTime(year, month)),
                  style: Theme.of(context).textTheme.bodyText1.copyWith(),
                ),
              ),
              Divider(
                indent: 10,
                endIndent: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    weekText('Mon'),
                    weekText('Tue'),
                    weekText('Wed'),
                    weekText('Thu'),
                    weekText('Fri'),
                    weekText('Sat'),
                    weekText('Sun'),
                  ],
                ),
              ),
            ],
          );
        },
        dayBuilder: (context, date) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: ((date == prevDDate) ||
                        (date == prevADate) ||
                        date == selectedDay)
                    ? Color.fromRGBO(249, 190, 2, 1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  DateFormat('d').format(date),
                  style: TextStyle(
                    color: ((date == prevDDate) ||
                            (date == prevADate) ||
                            (date == selectedDay))
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
        onDayPressed: (date) {
          setState(() {
            selectedDay = date;
            prevADate = null;
          });
        },
      );
    }
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
          Container(
            height: 75,
            width: screenWidth,
            color: Colors.black87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                    left: 15,
                  ),
                  child: Text(
                    "Pick a Date",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          Container(
            height: screenHeight - 150,
            child: Stack(
              children: [
                Container(
                  height: screenHeight - 120,
                  child: calendar(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            child: MaterialButton(
                              color: Color.fromRGBO(249, 190, 2, 1),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "DONE",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (r == 0) {
                                  Navigator.pushAndRemoveUntil(
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
                                                selectedDay,
                                                arrivalDate,
                                                adt,
                                                chd,
                                                inf,
                                                tc,
                                              )),
                                      (route) => false);
                                }
                                if (r == 1) {
                                  Navigator.pushAndRemoveUntil(
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
                                          selectedDay,
                                          adt,
                                          chd,
                                          inf,
                                          tc,
                                        ),
                                      ),
                                      (route) => false);
                                }
                              },
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
        ],
      ),
    );
  }
}
