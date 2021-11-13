import 'dart:convert';

import 'package:babylon/models/flightCheckoutModel.dart';
import 'package:babylon/pages/travelerDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdditionalMarkup extends StatefulWidget {
  final String sessionId;
  final String refNo;
  final String currency;
  final String baseFare;
  final String tax;
  final String total;
  const AdditionalMarkup({
    Key key,
    this.sessionId,
    this.refNo,
    this.currency,
    this.baseFare,
    this.tax,
    this.total,
  }) : super(key: key);
  @override
  _AdditionalMarkupState createState() => _AdditionalMarkupState(
        this.sessionId,
        this.refNo,
        this.currency,
        this.baseFare,
        this.tax,
        this.total,
      );
}

class _AdditionalMarkupState extends State<AdditionalMarkup> {
  String token = "";
  String markup = "0";
  bool loading = false;

  final sessionId;
  final refNo;
  final currency;
  final baseFare;
  final tax;
  final total;
  _AdditionalMarkupState(
    this.sessionId,
    this.refNo,
    this.currency,
    this.baseFare,
    this.tax,
    this.total,
  );

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
  }

  flightCheckout() async {
    var headers = {
      'Authorization': 'Bearer $token',
      'SessionID': '$sessionId',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://ibeapi.mobile.it4t.in/api/flight/checkout'));
    request.fields.addAll({
      'OfferID': '$refNo',
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(data);
      var body = jsonDecode(data);
      var dataInJson = FlightCheckoutModel.fromJson(body);
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(dataInJson.message["Desc"]),
        ),
      );
      if (dataInJson.message["Code"] == "SUCCESS") {
        //booking confirmed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TravelerDetail(
              sessionId: sessionId,
              refNo: refNo,
              amount: total,
            ),
          ),
        );
      }
      //booking not confirmed
      else {}
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "Additional Markup",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Fare Summary",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "2 Traveler(s)",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Base Fare",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "$currency $baseFare",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Taxes & Fee",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "$currency $tax",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey[600],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 5,
                                ),
                                child: Text(
                                  "Additional Markup",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                "+$markup $currency Markup",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 50.0,
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (val) {
                                if (val == "") {
                                  setState(() {
                                    markup = "0";
                                  });
                                } else {
                                  setState(() {
                                    markup = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 100,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                    ),
                    child: MaterialButton(
                      color: Colors.yellow[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        flightCheckout();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                total,
                                style: TextStyle(),
                              ),
                              Text("$currency"),
                            ],
                          ),
                          Row(
                            children: [
                              Text("SELECT"),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
