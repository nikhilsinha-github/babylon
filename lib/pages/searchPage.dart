import 'dart:convert';
import 'dart:math';

import 'package:babylon/main.dart';
import 'package:babylon/pages/agencyInfo.dart';
import 'package:babylon/pages/bookings.dart';
import 'package:babylon/pages/branches.dart';
import 'package:babylon/pages/flightDetails.dart';
import 'package:babylon/models/flightInfoModel.dart';
import 'package:babylon/models/flightSearchResultModel.dart';
import 'package:babylon/pages/profile.dart';
import 'package:babylon/pages/reports.dart';
import 'package:babylon/svgIcons.dart';
import 'package:babylon/pages/users.dart';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';

class SearchPage extends StatefulWidget {
  final String tripType;
  final String depCity;
  final String depCon;
  final String arrCity;
  final String arrCon;
  final String depDate;
  final String arrDate;
  final int adt;
  final int chd;
  final int inf;
  final String tc;
  final int tcIndex;
  final String currency;

  const SearchPage({
    Key key,
    this.tripType,
    this.depCity,
    this.depCon,
    this.arrCity,
    this.arrCon,
    this.depDate,
    this.arrDate,
    this.adt,
    this.chd,
    this.inf,
    this.tc,
    this.tcIndex,
    this.currency,
  }) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState(
        this.tripType,
        this.depCity,
        this.depCon,
        this.arrCity,
        this.arrCon,
        this.depDate,
        this.arrDate,
        this.adt,
        this.chd,
        this.inf,
        this.tc,
        this.tcIndex,
        this.currency,
      );
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final tripType;
  final depCity;
  final depCon;
  final arrCity;
  final arrCon;
  final depDate;
  final arrDate;
  final adt;
  final chd;
  final inf;
  final tc;
  final tcIndex;
  final currency;
  _SearchPageState(
    this.tripType,
    this.depCity,
    this.depCon,
    this.arrCity,
    this.arrCon,
    this.depDate,
    this.arrDate,
    this.adt,
    this.chd,
    this.inf,
    this.tc,
    this.tcIndex,
    this.currency,
  );

  String reqBody = "";
  bool showDrawer = false;
  bool showPrice = false;
  bool showStop = false;
  bool showTimes = false;
  RangeValues tempPrice = RangeValues(0.0, 500.0);
  List price = [0.0, 500.0];
  int stopIndex = 0;
  List noOfStops = [];
  int outbound = 0;
  List times = [];
  List timeData = [
    "00:00-06:00",
    "06:00-12:00",
    "12:00-18:00",
    "18:00-23:59",
  ];
  List<FlightSearchResultModel> items = List<FlightSearchResultModel>();
  int found = 1;
  List travelClass = [
    "Economy",
    "Premium",
    "Business",
    "First Class",
  ];
  List coachId = ["EC", "PE", "BC", "FC"];
  List ai = [];
  bool filter = false;
  String storedSessionID = "";
  String sessionID = "";
  String box = "default";

  TabController _tabController;

  int selected = 0;
  List tripItems = [
    "One Way",
    "Round Trip",
    "Multi City",
    "Import PNR",
  ];

  int adult = 0;
  int child = 0;
  int infant = 0;
  bool modify = false;
  bool showTrip = false;
  bool showPassenger = false;
  bool showTravelClass = false;
  int travelClassIndex = 0;
  bool showDep = false;
  bool showArr = false;
  bool showDepDate = false;
  bool showArrDate = false;
  String selectedDepPlace = "";
  String modDep = "";
  String modDepTag = "";
  String modArr = "";
  String selectedArrPlace = "";
  String modArrTag = "";
  String place = "";
  List<FlightInfo> placeItems = List<FlightInfo>();
  DateTime modDepDate;
  String modStrDep = "";
  DateTime modArrDate;
  String modStrArr = "";
  String sessionIdRetrieved = "";

  @override
  void initState() {
    super.initState();
    adult = adt;
    child = chd;
    infant = inf;
    modDep = depCity;
    modArr = arrCity;
    modDepTag = depCon;
    modArrTag = arrCon;
    selectedDepPlace = depCity;
    selectedArrPlace = arrCity;
    modStrDep = depDate;
    modStrArr = arrDate;
    if (depDate != null) {
      modDepDate = DateTime.parse(depDate);
    }
    if (arrDate != null) {
      modArrDate = DateTime.parse(arrDate);
    }
    for (var i = 0; i < tripItems.length; i++) {
      if (tripType == tripItems[i]) {
        if (mounted) {
          setState(() {
            selected = i;
          });
        }
      }
    }
    if (tripType == "One Way") {
      reqBody =
          '{"Request":{"Flight":{"SearchCriteria":{"Flights":{"CabinCode":"$tc","TripType":"OW","JourneyType":"","RequestedSegment":[{"DeparturePoint":"$depCity","ArrivalPoint":"$arrCity","Date":"$depDate","Time":"","DepartureCountryCity":"$depCon","ArrivalCountryCity":"$arrCon"}]},"Passengers":{"Passenger":[{"Type":"ADT","Count": "$adt"},{"Type":"CHD","Count":"$chd"},{"Type":"INF","Count":"$inf"}]},"AdvanceSearch":{"DirectFlight":"false"}}}}}';
    }
    if (tripType == "Round Trip") {
      reqBody =
          '{"Request":{"Flight":{"SearchCriteria":{"Flights":{"CabinCode": "$tc","TripType":"RT","JourneyType":"","RequestedSegment":[{"DeparturePoint": "$depCity","ArrivalPoint": "$arrCity","Date": "$depDate","Time": "","DepartureCountryCity": "$depCon","ArrivalCountryCity": "$arrCon"}, {"DeparturePoint": "$arrCity","ArrivalPoint": "$depCity","Date": "$arrDate","Time": "","DepartureCountryCity": "$arrCon","ArrivalCountryCity": "$depCon"}]},"Passengers": {"Passenger": [{"Type": "ADT","Count": "$adt"}, {"Type": "CHD","Count": "$chd"}, {"Type": "INF","Count": "$inf"}]},"AdvanceSearch": {"DirectFlight": "false"}}}}}';
    }
    _tabController = TabController(length: 2, vsync: this);
  }

