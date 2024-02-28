import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:jollyfish/constants.dart";
import "package:jollyfish/models/product_model.dart";
import "package:jollyfish/models/shopping_cart_model.dart";
import "package:jollyfish/pages/cart/cart_page.dart";
import "package:jollyfish/utilities.dart";
import "package:provider/provider.dart";

class ProductPage extends StatefulWidget {
  final String product_id;

  const ProductPage({Key? key, required this.product_id}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<Map<String, dynamic>?> productDetails;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<int> getTotalReviews(String productId) async {
    try {
      QuerySnapshot reviewsSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .doc(productId)
          .collection('ratings')
          .get();

      return reviewsSnapshot.size;
    } catch (error) {
      print('Error getting total reviews: $error');
      return 0;
    }
  }

  Future<double> getAverageRating(String productId) async {
    try {
      QuerySnapshot ratingsSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .doc(productId)
          .collection('ratings')
          .get();

      if (ratingsSnapshot.size == 0) {
        return 0.0;
      }

      int totalRatings = ratingsSnapshot.size;
      int totalRatingSum = 0;

      for (var doc in ratingsSnapshot.docs) {
        totalRatingSum += doc['rating'] as int;
      }

      double averageRating = totalRatingSum / totalRatings;
      return averageRating;
    } catch (error) {
      print('Error getting average rating: $error');
      return 0.0;
    }
  }

  Future<void> fetchDetails() async {
    try {
      productDetails = ProductModel().getProductById(widget.product_id);
    } catch (ex) {
      print(ex);
    }
  }

  Future<void> addtoCart() async {
    try {
      await ShoppingCartModel().addToCart(widget.product_id);
    } catch (ex) {
      print(ex);
      Utilities.showSnackBar("${ex}", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingCartModel>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          leading: TextButton(
            child: Icon(
              Icons.chevron_left,
              color: accentColor,
            ),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
          title: Text('Product Page'),
        ),
        body: FutureBuilder<Map<String, dynamic>?>(
          future: productDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final productData = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ClipPath(
                      clipper: CustomClipPath(),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(productData['imagePath']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: 300,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                productData['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              // TextButton(
                              //   onPressed: () {},
                              //   child: Icon(
                              //     Icons.favorite_outline,
                              //     color: accentColor,
                              //   ),
                              // ),
                            ],
                          ),
                          Text(
                            "₱${productData['price']}",
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            "${productData['stock']} available",
                            style: TextStyle(
                              fontSize: 14,
                              color: minorText,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 16),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(34),
                                    border:
                                        Border.all(color: minorText, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8, left: 16, right: 16),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: accentColor,
                                        ),
                                        FutureBuilder(
                                          future: getAverageRating(
                                              widget.product_id),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              if (snapshot.hasError) {
                                                return Text("error");
                                              }

                                              // Assuming your getAverageRating function returns a double value
                                              double averageRating =
                                                  snapshot.data as double;

                                              // Display the average rating
                                              return Text(
                                                averageRating.toStringAsFixed(
                                                    1), // Displaying with one decimal point
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              );
                                            } else {
                                              return CircularProgressIndicator();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                FutureBuilder(
                                  future: getTotalReviews(widget.product_id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        // If an error occurred, display an error message
                                        return Text("Error: ${snapshot.error}");
                                      }

                                      // Assuming your getTotalReviews function returns an int value
                                      int totalReviews = snapshot.data as int;

                                      // Display the total number of reviews
                                      return Text(
                                        "${totalReviews.toString()} reviews",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: minorText),
                                      );
                                    } else {
                                      // While waiting for data, return a loading indicator
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Text(
                            productData['details'],
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: accentColor, width: 1),
                                    fixedSize: Size(0, 44),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8), // Adjust the radius as needed
                                    ),
                                  ),
                                  onPressed: () async {
                                    final cart =
                                        context.read<ShoppingCartModel>();

                                    await cart.addToCart(widget.product_id);
                                    context.go('/cart/checkout');
                                  },
                                  child: Text(
                                    "Buy Now",
                                    style: TextStyle(
                                      color: accentColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8), // Adjust the radius as needed
                                  ),
                                  elevation: 0,
                                  height: 44,
                                  onPressed: () {
                                    final cart =
                                        context.read<ShoppingCartModel>();

                                    cart.addToCart(widget.product_id);
                                    CartPage(
                                      reload: true,
                                    );
                                  },
                                  color: accentColor,
                                  textColor: Colors.white,
                                  child: Text(
                                    "Add to Cart",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No product details available'));
            }
          },
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.lineTo(0, size.height);
    path_0.quadraticBezierTo(size.width * 0.0028244, size.height * 0.8578857,
        size.width * 0.1276336, size.height * 0.8571429);
    path_0.cubicTo(
        size.width * 0.3183715,
        size.height * 0.8571429,
        size.width * 0.6997455,
        size.height * 0.8571429,
        size.width * 0.8905852,
        size.height * 0.8571429);
    path_0.quadraticBezierTo(size.width * 0.9997710, size.height * 0.8599429,
        size.width, size.height);
    path_0.lineTo(size.width, 0);
    path_0.lineTo(0, 0);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
