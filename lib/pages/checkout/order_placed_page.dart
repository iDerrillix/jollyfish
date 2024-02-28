import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jollyfish/app_router.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/widgets/input_button.dart';

class OrderPlacedPage extends StatelessWidget {
  const OrderPlacedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Placed"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Order Placed",
              style: TextStyle(
                color: majorText,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Check your notifications for updates regarding your order",
              style: TextStyle(
                  color: minorText, fontWeight: FontWeight.w500, fontSize: 16),
            ),
            InputButton(
                label: "Continue Shopping",
                function: () {
                  context.pop();
                  context.pop();
                },
                large: true),
          ],
        ),
      ),
    );
  }
}
