class ActivityModel {
  String ip;
  String loginTime;
  String country;
  String city;

  ActivityModel(
    this.ip,
    this.loginTime,
    this.country,
    this.city,
  );

  ActivityModel.fromJson(Map<String, dynamic> json) {
    ip = json["Ip"];
    loginTime = json["LoginTime"];
    country = json["CountryName"];
    city = json["CityName"];
  }
}
