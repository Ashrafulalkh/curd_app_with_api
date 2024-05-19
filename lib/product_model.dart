class ProductModel {
  String? id;
  String? productName;
  String? productCode;
  String? productQuantity;
  String? productUnitPrice;
  String? productTotalPrice;
  String? productImage;

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    productName = json['ProductName'];
    productCode = json['ProductCode'];
    productQuantity = json['Qty'];
    productUnitPrice = json['UnitPrice'];
    productTotalPrice = json['TotalPrice'];
    productImage = json['Img'];
  }

}