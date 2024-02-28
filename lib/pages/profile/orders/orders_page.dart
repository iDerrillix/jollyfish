import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";
import "package:jollyfish/constants.dart";
import "package:jollyfish/widgets/order_summary.dart";

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {},
            child: Icon(
              Icons.filter_alt,
              color: accentColor,
            ),
          ),
        ],
        title: Text("My Orders"),
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            color: accentColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('ordered_by',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              List<OrderSummary> orderWidgets = [];

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

                  final orderWidget = OrderSummary(
                    orderNum: order.id,
                    status: order['status'],
                    date: myDate,
                    total: order['total'].toDouble(),
                    action: () {},
                  );

                  orderWidgets.add(orderWidget);
                }
              }

              // if (snapshot.connectionState == ConnectionState.done) {
              // } else {
              //   return CircularProgressIndicator();
              // }

              return Column(
                children: orderWidgets,
              );
              // OrderSummary(
              //       orderNum: "696969",
              //       status: "Completed",
              //       date: "12-31-2023",
              //       total: 999.99,
              //       action: () {
              //         context.goNamed("Order Details");
              //       },
              //     ),
            },
          ),
        ),
      ),
    );
  }
}
