class CountryModel {
  String countryCode;
  String countryName;
  String nationality;
  String dialingCode;

  CountryModel(
    this.countryCode,
    this.countryName,
    this.nationality,
    this.dialingCode,
  );

  CountryModel.fromJson(Map<String, dynamic> json) {
    countryCode = json["CountryCode"].toString();
    countryName = json["CountryName"].toString();
    nationality = json["Nationality"].toString();
    dialingCode = json["DialingCode"].toString();
  }
}
