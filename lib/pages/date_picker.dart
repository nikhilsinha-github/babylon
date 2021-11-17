import 'package:babylon/constraints.dart';
import 'package:babylon/pages/travelerDetail.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePicker extends StatefulWidget {
  final String field;
  final String sessionId;
  final String refNo;
  final String amount;
  final bool passportReq;
  final bool dobReq;
  final bool hesCodeReq;
  final bool idCardReq;
  final bool contactDetailsReq;
  final List paymentMethods;
  final String dobSelected;
  final String expDate;
  final List passengers;

  const DatePicker({
    Key key,
    this.field,
    this.sessionId,
    this.refNo,
    this.amount,
    this.passportReq,
    this.dobReq,
    this.hesCodeReq,
    this.idCardReq,
    this.contactDetailsReq,
    this.paymentMethods,
    this.dobSelected,
    this.expDate,
    this.passengers,
  }) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState(
        this.field,
        this.sessionId,
        this.refNo,
        this.amount,
        this.passportReq,
        this.dobReq,
        this.hesCodeReq,
        this.idCardReq,
        this.contactDetailsReq,
        this.paymentMethods,
        this.dobSelected,
        this.expDate,
        this.passengers,
      );
}

class _DatePickerState extends State<DatePicker> {
  String dateSelected = "";

  final field;
  final sessionId;
  final refNo;
  final amount;
  final passportReq;
  final dobReq;
  final hesCodeReq;
  final idCardReq;
  final contactDetailsReq;
  final paymentMethods;
  final dobSelected;
  final expDate;
  final passengers;
  _DatePickerState(
    this.field,
    this.sessionId,
    this.refNo,
    this.amount,
    this.passportReq,
    this.dobReq,
    this.hesCodeReq,
    this.idCardReq,
    this.contactDetailsReq,
    this.paymentMethods,
    this.dobSelected,
    this.expDate,
    this.passengers,
  );
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
                              dobSelected: dateSelected,
                              expDate: expDate,
                              passengers: passengers,
                            ),
                          ),
                        );
                      }
                      if (field == "expiry") {
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
                              dobSelected: dobSelected,
                              expDate: dateSelected,
                              passengers: passengers,
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
