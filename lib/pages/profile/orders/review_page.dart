import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/input_button.dart';

class ReviewPage extends StatefulWidget {
  final String order_id;
  const ReviewPage({Key? key, required this.order_id}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    Map<String, dynamic> orderDetails = {};

    try {
      // Get the order document by its ID
      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .get();

      if (orderSnapshot.exists) {
        // Get the data from the order document
        orderDetails = orderSnapshot.data() as Map<String, dynamic>;

        // Get the items inside the order from the products collection
        QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .collection('products')
            .get();

        List<Map<String, dynamic>> items = [];

        if (productsSnapshot.docs.isNotEmpty) {
          for (var productDoc in productsSnapshot.docs) {
            // Get product details from Firestore
            DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
                .collection('products')
                .doc(productDoc.id)
                .get();

            // Check if product exists
            if (productSnapshot.exists) {
              // Access product details
              String productName = productSnapshot['name'];
              String productImagePath = productSnapshot['imagePath'];

              // Extract product details
              Map<String, dynamic> productData = {
                'product_id': productDoc.id,
                'quantity': productDoc['quantity'],
                'imagePath': productImagePath,
                'name': productName,
                'total': productDoc['total'],
              };
              items.add(productData);
              print(
                  "item added ${productDoc.id}, name: ${productName}, image: ${productImagePath}");
            } else {
              print('Product with ID ${productDoc.id} does not exist.');
            }
          }
          ;

          // Add the items to the order details
          orderDetails['items'] = items;
        } else {
          print("empty much wow");
        }
      }
    } catch (e) {
      print('Error fetching order details: $e');
    }

    return orderDetails;
  }

  Map<String, int> ratings = {};

  // void updateRating(String productId, int rating) {
  //   setState(() {
  //     ratings[productId] = rating;
  //   });
  // }

  // void handleSubmit() {
  //   // Submit ratings to the database
  //   ratings.forEach((productId, rating) {
  //     FirebaseFirestore.instance
  //         .collection('reviews')
  //         .doc(productId)
  //         .collection('ratings')
  //         .doc(widget.order_id)
  //         .set({
  //       'rating': rating,
  //       'order_id': widget.order_id,
  //     }).then((value) {
  //       // Review submitted successfully
  //       print('Review submitted for product $productId');
  //     }).catchError((error) {
  //       // Error handling
  //       print('Error submitting review: $error');
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leave a Review"),
        leading: TextButton(
          child: Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: FutureBuilder(
          future: getOrderDetails(widget.order_id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> orderDetails = snapshot.data!;
              List<Widget> orderItems = [];
              if (orderDetails.containsKey('items')) {
                // Iterate through the items list
                List<Map<String, dynamic>> items = orderDetails['items'];
                items.forEach((item) {
                  // Access item details
                  String productId = item['product_id'];
                  String productImagePath = item['imagePath'];
                  String productName = item['name'];
                  double quantity = item['quantity'];
                  double total = item['total'];

                  if (ratings[productId] == null) {
                    ratings[productId] = 5;
                  }

                  print(ratings[productId]);

                  orderItems.add(
                    RatingContainer(
                      imagePath: productImagePath,
                      namne: productName,
                      initialRating: ratings[productId]!,
                      onRatingUpdate: (rating) {
                        setState(() {
                          ratings[productId] = rating;
                          print("${ratings[productId]} $productId");
                        });
                      },
                    ),
                  );

                  // Get product details from Firestore
                });
              } else {
                print('No items found in the order.');
              }
              return Column(
                children: [
                  Column(children: orderItems),
                  InputButton(
                      label: "SUBMIT",
                      function: () {
                        ratings.forEach((productId, rating) {
                          FirebaseFirestore.instance
                              .collection('reviews')
                              .doc(productId)
                              .collection('ratings')
                              .doc(widget.order_id)
                              .set({
                            'rating': rating,
                            'order_id': widget.order_id,
                          }).then((value) {
                            FirebaseFirestore.instance
                                .collection('orders')
                                .doc(widget.order_id)
                                .update({'rated': true});
                            // Review submitted successfully
                            print('Review submitted for product $productId');
                            Utilities.showSnackBar(
                                "Thank you for leaving a review!",
                                Colors.green);
                          }).catchError((error) {
                            // Error handling
                            print('Error submitting review: $error');
                            Utilities.showSnackBar(
                                'Error submitting review: $error', Colors.red);
                          });
                        });
                      },
                      large: false),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class RatingContainer extends StatefulWidget {
  final String imagePath;
  final String namne;
  final int initialRating;
  final void Function(int) onRatingUpdate;

  const RatingContainer({
    Key? key,
    required this.imagePath,
    required this.namne,
    required this.initialRating,
    required this.onRatingUpdate,
  }) : super(key: key);

  @override
  State<RatingContainer> createState() => _RatingContainerState();
}

class _RatingContainerState extends State<RatingContainer> {
  late int rating;

  @override
  void initState() {
    super.initState();
    rating = widget.initialRating;
  }

  int getCurrentRating() {
    return rating;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                widget.namne,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          RatingBar.builder(
            itemSize: 24,
            maxRating: 5,
            initialRating: widget.initialRating
                .toDouble(), // Use initialRating from the widget
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: accentColor,
            ),
            onRatingUpdate: (value) {
              setState(() {
                rating = value.toInt(); // Update the local rating state
              });
              widget.onRatingUpdate(
                  rating); // Notify the parent widget of the rating update
            },
          )
        ],
      ),
    );
  }
}
