class LedgerModel {
  String companyName;
  String branch;
  String total;
  String bookingRef;
  String pNR;
  String createdAt;
  String cAmount;
  String agentROE;
  String dAmount;
  String agentBalance;
  String paymentRemarks;
  String transactionType;
  String paymentSource;
  String balance;

  LedgerModel(
      {this.companyName,
      this.branch,
      this.total,
      this.bookingRef,
      this.pNR,
      this.createdAt,
      this.cAmount,
      this.agentROE,
      this.dAmount,
      this.agentBalance,
      this.paymentRemarks,
      this.transactionType,
      this.paymentSource,
      this.balance});

  LedgerModel.fromJson(Map<String, dynamic> json) {
    companyName = json['CompanyName'];
    branch = json['Branch'];
    total = json['Total'];
    bookingRef = json['BookingRef'];
    pNR = json['PNR'];
    createdAt = json['created_at'];
    cAmount = json['CAmount'];
    agentROE = json['AgentROE'];
    dAmount = json['DAmount'];
    agentBalance = json['AgentBalance'];
    paymentRemarks = json['PaymentRemarks'];
    transactionType = json['TransactionType'];
    paymentSource = json['PaymentSource'];
    balance = json['Balance'];
  }
}