  String convertStringToDate(monthNum) {
    List monthList = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    return monthList.elementAt(int.parse(monthNum) + 1);
  }

  generateDigits(min, max) {
    int n;
    n = min + Random().nextInt(max - min);
    return n;
  }

  generateID() {
    String genNum = "";
    for (var i = 0; i < 4; i++) {
      if (i < 3) {
        genNum = genNum + generateDigits(10000, 99999).toString();
      }
      if (i == 3) {
        genNum = genNum + generateDigits(1000, 9999).toString();
      }
    }
    return genNum;
  }

  searchFlight() async {
    var baseurl = "http://ibeapi.mobile.it4t.in/api/flight/";
    var normalSearch = "search";
    var filterUrl = "filterflightresult?page=1";
    var extendedUrl = normalSearch;
    if (filter == true) {
      if (mounted) {
        setState(() {
          extendedUrl = filterUrl;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          extendedUrl = normalSearch;
        });
      }
    }

    if (filter == false) {
      setState(() {
        storedSessionID = generateID();
      });
    }

    setState(() {
      sessionID = storedSessionID;
    });

    print(sessionID);

    var headers = {
      'ClientId': '35',
      'SessionId': '$sessionID',
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiODU3NDQxNDhjMzZjMTA2OTMyYWU2MTNlNjUwY2E2ZGYzOTA5OTgzZGNkOWRkZGQ0Mjc5MTAwM2FlMWFhZTQzZTc1NjI2ZjY2MDgxNmNjZWUiLCJpYXQiOjE2MjYxMDQxOTUsIm5iZiI6MTYyNjEwNDE5NSwiZXhwIjoxNjU3NjQwMTk1LCJzdWIiOiIzNCIsInNjb3BlcyI6W119.LEuM65-AfWp11wyZ98rDDuF0Hqd1hbDEeHJCATRsJGZFe8Pyq_XAD1xecHjigG0aLF3-Dxt1YXhnF3SbMJJhoYsi-hZFYqrT8aHU8La5WaLefw46PqrhNjpMws0m7_emKU3nCSm_oPjOAEpiPhlniwyG08ab6qFbW2HfyYg2alfdyxAadGdbPRbThG02D6mLrEie1deP4Hu25gcWVysufGP-rB2Zr6EZnhZ280iq3PA1PGMK9hBso-GMfFr7ae-KI-eC2iaFepW2SV9UIJI3F82G-g7c3efdV5PiviEkgPj7wK4ev18dzQ6tfiZDt6OcvEyasKA6biOZShCXYyvD0dZb1ut4yEoClqd15MC-KyDxdkZOmJRaCNXc0F5Iw0gZDGTvX1d7xWr7HfaOPlQsxhSvvbvZu3GEUjG2ouqEeMfSx2TRNWIUzAH9xYo1pm0x9k-79ui2jn4Fi3tw-HLJVIYqGiMyUaQ4oEc6Zdx9GT9drUHxXXl0xgWdqa2z_Kojk2v6-gSi7z1Qwj40XdRGh2fmw9Ci2mGajOesyYTqqSwyGf9hiV9NJ9FIVjkRFwxs3-80m2d8WrdDsJsozDEOYw1bywN8G_WUhC-ajB_2aWRffKtBr0b02cBRkWshm5avL0CnsLM7YYMP6HSm0AIDI16Hd6C8vxekPvN-zeDUAkQ",
    };
    var request = http.Request('POST', Uri.parse('$baseurl' + '$extendedUrl'));
    request.body = reqBody;

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print(request.body);

    var dataItems = List<FlightSearchResultModel>();

    if (response.statusCode == 200) {
      var body = await response.stream.bytesToString();

      if (body != "") {
        print(body);
        sessionIdRetrieved = jsonDecode(body)["Master"]["SessionId"];
        var listItems = jsonDecode(body)["Flight"]["AirlineList"]["AI"];
        ai = listItems;
        if (ai.isNotEmpty) {
          for (var data in listItems) {
            dataItems.add(FlightSearchResultModel.fromJson(data));
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

  getPlace(pre) async {
    var headers = {
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiZDUxOWIxOTlkNDI5ZTdiNGM3Y2FjZTM4ODk1MzQxMmE1YTRkYjYyNGI3MzM5MjJhYzc5NDc1YjYxNjFmZDllZmQ2YTI0Y2YyNjBhMWI4NmQiLCJpYXQiOjE2MjU2NjIzMjcsIm5iZiI6MTYyNTY2MjMyNywiZXhwIjoxNjU3MTk4MzI3LCJzdWIiOiIzNCIsInNjb3BlcyI6W119.m0ZWYeSJao_lTeP701QAtnKtvjFNLg_CkXKOpJVKb3FLTzK1qHVvJZM63WTJlI1H1PDhzcII5uolLcTXHmPWWiBAZTwDjo7FBZg_TgCG1Gf0fAA8WmlnHTmf-4EclFX1-XRUVcrCi_NV6NkLXl4lhqJEZCgCd8-8LEA3EWXIqJS9YUZ9yCqCPL4w3Q6Rz1iL8STlRolmJVj_4npTKFv3NY01R0UMFgYajzPTrFF5XQWmzIXcRxVrmX0wNf11ou01P2KtshjOL-mSdNog_p0vSRR5CRAMm0Q0a1zANbn2WMAy7q8utq9UwQ0mzosxtpgVnnHJxWCvMf2EF4DB_To5nDUq0WX8i-JBLM4gu9aiWK6Jp-1nQHl5xjssIOdfVxhwRnyHhg5QdV6omgMzgMOAfnlGEpFG1BDkXcUqVzttkX2GLeNenvRiljKa0R1x0hl5FIQmQWYqHJgDJWrCGTymjeH574A5nAH4-biQsuHp5tKCDHoy4KZuWhqJGUfCuT-1fvmfSlfRZyrdae_m8tabDVB72YVdQwhrckv_c6s26X3oaQAiCsUdOrz8hXZ2ff-04g0RP9VDFX7pCRbInusuet-BgDQK2lBb-jNjP-IstzJYaNEFcNMJWxQONT8cLvsK69oDXKqzGPeWvng-J3cu92Ie90mZA9gGWf25T1S3cqc'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://ibeapi.mobile.it4t.in/api/static/airports'));
    request.fields.addAll({'prefix': '$pre'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var dataItems = List<FlightInfo>();

    if (response.statusCode == 200) {
      var body = await response.stream.bytesToString();
      var listItems = jsonDecode(body)["Items"];
      for (var data in listItems) {
        dataItems.add(FlightInfo.fromJson(data));
      }
    } else {
      print(response.reasonPhrase);
    }
    return dataItems;
  }

  getDuration(i) {
    int dur = ai[i]["Duration"];
    String hr = ((dur / 60).floor()).toString();
    String min = (dur % 60).toString();
    return Text(hr + "hr " + min + "min");
  }

  showPriceSlider() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 125,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Price"),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    showPrice = false;
                                  });
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      Text("Set maximum price"),
                      RangeSlider(
                        values: tempPrice,
                        min: 0.0,
                        max: 1000,
                        inactiveColor: Colors.grey[400],
                        onChanged: (val) {
                          if (mounted) {
                            setState(() {
                              tempPrice = val;
                            });
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "${tempPrice.start} - ${tempPrice.end}",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showStopBox() {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 125,
              left: 20,
              right: 20,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                          ),
                          child: Text(
                            "Stop",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    ListTile(
                      leading: CustomCheckBox(
                        value: stopIndex == 0 ? true : false,
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
                          if (mounted) {
                            setState(() {
                              stopIndex = 0;
                              noOfStops = [0, 1, 2, 3];
                            });
                          }
                        },
                      ),
                      title: Text(
                        "Any number of stops",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: CustomCheckBox(
                        value: stopIndex == 1 ? true : false,
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
                          if (mounted) {
                            setState(() {
                              stopIndex = 1;
                              noOfStops = [0];
                            });
                          }
                        },
                      ),
                      title: Text(
                        "No stops only",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: CustomCheckBox(
                        value: stopIndex == 2 ? true : false,
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
                          if (mounted) {
                            setState(() {
                              stopIndex = 2;
                              noOfStops = [0, 1];
                            });
                          }
                        },
                      ),
                      title: Text(
                        "One stop or fewer",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: CustomCheckBox(
                        value: stopIndex == 3 ? true : false,
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
                          if (mounted) {
                            setState(() {
                              stopIndex = 3;
                              noOfStops = [0, 1, 2];
                            });
                          }
                        },
                      ),
                      title: Text(
                        "Two stops or fewer",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  showTimesSlider() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 125,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Times",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    showTimes = false;
                                  });
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: CustomCheckBox(
                          value: times.contains(0) ? true : false,
                          shouldShowBorder: true,
                          borderColor: Colors.yellow[700],
                          checkedFillColor: Colors.white,
                          checkedIcon: Icons.done,
                          checkedIconColor: Colors.yellow[700],
                          borderRadius: 5,
                          borderWidth: 2,
                          checkBoxSize: 20,
                          onChanged: (val) {
                            if (val) {
                              if (mounted) {
                                setState(() {
                                  times.add(0);
                                });
                              }
                            } else {
                              if (mounted) {
                                setState(() {
                                  times.remove(0);
                                });
                              }
                            }
                          },
                        ),
                        title: Text(
                          timeData[0],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: CustomCheckBox(
                          value: times.contains(1) ? true : false,
                          shouldShowBorder: true,
                          borderColor: Colors.yellow[700],
                          checkedFillColor: Colors.white,
                          checkedIcon: Icons.done,
                          checkedIconColor: Colors.yellow[700],
                          borderRadius: 5,
                          borderWidth: 2,
                          checkBoxSize: 20,
                          onChanged: (val) {
                            if (val) {
                              if (mounted) {
                                setState(() {
                                  times.add(1);
                                });
                              }
                            } else {
                              if (mounted) {
                                setState(() {
                                  times.remove(1);
                                });
                              }
                            }
                          },
                        ),
                        title: Text(
                          timeData[1],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: CustomCheckBox(
                          value: times.contains(2) ? true : false,
                          shouldShowBorder: true,
                          borderColor: Colors.yellow[700],
                          checkedFillColor: Colors.white,
                          checkedIcon: Icons.done,
                          checkedIconColor: Colors.yellow[700],
                          borderRadius: 5,
                          borderWidth: 2,
                          checkBoxSize: 20,
                          onChanged: (val) {
                            if (val) {
                              if (mounted) {
                                setState(() {
                                  times.add(2);
                                });
                              }
                            } else {
                              if (mounted) {
                                setState(() {
                                  times.remove(2);
                                });
                              }
                            }
                          },
                        ),
                        title: Text(
                          timeData[2],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: CustomCheckBox(
                          value: times.contains(3) ? true : false,
                          shouldShowBorder: true,
                          borderColor: Colors.yellow[700],
                          checkedFillColor: Colors.white,
                          checkedIcon: Icons.done,
                          checkedIconColor: Colors.yellow[700],
                          borderRadius: 5,
                          borderWidth: 2,
                          checkBoxSize: 20,
                          onChanged: (val) {
                            if (val) {
                              if (mounted) {
                                setState(() {
                                  times.add(3);
                                });
                              }
                            } else {
                              if (mounted) {
                                setState(() {
                                  times.remove(3);
                                });
                              }
                            }
                          },
                        ),
                        title: Text(
                          timeData[3],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  getTimes() {
    var selectedTimes = [];
    for (var i = 0; i < times.length; i++) {
      selectedTimes.add(timeData[times[i]]);
    }
    return selectedTimes;
  }

  Widget selectTrip() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 80,
        left: 20,
        right: 20,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CustomCheckBox(
                    value: selected == 0 ? true : false,
                    shouldShowBorder: true,
                    borderColor: Colors.white,
                    checkedFillColor: Colors.white,
                    checkedIcon: Icons.done,
                    checkedIconColor: Colors.yellow[700],
                    borderRadius: 5,
                    borderWidth: 2,
                    checkBoxSize: 20,
                    onChanged: (val) {
                      if (mounted) {
                        setState(() {
                          selected = 0;
                          showTrip = false;
                        });
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          selected = 0;
                          showTrip = false;
                        });
                      }
                    },
                    child: Text(
                      tripItems[0],
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: (selected == 0)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CustomCheckBox(
                    value: selected == 1 ? true : false,
                    shouldShowBorder: true,
                    borderColor: Colors.white,
                    checkedFillColor: Colors.white,
                    checkedIcon: Icons.done,
                    checkedIconColor: Colors.yellow[700],
                    borderRadius: 5,
                    borderWidth: 2,
                    checkBoxSize: 20,
                    onChanged: (val) {
                      if (mounted) {
                        setState(() {
                          selected = 1;
                          showTrip = false;
                        });
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          selected = 1;
                          showTrip = false;
                        });
                      }
                    },
                    child: Text(
                      tripItems[1],
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: (selected == 1)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CustomCheckBox(
                    value: selected == 2 ? true : false,
                    shouldShowBorder: true,
                    borderColor: Colors.white,
                    checkedFillColor: Colors.white,
                    checkedIcon: Icons.done,
                    checkedIconColor: Colors.yellow[700],
                    borderRadius: 5,
                    borderWidth: 2,
                    checkBoxSize: 20,
                    onChanged: (val) {
                      if (mounted) {
                        setState(() {
                          selected = 2;
                          showTrip = false;
                        });
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          selected = 2;
                          showTrip = false;
                        });
                      }
                    },
                    child: Text(
                      tripItems[2],
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: (selected == 2)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CustomCheckBox(
                    value: selected == 3 ? true : false,
                    shouldShowBorder: true,
                    borderColor: Colors.white,
                    checkedFillColor: Colors.white,
                    checkedIcon: Icons.done,
                    checkedIconColor: Colors.yellow[700],
                    borderRadius: 5,
                    borderWidth: 2,
                    checkBoxSize: 20,
                    onChanged: (val) {
                      if (mounted) {
                        setState(() {
                          selected = 3;
                          showTrip = false;
                        });
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          selected = 3;
                          showTrip = false;
                        });
                      }
                    },
                    child: Text(
                      tripItems[3],
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: (selected == 3)
                            ? FontWeight.bold
                            : FontWeight.normal,
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
  }

  Widget selectPassenger() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 80,
        left: 20,
        right: 20,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                              showPassenger = false;
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
                              showPassenger = false;
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
                                showPassenger = false;
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
                              showPassenger = false;
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
                                showPassenger = false;
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
                              showPassenger = false;
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
        ),
      ),
    );
  }

  Widget selectTravelClass() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 80,
        left: 20,
        right: 20,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CustomCheckBox(
                  value: travelClassIndex == 0 ? true : false,
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
                      travelClassIndex = 0;
                      showTravelClass = false;
                    });
                  },
                ),
                title: GestureDetector(
                  onTap: () {
                    setState(() {
                      travelClassIndex = 0;
                      showTravelClass = false;
                    });
                  },
                  child: Text(
                    travelClass[0],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: CustomCheckBox(
                  value: travelClassIndex == 1 ? true : false,
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
                      travelClassIndex = 1;
                      showTravelClass = false;
                    });
                  },
                ),
                title: GestureDetector(
                  onTap: () {
                    setState(() {
                      travelClassIndex = 1;
                      showTravelClass = false;
                    });
                  },
                  child: Text(
                    travelClass[1],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: CustomCheckBox(
                  value: travelClassIndex == 2 ? true : false,
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
                      travelClassIndex = 2;
                      showTravelClass = false;
                    });
                  },
                ),
                title: GestureDetector(
                  onTap: () {
                    setState(() {
                      travelClassIndex = 2;
                      showTravelClass = false;
                    });
                  },
                  child: Text(
                    travelClass[2],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: CustomCheckBox(
                  value: travelClassIndex == 3 ? true : false,
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
                      travelClassIndex = 3;
                      showTravelClass = false;
                    });
                  },
                ),
                title: GestureDetector(
                  onTap: () {
                    setState(() {
                      travelClassIndex = 3;
                      showTravelClass = false;
                    });
                  },
                  child: Text(
                    travelClass[3],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectPlace(int n) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 80,
        left: 20,
        right: 20,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                  left: 10,
                  right: 10,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Color.fromRGBO(249, 190, 6, 1),
                      width: 2.5,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(Icons.flight_takeoff),
                    title: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onChanged: (val) {
                        setState(() {
                          place = val;
                        });
                        getPlace("$place").then((value) {
                          setState(() {
                            placeItems = [];
                            placeItems.addAll(value);
                          });
                        });
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 200,
                child: placeItems.isEmpty
                    ? Container()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: placeItems.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                n == 0
                                    ? selectedDepPlace =
                                        "${placeItems[index].airportCode}"
                                    : selectedArrPlace =
                                        "${placeItems[index].airportCode}";
                                n == 0
                                    ? modDep = selectedDepPlace
                                    : modArr = selectedArrPlace;
                                n == 0
                                    ? modDepTag =
                                        "${placeItems[index].countryCode}#${placeItems[index].cityCode}#${placeItems[index].airportCode}#AS"
                                    : modArrTag =
                                        "${placeItems[index].countryCode}#${placeItems[index].cityCode}#${placeItems[index].airportCode}#AS";
                                n == 0 ? showDep = false : showArr = false;
                                placeItems = [];
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                bottom: 25,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "${placeItems[index].airportCode} - ",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${placeItems[index].cityName} - ",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${placeItems[index].airportName}",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
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
        ),
      ),
    );
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

