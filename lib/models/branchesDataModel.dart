class BranchesDataModel {
  String agentBranchId;
  String name;
  String email;
  String phone;
  String city;

  BranchesDataModel(
    this.agentBranchId,
    this.name,
    this.email,
    this.phone,
    this.city,
  );

  BranchesDataModel.fromJson(Map<String, dynamic> json) {
    agentBranchId = json["AgentBranchId"].toString();
    name = json["Name"].toString();
    email = json["Email"].toString();
    phone = json["Phone"].toString();
    city = json["CityName"].toString();
  }
}
