import 'dart:convert';

import 'package:babylon/constraints.dart';
import 'package:babylon/main.dart';
import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/bookingDetails.dart';
import 'package:babylon/pages/branches.dart';
import 'package:babylon/models/bookingsModel.dart';
import 'package:babylon/pages/profile.dart';
import 'package:babylon/pages/reports.dart';
import 'package:babylon/svgIcons.dart';
import 'package:babylon/pages/users.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Bookings extends StatefulWidget {
  @override
  _BookingsState createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  String token = "";
  bool showDrawer = false;
  int index = 0;
  bool filter = false;
  List<BookingsModel> items = List<BookingsModel>();
  List ai = [];
  int found = 1;
  Color cardTextColor = Color(0xFF707070);
  List statusList = ['All Booking', 'Confirmed', 'On Request', 'Cancelled'];
  Map statusCodes = {
    'All Booking': 'ALL',
    'Confirmed': 'HK',
    'On Request': 'UC',
    'Cancelled': 'CL',
  };
  String statusName = "";
  String bookingRef = "";
  String paxRef = "";
  String contactNo = "";
  String email = "";
  String pnr = "";
  String status = "";
  String tripDateFrom = "";
  String tripDateTo = "";
  String bookingDateFrom = "";
  String bookingDateTo = "";
  bool selectTripDate = false;
  bool selectBookingDate = false;
  int tripIndex = 0;
  int bookingIndex = 0;

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
      getBookingData().then((value) {
        if (mounted) {
          setState(() {
            items = value;
          });
        }
      });
    }
  }

  getBookingData() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://ibeapi.mobile.it4t.in/api/report/bookings/'));
    request.fields.addAll({
      'bookref': '$bookingRef',
      'paxname': '$paxRef',
      'contactno': '$contactNo',
      'email': '$email',
      'pnr': '$pnr',
      'status': '$status',
      'tripdatefrom': '$tripDateFrom',
      'tripdateto': '$tripDateTo',
      'bookingdatefrom': '$bookingDateFrom',
      'bookingdateto': '$bookingDateTo',
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var dataItems = List<BookingsModel>();

    if (response.statusCode == 200) {
      var body = await response.stream.bytesToString();
      if (body != "") {
        var listItems = jsonDecode(body);
        ai = listItems;
        if (ai.isNotEmpty) {
          for (var data in listItems) {
            dataItems.add(BookingsModel.fromJson(data));
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
      appBar: showDrawer || selectTripDate || selectBookingDate
          ? AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.black87,
              elevation: 0,
            )
          : AppBar(
              backgroundColor: Colors.black87,
              elevation: 0,
              title: Text(
                "BOOKINGS",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat-Bold',
                  fontSize: 20.0,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: 32.0,
                  ),
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        showDrawer = !showDrawer;
                      });
                    }
                  },
                ),
              ],
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              filter = true;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text("Booking Filter"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.tune_rounded,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "My Bookings",
                  style: TextStyle(
                    fontFamily: 'Montserrat-Bold',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: screenHeight - 210,
                child: found == 0
                    ? Center(
                        child: Container(
                          height: screenHeight - 150,
                          child: Text("Sorry!! No results found."),
                        ),
                      )
                    : items.length == 0
                        ? Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.asset(
                                "assets/images/Group 3025.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookingDetails(
                                          bookingId: items[index].bookingRef,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 12,
                                                    bottom: 12,
                                                    left: 8,
                                                    right: 8,
                                                  ),
                                                  child: Text(
                                                    "Lead Pax: " +
                                                        items[index].leadPax,
                                                    style: TextStyle(
                                                      color: cardTextColor,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(
                                                        color: Colors.grey[400],
                                                      ),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 12,
                                                      bottom: 12,
                                                      left: 8,
                                                      right: 8,
                                                    ),
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                "Booking Ref.: ",
                                                            style: TextStyle(
                                                              color:
                                                                  cardTextColor,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: items[index]
                                                                .bookingRef,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Text(
                                                          "Status: " +
                                                              items[index]
                                                                  .status,
                                                          style: TextStyle(
                                                            color:
                                                                cardTextColor,
                                                            fontSize: items[index]
                                                                        .status ==
                                                                    "UnConfirmed"
                                                                ? 13
                                                                : 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 20.0),
                                                      child: CircleAvatar(
                                                        radius: 5,
                                                        backgroundColor: items[
                                                                        index]
                                                                    .status ==
                                                                "Confirmed"
                                                            ? Colors.green
                                                            : items[index]
                                                                        .status ==
                                                                    "UnConfirmed"
                                                                ? Colors
                                                                    .yellow[800]
                                                                : Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(
                                                        color: Colors.grey[400],
                                                      ),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 12,
                                                      bottom: 12,
                                                      left: 8,
                                                      right: 8,
                                                    ),
                                                    child: Text(
                                                      "Supplier Ref.: " +
                                                          items[index]
                                                              .supplierRef,
                                                      style: TextStyle(
                                                        color: cardTextColor,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 12,
                                                    bottom: 12,
                                                    left: 8,
                                                    right: 8,
                                                  ),
                                                  child: Text(
                                                    "Created: " +
                                                        DateFormat(
                                                                "dd MMM yyyy")
                                                            .format(DateTime
                                                                .parse(items[
                                                                        index]
                                                                    .created)),
                                                    style: TextStyle(
                                                      color: cardTextColor,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide(
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 12,
                                                    bottom: 12,
                                                    left: 8,
                                                    right: 8,
                                                  ),
                                                  child: Text(
                                                    "Payment: " +
                                                        items[index]
                                                            .paymentStatus,
                                                    style: TextStyle(
                                                      color: cardTextColor,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 12,
                                                  bottom: 12,
                                                  left: 8,
                                                  right: 8,
                                                ),
                                                child: Text(
                                                  "Deadline: " +
                                                      DateFormat("dd MMM yyyy")
                                                          .format(DateTime
                                                              .parse(items[
                                                                      index]
                                                                  .deadline)),
                                                  style: TextStyle(
                                                    color: cardTextColor,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
          filter
              ? Container(
                  color: Colors.black45,
                )
              : Container(),
          filter
              ? Align(
                  alignment: Alignment.topCenter,
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: Row(
                            children: [
                              //Booking ref
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50.0,
                                    child: TextFormField(
                                        initialValue: bookingRef,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Booking Reference",
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        onChanged: (val) {
                                          if (mounted) {
                                            setState(() {
                                              bookingRef = val;
                                            });
                                          }
                                        }),
                                  ),
                                ),
                              ),
                              //Pax name
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50.0,
                                    child: TextFormField(
                                      initialValue: paxRef,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "Pax Name",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      onChanged: (val) {
                                        if (mounted) {
                                          setState(() {
                                            paxRef = val;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: Row(
                            children: [
                              //Contact no.
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50.0,
                                    child: TextFormField(
                                      initialValue: contactNo,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "Contact No.",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      onChanged: (val) {
                                        if (mounted) {
                                          setState(() {
                                            contactNo = val;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              //Email
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50.0,
                                    child: TextFormField(
                                      initialValue: email,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "Email",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      onChanged: (val) {
                                        if (mounted) {
                                          setState(() {
                                            email = val;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: Row(
                            children: [
                              //PNR
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50.0,
                                    child: TextFormField(
                                      initialValue: pnr,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "PNR",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12.0,
                                        ),
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
                              ),
                              //Status
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 2.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                statusName ?? "",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            DropdownButton(
                                              icon: Icon(
                                                Icons.expand_more,
                                              ),
                                              items: statusList.map(
                                                (val) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: val,
                                                    child: Text(
                                                      val,
                                                      style: TextStyle(
                                                        fontSize: 10.0,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).toList(),
                                              onChanged: (val) {
                                                setState(
                                                  () {
                                                    statusName = val;
                                                    status = statusCodes[val];
                                                  },
                                                );
                                                print(status);
                                                print(statusName);
                                              },
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Trip dates
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: Row(
                            children: [
                              //Trip date (From)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          filter = false;
                                          selectTripDate = true;
                                          tripIndex = 0;
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 15.0,
                                          left: 10.0,
                                        ),
                                        child: tripDateFrom == ""
                                            ? Text(
                                                "Trip date (From)",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0,
                                                ),
                                              )
                                            : Text(
                                                tripDateFrom ?? "",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //Trip date (To)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          filter = false;
                                          selectTripDate = true;
                                          tripIndex = 1;
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 15.0,
                                          left: 10.0,
                                        ),
                                        child: tripDateTo == ""
                                            ? Text(
                                                "Trip date (To)",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0,
                                                ),
                                              )
                                            : Text(
                                                tripDateTo ?? "",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Booking dates
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: Row(
                            children: [
                              //Booking (From)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          filter = false;
                                          selectBookingDate = true;
                                          bookingIndex = 0;
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 15.0,
                                          left: 10.0,
                                        ),
                                        child: bookingDateFrom == ""
                                            ? Text(
                                                "Booking (From)",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0,
                                                ),
                                              )
                                            : Text(
                                                bookingDateFrom ?? "",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //Booking (To)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          filter = false;
                                          selectBookingDate = true;
                                          bookingIndex = 1;
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 15.0,
                                          left: 10.0,
                                        ),
                                        child: bookingDateTo == ""
                                            ? Text(
                                                "Booking (To)",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0,
                                                ),
                                              )
                                            : Text(
                                                bookingDateTo ?? "",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: Row(
                            children: [
                              //Clear Filter
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    color: Colors.redAccent[400],
                                    onPressed: () {
                                      setState(() {
                                        filter = false;
                                        bookingRef = "";
                                        paxRef = "";
                                        contactNo = "";
                                        email = "";
                                        pnr = "";
                                        status = "";
                                        tripDateFrom = "";
                                        tripDateTo = "";
                                        bookingDateFrom = "";
                                        bookingDateTo = "";
                                      });
                                      items = [];
                                      getBookingData().then((value) {
                                        if (mounted) {
                                          setState(() {
                                            items = value;
                                          });
                                        }
                                      });
                                      if (mounted) {
                                        setState(() {
                                          filter = false;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Clear Filter",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //Apply
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    color: primaryColor,
                                    onPressed: () {
                                      items = [];
                                      getBookingData().then((value) {
                                        if (mounted) {
                                          setState(() {
                                            items = value;
                                          });
                                        }
                                      });
                                      if (mounted) {
                                        setState(() {
                                          filter = false;
                                        });
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "APPLY",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          Icons.done,
                                        )
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
                )
              : Container(),
          selectTripDate
              ? Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                                      filter = true;
                                      selectTripDate = false;
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
                            minDate: tripDateTo != ""
                                ? DateTime.parse(tripDateTo)
                                : tripDateFrom != ""
                                    ? DateTime.parse(tripDateFrom)
                                    : DateTime.now(),
                            onSelectionChanged: (val) {
                              setState(() {
                                filter = true;
                                selectTripDate = false;
                                if (tripIndex == 0) {
                                  tripDateFrom =
                                      val.value.toString().substring(0, 10);
                                }
                                if (tripIndex == 1) {
                                  tripDateTo =
                                      val.value.toString().substring(0, 10);
                                }
                                //dateSelected = val.value.toString().substring(0, 10);
                              });
                              //print(dateSelected);
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
                                    filter = true;
                                    selectTripDate = false;
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
                  ),
                )
              : Container(),
          selectBookingDate
              ? Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                                      filter = true;
                                      selectBookingDate = false;
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
                            maxDate: bookingDateTo != ""
                                ? DateTime.parse(bookingDateTo)
                                : bookingDateFrom != ""
                                    ? DateTime.parse(bookingDateFrom)
                                    : DateTime.now(),
                            todayHighlightColor: Colors.transparent,
                            onSelectionChanged: (val) {
                              setState(() {
                                filter = true;
                                selectBookingDate = false;
                                if (bookingIndex == 0) {
                                  bookingDateFrom =
                                      val.value.toString().substring(0, 10);
                                }
                                if (bookingIndex == 1) {
                                  bookingDateTo =
                                      val.value.toString().substring(0, 10);
                                }
                              });
                            },
                            selectionMode: DateRangePickerSelectionMode.multiple,
                            
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
                                    filter = true;
                                    selectBookingDate = false;
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
                  ),
                )
              : Container(),
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
                                if (mounted) {
                                  setState(() {
                                    showDrawer = false;
                                  });
                                }
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
                          if (mounted) {
                            setState(() {
                              showDrawer = !showDrawer;
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
                            if (mounted) {
                              setState(() {
                                showDrawer = false;
                              });
                            }
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
                            if (mounted) {
                              setState(() {
                                showDrawer = false;
                              });
                            }
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
                            if (mounted) {
                              setState(() {
                                showDrawer = false;
                              });
                            }
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
                            if (mounted) {
                              setState(() {
                                showDrawer = false;
                              });
                            }
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
                            if (mounted) {
                              setState(() {
                                showDrawer = false;
                              });
                            }
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
              : Container(),
        ],
      ),
    );
  }
}
