class UserModel {
  String agentUserId;
  String fullName;
  String email;
  String loginId;
  String mobile;
  String dob;
  String status;
  String name;

  UserModel(
    this.agentUserId,
    this.fullName,
    this.email,
    this.loginId,
    this.mobile,
    this.dob,
    this.status,
    this.name,
  );

  UserModel.fromJson(Map<String, dynamic> json) {
    agentUserId = json["AgentUserId"].toString();
    fullName = json["FullName"].toString();
    email = json["Email"].toString();
    loginId = json["LoginId"].toString();
    mobile = json["Mobile"].toString();
    dob = json["DOB"].toString();
    status = json["Status"].toString();
    name = json["Name"].toString();
  }
}
