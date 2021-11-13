class BookingsModel {
  String bookingRef;
  String dateOfBooking;
  String channel;
  String origin;
  String destination;
  String client;
  String supplierRef;
  String status;
  String leadPax;
  String paymentStatus;
  String created;
  String deadline;

  BookingsModel(
    this.bookingRef,
    this.dateOfBooking,
    this.channel,
    this.origin,
    this.destination,
    this.client,
    this.supplierRef,
    this.status,
    this.leadPax,
    this.paymentStatus,
    this.created,
    this.deadline,
  );

  BookingsModel.fromJson(Map<String, dynamic> json) {
    bookingRef = json["BookingRef"];
    dateOfBooking = json["DateOfBooking"];
    channel = json["Channel"];
    origin = json["Origin"];
    destination = json["Destination"];
    client = json["Client"];
    supplierRef = json["SupplierRef"];
    status = json["Status"];
    leadPax = json["LeadPax"];
    paymentStatus = json["PaymentStatus"];
    created = json["DateOfBooking"];
    deadline = json["TicketDeadline"];
  }
}
