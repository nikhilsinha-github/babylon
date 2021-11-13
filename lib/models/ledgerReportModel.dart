class LedgerReportModel {
  String companyName;
  String branch;
  String total;
  String bookingRef;
  String pnr;
  String createdAt;
  String cAmt;
  String agentROE;
  String dAmt;
  String agentBal;
  String remarks;
  String transactionType;
  String paymentSource;
  String balance;

  LedgerReportModel(
    this.companyName,
    this.branch,
    this.total,
    this.bookingRef,
    this.pnr,
    this.createdAt,
    this.cAmt,
  );

  LedgerReportModel.fromJson(Map<String, dynamic> json) {
    companyName = json["AirportCode"];
    branch = json["AirportName"];
    total = json["CityCode"];
    bookingRef = json["CityName"];
    pnr = json["CountryCode"];
    createdAt = json["priority"];
  }
}
