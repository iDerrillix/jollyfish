import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:jollyfish/constants.dart";
import "package:jollyfish/models/shopping_cart_model.dart";
import "package:jollyfish/utilities.dart";
import "package:jollyfish/widgets/cart_item.dart";
import "package:jollyfish/widgets/product_tile.dart";
import "package:provider/provider.dart";

class CartPage extends StatefulWidget {
  final bool? reload;
  const CartPage({Key? key, this.reload}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalPrice = 0;
  // static late Future<List<Map<String, dynamic>>> shopping_cart;
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late ShoppingCartModel cart;

  @override
  void initState() {
    super.initState();
    cart = context.read<ShoppingCartModel>();
    cart.addListener(_updateTotalPrice); // Listen for changes to the cart
    _updateTotalPrice(); // Call the method initially to set the totalPrice
  }

  @override
  void didChangeDependencies() {
    setState(() {});
    super.didChangeDependencies();
    setState(() {});
  }

  void _updateTotalPrice() {
    final cart = context.read<ShoppingCartModel>();
    setState(() {
      totalPrice = cart.getTotalPrice();
    });
  }

  @override
  void dispose() {
    cart.removeListener(
        _updateTotalPrice); // Remove the listener to prevent memory leaks
    super.dispose();
  }

  void deleteCartItem(String product_id) async {}

  @override
  Widget build(BuildContext context) {
    totalPrice = totalPrice;
    setState(() {});
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
            //
            Consumer<ShoppingCartModel>(
              builder: (context, cartModel, child) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: cartModel.cart.length,
                    itemBuilder: (context, index) {
                      final item = cartModel.cart[index];
                      return CartItem(
                        imgPath: item['imagePath'],
                        name: item['name'],
                        price: item['price'].toDouble(),
                        initialQuantity: 1,
                        stock: item['stock'].toInt(),
                        product_id: item['product_id'],
                        onDelete: () {
                          final cart = context.read<ShoppingCartModel>();

                          cart.deleteCartItem(item['product_id']);
                        },
                        onQuantityChanged: (quantity, price, type) {
                          // Update quantity in the shopping cart model
                          final cart = context.read<ShoppingCartModel>();
                          cart.updateQuantity(item['product_id'], quantity);
                          // Adjust the total price
                          setState(() {});
                        },
                      );
                    },
                  ),
                );
              },
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
                              "P${totalPrice}",
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
                    final _cart = context.read<ShoppingCartModel>();
                    if (_cart.cart.isEmpty) {
                      Utilities.showSnackBar("Your cart is empty", Colors.red);
                    } else {
                      context.goNamed("Checkout");
                    }
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
