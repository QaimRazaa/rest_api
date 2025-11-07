import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api/models/products_model.dart';
import 'package:rest_api/screens/clothes.dart';
import 'package:rest_api/screens/electronics.dart';
import 'package:rest_api/screens/furniture.dart';
import 'package:rest_api/screens/miscellaneous.dart';
import 'package:rest_api/screens/shoes.dart';

import 'create_product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductsModel> productsList = [];

  Future<List<ProductsModel>> getPostApi() async {
    final response = await http.get(
      Uri.parse('https://api.escuelajs.co/api/v1/products'),
    );
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      productsList.clear();
      for (Map<String, dynamic> i in data) {
        productsList.add(ProductsModel.fromJson(i));
      }
      return productsList;
    } else {
      return productsList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateProductScreen(),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            color: Colors.blueGrey.shade300,
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              if (value == 'clothes') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Clothes()),
                );
              } else if (value == 'electronics') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Electronics()),
                );
              } else if (value == 'furniture') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Furniture()),
                );
              } else if (value == 'shoes') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Shoes()),
                );
              } else if (value == 'miscellaneous') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Miscellaneous()),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'clothes',
                child: Text('Clothes', style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'electronics',
                child: Text(
                  'Electronics',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const PopupMenuItem(
                value: 'furniture',
                child: Text('Furniture', style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'shoes',
                child: Text('Shoes', style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'miscellaneous',
                child: Text(
                  'Miscellaneous',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder(
        future: getPostApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: productsList.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return ProductCard(product: product);
              },
            );
          }
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductsModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              product.images![0],
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? 'No title',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '\$${product.price ?? 0}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
