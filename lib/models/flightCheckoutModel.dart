class FlightCheckoutModel {
  Map master;
  Map message;
  Map flight;
  Map mandatoryInfo;
  Map additionalInfo;

  FlightCheckoutModel(
    this.master,
    this.message,
    this.flight,
    this.mandatoryInfo,
    this.additionalInfo,
  );

  FlightCheckoutModel.fromJson(Map<String, dynamic> json) {
    master = json["Master"];
    message = json["Message"];
    flight = json["Flight"];
    mandatoryInfo = json["MandatoryInfo"];
    additionalInfo = json["AdditionalInfo"];
  }
}
