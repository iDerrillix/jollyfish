import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:jollyfish/constants.dart";
import "package:jollyfish/widgets/cart_item.dart";

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text("My Cart"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                CartItem(
                  imgPath:
                      "https://assets.petco.com/petco/image/upload/f_auto,q_auto/koi-care-sheet",
                  name: "Koi Fish",
                  price: 420,
                  quantity: 1,
                ),
                CartItem(
                  imgPath:
                      "https://assets.petco.com/petco/image/upload/f_auto,q_auto/koi-care-sheet",
                  name: "Koi Fish",
                  price: 420,
                  quantity: 1,
                ),
                CartItem(
                  imgPath:
                      "https://assets.petco.com/petco/image/upload/f_auto,q_auto/koi-care-sheet",
                  name: "Koi Fish",
                  price: 420,
                  quantity: 1,
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 239, 242, 242),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal",
                              style: TextStyle(
                                color: minorText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "P999.99",
                              style: TextStyle(
                                color: minorText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "VAT",
                              style: TextStyle(
                                color: minorText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "P107.14",
                              style: TextStyle(
                                color: minorText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery Fee",
                              style: TextStyle(
                                color: minorText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "P50",
                              style: TextStyle(
                                color: minorText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                          "........................................................................................"),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                color: majorText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "P1157.13",
                              style: TextStyle(
                                color: majorText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Adjust the radius as needed
                  ),
                  elevation: 0,
                  height: 44,
                  minWidth: 400,
                  onPressed: () {
                    context.goNamed("Checkout");
                  },
                  color: accentColor,
                  textColor: Colors.white,
                  child: Text(
                    "Checkout",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
