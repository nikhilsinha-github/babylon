class GdsSupplierModel {
  String supplierId;
  String company;
  String importPnr;

  GdsSupplierModel(
    this.supplierId,
    this.company,
    this.importPnr,
  );

  GdsSupplierModel.fromJson(Map<String, dynamic> json) {
    supplierId = json["SupplierId"].toString();
    company = json["Company"].toString();
    importPnr = json["ImportPNR"].toString();
  }
}
