// class BookingDetailModel {
//   List ticketCostingDetails;
//   Map bookingInfo;
//   Map bookingCharge;
//   String thresholdLimit;
//   List paymentGateway;
//   String paymentCurrency;
//   List agentDetails;
//   List additionalCharges;
//   List receivedPayment;
//   List queueStatus;
//   Map flightSeg;
//   String totalReceivedAmount;
//   List forTicket;
//   String totalRefundAmt;
//   Map data;
//   String bookingRef;
//   List forTicketVoid;

//   BookingDetailModel(
//     this.ticketCostingDetails,
//     this.bookingInfo,
//     this.bookingCharge,
//     this.thresholdLimit,
//     this.paymentGateway,
//     this.paymentCurrency,
//     this.agentDetails,
//     this.additionalCharges,
//     this.receivedPayment,
//     this.queueStatus,
//     this.flightSeg,
//     this.totalReceivedAmount,
//     this.forTicket,
//     this.totalRefundAmt,
//     this.data,
//     this.bookingRef,
//     this.forTicketVoid,
//   );

//   BookingDetailModel.fromJson(Map<String, dynamic> json) {
//     ticketCostingDetails = json["TicketCostingDetails"];
//     bookingInfo = json["BookingInfo"];
//     bookingCharge = json["BookingCharge"];
//     thresholdLimit = json["ThresholdLimit"].toString();
//     paymentGateway = json["PayemtnGateway"];
//     paymentCurrency = json["PaymentCurrencyER"].toString();
//     agentDetails = json["AgentDetails"];
//     additionalCharges = json["AdditionalCharges"];
//     receivedPayment = json["ReceiviedPayment"];
//     queueStatus = json["QueueStatus"];
//     flightSeg = json["flightSegementItinerary"];
//     totalReceivedAmount = json["TotalRecivedAmount"].toString();
//     forTicket = json["forTicket"];
//     totalRefundAmt = json["TotalRefundAmount"].toString();
//     data = json["Data"];
//     bookingRef = json["BookingRef"];
//     forTicketVoid = json["forTicketVoid"];
//   }
// }

class BookingDetailModel {
  String bookingRef;
  Map bookingInformation;
  List travelDetails;
  List costingDetails;
  Map paymentDetails;
  List bookingDocument;
  Map flightSeg;

  BookingDetailModel(
    this.bookingRef,
    this.bookingInformation,
    this.travelDetails,
    this.costingDetails,
    this.paymentDetails,
    this.bookingDocument,
    this.flightSeg,
  );

  BookingDetailModel.fromJson(Map<String, dynamic> json) {
    bookingRef = json["BookingRef"].toString();
    bookingInformation = json["BookingInformation"];
    travelDetails = json["TravelsDetails"];
    costingDetails = json["CostingDetails"];
    paymentDetails = json["PaymentDetails"];
    bookingDocument = json["BookingDocument"];
    flightSeg = json["flightSegementItinerary"];
  }
}
