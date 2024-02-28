import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/core/input_validator.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/input_button.dart';
import 'package:jollyfish/widgets/input_field.dart';

class DeliveryDetailsPage extends StatefulWidget {
  final String delivery_id;
  const DeliveryDetailsPage({Key? key, required this.delivery_id})
      : super(key: key);

  @override
  _DeliveryDetailsPageState createState() => _DeliveryDetailsPageState();
}

class _DeliveryDetailsPageState extends State<DeliveryDetailsPage> {
  final _trackingNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
  void dispose() {
    _trackingNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Details"),
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.chevron_left),
        ),
      ),
      body: Form(
        key: formKey,
        child: FutureBuilder(
            future: getOrderDetails(widget.delivery_id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> orderDetails = snapshot.data!;
                List<DataRow> orderItems = [];

                String myDate = "test";

                if (orderDetails['ordered_at'] != null) {
                  Timestamp t = orderDetails['ordered_at'] as Timestamp;
                  DateTime date = t.toDate();
                  myDate = DateFormat('dd/MM/yyyy,hh:mm').format(date);

                  if (orderDetails.containsKey('items')) {
                    // Iterate through the items list
                    List<Map<String, dynamic>> items = orderDetails['items'];
                    items.forEach((item) {
                      // Access item details
                      String productId = item['product_id'];
                      String productImagePath = item['imagePath'];
                      String productName = item['name'];
                      int quantity = item['quantity'].toInt();
                      double total = item['total'];

                      // orderItems.add(OrderItem(
                      //     imagePath: productImagePath,
                      //     name: productName,
                      //     quantity: quantity.toInt(),
                      //     total: total));

                      orderItems.add(DataRow(
                        cells: [
                          DataCell(Row(
                            children: [
                              SizedBox(
                                height: 32,
                                width: 32,
                                child: Image.network(
                                  productImagePath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(productName),
                            ],
                          )),
                          DataCell(Text("$quantity")),
                          DataCell(Text("P$total")),
                        ],
                      ));
                      // Get product details from Firestore
                    });
                  } else {
                    print('No items found in the order.');
                  }
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order No. ${widget.delivery_id}",
                          style: TextStyle(
                            color: majorText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              orderDetails['recipient_name'],
                              style: TextStyle(
                                color: majorText,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              orderDetails['recipient_contact'],
                              style: TextStyle(
                                color: majorText,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${orderDetails['address1']}, ${orderDetails['barangay']}, ${orderDetails['city']}, ${orderDetails['province']}",
                          style: TextStyle(
                            color: majorText,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Payment Method",
                          style: TextStyle(
                            color: majorText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          orderDetails['payment_method'],
                          style: TextStyle(
                            color: majorText,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text("Item")),
                              DataColumn(label: Text("Quantity")),
                              DataColumn(label: Text("Price")),
                            ],
                            rows: orderItems,
                          ),
                        ),
                        Align(
                          child: Text(
                            "Total: P${orderDetails['total']}",
                            style: TextStyle(
                              color: majorText,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          alignment: Alignment.centerRight,
                        ),
                        Align(
                          child: Text(
                            "Summary",
                            style: TextStyle(
                              color: majorText,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          alignment: Alignment.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal",
                              style: TextStyle(
                                color: majorText,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "P${(orderDetails['total'] / 1.12).toStringAsFixed(2)}",
                              style: TextStyle(
                                color: majorText,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "VAT (12%)",
                              style: TextStyle(
                                color: majorText,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "P${((orderDetails['total']) - ((orderDetails['total'] / (1 + 0.12)))).toStringAsFixed(2)}",
                              style: TextStyle(
                                color: majorText,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                color: majorText,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "P${orderDetails['total']}",
                              style: TextStyle(
                                color: majorText,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        InputField(
                          placeholder: "Tracking Number",
                          inputType: "text",
                          controller: _trackingNumberController,
                          validator: InputValidator.requiredValidator,
                        ),
                        InputButton(
                          function: () async {
                            InputValidator.checkFormValidity(formKey, context);
                            if (_trackingNumberController.text.isEmpty) {
                              Utilities.showSnackBar(
                                  "Tracking number is required", Colors.red);
                              return;
                            }

                            try {
                              CollectionReference orders =
                                  FirebaseFirestore.instance.collection(
                                'orders',
                              );
                              orders.doc(widget.delivery_id).update({
                                'status': "Order handed to courier",
                                'tracking_no':
                                    _trackingNumberController.text.trim(),
                              });
                              try {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(orderDetails['ordered_by'])
                                    .collection('notifications')
                                    .add({
                                  'heading':
                                      "Order ${widget.delivery_id} Handed Over to Courier",
                                  'body':
                                      "Tracking Number: ${_trackingNumberController.text.trim()}",
                                  'timestamp': FieldValue.serverTimestamp(),
                                });
                                print('Notification added successfully');
                              } catch (error) {
                                print('Error adding notification: $error');
                              }
                              Utilities.showSnackBar(
                                  "Successfully updated status", Colors.green);
                              setState(() {});
                            } catch (ex) {
                              Utilities.showSnackBar(
                                  "An error occured upon updating status of order $ex",
                                  Colors.red);
                            }
                            Navigator.of(context).pop();
                          },
                          label: "Handover to Courier",
                          large: false,
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
            }),
      ),
    );
  }
}
