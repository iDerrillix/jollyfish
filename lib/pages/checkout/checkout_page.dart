import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:jollyfish/constants.dart";
import "package:jollyfish/widgets/checkout_details.dart";
import "package:jollyfish/widgets/checkout_item.dart";

TextStyle orderSumStyle =
    TextStyle(color: minorText, fontSize: 16, fontWeight: FontWeight.w500);

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text("Checkout"),
        leading: TextButton(
          child: Icon(
            Icons.chevron_left,
            color: accentColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Order",
                      style: TextStyle(
                          fontSize: 18,
                          color: majorText,
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Hide",
                        style: TextStyle(color: minorText),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    CheckoutItem(),
                  ],
                ),
                Text(
                  "Delivery Location",
                  style: TextStyle(
                      fontSize: 18,
                      color: majorText,
                      fontWeight: FontWeight.bold),
                ),
                CheckoutDetails(
                  heading: "1084 Kalsadang Bago Street",
                  body: "Caingin, San Rafael, Bulacan",
                  icon: Icon(Icons.location_city),
                  iconBgColor: Color(0xFF123123),
                  action: () => {print("checked")},
                ),
                Text(
                  "Payment Method",
                  style: TextStyle(
                      fontSize: 18,
                      color: majorText,
                      fontWeight: FontWeight.bold),
                ),
                CheckoutDetails(
                  heading: "GCash",
                  body: "09******221",
                  iconBgColor: Colors.blue.shade300,
                  icon: Icon(
                    Icons.money,
                    color: Colors.white,
                  ),
                  action: () => print("yo momma"),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Summary",
                  style: TextStyle(
                      fontSize: 18,
                      color: majorText,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 239, 242, 242),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal",
                              style: orderSumStyle,
                            ),
                            Text(
                              "P999.99",
                              style: orderSumStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "VAT",
                              style: orderSumStyle,
                            ),
                            Text(
                              "P107.14",
                              style: orderSumStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery Fee",
                              style: orderSumStyle,
                            ),
                            Text(
                              "P50",
                              style: orderSumStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
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
                          "Total",
                          style: TextStyle(
                              color: majorText,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        Text(
                          "P999.99",
                          style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // Adjust the radius as needed
                      ),
                      elevation: 0,
                      height: 44,
                      onPressed: () {},
                      color: accentColor,
                      textColor: Colors.white,
                      child: Text(
                        "Place Order",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
