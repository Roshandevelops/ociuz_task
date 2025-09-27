import 'package:flutter/material.dart';
import 'package:ociuz_task/domain/model/product_model.dart';
import 'package:ociuz_task/infrastructure/product_controller.dart';
import 'package:ociuz_task/utils/constants/app_colors.dart';
import 'package:ociuz_task/widgets/app_button_widget.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? "Unknown Title"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.network(
                  product.image ??
                      "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930",
                  height: 250),
              const SizedBox(height: 16),
              Text(
                product.title ?? "Unknown Title",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${product.price}',
                style: const TextStyle(fontSize: 18, color: Colors.green),
              ),
              const SizedBox(height: 16),
              Text(product.description ?? "Unknown Description"),
              const SizedBox(height: 24),
              AppButtonWidget(
                onTap: () {
                  productController.addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Product added to cart",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
                textColor: KAppColors.kwhite,
                buttonText: "Add to Cart",
              )
            ],
          ),
        ),
      ),
    );
  }
}
