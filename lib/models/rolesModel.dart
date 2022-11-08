class RolesModel {
  String agentRoleId;
  String name;
  String description;

  RolesModel({
    this.agentRoleId,
    this.name,
    this.description,
  });

  RolesModel.fromJson(Map<String, dynamic> json) {
    agentRoleId = json['AgentRoleId'].toString();
    name = json['Name'];
    description = json['Description'];
  }
}
