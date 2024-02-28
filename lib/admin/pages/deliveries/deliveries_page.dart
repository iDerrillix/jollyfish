import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jollyfish/constants.dart';

class DeliveriesPage extends StatefulWidget {
  const DeliveriesPage({Key? key}) : super(key: key);

  @override
  _DeliveriesPageState createState() => _DeliveriesPageState();
}

class _DeliveriesPageState extends State<DeliveriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deliveries"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('status', isEqualTo: 'Awaiting Courier Pickup')
                  .snapshots(),
              builder: (context, snapshot) {
                List<Widget> deliveryWidgets = [];

                if (snapshot.hasData) {
                  final deliveries = snapshot.data?.docs.toList();

                  for (var delivery in deliveries!) {
                    String myDate = "test";

                    if (delivery['ordered_at'] != null) {
                      Timestamp t = delivery['ordered_at'] as Timestamp;
                      DateTime date = t.toDate();
                      myDate = DateFormat('dd/MM/yyyy,hh:mm').format(date);
                    }

                    final deliveryWidget = GestureDetector(
                      onTap: () =>
                          context.go('/deliveries/details/${delivery.id}'),
                      child: DeliveriesContainer(
                        name: delivery['recipient_name'],
                        address: delivery['recipient_contact'],
                        date: myDate,
                        contact_no:
                            "${delivery['address1']}, ${delivery['barangay']}, ${delivery['city']}, ${delivery['province']}",
                      ),
                    );

                    deliveryWidgets.add(deliveryWidget);
                  }
                }
                return Column(
                  children: deliveryWidgets,
                );
              }),
        ),
      ),
    );
  }
}

class DeliveriesContainer extends StatelessWidget {
  final String name;
  final String address;
  final String date;
  final String contact_no;
  const DeliveriesContainer(
      {Key? key,
      required this.name,
      required this.address,
      required this.date,
      required this.contact_no})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4, bottom: 4),
      child: Container(
        width: double.infinity,
        height: 63,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color.fromARGB(255, 234, 240, 249),
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: majorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      address,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: minorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        color: minorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      contact_no,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: minorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
