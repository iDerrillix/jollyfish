import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/input_button.dart';
import 'package:jollyfish/widgets/input_field.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<AdminOrdersPage> {
  final _searchController = TextEditingController();

  Future<bool> doesOrderExist(String orderId) async {
    DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .get();

    return orderSnapshot.exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        actions: [
          TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          InputField(
                            placeholder: "Order ID",
                            inputType: "text",
                            controller: _searchController,
                            label: "Order ID",
                          ),
                          InputButton(
                              label: "Search",
                              function: () async {
                                if (_searchController.text.isEmpty) {
                                  Utilities.showSnackBar(
                                      "Provide the order id first", Colors.red);
                                } else {
                                  String orderId =
                                      _searchController.text.trim();
                                  bool orderIdExists =
                                      await doesOrderExist(orderId);
                                  if (orderIdExists) {
                                    context.go('/orders/details/$orderId');
                                  } else {
                                    Utilities.showSnackBar(
                                        "Order ID not found", Colors.red);
                                  }
                                }
                              },
                              large: true),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.search)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .orderBy('status', descending: true)
                .where('status',
                    whereIn: ['Verifying', 'Processing']).snapshots(),
            builder: (context, snapshot) {
              List<Widget> orderWidgets = [];

              if (snapshot.hasData) {
                final orders = snapshot.data?.docs.reversed.toList();

                for (var order in orders!) {
                  // final Timestamp timestamp = order['ordered_at'];
                  // DateTime date =
                  //     DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
                  // String myDate = DateFormat('dd/MM/yyyy,hh:mm').format(date);

                  String myDate = "test";

                  if (order['ordered_at'] != null) {
                    Timestamp t = order['ordered_at'] as Timestamp;
                    DateTime date = t.toDate();
                    myDate = DateFormat('dd/MM/yyyy,hh:mm').format(date);
                  }

                  final orderWidget = GestureDetector(
                    onTap: () => context.go('/orders/details/${order.id}'),
                    child: OrdersContainer(
                        id: order.id,
                        name: order['recipient_name'],
                        date: myDate,
                        status: order['status'],
                        status_color: accentColor),
                  );

                  orderWidgets.add(orderWidget);
                }
              }

              return Column(
                children: orderWidgets,
              );
            },
          ),
        ),
      ),
    );
  }
}

class OrdersContainer extends StatelessWidget {
  final String id;
  final String name;
  final String date;
  final String status;
  final Color status_color;
  const OrdersContainer({
    Key? key,
    required this.id,
    required this.name,
    required this.date,
    required this.status,
    required this.status_color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4, bottom: 4),
      child: Container(
        width: double.infinity,
        height: 63,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color.fromARGB(255, 234, 240, 249),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 175,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ID. $id",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: majorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: minorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      color: minorText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                      color: status_color,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
