class ConfirmedBookingModel {
  String bookingRef;
  String queueStatus;
  Map bookingInfo;

  ConfirmedBookingModel(
    this.bookingRef,
    this.queueStatus,
    this.bookingInfo,
  );

  ConfirmedBookingModel.fromJson(Map<String, dynamic> json) {
    bookingRef = json["BookingRef"];
    queueStatus = json["QueueStatus"];
    bookingInfo = json["BookingInfo"];
  }
}
