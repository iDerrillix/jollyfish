import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jollyfish/app_router.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/models/product_model.dart';
import 'package:jollyfish/models/shopping_cart_model.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/product_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late Future<Map<String, List<Map<String, dynamic>>>>
      categoriesWithProductsFuture;
  late Future<List<Map<String, dynamic>>> categories;
  late TabController _tabController;
  List<String> categoryNames = [];

  late Future<List<Map<String, dynamic>>> allCategoriesWithEachProducts;

  @override
  void initState() {
    super.initState();

    checkUserType();

    // ShoppingCartModel();

    categories = ProductModel().getCategories();

    categories.then((categoriesList) {
      _tabController =
          TabController(length: categoriesList.length + 1, vsync: this);
    });

    allCategoriesWithEachProducts = ProductModel().getCategoriesWithItems();
    // fetchCategories();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void checkUserType() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> userDetails =
          documentSnapshot.data() as Map<String, dynamic>;

      if (userDetails['user_type'] == 'Customer') {
        AppRouter.initR = "/home";
      } else {
        AppRouter.initR = "/dashboard";
        context.goNamed("Dashboard");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "JollyFish",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFA800),
          ),
        ),
        centerTitle: false,
      ),
      backgroundColor: scaffoldBg,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Our',
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              const Text(
                'Products',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.search, color: accentColor),
                    label: Text(
                      "Search Products",
                      style: TextStyle(color: minorText),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Color(0xFFEBEBEB),
                      ), // Change the border color for the enabled state
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: accentColor,
                      ), // Change the border color for the focused state
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        width: 360,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFA800),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                    ),
                    Container(
                      width: 360,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFA800),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              FutureBuilder(
                future: allCategoriesWithEachProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Utilities.showSnackBar(
                        "Something went wrong",
                        Colors.red,
                      );
                    }
                    int productsLength = 0;
                    List<Map<String, dynamic>> categoriesList = snapshot.data!;

                    List<Tab> tabs = categoriesList.map((category) {
                      return Tab(
                        text: category['name'],
                      );
                    }).toList();

                    List<Widget> tabBarViews = [];
                    List<Widget> allProductTiles = [];

                    // Iterate through each category map
                    for (Map<String, dynamic> category in categoriesList) {
                      // Get the 'items' list inside the category map
                      List<Map<String, dynamic>> itemsList = category['items'];

                      List<Widget> productTiles = [];
                      // Iterate through each item in the 'items' list
                      for (Map<String, dynamic> item in itemsList) {
                        // Access the properties of each item
                        String itemName = item['name'];
                        String itemDetails = item['details'];
                        double itemPrice = item['price'].toDouble();
                        int itemStock = item['stock'].toInt();
                        String itemImagePath = item['imagePath'];
                        String product_id = item['product_id'];

                        productTiles.add(
                          ProductTile(
                            imgPath: itemImagePath,
                            name: itemName,
                            stock: itemStock,
                            price: itemPrice,
                            product_id: product_id,
                          ),
                        );

                        productsLength++;
                        allProductTiles.add(
                          ProductTile(
                            imgPath: itemImagePath,
                            name: itemName,
                            stock: itemStock,
                            price: itemPrice,
                            product_id: product_id,
                          ),
                        );
                      }
                      tabBarViews.add(Column(
                        children: productTiles,
                      ));
                    }

                    tabs.add(Tab(text: 'All Products'));
                    tabBarViews.add(Column(
                      children: allProductTiles,
                    ));

                    return DefaultTabController(
                      length: tabs.length,
                      child: Container(
                        height: 300.0 * productsLength,
                        child: Column(
                          children: [
                            TabBar(
                              isScrollable: true,
                              indicatorColor: accentColor,
                              unselectedLabelColor: minorText,
                              labelColor: accentColor,
                              tabs: tabs,
                              controller: _tabController,
                            ),
                            Expanded(
                              // Wrap TabBarView with Expanded widget
                              child: TabBarView(
                                children: tabBarViews,
                                controller: _tabController,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
