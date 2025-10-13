import 'package:flutter/material.dart';
import 'package:phone_shop/views/product/phone_screen.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📱 Phones'),
        backgroundColor: Colors.blueAccent,
      ),
      body: PhoneScreen(),
    );
  }
}