  Widget selectDate(int r) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 80,
        left: 20,
        right: 20,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Card(
          child: Container(
            height: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                r == 0
                    ? Expanded(
                        child: PagedVerticalCalendar(
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
                                    DateFormat('MMMM yyyy')
                                        .format(DateTime(year, month)),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                  color: (date == modDepDate)
                                      ? Color.fromRGBO(249, 190, 2, 1)
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    DateFormat('d').format(date),
                                    style: TextStyle(
                                      color: (date == modDepDate)
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
                              modDepDate = date;
                              modStrDep =
                                  modDepDate.toString().substring(0, 10);
                              showDepDate = false;
                            });
                          },
                        ),
                      )
                    : Expanded(
                        child: PagedVerticalCalendar(
                          startDate: modDepDate,

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
                                    DateFormat('MMMM yyyy')
                                        .format(DateTime(year, month)),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                  color: date == modArrDate
                                      ? Color.fromRGBO(249, 190, 2, 1)
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    DateFormat('d').format(date),
                                    style: TextStyle(
                                      color: date == modArrDate
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
                              modArrDate = date;
                              modStrArr =
                                  modArrDate.toString().substring(0, 10);
                              showArrDate = false;
                            });
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showModify() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 80,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  child: IconButton(
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          modify = false;
                        });
                      }
                    },
                    icon: Icon(Icons.close),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              showTrip = true;
                            });
                          }
                        },
                        child: Text(tripItems[selected]),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.expand_more_rounded,
                        ),
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              showTrip = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              showPassenger = true;
                            });
                          }
                        },
                        child: Text("${adult + child + infant} Passenger"),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.expand_more_rounded,
                        ),
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              showPassenger = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              showTravelClass = true;
                            });
                          }
                        },
                        child: Text(travelClass[travelClassIndex]),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.expand_more_rounded,
                        ),
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              showTravelClass = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.flight_takeoff_rounded),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              showDep = true;
                            });
                          }
                        },
                        child: selectedDepPlace.length > 3
                            ? Text(selectedDepPlace.substring(0, 4))
                            : Text(selectedDepPlace),
                      ),
                      IconButton(
                        icon: Icon(Icons.expand_more_rounded),
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              showDep = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 40,
                      width: 50,
                      child: Stack(
                        children: [
                          Center(
                            child: VerticalDivider(
                              color: Colors.grey,
                            ),
                          ),
                          Center(
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.yellow,
                              child: Icon(
                                Icons.compare_arrows_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.flight_land_rounded),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              showArr = true;
                            });
                          }
                        },
                        child: selectedArrPlace.length > 3
                            ? Text(selectedArrPlace.substring(0, 4))
                            : Text(selectedArrPlace),
                      ),
                      IconButton(
                        icon: Icon(Icons.expand_more_rounded),
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              showArr = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FaIcon(
                          FontAwesomeIcons.solidCalendarAlt,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              showDepDate = true;
                            });
                          }
                        },
                        child: Text(modStrDep),
                      ),
                      IconButton(
                        icon: Icon(Icons.expand_more_rounded),
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              showDepDate = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 40,
                      width: 50,
                      child: Stack(
                        children: [
                          Center(
                            child: VerticalDivider(
                              color: Colors.grey,
                            ),
                          ),
                          Center(
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  selected == 0 ? Colors.grey : Colors.yellow,
                              child: Icon(
                                Icons.compare_arrows_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FaIcon(
                          FontAwesomeIcons.solidCalendarAlt,
                          color: selected == 0 ? Colors.grey : Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (mounted) {
                            if (selected != 0) {
                              setState(() {
                                showArrDate = true;
                              });
                            }
                          }
                        },
                        child: selected == 0
                            ? Text(
                                "0000-00-00",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            : modArrDate == null
                                ? Text("Select Date")
                                : Text(modStrArr),
                      ),
                      IconButton(
                        icon: Icon(Icons.expand_more_rounded),
                        onPressed: () {
                          if (mounted) {
                            if (selected != 0) {
                              setState(() {
                                showArrDate = true;
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              MaterialButton(
                color: Colors.yellow[700],
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      found = 1;
                      items = [];
                      print(modDep);
                      print(modArr);
                      if (selected == 0) {
                        reqBody =
                            '{"Request":{"Flight":{"SearchCriteria":{"Flights":{"CabinCode":"${coachId[travelClassIndex]}","TripType":"OW","JourneyType":"","RequestedSegment":[{"DeparturePoint":"$modDep","ArrivalPoint":"$modArr","Date":"$modStrDep","Time":"","DepartureCountryCity":"$modDepTag","ArrivalCountryCity":"$modArrTag"}]},"Passengers":{"Passenger":[{"Type":"ADT","Count": "$adult"},{"Type":"CHD","Count":"$child"},{"Type":"INF","Count":"$infant"}]},"AdvanceSearch":{"DirectFlight":"false"}}}}}';
                      }
                      if (selected == 1) {
                        reqBody =
                            '{"Request":{"Flight":{"SearchCriteria":{"Flights":{"CabinCode": "${coachId[travelClassIndex]}","TripType":"RT","JourneyType":"","RequestedSegment":[{"DeparturePoint": "$modDep","ArrivalPoint": "$modArr","Date": "$modStrDep","Time": "","DepartureCountryCity": "$modDepTag","ArrivalCountryCity": "$modArrTag"}, {"DeparturePoint": "$modArr","ArrivalPoint": "$modDep","Date": "$modStrArr","Time": "","DepartureCountryCity": "$modArrTag","ArrivalCountryCity": "$modDepTag"}]},"Passengers": {"Passenger": [{"Type": "ADT","Count": "$adult"}, {"Type": "CHD","Count": "$child"}, {"Type": "INF","Count": "$infant"}]},"AdvanceSearch": {"DirectFlight": "false"}}}}}';
                      }
                      modify = false;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Text("SEARCH"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    if (reqBody != "" && items.isEmpty && found != 0) {
      searchFlight().then((value) {
        if (mounted) {
          setState(() {
            items.addAll(value);
          });
        }
      });
    }
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.black87,
        ),
        body: Stack(
          children: [
            Container(
              height: screenHeight,
              child: Stack(
                children: [
                  //header
                  Container(
                    height: 75,
                    width: screenWidth,
                    color: Colors.black87,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SvgPicture.asset("assets/svgIcons/logo.svg"),
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                showDrawer = true;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  //body
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 75,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: screenWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              top: 75,
                                            ),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Container(
                                                height: 120,
                                                color: Colors.grey[200],
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      child: ListView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                MaterialButton(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                showPrice =
                                                                    true;
                                                                showPriceSlider();
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      "Price",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .grey[500],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  showPrice
                                                                      ? Icon(Icons
                                                                          .expand_less)
                                                                      : Icon(Icons
                                                                          .expand_more),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                MaterialButton(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                showStop = true;
                                                                showStopBox();
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      "Stop",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .grey[500],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  showPrice
                                                                      ? Icon(Icons
                                                                          .expand_less)
                                                                      : Icon(Icons
                                                                          .expand_more),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                MaterialButton(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                showTimes =
                                                                    true;
                                                                showTimesSlider();
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      "Times",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .grey[500],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  showPrice
                                                                      ? Icon(Icons
                                                                          .expand_less)
                                                                      : Icon(Icons
                                                                          .expand_more),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                MaterialButton(
                                                              color: Colors.red,
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                super.widget));
                                                              },
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Clear Fliter",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                MaterialButton(
                                                              color:
                                                                  Colors.yellow,
                                                              onPressed: () {
                                                                if (mounted) {
                                                                  setState(() {
                                                                    price = [
                                                                      tempPrice
                                                                          .start,
                                                                      tempPrice
                                                                          .end
                                                                    ];
                                                                    filter =
                                                                        true;
                                                                    reqBody = json
                                                                        .encode({
                                                                      "Airline":
                                                                          [
                                                                        // "AI",
                                                                        // "EK",
                                                                        // "ET",
                                                                        // "EY"
                                                                      ],
                                                                      "Airport":
                                                                          [
                                                                        // "ADD",
                                                                        // "AMD",
                                                                        // "DEL"
                                                                      ],
                                                                      "Refundable":
                                                                          [
                                                                        // "na",
                                                                        // "nrf",
                                                                        // "rf",
                                                                        // "prf"
                                                                      ],
                                                                      "Stop":
                                                                          noOfStops,
                                                                      "Price":
                                                                          price,
                                                                      "Duration":
                                                                          [
                                                                        // "335",
                                                                        // "365"
                                                                      ],
                                                                      "Time":
                                                                          getTimes(),
                                                                      "SortBy":
                                                                          {
                                                                        "Section":
                                                                            "QUICKEST",
                                                                        "#By#Order":
                                                                            [
                                                                          // [
                                                                          //   "Price",
                                                                          //   4
                                                                          // ],
                                                                          // [
                                                                          //   "Price",
                                                                          //   4
                                                                          // ]
                                                                        ]
                                                                      }
                                                                    });
                                                                    items = [];
                                                                  });
                                                                }

                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "APPLY",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                  ),
                                                                  Icon(Icons
                                                                      .done),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 80,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Filter"),
                                          Icon(Icons.tune_rounded),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    onPressed: () {
                                      if (mounted) {
                                        setState(() {
                                          modify = true;
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 80,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Modify"),
                                          Icon(Icons.sync),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          found == 0
                              ? Center(
                                  child: Container(
                                    height: screenHeight - 150,
                                    child: Text("Sorry!! No results found."),
                                  ),
                                )
                              : Container(
                                  height: screenHeight - 150,
                                  child: items.length == 0
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
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 20,
                                          ),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: items.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 15,
                                                  right: 15,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            FlightDetails(
                                                          sessionId:
                                                              sessionIdRetrieved,
                                                          refNo: items[index]
                                                              .refNo,
                                                          rsegment:
                                                              items[index].rSeg,
                                                          amt: items[index]
                                                              .api["TGP"],
                                                          api: items[index].api,
                                                          currency: currency,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Card(
                                                    elevation: 2.6,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 8,
                                                            bottom: 2,
                                                            left: 10,
                                                            right: 10,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Agent Cost: ${items[index].api["TAGN"]}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                              Text(
                                                                "Total Profit: ${items[index].api["TAGM"]}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                        ),
                                                        Column(
                                                          children:
                                                              List.generate(
                                                                  items[index]
                                                                      .rSeg
                                                                      .length,
                                                                  (index1) {
                                                            return Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            32,
                                                                        width:
                                                                            32,
                                                                        child: Image
                                                                            .network(
                                                                          "https://babylonxtra.com/images/flightimages/sm/sm${items[index].rSeg[index1]["GSeg"]["ASeg"][0]["OC"]}.gif",
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(
                                                                              left: 10,
                                                                              right: 10,
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Column(
                                                                                  children: List.generate(items[index].rSeg[index1]["GSeg"]["ASeg"].length, (ind1) {
                                                                                    return ind1 == 0
                                                                                        ? Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Text(
                                                                                                  items[index].rSeg[index1]["GSeg"]["ASeg"][ind1]["DTim"],
                                                                                                  style: TextStyle(
                                                                                                    color: Colors.grey[600],
                                                                                                    fontSize: 18,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                                ),
                                                                                                Text(
                                                                                                  items[index].rSeg[index1]["GSeg"]["ASeg"][ind1]["DDat"].toString().substring(8) + convertStringToDate(items[index].rSeg[index1]["GSeg"]["ASeg"][ind1]["DDat"].toString().substring(6, 7)),
                                                                                                  style: TextStyle(
                                                                                                    color: Colors.grey,
                                                                                                    fontSize: 14,
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          )
                                                                                        : Container();
                                                                                  }),
                                                                                ),
                                                                                Expanded(
                                                                                  child: Column(
                                                                                    children: [
                                                                                      getDuration(index),
                                                                                      Row(
                                                                                        children: List.generate(items[index].rSeg[index1]["GSeg"]["ASeg"].length + 1, (ind) {
                                                                                          return ind == items[index].rSeg[index1]["GSeg"]["ASeg"].length
                                                                                              ? CircleAvatar(
                                                                                                  radius: 4,
                                                                                                  backgroundColor: Colors.yellow[700],
                                                                                                )
                                                                                              : Expanded(
                                                                                                  child: Row(
                                                                                                    children: [
                                                                                                      ind == 0
                                                                                                          ? CircleAvatar(
                                                                                                              radius: 4,
                                                                                                              backgroundColor: Colors.yellow[700],
                                                                                                            )
                                                                                                          : CircleAvatar(
                                                                                                              radius: 4,
                                                                                                              backgroundColor: Colors.grey,
                                                                                                              child: CircleAvatar(
                                                                                                                radius: 3,
                                                                                                                backgroundColor: Colors.white,
                                                                                                              ),
                                                                                                            ),
                                                                                                      Expanded(
                                                                                                        child: Divider(
                                                                                                          color: Colors.grey[600],
                                                                                                          thickness: 1,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                );
                                                                                        }),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: List.generate(items[index].rSeg[index1]["GSeg"]["ASeg"].length + 1, (index2) {
                                                                                          return (index2 == items[index].rSeg[index1]["GSeg"]["ASeg"].length)
                                                                                              ? Padding(
                                                                                                  padding: const EdgeInsets.only(
                                                                                                    right: 0,
                                                                                                  ),
                                                                                                  child: Text(
                                                                                                    items[index].rSeg[index1]["GSeg"]["ASeg"][index2 - 1]["AApot"],
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.grey,
                                                                                                      fontSize: 12,
                                                                                                    ),
                                                                                                  ),
                                                                                                )
                                                                                              : Padding(
                                                                                                  padding: index2 == 0
                                                                                                      ? EdgeInsets.only(
                                                                                                          left: 0,
                                                                                                        )
                                                                                                      : EdgeInsets.all(0),
                                                                                                  child: Text(
                                                                                                    items[index].rSeg[index1]["GSeg"]["ASeg"][index2]["DApot"],
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.grey,
                                                                                                      fontSize: 12,
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                        }),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                  children: List.generate(items[index].rSeg[index1]["GSeg"]["ASeg"].length, (ind1) {
                                                                                    return ind1 == items[index].rSeg[index1]["GSeg"]["ASeg"].length - 1
                                                                                        ? Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Text(
                                                                                                  items[index].rSeg[index1]["GSeg"]["ASeg"][ind1]["ATim"],
                                                                                                  style: TextStyle(
                                                                                                    color: Colors.grey[600],
                                                                                                    fontSize: 18,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                                ),
                                                                                                Text(
                                                                                                  items[index].rSeg[index1]["GSeg"]["ASeg"][ind1]["ADat"].toString().substring(8) + convertStringToDate(items[index].rSeg[index1]["GSeg"]["ASeg"][ind1]["DDat"].toString().substring(6, 7)),
                                                                                                  style: TextStyle(
                                                                                                    color: Colors.grey,
                                                                                                    fontSize: 14,
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          )
                                                                                        : Container();
                                                                                  }),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Divider(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ],
                                                            );
                                                          }),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            bottom: 5,
                                                            left: 10,
                                                            right: 10,
                                                          ),
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
                                                                    "Refundable",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "3 Seats available",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                    items[index]
                                                                            .api[
                                                                        "TGP"],
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "USD",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  modify
                      ? Container(
                          height: screenHeight,
                          color: Colors.black54,
                        )
                      : Container(),
                  modify ? showModify() : Container(),
                  showTrip
                      ? Container(
                          height: screenHeight,
                          color: Colors.black54,
                        )
                      : Container(),
                  showTrip ? selectTrip() : Container(),
                  showPassenger
                      ? Container(
                          height: screenHeight,
                          color: Colors.black54,
                        )
                      : Container(),
                  showPassenger ? selectPassenger() : Container(),
                  showTravelClass
                      ? Container(
                          height: screenHeight,
                          color: Colors.black54,
                        )
                      : Container(),
                  showTravelClass ? selectTravelClass() : Container(),
                  showDep
                      ? Container(
                          height: screenHeight,
                          color: Colors.black54,
                        )
                      : Container(),
                  showDep ? selectPlace(0) : Container(),
                  showArr
                      ? Container(
                          height: screenHeight,
                          color: Colors.black54,
                        )
                      : Container(),
                  showArr ? selectPlace(1) : Container(),
                  showDepDate
                      ? Container(
                          height: screenHeight,
                          color: Colors.black54,
                        )
                      : Container(),
                  showDepDate ? selectDate(0) : Container(),
                  showArrDate
                      ? Container(
                          height: screenHeight,
                          color: Colors.black54,
                        )
                      : Container(),
                  showArrDate ? selectDate(1) : Container(),
                ],
              ),
            ),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Bookings()));
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
                            left: 20,
                            right: 20,
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
        ));
  }
}
