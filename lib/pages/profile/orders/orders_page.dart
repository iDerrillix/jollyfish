import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            OrderSummary(
              orderNum: "696969",
              status: "Completed",
              date: "12-31-2023",
              total: 999.99,
              action: () {
                context.goNamed("Order Details");
              },
            ),
            OrderSummary(
              orderNum: "696969",
              status: "Completed",
              date: "12-31-2023",
              total: 999.99,
              action: () {},
            ),
          ],
        ),
      ),
    );
  }
}
