class ProfileModel {
  String agentUserId;
  String firstName;
  String middleName;
  String lastName;
  String email;

  ProfileModel(
    this.agentUserId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
  );

  ProfileModel.fromJson(Map<String, dynamic> json) {
    agentUserId = json["AgentUserId"].toString();
    firstName = json["FirstName"].toString();
    middleName = json["MiddleName"].toString();
    lastName = json["LastName"].toString();
    email = json["Email"].toString();
  }
}
