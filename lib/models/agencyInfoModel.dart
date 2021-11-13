class AgencyInfoModel {
  Map agencyInfo;

  AgencyInfoModel(this.agencyInfo);

  AgencyInfoModel.fromJson(Map<String, dynamic> json) {
    agencyInfo = json["AgencyInfo"];
  }
}
