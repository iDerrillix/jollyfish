import 'package:go_router/go_router.dart';
import "package:jollyfish/constants.dart";
import 'package:flutter/material.dart';
import 'package:jollyfish/pages/home/product_page.dart';
import 'package:intl/intl.dart';

class ProductTile extends StatelessWidget {
  final String imgPath;
  final String name;
  final int stock;
  final double price;

  const ProductTile({
    Key? key,
    required this.imgPath,
    required this.name,
    required this.stock,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed("Product");
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgPath,
                width: 250,
                height: 125,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: majorText,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "${stock} available",
              style: TextStyle(fontSize: 14, color: minorText),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "₱${NumberFormat("#,##0.00", "en_US").format(price)}",
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
