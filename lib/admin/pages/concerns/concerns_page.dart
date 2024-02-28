import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/models/user_model.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/input_button.dart';
import 'package:jollyfish/widgets/input_field.dart';

class ConcernsPage extends StatefulWidget {
  const ConcernsPage({Key? key}) : super(key: key);

  @override
  _ConcernsPageState createState() => _ConcernsPageState();
}

class _ConcernsPageState extends State<ConcernsPage> {
  final _searchController = TextEditingController();

  Future<bool> doesConcernExist(String concernId) async {
    DocumentSnapshot reportSnapshot = await FirebaseFirestore.instance
        .collection('reports')
        .doc(concernId)
        .get();

    return reportSnapshot.exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Concerns"),
        actions: [
          TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          InputField(
                            placeholder: "Ticket ID",
                            inputType: "text",
                            controller: _searchController,
                            label: "Ticket ID",
                          ),
                          InputButton(
                              label: "Search",
                              function: () async {
                                if (_searchController.text.isEmpty) {
                                  Utilities.showSnackBar(
                                      "Provide the ticket id first",
                                      Colors.red);
                                } else {
                                  String ticketId =
                                      _searchController.text.trim();
                                  bool ticketIdExists =
                                      await doesConcernExist(ticketId);
                                  if (ticketIdExists) {
                                    context.go('/concerns/details/$ticketId');
                                  } else {
                                    Utilities.showSnackBar(
                                        "Order ID not found", Colors.red);
                                  }
                                }
                              },
                              large: true),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.search)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('reports')
                .where('status', isEqualTo: 'Unresolved')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final concerns = snapshot.data?.docs.toList();
                return Column(
                  children: concerns!
                      .map((concern) => buildConcernWidget(concern))
                      .toList(),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildConcernWidget(DocumentSnapshot concern) {
    String myDate = "test";
    if (concern['placed_at'] != null) {
      Timestamp t = concern['placed_at'] as Timestamp;
      DateTime date = t.toDate();
      myDate = DateFormat('dd/MM/yyyy,hh:mm').format(date);
    }

    return FutureBuilder(
      future: UserModel.getUserById(concern['reported_by']),
      builder: (context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        String userName = snapshot.data?['full_name'] ?? 'Unknown';
        return GestureDetector(
          onTap: () => context.go('/concerns/details/${concern.id}'),
          child: ConcernContainer(
            name: userName,
            concern: concern['concern'],
            date: myDate,
            order_id: concern['order_number'],
          ),
        );
      },
    );
  }
}

class ConcernContainer extends StatelessWidget {
  final String name;
  final String concern;
  final String date;
  final String order_id;
  const ConcernContainer(
      {Key? key,
      required this.name,
      required this.concern,
      required this.date,
      required this.order_id})
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 180,
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
                      concern,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        color: majorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      order_id,
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
