import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:jollyfish/constants.dart";
import "package:jollyfish/widgets/input_button.dart";

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order No. 123123123",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: majorText,
                    ),
                  ),
                  Text(
                    "Completed",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Yesterday at 12:59 AM",
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
                "Franz Dainell V. Valones",
                style: NormalStyle,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "+63 918-463-9221",
                style: NormalStyle,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Delivered to",
                style: HeadingStyle,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "1084 Kalsadang Bago Caingin San Rafael Bulacan",
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
                "09184639221 GCash",
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
              OrderItem(),
              OrderItem(),
              OrderItem(),
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
                  Text("P999.99"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Delivery Fee"),
                  Text("P50.00"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total"),
                  Text("P2999.99"),
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
                      function: () {},
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: InputButton(
                      label: "Leave a Review",
                      large: false,
                      function: () {},
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  const OrderItem({Key? key}) : super(key: key);

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
              ),
              SizedBox(
                width: 8,
              ),
              Text("Product Name x3"),
            ],
          ),
          Text("P999.99"),
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
