import "package:flutter/material.dart";
import "package:jollyfish/constants.dart";
import 'package:intl/intl.dart';

class CartItem extends StatefulWidget {
  final String imgPath;
  final String name;
  final double price;
  int quantity;
  CartItem(
      {Key? key,
      required this.imgPath,
      required this.name,
      required this.price,
      required this.quantity})
      : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: tintColor,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: Image.network(
                    widget.imgPath,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "₱${widget.price}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: MaterialButton(
                    elevation: 0,
                    onPressed: () {
                      setState(() {
                        if (widget.quantity > 1) {
                          widget.quantity--;
                        }
                      });
                    },
                    color: Colors.white,
                    padding: EdgeInsets.zero, // Set padding to zero
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8), // Adjust the radius as needed
                    ),
                    child: Text(
                      "-",
                      style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "${widget.quantity}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 8,
                ),
                SizedBox(
                  height: 24,
                  width: 24,
                  child: MaterialButton(
                    elevation: 0,
                    onPressed: () {
                      setState(() {
                        //lagay ng condition where d pwede tumaas yung quantity na lalagpas sa stocks available
                        //gawin rin editable yung number sa quantity para d hassle pag marami bibilin
                        widget.quantity++;
                      });
                    },
                    color: accentColor,
                    padding: EdgeInsets.zero, // Set padding to zero
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8), // Adjust the radius as needed
                    ),
                    child: Text(
                      "+",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Text(
                "₱${NumberFormat("#,##0.00", "en_US").format(widget.price * widget.quantity)}"),
          ],
        ),
      ),
    );
  }
}
