import 'dart:convert';

import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/booking_document.dart';
import 'package:babylon/pages/branches.dart';
import 'package:babylon/constraints.dart';
import 'package:babylon/generalFunctions.dart';
import 'package:babylon/models/bookingDetailsModel.dart';
import 'package:babylon/pages/profile.dart';
import 'package:babylon/pages/reports.dart';
import 'package:babylon/svgIcons.dart';
import 'package:babylon/pages/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingDetails extends StatefulWidget {
  final String bookingId;

  const BookingDetails({Key key, this.bookingId}) : super(key: key);
  @override
  _BookingDetailsState createState() => _BookingDetailsState(this.bookingId);
}

class _BookingDetailsState extends State<BookingDetails> {
  final bookingId;
  _BookingDetailsState(this.bookingId);

  String token = "";
  bool showDrawer = false;
  bool loading = false;
  int found = 1;
  List<BookingDetailModel> items = List<BookingDetailModel>();
  var genFunc = GenFunc();
  Color cardTextColor = Color(0xFF707070);

  @override
  void initState() {
    super.initState();
    getToken();
    debugPrint(bookingId);
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        token = prefs.getString('token');
      });
    }
    if (items.isEmpty) {
      getData().then((value) {
        if (mounted) {
          setState(() {
            items.addAll(value);
          });
        }
      });
    }
  }

  getData() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest('POST',
        Uri.parse('http://ibeapi.mobile.it4t.in/api/booking/bookingdetails/'));
    request.fields.addAll({'BookingRef': '$bookingId'});
    print('$bookingId');

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var dataItems = List<BookingDetailModel>();

    if (response.statusCode == 200) {
      var body = await response.stream.bytesToString();
      print(body);
      if (body != "") {
        var listItems = jsonDecode(body);
        dataItems.add(BookingDetailModel.fromJson(listItems));
        print(dataItems);

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
      print(response.reasonPhrase);
    }

    return dataItems;
  }

  cancelBooking() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest('POST',
        Uri.parse('http://ibeapi.mobile.it4t.in/api/booking/cancelpnr'));
    request.fields.addAll({'BookingRef': '$bookingId'});

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
      setState(() {
        loading = false;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  issueTicket() async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('http://ibeapi.mobile.it4t.in/api/booking/issueticket'));
    request.body = json.encode({
      "TotalOfferPrice": "250",
      "Passengers": [4562],
      "BookingRef": "302119",
      "PaymentMethod": "wallet",
      "QueueStatus": ""
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
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
          SingleChildScrollView(
            child: found == 0
                ? Center(
                    child: Container(
                      height: screenHeight - 150,
                      child: Text("Sorry!! No results found."),
                    ),
                  )
                : items.length == 0
                    ? Container(
                        height: screenHeight,
                        child: Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              "assets/images/Group 3025.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 2.0,
                                      ),
                                      child: Card(
                                        elevation: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                            "Booking Detail",
                                            style: TextStyle(
                                              fontFamily: 'Montserrat-Bold',
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 2.0,
                                      ),
                                      child: Card(
                                        elevation: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                            "Help & Support",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Montserrat-Bold',
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 40,
                                bottom: 10,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Booking ID: ",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: bookingId,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16.0,
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
                                  leading: Icon(
                                    Icons.info_rounded,
                                    color: Colors.yellow[700],
                                  ),
                                  title: Text(
                                    "Booking Information",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Sector :",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(items[0].bookingInformation ==
                                                  null
                                              ? ""
                                              : items[0].bookingInformation[
                                                  'Sector']),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Name :",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(items[0].bookingInformation ==
                                                  null
                                              ? ""
                                              : items[0]
                                                  .bookingInformation['Name']),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Created by :",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(items[0].bookingInformation ==
                                                  null
                                              ? ""
                                              : items[0].bookingInformation[
                                                  'Createdby']),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Booking Date :",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(items[0].bookingInformation ==
                                                  null
                                              ? ""
                                              : items[0].bookingInformation[
                                                  'BookingDate']),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Locked by :",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(items[0].bookingInformation ==
                                                  null
                                              ? ""
                                              : items[0].bookingInformation[
                                                  'LockedBy']),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Status :",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              items[0].bookingInformation ==
                                                      null
                                                  ? Container()
                                                  : Text(items[0]
                                                          .bookingInformation[
                                                      'Status']),
                                              items[0].bookingInformation ==
                                                      null
                                                  ? Container()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: CircleAvatar(
                                                        radius: 5,
                                                        backgroundColor: items[
                                                                            0]
                                                                        .bookingInformation[
                                                                    'Status'] ==
                                                                "Confirmed"
                                                            ? Colors.green
                                                            : items[0].bookingInformation[
                                                                        'Status'] ==
                                                                    "UnConfirmed"
                                                                ? Colors
                                                                    .yellow[800]
                                                                : Colors.red,
                                                      ),
                                                    ),
                                            ],
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
                                  leading: Icon(
                                    FontAwesomeIcons.plane,
                                    color: Colors.yellow[700],
                                    size: 20,
                                  ),
                                  title: Text(
                                    "Flight Itinerary",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  children: [
                                    items[0].flightSeg == null
                                        ? Container()
                                        : Container(
                                            constraints: BoxConstraints(
                                              minHeight: 100,
                                              maxHeight: 500,
                                            ),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  items[0].flightSeg.length,
                                              itemBuilder: (context, index) {
                                                var flight = items[0].flightSeg[
                                                    (index + 1).toString()];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Card(
                                                    elevation: items[0]
                                                                .flightSeg
                                                                .length ==
                                                            1
                                                        ? 0
                                                        : 5,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    flight[0][
                                                                            "DepartureAirport"] +
                                                                        " - " +
                                                                        flight[flight.length -
                                                                                1]
                                                                            [
                                                                            "ArrivalAirport"],
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Montserrat-Bold',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(DateFormat(
                                                                          "EEE, dd MMM")
                                                                      .format(DateTime.parse(
                                                                          flight[0]
                                                                              [
                                                                              "DepartureDate"]))
                                                                      .toString()),
                                                                ],
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  genFunc.getDuration(
                                                                      flight[0][
                                                                          "TotalDuration"]),
                                                                  Text((flight.length -
                                                                              1)
                                                                          .toString() +
                                                                      " stop"),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                        ),
                                                        SingleChildScrollView(
                                                          child: Column(
                                                            children:
                                                                List.generate(
                                                              flight.length,
                                                              (index) {
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            flight[index]["DepartureAirport"],
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 12.0,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            flight[index]["DepartureTime"],
                                                                            style:
                                                                                TextStyle(
                                                                              color: cardTextColor,
                                                                              fontFamily: 'Montserrat-Bold',
                                                                              fontSize: 18.0,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            DateFormat("EEE, dd MMM").format(DateTime.parse(flight[index]["DepartureDate"])),
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 12.0,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "Terminal: " +
                                                                                flight[index]["DepartureTerminal"],
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 12.0,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            flight[index]["ArrivalAirport"],
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 12.0,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            flight[index]["ArrivalTime"],
                                                                            style:
                                                                                TextStyle(
                                                                              color: cardTextColor,
                                                                              fontFamily: 'Montserrat-Bold',
                                                                              fontSize: 18.0,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            DateFormat("EEE, dd MMM").format(DateTime.parse(flight[index]["ArrivalDate"])),
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 12.0,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "Terminal: " +
                                                                                flight[index]["ArrivalTerminal"],
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 12.0,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
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
                                  leading: Icon(
                                    Icons.group_rounded,
                                    color: Colors.yellow[700],
                                  ),
                                  title: Text(
                                    "Travel(s) Details",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  children: [
                                    items[0].travelDetails == null
                                        ? Container()
                                        : Container(
                                            constraints: BoxConstraints(
                                              minHeight: 100,
                                              maxHeight: 500,
                                            ),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  items[0].travelDetails.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Card(
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Name :",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      cardTextColor,
                                                                ),
                                                              ),
                                                              Text(items[0]
                                                                      .travelDetails[
                                                                  index]["Name"]),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Phone Number :",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      cardTextColor,
                                                                ),
                                                              ),
                                                              Text(items[0]
                                                                          .travelDetails[
                                                                      index][
                                                                  "PhoneNumber"]),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Nationality :",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      cardTextColor,
                                                                ),
                                                              ),
                                                              Text(items[0]
                                                                          .travelDetails[
                                                                      index][
                                                                  "Nationality"]),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Passport Number :",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      cardTextColor,
                                                                ),
                                                              ),
                                                              Text(items[0]
                                                                          .travelDetails[
                                                                      index][
                                                                  "PassportNumber"]),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Ticket Number :",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      cardTextColor,
                                                                ),
                                                              ),
                                                              Text(items[0].travelDetails[
                                                                              index]
                                                                          [
                                                                          "TicketNumber"] !=
                                                                      null
                                                                  ? items[0].travelDetails[
                                                                          index]
                                                                      [
                                                                      "TicketNumber"]
                                                                  : "null"),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Date of birth :",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      cardTextColor,
                                                                ),
                                                              ),
                                                              Text(items[0]
                                                                          .travelDetails[
                                                                      index][
                                                                  "DateofBirth"]),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Status :",
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      cardTextColor,
                                                                ),
                                                              ),
                                                              Text(items[0]
                                                                      .travelDetails[
                                                                  index]["Status"]),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
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
                                  leading: Icon(
                                    FontAwesomeIcons.dollarSign,
                                    color: Colors.yellow[700],
                                    size: 20,
                                  ),
                                  title: Text(
                                    "Costing Details",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  children: [
                                    Container(
                                      color: Colors.grey,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Service type",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 60,
                                            child: VerticalDivider(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Net Price",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 60,
                                            child: VerticalDivider(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Gross Price",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 60,
                                            child: VerticalDivider(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Profit",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    items[0].costingDetails == null
                                        ? Container()
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: List.generate(
                                                items[0].costingDetails.length,
                                                (index) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8.0,
                                                        ),
                                                        child: Text(
                                                          items[0].costingDetails[
                                                                      index]
                                                                  ["PaxType"] ??
                                                              "",
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      child: VerticalDivider(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8.0,
                                                        ),
                                                        child: Text(
                                                          items[0].costingDetails[
                                                                  index]
                                                              ["NetPrice"],
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      child: VerticalDivider(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8.0,
                                                        ),
                                                        child: Text(
                                                          items[0].costingDetails[
                                                                  index]
                                                              ["GrossPrice"],
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      child: VerticalDivider(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8.0,
                                                        ),
                                                        child: Text(
                                                          items[0]
                                                              .costingDetails[
                                                                  index]
                                                                  ["Profit"]
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: ExpansionTile(
                                  leading: Icon(
                                    FontAwesomeIcons.solidCreditCard,
                                    color: Colors.yellow[700],
                                    size: 20,
                                  ),
                                  title: Text(
                                    "Payment Details",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  children: [
                                    items[0].paymentDetails == null
                                        ? Container()
                                        : Container(
                                            color: Colors.grey,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Total Amount Payable",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'Montserrat-Medium',
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 60,
                                                  child: VerticalDivider(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Amount Recieved",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'Montserrat-Medium',
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 60,
                                                  child: VerticalDivider(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Amount Due",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'Montserrat-Medium',
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    items[0].paymentDetails == null
                                        ? Container()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    items[0].paymentDetails[
                                                        "TotalPayableAmount"],
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                child: VerticalDivider(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    items[0].paymentDetails[
                                                        "AmountRecived"],
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                child: VerticalDivider(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    items[0].paymentDetails[
                                                        "AmountDue"],
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: ExpansionTile(
                                  leading: Image.asset(
                                    'assets/images/document.png',
                                    height: 32,
                                    width: 28,
                                  ),
                                  title: Text(
                                    "Booking Document",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  children: [
                                    Container(
                                      color: Colors.grey,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Description",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            child: VerticalDivider(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Issued on",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            child: VerticalDivider(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    items[0].bookingDocument == null
                                        ? Container()
                                        : Column(
                                            children: List.generate(
                                                items[0].bookingDocument.length,
                                                (index) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          items[0].bookingDocument[
                                                                  index]
                                                              ["Description"],
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      child: VerticalDivider(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          items[0].bookingDocument[
                                                                  index]
                                                              ["IssuedOn"],
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      child: VerticalDivider(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            print("clicked");
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BookingDocument(
                                                                  url: items[0]
                                                                              .bookingDocument[
                                                                          index]
                                                                      ["View"],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .remove_red_eye_rounded,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                child: Text(
                                                                  "View",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Cancel booking
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MaterialButton(
                                        color: cancelBtnColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        onPressed: () {
                                          cancelBooking();
                                          setState(() {
                                            loading = true;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 17.0,
                                          ),
                                          child: Text(
                                            "CANCEL BOOKING",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Montserrat-Medium',
                                              fontSize: 10.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //Issue ticket
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MaterialButton(
                                        color: Colors.yellow[700],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        onPressed: () {
                                          issueTicket();
                                          setState(() {
                                            loading = true;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15.0,
                                          ),
                                          child: Text(
                                            "ISSUE TICKET",
                                            style: TextStyle(
                                              fontFamily: 'Montserrat-SemiBold',
                                              fontSize: 15.0,
                                            ),
                                          ),
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
                            showDrawer = !showDrawer;
                          });
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
