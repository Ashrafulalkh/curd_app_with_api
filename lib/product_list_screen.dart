import 'dart:async';
import 'dart:convert';

import 'package:curd_app/add_product_screen.dart';
import 'package:curd_app/product.dart';
import 'package:curd_app/update_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _getProductListInProgress = true;

  List<Product> productList = [];

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: Visibility(
        visible: _getProductListInProgress == false,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: ListView.separated(
          itemCount: productList.length,
          itemBuilder: (context, index) {
            return _buildProductItem(productList[index]);
          },
          separatorBuilder: (_, __) => const Divider(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddProductScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _getProductList() async {
    _getProductListInProgress = true;

    productList.clear();

    setState(() {});

    const String productListUrl = 'https://crud.teamrabbil.com/api/v1/ReadProduct';

    Uri uri = Uri.parse(productListUrl);

    Response response = await get(uri);

    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 200) {
      
      final decodeData = jsonDecode(response.body);

      final jsonProductList = decodeData['data'];

      for (Map<String, dynamic> p in jsonProductList) {
        Product product = Product(
            id: p['_id'] ?? 'Unknown',
            productName: p['ProductName'] ?? 'Unknown',
            productCode: p['ProductCode'] ?? 'Unknown',
            productQuantity: p['Qty'] ?? 'Unknown',
            productUnitPrice: p['UnitPrice'] ?? 'Unknown',
            productTotalPrice: p['TotalPrice'],
            productImage: p['Img']?? 'Unknown');

        productList.add(product);
      }

    }else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Get Product List Failed!! Try Again')));
    }

    _getProductListInProgress = false;
    setState(() {});



  }

  Widget _buildProductItem(Product product) {
    return ListTile(
      title:  Text(product.productName),
      subtitle: Wrap(
        spacing: 16,
        children: [
          Text('Unit Price: ${product.productUnitPrice}'),
          Text('Quantity: ${product.productQuantity}'),
          Text('Total Price: ${product.productTotalPrice}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UpdateProductScreen()));
          }, icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                showDeleteConfirmationDialog();
              },
              icon: const Icon(Icons.delete_forever_outlined)),
        ],
      ),
    );

  }

  void showDeleteConfirmationDialog() {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text('Delete'),
        content: const Text('Do you want to delete this product?'),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: const Text('Cancel'),),
          TextButton(onPressed: () {}, child: const Text('Yes,Delete'),),
        ],
      );
    });
  }


}
