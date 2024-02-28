import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/input_button.dart';
import 'package:jollyfish/widgets/input_field.dart';

class OrdersDetails extends StatefulWidget {
  final String order_id;
  const OrdersDetails({Key? key, required this.order_id}) : super(key: key);

  @override
  _OrdersDetailsState createState() => _OrdersDetailsState();
}

class _OrdersDetailsState extends State<OrdersDetails> {
  Future<void> reduceStockForProduct(Map<String, dynamic> orderDetails) async {
    List<Map<String, dynamic>> products = orderDetails['items'];
    for (Map<String, dynamic> orderProduct in products) {
      DocumentReference productRef = FirebaseFirestore.instance
          .collection('products')
          .doc(orderProduct['product_id']);

      DocumentSnapshot productSnapshot = await productRef.get();
      Map<String, dynamic>? productData =
          productSnapshot.data() as Map<String, dynamic>;

      if (productData != null) {
        int availableStock = (productData['stock'] as num?)?.toInt() ?? 0;

        await productRef.update({
          'stock': availableStock - orderProduct['quantity'],
        });
      } else {
        print(
            "An error occurred while reducing stock for product with ID ${orderDetails['product_id']}");
      }
    }
  }

  Future<bool> checkStockForOrder(Map<String, dynamic> orderDetails) async {
    List<Map<String, dynamic>> products = orderDetails['items'];
    print(products);
    for (Map<String, dynamic> orderProduct in products) {
      DocumentSnapshot productSnapshopt = await FirebaseFirestore.instance
          .collection('products')
          .doc(orderProduct['product_id'])
          .get();
      Map<String, dynamic>? productData =
          productSnapshopt.data() as Map<String, dynamic>;
      if (productData != null) {
        String productName = productData['name'] as String;
        int availableStock = (productData['stock'] as num?)?.toInt() ?? 0;

        if (availableStock < orderProduct['quantity']) {
          print("Insufficient stock for ${productName}");
          return false;
        }
      } else {
        print("error occured while checking stock availability");
        return false;
      }
    }

    print("Stock is sufficient for the order");
    return true;
  }

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

  void updateStatus(String status) {
    try {
      CollectionReference orders = FirebaseFirestore.instance.collection(
        'orders',
      );
      orders.doc(widget.order_id).update({
        'status': status,
      });
      Utilities.showSnackBar("Successfully updated status", Colors.green);
      setState(() {});
    } catch (ex) {
      Utilities.showSnackBar(
          "An error occured upon updating status of order $ex", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.chevron_left),
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

            List<DataRow> orderItems = [];
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
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order No. ${widget.order_id}",
                      style: TextStyle(
                        color: majorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      orderDetails['status'],
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        (orderDetails['status'] == 'Verifying')
                            ? TextButton(
                                onPressed: () async {
                                  bool isStockSufficient =
                                      await checkStockForOrder(orderDetails);
                                  if (isStockSufficient) {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(orderDetails['ordered_by'])
                                          .collection('notifications')
                                          .add({
                                        'heading':
                                            "Order ${widget.order_id} Verified",
                                        'body':
                                            "Verification complete. Your order is now being processed.",
                                        'timestamp':
                                            FieldValue.serverTimestamp(),
                                      });
                                      print('Notification added successfully');
                                    } catch (error) {
                                      print(
                                          'Error adding notification: $error');
                                    }
                                    updateStatus("Processing");
                                  } else {
                                    Utilities.showSnackBar(
                                        "Insufficient stock", Colors.red);
                                  }
                                },
                                child: Text(
                                  "Verify",
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : Text(
                                "Verified",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Recipient Information",
                      style: TextStyle(
                        color: majorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
                    Text(
                      "${orderDetails['address1']}, ${orderDetails['barangay']}, ${orderDetails['city']}, ${orderDetails['province']}",
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
                          DataColumn(label: Text("Quantity"), numeric: true),
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
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          useSafeArea: true,
                          context: context,
                          builder: (context) {
                            return Center(
                              child: SizedBox(
                                width: 360,
                                child: Image.network(
                                  orderDetails['proof_path'],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        color: majorText,
                        child: Image.network(
                          orderDetails['proof_path'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [],
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
                    (orderDetails['status'] == 'Verifying' ||
                            orderDetails['status'] == 'Processing')
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InputButton(
                                  function: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Reject Order"),
                                          content: Text(
                                              "Are you sure you want to reject this order?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("No")),
                                            TextButton(
                                                onPressed: () async {
                                                  try {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(orderDetails[
                                                            'ordered_by'])
                                                        .collection(
                                                            'notifications')
                                                        .add({
                                                      'heading':
                                                          "Order ${widget.order_id} Rejected",
                                                      'body':
                                                          "Details did not match attached proof. Please retry again.",
                                                      'timestamp': FieldValue
                                                          .serverTimestamp(),
                                                    });
                                                    print(
                                                        'Notification added successfully');
                                                  } catch (error) {
                                                    print(
                                                        'Error adding notification: $error');
                                                  }
                                                  Navigator.of(context).pop();
                                                  updateStatus("Rejected");
                                                  context.go('/orders');
                                                },
                                                child: Text("Yes")),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  label: "REJECT",
                                  large: false,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputButton(
                                  function: () async {
                                    bool isStockSufficient =
                                        await checkStockForOrder(orderDetails);
                                    if (isStockSufficient) {
                                      await reduceStockForProduct(orderDetails);
                                      updateStatus("Awaiting Courier Pickup");
                                      context.go('/orders');
                                    } else {
                                      Utilities.showSnackBar(
                                          "Insufficient stock detected",
                                          Colors.red);
                                    }
                                  },
                                  label: "PROCESS",
                                  large: false,
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
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
