class Product {
  final String id;
  final String productName;
  final String productCode;
  final String productQuantity;
  final String productUnitPrice;
  final String productTotalPrice;
  final String productImage;

  Product(
      {required this.id,
        required this.productName,
        required this.productCode,
        required this.productQuantity,
        required this.productUnitPrice,
        required this.productTotalPrice,
        required this.productImage});
}