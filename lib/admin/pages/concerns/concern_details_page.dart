import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/models/user_model.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/input_button.dart';

class ConcernDetailsPage extends StatefulWidget {
  final String concern_id;
  const ConcernDetailsPage({Key? key, required this.concern_id})
      : super(key: key);

  @override
  _ConcernDetailsPageState createState() => _ConcernDetailsPageState();
}

class _ConcernDetailsPageState extends State<ConcernDetailsPage> {
  void updateStatus(String status) {
    try {
      CollectionReference concerns = FirebaseFirestore.instance.collection(
        'reports',
      );
      concerns.doc(widget.concern_id).update({
        'status': status,
      });
      Utilities.showSnackBar("Successfully updated status", Colors.green);
      setState(() {});
    } catch (ex) {
      Utilities.showSnackBar(
          "An error occured upon updating status of ticket $ex", Colors.red);
    }
    if (status == 'Resolved') {
      Navigator.of(context).pop();
    }
  }

  Future<Map<String, dynamic>> getConcernDetails(String concern_id) async {
    Map<String, dynamic> concernDetails = {};

    try {
      DocumentSnapshot concernSnapshot = await FirebaseFirestore.instance
          .collection('reports')
          .doc(concern_id)
          .get();
      if (concernSnapshot.exists) {
        concernDetails = concernSnapshot.data() as Map<String, dynamic>;
      } else {
        print("Concern with ID $concern_id does not exist");
      }
    } catch (ex) {
      print("Error fetching concern details $ex");
    }

    return concernDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Concern Details"),
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(Icons.chevron_left),
        ),
      ),
      body: FutureBuilder(
        future: getConcernDetails(widget.concern_id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> concernDetails = snapshot.data!;

            print(concernDetails);

            print(widget.concern_id);

            String myDate = "test";

            if (concernDetails['ordered_at'] != null) {
              Timestamp t = concernDetails['ordered_at'] as Timestamp;
              DateTime date = t.toDate();
              myDate = DateFormat('dd/MM/yyyy,hh:mm').format(date);
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future:
                          UserModel.getUserById(concernDetails['reported_by']),
                      builder: (context,
                          AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        String userName =
                            snapshot.data?['full_name'] ?? 'Unknown';
                        return Text(
                          userName,
                          style: TextStyle(
                            color: majorText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                    Text(
                      concernDetails['contact_number'],
                      style: TextStyle(
                        color: majorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      concernDetails['email_address'],
                      style: TextStyle(
                        color: majorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ticket No.",
                          style: TextStyle(
                            color: majorText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          concernDetails['concern'],
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      concernDetails['order_number'],
                      style: TextStyle(
                        color: majorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Details",
                      style: TextStyle(
                        color: majorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      concernDetails['details'],
                      style: TextStyle(
                        color: majorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          useSafeArea: true,
                          context: context,
                          builder: (context) {
                            return Center(
                              child: SizedBox(
                                width: 360,
                                child: Image.network(
                                  concernDetails['attached_image'],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        color: majorText,
                        child: Image.network(
                          concernDetails['attached_image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    (concernDetails['status'] == 'Unresolved')
                        ? InputButton(
                            label: "RESOLVE",
                            function: () {
                              updateStatus("Resolved");
                            },
                            large: false)
                        : InputButton(
                            label: "REOPEN TICKET",
                            function: () {
                              updateStatus("Unresolved");
                            },
                            large: false)
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
