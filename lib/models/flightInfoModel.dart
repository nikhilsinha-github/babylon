class FlightInfo {
  String airportCode;
  String airportName;
  String cityCode;
  String cityName;
  String countryCode;
  int priority;

  FlightInfo(this.airportCode, this.airportName, this.cityCode, this.cityName,
      this.countryCode, this.priority);

  FlightInfo.fromJson(Map<String, dynamic> json) {
    airportCode = json["AirportCode"];
    airportName = json["AirportName"];
    cityCode = json["CityCode"];
    cityName = json["CityName"];
    countryCode = json["CountryCode"];
    priority = json["priority"];
  }
}
