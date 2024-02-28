import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:jollyfish/constants.dart";
import 'package:intl/intl.dart';
import "package:jollyfish/models/shopping_cart_model.dart";
import "package:provider/provider.dart";

class CartItem extends StatefulWidget {
  final String product_id;
  final String imgPath;
  final String name;
  final double price;
  final int initialQuantity;
  int stock;
  final VoidCallback onDelete;
  final Function(int quantity, double price, String type) onQuantityChanged;
  CartItem({
    Key? key,
    required this.imgPath,
    required this.name,
    required this.price,
    required this.initialQuantity,
    required this.stock,
    required this.product_id,
    required this.onDelete,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    print("new cart item quantity");
    quantity = widget.initialQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              height: 80,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          SizedBox(
                            width: 120,
                            child: Text(
                              widget.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "₱${NumberFormat("#,##0.00", "en_US").format(widget.price * quantity)}"),
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: MaterialButton(
                              elevation: 0,
                              onPressed: () {
                                setState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                    print("button working");
                                    widget.onQuantityChanged(
                                        quantity, widget.price, 'decrease');
                                  }

                                  print("this is happening");
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
                            "${quantity}",
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

                                  if (quantity < widget.stock) {
                                    quantity++;
                                    print("button working");
                                    widget.onQuantityChanged(
                                        quantity, widget.price, 'increase');
                                  }

                                  print(
                                      "this is happening/nstock: ${widget.stock}");
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
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: widget.onDelete,
              child: Container(
                height: 80,
                width: 20,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(16)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
