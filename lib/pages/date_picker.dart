import 'package:babylon/constraints.dart';
import 'package:babylon/pages/travelerDetail.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePicker extends StatefulWidget {
  final String field;
  final int i;
  final String sessionId;
  final String refNo;
  final String amount;
  final bool passportReq;
  final bool dobReq;
  final bool hesCodeReq;
  final bool idCardReq;
  final bool contactDetailsReq;
  final List paymentMethods;
  final List passengers;
  final List travelerDetailsRecorded;
  final String markup;
  final String baseFare;
  final String taxFee;
  final String total;

  const DatePicker({
    Key key,
    this.field,
    this.i,
    this.sessionId,
    this.refNo,
    this.amount,
    this.passportReq,
    this.dobReq,
    this.hesCodeReq,
    this.idCardReq,
    this.contactDetailsReq,
    this.paymentMethods,
    this.passengers,
    this.travelerDetailsRecorded,
    this.markup,
    this.baseFare,
    this.taxFee,
    this.total,
  }) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState(
        this.field,
        this.i,
        this.sessionId,
        this.refNo,
        this.amount,
        this.passportReq,
        this.dobReq,
        this.hesCodeReq,
        this.idCardReq,
        this.contactDetailsReq,
        this.paymentMethods,
        this.passengers,
        this.travelerDetailsRecorded,
        this.markup,
        this.baseFare,
        this.taxFee,
        this.total,
      );
}

class _DatePickerState extends State<DatePicker> {
  String dateSelected = "";
  List travelDetailsDateSetup = [];

  final field;
  final i;
  final sessionId;
  final refNo;
  final amount;
  final passportReq;
  final dobReq;
  final hesCodeReq;
  final idCardReq;
  final contactDetailsReq;
  final paymentMethods;
  final markup;
  final baseFare;
  final taxFee;
  final total;
  final passengers;
  final travelerDetailsRecorded;
  _DatePickerState(
    this.field,
    this.i,
    this.sessionId,
    this.refNo,
    this.amount,
    this.passportReq,
    this.dobReq,
    this.hesCodeReq,
    this.idCardReq,
    this.contactDetailsReq,
    this.paymentMethods,
    this.passengers,
    this.travelerDetailsRecorded,
    this.markup,
    this.baseFare,
    this.taxFee,
    this.total,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(travelerDetailsRecorded);
    travelDetailsDateSetup = travelerDetailsRecorded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "Pick a date",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat-Bold',
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SfDateRangePicker(
            todayHighlightColor: Colors.transparent,
            onSelectionChanged: (val) {
              setState(() {
                dateSelected = val.value.toString().substring(0, 10);
              });
              print(dateSelected);
            },
            selectionMode: DateRangePickerSelectionMode.single,
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
                      if (field == "dob") {
                        setState(() {
                          travelDetailsDateSetup[i]["DOB"] = dateSelected;
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TravelerDetail(
                              sessionId: sessionId,
                              refNo: refNo,
                              amount: amount,
                              passportReq: passportReq,
                              dobReq: dobReq,
                              hesCodeReq: hesCodeReq,
                              idCardReq: idCardReq,
                              contactDetailsReq: contactDetailsReq,
                              paymentMethods: paymentMethods,
                              passengers: passengers,
                              travelerDetailsRecorded: travelDetailsDateSetup,
                              markup: markup,
                              baseFare: baseFare,
                              taxFee: taxFee,
                              total: total,
                            ),
                          ),
                        );
                      }
                      if (field == "expiry") {
                        setState(() {
                          travelDetailsDateSetup[i]["DocExpiry"] = dateSelected;
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TravelerDetail(
                              sessionId: sessionId,
                              refNo: refNo,
                              amount: amount,
                              passportReq: passportReq,
                              dobReq: dobReq,
                              hesCodeReq: hesCodeReq,
                              idCardReq: idCardReq,
                              contactDetailsReq: contactDetailsReq,
                              paymentMethods: paymentMethods,
                              passengers: passengers,
                              travelerDetailsRecorded: travelDetailsDateSetup,
                              markup: markup,
                              baseFare: baseFare,
                              taxFee: taxFee,
                              total: total,
                            ),
                          ),
                        );
                      }
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
    );
  }
}
