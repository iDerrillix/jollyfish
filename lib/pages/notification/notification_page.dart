import "package:flutter/material.dart";
import "package:jollyfish/constants.dart";
import "package:jollyfish/widgets/notif_item.dart";

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text("Notifications"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: majorText),
            ),
            Column(
              children: [
                NotifItem(
                  name: "Order Delivered Successfully",
                  description: "Description Here",
                  type: "Success",
                ),
              ],
            ),
            Text(
              "Earlier",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: majorText),
            ),
            Column(
              children: [
                NotifItem(
                  name: "Order Delivered Successfully",
                  description: "Description Here",
                  type: "Error",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
