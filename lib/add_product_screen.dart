import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final TextEditingController _productCodeTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _addNewProductInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          'Add Product',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Enter New Product Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _nameTEController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    labelText: 'Name',
                  ),
                  validator: (String? value) {
                    if(value == null || value.trim().isEmpty) {
                      return 'Write your product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _productCodeTEController,
                  decoration: const InputDecoration(
                    hintText: 'Product Code',
                    labelText: 'Product Code',
                  ),
                  validator: (String? value) {
                    if(value == null || value.trim().isEmpty) {
                      return 'Write your product Code';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _unitPriceTEController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Unit Price',
                    labelText: 'Unit Price',
                  ),
                  validator: (String? value) {
                    if(value == null || value.trim().isEmpty) {
                      return 'Write your product unit price';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _quantityTEController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Quantity',
                    labelText: 'Quantity',
                  ),
                  validator: (String? value) {
                    if(value == null || value.trim().isEmpty) {
                      return 'Write your product quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _totalPriceTEController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Total Price',
                    labelText: 'Total Price',
                  ),
                  validator: (String? value) {
                    if(value == null || value.trim().isEmpty) {
                      return 'Write your product total price';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _imageTEController,
                  decoration: const InputDecoration(
                    hintText: 'Image',
                    labelText: 'Image',
                  ),
                  validator: (String? value) {
                    if(value == null || value.trim().isEmpty) {
                      return 'Give your product image';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                Visibility(
                  visible: _addNewProductInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),

                  child: ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()) {
                        _addProduct();
                      }
                    },
                    child: const Text('Add Product'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addProduct() async {
    _addNewProductInProgress = true;
    setState(() {});

    const addNewProductUrl = 'https://crud.teamrabbil.com/api/v1/CreateProduct';

    Map<String, dynamic> inputData = {
      "Img": _imageTEController.text,
      "ProductCode": _productCodeTEController.text,
      "ProductName": _nameTEController.text.trim(),
      "Qty": _quantityTEController.text,
      "TotalPrice": _totalPriceTEController.text,
      "UnitPrice": _unitPriceTEController.text,
    };

    Uri uri = Uri.parse(addNewProductUrl);
    Response response = await post(uri,
        body: jsonEncode(inputData),
        headers: {'content-type': 'application/json'});

    print(response.statusCode);
    print(response.headers);
    print(response.body);

    _addNewProductInProgress = false;
    setState(() {});

    if (response.statusCode == 200) {
      _nameTEController.clear();
      _unitPriceTEController.clear();
      _quantityTEController.clear();
      _totalPriceTEController.clear();
      _imageTEController.clear();
      _productCodeTEController.clear();

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('New Product Added')));

      Navigator.pop(context,true);
    }else{

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('New Product Add Failed!! Try Again')));
    }

  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _unitPriceTEController.dispose();
    _quantityTEController.dispose();
    _totalPriceTEController.dispose();
    _imageTEController.dispose();
    super.dispose();
  }

}
