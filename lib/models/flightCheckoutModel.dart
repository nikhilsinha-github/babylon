class FlightCheckoutModel {
  Map master;
  Map message;
  Map flight;
  Map mandatoryInfo;

  FlightCheckoutModel(
    this.master,
    this.message,
    this.flight,
    this.mandatoryInfo,
  );

  FlightCheckoutModel.fromJson(Map<String, dynamic> json) {
    master = json["Master"];
    message = json["Message"];
    flight = json["Flight"];
    mandatoryInfo = json["MandatoryInfo"];
  }
}
