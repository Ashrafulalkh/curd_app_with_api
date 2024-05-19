import 'dart:async';
import 'dart:convert';

import 'package:curd_app/add_product_screen.dart';
import 'package:curd_app/product_model.dart';
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

  List<ProductModel> productList = [];

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
      body: RefreshIndicator(
        onRefresh: () async{
          _getProductList();
        },
        child: Visibility(
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
        ProductModel productModel = ProductModel.fromJson(p);

        productList.add(productModel);
      }

    }else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Get Product List Failed!! Try Again')));
    }

    _getProductListInProgress = false;
    setState(() {});

  }

  Widget _buildProductItem(ProductModel productModel) {
    return ListTile(
      title:  Text(productModel.productName ?? ''),
      subtitle: Wrap(
        spacing: 16,
        children: [
          Text('Unit Price: ${productModel.productUnitPrice}'),
          Text('Quantity: ${productModel.productQuantity}'),
          Text('Total Price: ${productModel.productTotalPrice}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProductScreen(
                      product: productModel,
                    ),
                  ),
                );
                if(result == true) {
                  _getProductList();
                }

              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                showDeleteConfirmationDialog(productModel.id!);
              },
              icon: const Icon(Icons.delete_forever_outlined)),
        ],
      ),
    );

  }

  void showDeleteConfirmationDialog(String id) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text('Delete'),
        content: const Text('Do you want to delete this product?'),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: const Text('Cancel'),),
          TextButton(onPressed: () {
            _deleteProductList(id);
            Navigator.pop(context);
          }, child: const Text('Yes,Delete'),),
        ],
      );
    });
  }


  Future<void> _deleteProductList(String id) async {
    _getProductListInProgress = true;
    setState(() {});

    String deleteProductUrl = 'https://crud.teamrabbil.com/api/v1/DeleteProduct/$id';

    Uri uri = Uri.parse(deleteProductUrl);

    Response response = await get(uri);

    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 200) {
      _getProductList();

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product deleted Successfully')));

    }else {
      _getProductListInProgress = false;
      setState(() {});

  ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Delete Product Failed!! Try Again')));
    }

  }
}


