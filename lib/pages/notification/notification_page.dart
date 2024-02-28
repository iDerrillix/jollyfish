import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:jollyfish/constants.dart";
import "package:jollyfish/widgets/notif_item.dart";

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text("Notifications"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('notifications')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Text('No notifications');
                }

                // Define lists for recent and earlier notifications
                List<Widget> recentNotifications = [];
                List<Widget> earlierNotifications = [];

                // Get the current time
                DateTime now = DateTime.now();

                // Iterate over the notifications
                snapshot.data!.docs.forEach((notificationDoc) {
                  // Extract notification data
                  Map<String, dynamic>? notificationData =
                      notificationDoc.data();
                  if (notificationData != null) {
                    String title = notificationData['heading'] ?? '';
                    String message = notificationData['body'] ?? '';
                    String myDate = "test";

                    if (notificationData['timestamp'] != null) {
                      Timestamp t = notificationData['timestamp'] as Timestamp;
                      DateTime date = t.toDate();
                      myDate = DateFormat('MM-dd hh:mm').format(date);
                    }

                    // Extract timestamp and convert it to DateTime
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(
                        (notificationData['timestamp'] as Timestamp)
                            .millisecondsSinceEpoch);

                    // Create a widget for the notification
                    Widget notificationWidget = NotifItem(
                      name: title,
                      description: message,
                      date: myDate,
                      type: "notif",
                    );

                    // Check if the notification is recent or earlier
                    if (now.difference(date).inHours <= 24) {
                      recentNotifications.add(notificationWidget);
                    } else {
                      earlierNotifications.add(notificationWidget);
                    }
                  }
                });

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (recentNotifications.isNotEmpty) ...[
                      Text(
                        "Recent",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: majorText),
                      ),
                      Column(
                        children: recentNotifications,
                      ),
                    ],
                    if (earlierNotifications.isNotEmpty) ...[
                      Text(
                        "Earlier",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: majorText),
                      ),
                      Column(
                        children: earlierNotifications,
                      ),
                    ],
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
