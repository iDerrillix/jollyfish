import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jollyfish/admin/admin_navigation_menu.dart';
import 'package:jollyfish/constants.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Stream<int> _numberOfPendingOrdersStream = Stream.empty();
  late Stream<int> _numberOfOrdersAwaitingPickupStream = Stream.empty();
  late Stream<double> _earningsForTodayStream = Stream.empty();
  late Stream<int> _completedOrdersCountStream = Stream.empty();

  @override
  void initState() {
    super.initState();
    _numberOfPendingOrdersStream = getNumberOfPendingOrders();
    _numberOfOrdersAwaitingPickupStream = getNumberOfOrdersAwaitingPickup();
    _earningsForTodayStream = getEarningsForToday();
    _completedOrdersCountStream = getCompletedOrdersCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              context.goNamed('Login');
            },
            child: Icon(Icons.logout),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "New Orders",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            StreamBuilder<int>(
                              stream: _numberOfPendingOrdersStream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  int numberOfPendingOrders =
                                      snapshot.data ?? 0;
                                  return Text(
                                    "$numberOfPendingOrders",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              },
                            ),
                            Text(
                              "Orders to be processed",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Deliveries",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            StreamBuilder<int>(
                              stream: _numberOfOrdersAwaitingPickupStream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  int numberOfOrdersAwaitingPickup =
                                      snapshot.data ?? 0;
                                  return Text(
                                    "$numberOfOrdersAwaitingPickup",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              },
                            ),
                            Text(
                              "Orders to be delivered",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Earnings",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            StreamBuilder<double>(
                              stream: _earningsForTodayStream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  double earningsForToday = snapshot.data ?? 0;
                                  return Text(
                                    "$earningsForToday",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              },
                            ),
                            Text(
                              "Earnings for today",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Completed Orders",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            StreamBuilder<int>(
                              stream: _completedOrdersCountStream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  int completedOrders = snapshot.data ?? 0;
                                  return Text(
                                    "$completedOrders",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              },
                            ),
                            Text(
                              "Lifetime completed orders",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Container(
                  height: 150,
                  width: 393,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      "https://e0.pxfuel.com/wallpapers/582/390/desktop-wallpaper-painted-mountain-landscape-sunset-vector-art-landscape-vector-art-landscape-vector-background-sunset-vector-background.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Orders",
                    style: TextStyle(
                      color: majorText,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/orders');
                    },
                    child: Text(
                      "View All",
                      style: TextStyle(
                        color: minorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('status', whereIn: [
                      'Processing',
                      'Verifying'
                    ]) // Order by timestamp in descending order (most recent first)
                    .limit(20) // Limit the result to 20 documents
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No recent orders found.');
                  }

                  List<DocumentSnapshot> orders = snapshot.data!.docs;

                  return Column(
                    children: orders
                        .map((order) => OrderContainer(
                              order_id: order.id,
                              date: formatDate(order['ordered_at']),
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '';

    DateTime date = timestamp.toDate();
    return DateFormat('dd/MM/yyyy hh:mm').format(date);
  }

  Stream<int> getNumberOfPendingOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('status', whereIn: ['Processing', 'Verifying'])
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Stream<int> getNumberOfOrdersAwaitingPickup() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'Awaiting Courier Pickup')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Stream<double> getEarningsForToday() {
    DateTime now = DateTime.now();
    DateTime startOfDay =
        DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0); // Start of today
    DateTime endOfDay = DateTime(
        now.year, now.month, now.day, 23, 59, 59, 999, 999); // End of today

    return FirebaseFirestore.instance
        .collection('orders')
        .where('ordered_at', isGreaterThanOrEqualTo: startOfDay)
        .where('ordered_at', isLessThanOrEqualTo: endOfDay)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .fold<double>(0, (total, doc) => total + (doc['total'] ?? 0.0)));
  }

  Stream<int> getCompletedOrdersCount() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('status', whereIn: ['Order handed to courier', 'Completed'])
        .snapshots()
        .map((snapshot) => snapshot.size);
  }
}

class OrderContainer extends StatelessWidget {
  final String order_id;
  final String date;
  const OrderContainer({
    Key? key,
    required this.order_id,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 234, 240, 249),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Color(0xffFFDE9F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order ID",
                      style: TextStyle(
                        color: minorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      order_id,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: majorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color: minorText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
