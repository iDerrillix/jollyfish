import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jollyfish/models/user_model.dart';
import 'package:jollyfish/utilities.dart';

class ShoppingCartModel extends ChangeNotifier {
  late List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get cart => _cart;

  ShoppingCartModel() {
    _initializeCart();
  }
  Future<void> placeOrder(Map<String, dynamic> orderData) async {
    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');

    try {
      // Start a Firestore transaction
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Add the order to the orders collection
        DocumentReference newOrderRef = await orders.add(orderData);

        // Create the products subcollection within the order document
        CollectionReference productsRef = newOrderRef.collection('products');

        // Add each cart item to the products subcollection
        for (var cartItem in _cart) {
          // Get the product ID from the cart item
          String productId = cartItem['product_id'];

          // Convert price and quantity to double if they are integers
          double price = (cartItem['price'] as num).toDouble();
          double quantity = (cartItem['quantity'] as num).toDouble();

          // Calculate the total price for the cart item
          double totalPrice = price * quantity;

          // Create a new map with limited fields and calculated total
          Map<String, dynamic> productData = {
            'quantity': quantity,
            'total': totalPrice,
          };

          // Add the cart item to the products subcollection
          await productsRef.doc(productId).set(productData);
        }
      });
      // Clear the shopping_cart field in the user's document
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userRef.update({'shopping_cart': []});
      }
      _cart.clear();
      notifyListeners();
      print("Order and products added successfully");
    } catch (error) {
      print("Failed to add order and products: $error");
    }
  }

  Future<void> _initializeCart() async {
    if (_cart.isEmpty) {
      await fetchCart();
    }
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (var item in _cart) {
      totalPrice += item['price'] * item['quantity'];
    }
    return totalPrice;
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      // Find the item with the given productId in the cart
      var item = _cart.firstWhere((item) => item['product_id'] == productId);

      // Update the quantity of the item
      item['quantity'] = quantity;

      // Notify listeners of changes
      notifyListeners();
    } catch (error) {
      print('Error updating quantity: $error');
      // Handle error as needed
    }
  }

  Future<void> addToCart(String productId) async {
    try {
      // Fetch user information
      UserModel user = UserModel(); // Assuming UserModel has the user's ID

      // Get reference to the user document
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uId);

      // Get the current shopping cart array from the user document
      DocumentSnapshot userDoc = await userRef.get();
      List<dynamic> shoppingCart = userDoc.get('shopping_cart') ?? [];

      // Check if the product ID is already in the shopping cart
      if (shoppingCart.contains(productId)) {
        print('Product already exists in shopping cart');
        Utilities.showSnackBar("Product already in cart", Colors.green);
        return; // Exit function if product already exists
      }

      // Add the new product ID to the shopping cart array
      shoppingCart.add(productId);

      // Update the user document with the updated shopping cart array
      await userRef.update({'shopping_cart': shoppingCart});

      print('Product added to shopping cart successfully');
      Utilities.showSnackBar("Item added to cart", Colors.green);

      // Update the local cart state
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (productDoc.exists) {
        print('Product document exists for ID: $productId');
        Map<String, dynamic> productData =
            productDoc.data() as Map<String, dynamic>;
        // Include product price in the map
        _cart.add({
          'product_id': productId,
          'name': productData['name'],
          'imagePath': productData['imagePath'],
          'price': productData['price'],
          'quantity': 1,
          'stock': productData['stock'],
          // Add other product details as needed
        });
      }
      notifyListeners();
    } catch (error) {
      print('Error adding product to shopping cart: $error');
      // Handle error as needed
    }
  }

  Future<void> deleteCartItem(String productId) async {
    try {
      // Fetch user information
      UserModel user = UserModel(); // Assuming UserModel has the user's ID

      // Get reference to the user document
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uId);

      // Get the current shopping cart array from the user document
      DocumentSnapshot userDoc = await userRef.get();
      List<dynamic> shoppingCart = userDoc.get('shopping_cart') ?? [];

      // Remove the specified product ID from the shopping cart array
      shoppingCart.remove(productId);

      // Update the user document with the modified shopping cart array
      await userRef.update({'shopping_cart': shoppingCart});

      print('Product removed from shopping cart successfully');

      try {
        // Remove the specified product from the _cart list
        _cart.removeWhere((item) => item['product_id'] == productId);

        // Notify listeners of changes
        notifyListeners();

        print('Product removed from shopping cart successfully');
      } catch (error) {
        print('Error removing product from shopping cart: $error');
        // Handle error as needed
      }
    } catch (error) {
      print('Error removing product from shopping cart: $error');
      // Handle error as needed
    }
  }

  Future<void> fetchCart() async {
    try {
      // Fetch user information
      UserModel user = UserModel(); // Assuming UserModel has the user's ID

      // Get reference to the user document
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uId)
          .get();

      List<Map<String, dynamic>> cartWithPrice = [];
      if (userDoc.exists) {
        print('User document exists / happening in fetchDetails');
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        if (userData.containsKey('shopping_cart')) {
          print('Shopping cart exists in user data');
          List<String> cartProductIds =
              List<String>.from(userData['shopping_cart']);
          print('Cart product IDs: $cartProductIds');

          // Fetch product details for each product in the cart
          for (String productId in cartProductIds) {
            DocumentSnapshot productDoc = await FirebaseFirestore.instance
                .collection('products')
                .doc(productId)
                .get();

            if (productDoc.exists) {
              print('Product document exists for ID: $productId');
              Map<String, dynamic> productData =
                  productDoc.data() as Map<String, dynamic>;
              // Include product price in the map
              cartWithPrice.add({
                'product_id': productId,
                'name': productData['name'],
                'imagePath': productData['imagePath'],
                'price': productData['price'],
                'quantity': 1,
                'stock': productData['stock'],
                // Add other product details as needed
              });
            } else {
              print('Product document does not exist for ID: $productId');
            }
          }
        } else {
          print('Shopping cart does not exist in user data');
        }
      } else {
        print('User document does not exist');
      }
      _cart = cartWithPrice;
      print("$_cart inside of model");
      notifyListeners(); // Notify listeners of changes
    } catch (error) {
      print('Error fetching cart: $error');
      // Handle error as needed
    }
  }
}
