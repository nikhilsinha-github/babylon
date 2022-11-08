class CityModel {
  String id;
  String cityCode;
  String cityName;
  String countryCode;

  CityModel(
    this.id,
    this.cityCode,
    this.cityName,
    this.countryCode,
  );

  CityModel.fromJson(Map<String, dynamic> json) {
    id = json["Id"].toString();
    cityCode = json["CityCode"].toString();
    cityName = json["CityName"].toString();
    countryCode = json["CountryCode"].toString();
  }
}
