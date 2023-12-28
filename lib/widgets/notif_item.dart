import "package:flutter/material.dart";
import "package:jollyfish/constants.dart";

const successColor = Color(0xFFBBFFDA);
const warningColor = Color(0xFFFFFCBB);
const errorColor = Color(0xFFFFBBBB);

class NotifItem extends StatelessWidget {
  final String name;
  final String description;
  final String type;
  const NotifItem({
    Key? key,
    required this.name,
    required this.description,
    required this.type,
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
      color = Colors.amber;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        height: 64,
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
                  child: Icon(Icons.warning, color: Colors.white),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
