import "package:flutter/material.dart";
import "package:jollyfish/constants.dart";

const successColor = Color(0xFFBBFFDA);
const warningColor = Color(0xFFFFFCBB);
const errorColor = Color(0xFFFFBBBB);

class NotifItem extends StatelessWidget {
  final String name;
  final String description;
  final String type;
  final String date;
  const NotifItem({
    Key? key,
    required this.name,
    required this.description,
    required this.type,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color;
    if (type == "Success") {
      color = successColor;
    } else if (type == "Warning") {
      color = warningColor;
    } else if (type == "Error") {
      color = errorColor;
    } else {
      color = Color.fromARGB(255, 255, 233, 199);
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF004365).withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 50,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.zero,
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: color,
                    ),
                    child: Center(
                      child: Icon(Icons.notification_add, color: accentColor),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: 190,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: majorText,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 12,
                            color: minorText,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: minorText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
