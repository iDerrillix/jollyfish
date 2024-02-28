import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";
import "package:jollyfish/constants.dart";
import "package:jollyfish/widgets/input_button.dart";

class OrderDetailsPage extends StatefulWidget {
  final String order_id;
  const OrderDetailsPage({Key? key, required this.order_id}) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late Future<Map<String, dynamic>> orderDetails;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        leading: TextButton(
          child: Icon(Icons.chevron_left),
          onPressed: () => context.goNamed("Orders"),
        ),
      ),
      body: FutureBuilder(
        future: getOrderDetails(widget.order_id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> orderDetails = snapshot.data!;

            String myDate = "test";

            if (orderDetails['ordered_at'] != null) {
              Timestamp t = orderDetails['ordered_at'] as Timestamp;
              DateTime date = t.toDate();
              myDate = DateFormat('dd/MM/yyyy,hh:mm').format(date);
            }
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

                orderItems.add(OrderItem(
                    imagePath: productImagePath,
                    name: productName,
                    quantity: quantity.toInt(),
                    total: total));

                // Get product details from Firestore
              });
            } else {
              print('No items found in the order.');
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.order_id}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: majorText,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      orderDetails['status'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      myDate,
                      style: NormalStyle,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Customer Information",
                      style: HeadingStyle,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      orderDetails['recipient_name'],
                      style: NormalStyle,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      orderDetails['recipient_contact'],
                      style: NormalStyle,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Shipping Address",
                      style: HeadingStyle,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${orderDetails['address1']}, ${orderDetails['barangay']}, ${orderDetails['city']}, ${orderDetails['province']}",
                      style: NormalStyle,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Payment Method",
                      style: HeadingStyle,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${orderDetails['payment_method']} ${orderDetails['payment_details']}",
                      style: NormalStyle,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(
                      color: majorText,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "ITEMS",
                      style: HeadingStyle,
                    ),
                    Column(
                      children: orderItems,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(
                      color: majorText,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Subtotal"),
                        Text(
                            "P${(orderDetails['total'] / 1.12).toStringAsFixed(2)}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("VAT (12%)"),
                        Text(
                            "P${(orderDetails['total'] / (1 + 0.12) * 0.12).toStringAsFixed(2)}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total"),
                        Text("P${orderDetails['total']}"),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(
                      color: majorText,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputButton(
                            label: "Report a Problem",
                            large: false,
                            function: () {
                              context.go('/profile/report/${widget.order_id}');
                            },
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        (orderDetails['status'] == 'Order handed to courier' &&
                                (orderDetails['rated'] == null))
                            ? Expanded(
                                child: InputButton(
                                  label: "Leave a Review",
                                  large: false,
                                  function: () {
                                    context.go(
                                        '/profile/orders/order-details/${widget.order_id}/review/${widget.order_id}');
                                  },
                                ),
                              )
                            : SizedBox(),
                        (orderDetails['rated'] == true)
                            ? Text(
                                "Thanks for your review!",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500),
                              )
                            : SizedBox(),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final int quantity;
  final double total;
  const OrderItem(
      {Key? key,
      required this.imagePath,
      required this.name,
      required this.quantity,
      required this.total})
      : super(key: key);

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
                color: Colors.grey,
                child: Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text("${name} x${quantity}"),
            ],
          ),
          Text("P${total}"),
        ],
      ),
    );
  }
}

const HeadingStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  color: minorText,
);

const NormalStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: majorText,
);
