import "package:flutter/material.dart";
import "package:jollyfish/constants.dart";
import "package:jollyfish/widgets/notif_item.dart";

class OrderSummary extends StatelessWidget {
  final String orderNum;
  final String status;
  final String date;
  final double total;
  final VoidCallback action;
  const OrderSummary(
      {Key? key,
      required this.orderNum,
      required this.status,
      required this.date,
      required this.total,
      required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF004365).withOpacity(0.08),
                spreadRadius: 0,
                blurRadius: 50,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          height: 96,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        size: 34,
                        Icons.shopping_basket_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order No. 696969",
                        style: TextStyle(
                          color: majorText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: 120,
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(44),
                          border: Border.all(
                            color: Color(0xFF42FF00),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Completed",
                            style: TextStyle(
                              color: Color(0xFF42FF00),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "12-31-2023",
                    style: TextStyle(
                      color: minorText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "P999.99",
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
