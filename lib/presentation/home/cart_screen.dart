import 'package:flutter/material.dart';
import 'package:ociuz_task/infrastructure/product_controller.dart';
import 'package:ociuz_task/widgets/app_button_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: productController.cart.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: productController.cart.length,
                      itemBuilder: (context, index) {
                        final item = productController.cart[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  item.product.image ??
                                      "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930",
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.title ?? "Unknown Title",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '\$${(item.product.price ?? 0) * item.quantity}',
                                        style: const TextStyle(
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => productController
                                          .decreaseQuantity(item),
                                      icon: const Icon(Icons.remove),
                                    ),
                                    Text('${item.quantity}'),
                                    IconButton(
                                      onPressed: () => productController
                                          .increaseQuantity(item),
                                      icon: const Icon(Icons.add),
                                    ),
                                    IconButton(
                                      onPressed: () => productController
                                          .removeFromCart(item.product),
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Total:  ",
                          style: Theme.of(context).textTheme.titleLarge),
                      Text(
                          '\$${productController.totalPrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 150,
                    child: AppButtonWidget(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Checkout Successfully Completed",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                      buttonText: "CHECKOUt",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
    );
  }
}
