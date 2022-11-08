import 'package:babylon/pages/flightDetails.dart';
import 'package:flutter/material.dart';

class AdditionalMarkup extends StatefulWidget {
  final String sessionId;
  final String refNo;
  final List rsegment;
  final String amt;
  final Map api;
  final String currency;
  final String markupFromFlightDetails;
  final String baseFare;
  final String tax;
  final String total;
  const AdditionalMarkup({
    Key key,
    this.sessionId,
    this.refNo,
    this.rsegment,
    this.amt,
    this.api,
    this.currency,
    this.markupFromFlightDetails,
    this.baseFare,
    this.tax,
    this.total,
  }) : super(key: key);
  @override
  _AdditionalMarkupState createState() => _AdditionalMarkupState(
        this.sessionId,
        this.refNo,
        this.rsegment,
        this.amt,
        this.api,
        this.currency,
        this.markupFromFlightDetails,
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
  final rsegment;
  final amt;
  final api;
  final currency;
  final markupFromFlightDetails;
  final baseFare;
  final tax;
  final total;
  _AdditionalMarkupState(
    this.sessionId,
    this.refNo,
    this.rsegment,
    this.amt,
    this.api,
    this.currency,
    this.markupFromFlightDetails,
    this.baseFare,
    this.tax,
    this.total,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (markupFromFlightDetails != null) {
      markup = markupFromFlightDetails;
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
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
                        child: TextFormField(
                          initialValue: markup,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlightDetails(
                          sessionId: sessionId,
                          refNo: refNo,
                          rsegment: rsegment,
                          amt: amt,
                          api: api,
                          currency: currency,
                          markup: markup,
                        ),
                      ),
                    );
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
                          Text("DONE"),
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
    );
  }
}
