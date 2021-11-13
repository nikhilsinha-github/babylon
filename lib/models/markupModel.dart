class MarkupModel {
  String productType;
  String markup;
  String markupType;
  String markupId;
  String status;
  String name;

  MarkupModel(
    this.productType,
    this.markup,
    this.markupType,
    this.markupId,
    this.status,
    this.name,
  );

  MarkupModel.fromJson(Map<String, dynamic> json) {
    productType = json["ProductType"];
    markup = json["Markup"].toString();
    markupType = json["MarkupType"];
    markupId = json["MarkupId"].toString();
    status = json["Status"].toString();
    name = json["Name"];
  }
}
