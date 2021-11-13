class FlightSearchResultModel {
  List rSeg;
  Map api;
  String refNo;

  FlightSearchResultModel(this.rSeg, this.api, this.refNo);

  FlightSearchResultModel.fromJson(Map<String, dynamic> json) {
    rSeg = json["RSegs"]["RSeg"];
    api = json["API"];
    refNo = json["RefNo"];
  }
}
