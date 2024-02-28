import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  Future<Map<String, dynamic>?> getProductById(String productId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> productSnapshot =
          await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .get();

      if (productSnapshot.exists) {
        Map<String, dynamic>? productData = productSnapshot.data();
        if (productData != null) {
          return {
            'product_id': productSnapshot.id,
            'name': productData['name'],
            'details': productData['details'],
            'imagePath': productData['imagePath'],
            'price': productData['price'],
            'stock': productData['stock'],
          };
        }
      }
    } catch (e) {
      print('Error retrieving product: $e');
    }
    return null; // Return null if product not found or error occurs
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();

    List<Map<String, dynamic>> productsList = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> productData = doc.data() as Map<String, dynamic>;
      productsList.add(productData);
    });

    return productsList;
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();

    List<Map<String, dynamic>> categoriesList = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> categoryData = doc.data() as Map<String, dynamic>;
      categoryData['id'] = doc.id; // Add the document ID as 'id'
      categoriesList.add(categoryData);
    });

    return categoriesList;
  }

  Future<List<String>> getCategoryItems(String categoryId) async {
    DocumentSnapshot categorySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId)
        .get();

    List<String> items = [];
    if (categorySnapshot.exists) {
      Map<String, dynamic> categoryData =
          categorySnapshot.data() as Map<String, dynamic>;
      items = List<String>.from(categoryData['items']);
    }

    return items;
  }

  Future<List<Map<String, dynamic>>> getCategoriesWithItems() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();

    List<Map<String, dynamic>> categoriesList = [];
    for (var categoryDoc in querySnapshot.docs) {
      Map<String, dynamic> categoryData = {};
      categoryData['name'] =
          categoryDoc['name']; // Assuming 'name' field exists in categories
      List<Map<String, dynamic>> itemsList = [];

      // Fetch items for the current category
      DocumentSnapshot categorySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryDoc.id)
          .get();

      if (categorySnapshot.exists) {
        List<String> productIds = List<String>.from(categorySnapshot['items']);
        for (var productId in productIds) {
          // Fetch product details using the productId
          DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .get();

          if (productSnapshot.exists) {
            Map<String, dynamic> productData =
                productSnapshot.data() as Map<String, dynamic>;
            itemsList.add({
              'product_id': productId,
              'name': productData['name'],
              'details': productData['details'],
              'price': productData['price'],
              'stock': productData['stock'],
              'imagePath': productData['imagePath'],
            });
          }
        }
      }

      categoryData['items'] = itemsList;
      categoriesList.add(categoryData);
    }

    return categoriesList;
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    List<Map<String, dynamic>> products = [];

    try {
      QuerySnapshot<Map<String, dynamic>> productsSnapshot =
          await FirebaseFirestore.instance.collection('products').get();

      // Iterate through each document in the collection
      productsSnapshot.docs
          .forEach((DocumentSnapshot<Map<String, dynamic>> productDoc) {
        // Access product data from each document
        Map<String, dynamic>? productData = productDoc.data();

        // Add product data to the list
        if (productData != null) {
          products.add({
            'product_id': productDoc.id,
            'name': productData['name'],
            'details': productData['details'],
            'imagePath': productData['imagePath'],
            'price': productData['price'],
            'stock': productData['stock'],
          });
        }
      });
    } catch (e) {
      print('Error retrieving products: $e');
    }

    return products;
  }

  Future<Map<String, List<Map<String, dynamic>>>>
      getProductCategoriesWithProducts() async {
    try {
      // Get all categories from the 'categories' collection
      QuerySnapshot<Map<String, dynamic>> categoriesSnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      // Initialize a map to store categories with their associated products
      Map<String, List<Map<String, dynamic>>> categoriesWithProducts = {};

      // Iterate through each category document
      for (QueryDocumentSnapshot<Map<String, dynamic>> categoryDoc
          in categoriesSnapshot.docs) {
        // Extract category data
        String categoryId = categoryDoc.id;
        String categoryName = categoryDoc['name'];
        List<dynamic> productIds = categoryDoc['items'];

        // Retrieve products for each category
        List<Map<String, dynamic>> products = [];
        for (String productId in productIds) {
          // Get product details from the 'products' collection based on product ID
          DocumentSnapshot<Map<String, dynamic>> productSnapshot =
              await FirebaseFirestore.instance
                  .collection('products')
                  .doc(productId)
                  .get();

          // Extract product data and add it to the products list
          Map<String, dynamic>? productData = productSnapshot.data();
          if (productData != null) {
            products.add({
              'product_id': productSnapshot.id,
              'name': productData['name'],
              'details': productData['details'],
              'imagePath': productData['imagePath'],
              'price': productData['price'],
              'stock': productData['stock'],
            });
          }
        }

        // Add the category with its associated products to the map
        categoriesWithProducts[categoryName] = products;
      }

      // Return the map containing categories with their associated products
      return categoriesWithProducts;
    } catch (e) {
      print('Error retrieving categories with products: $e');
      // In case of an error, return an empty map or handle it based on your requirement
      return {};
    }
  }
}
