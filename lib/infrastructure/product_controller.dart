import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ociuz_task/domain/model/product_model.dart';
import 'package:ociuz_task/domain/repository/product_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller to manage products and the shopping cart.
/// Handles fetching products, filtering them, and managing cart items.
class ProductController extends ChangeNotifier {
  /// All products fetched from the repository
  List<ProductModel> products = [];

  /// Filtered products based on search query
  List<ProductModel> filteredProducts = [];

  /// Loading state for showing progress indicator
  bool isLoading = false;

  /// List of items currently in the cart
  final List<CartItem> cart = [];

  /// Fetch products from the repository and set loading state.
  /// If an error occurs, resets products to an empty list.
  Future<void> loadProducts() async {
    isLoading = true;
    notifyListeners();

    try {
      products = await ProductRepository.fetchProducts();
      filteredProducts = products;
    } catch (e) {
      // If fetching fails, make sure lists are empty
      products = [];
      filteredProducts = [];
    }

    isLoading = false;
    notifyListeners();
  }

  /// Filter the product list using the given search query.
  /// Updates [filteredProducts] for the UI.
  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredProducts = products;
    } else {
      filteredProducts = products
          .where((p) =>
              (p.title ?? "").toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // ---------------- CART OPERATIONS ----------------

  /// Load cart data from SharedPreferences.
  /// Converts stored JSON into [CartItem] objects.
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart') ?? '[]';
    final List decoded = json.decode(cartString);

    cart.clear();
    for (var item in decoded) {
      cart.add(CartItem.fromJson(item));
    }
    notifyListeners();
  }

  /// Save current cart items to SharedPreferences as JSON.
  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = cart.map((e) => e.toJson()).toList();
    prefs.setString('cart', json.encode(cartJson));
  }

  /// Add a product to the cart.
  /// If the product is already in the cart, just increase its quantity.
  void addToCart(ProductModel product) {
    final existing = cart.indexWhere((item) => item.product.id == product.id);
    if (existing >= 0) {
      cart[existing].quantity += 1;
    } else {
      cart.add(CartItem(product: product, quantity: 1));
    }
    saveCart();
    notifyListeners();
  }

  /// Remove a product completely from the cart.
  void removeFromCart(ProductModel product) {
    cart.removeWhere((item) => item.product.id == product.id);
    saveCart();
    notifyListeners();
  }

  /// Increase the quantity of a cart item by 1
  void increaseQuantity(CartItem item) {
    item.quantity += 1;
    saveCart();
    notifyListeners();
  }

  /// Decrease the quantity of a cart item by 1, but never below 1
  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity -= 1;
      saveCart();
      notifyListeners();
    }
  }

  /// Calculate the total price of all items in the cart
  double get totalPrice {
    double total = 0;
    for (var item in cart) {
      total += (item.product.price ?? 0) * item.quantity;
    }
    return total;
  }
}

/// Represents a single item in the cart.
/// Includes the product and its quantity.
class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  /// Create a [CartItem] from JSON data
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  /// Convert the [CartItem] into JSON
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}
