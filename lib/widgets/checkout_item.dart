import "package:flutter/material.dart";
import "package:jollyfish/constants.dart";

class CheckoutItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final double price;
  final int quantity;

  const CheckoutItem(
      {Key? key,
      required this.imagePath,
      required this.name,
      required this.price,
      required this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                    fit: BoxFit.cover, height: 64, width: 64, imagePath),
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: majorText),
                  ),
                  Text(
                    "P${price}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: majorText),
                  ),
                ],
              ),
            ],
          ),
          Text(
            "QTY: $quantity",
            style: TextStyle(
              color: minorText,
            ),
          ),
        ],
      ),
    );
  }
}
