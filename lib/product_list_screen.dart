import 'package:curd_app/add_product_screen.dart';
import 'package:curd_app/update_product_screen.dart';
import 'package:flutter/material.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: ListView.separated(
        itemCount: 6,
        itemBuilder: (context, index) {
          return _buildProductItem();
        },
        separatorBuilder: (_, __) => const Divider(),
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

  Widget _buildProductItem() {
    return ListTile(
      title: const Text('Product Name'),
      subtitle: const Wrap(
        spacing: 16,
        children: [
          Text('Unit Price: 100'),
          Text('Quantity: 100'),
          Text('Total Price: 10000'),
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
