import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BookingDocument extends StatefulWidget {
  final String url;
  const BookingDocument({
    Key key,
    this.url,
  }) : super(key: key);

  @override
  _BookingDocumentState createState() => _BookingDocumentState(this.url);
}

class _BookingDocumentState extends State<BookingDocument> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final url;
  _BookingDocumentState(this.url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
        );
      }),
    );
  }
}
