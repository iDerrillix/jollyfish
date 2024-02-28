import "package:flutter/material.dart";
import "package:jollyfish/constants.dart";

class CheckoutDetails extends StatelessWidget {
  final String heading;
  final String body;
  final Color iconBgColor;
  final Icon icon;
  final VoidCallback action;
  const CheckoutDetails(
      {Key? key,
      required this.heading,
      required this.body,
      required this.iconBgColor,
      required this.icon,
      required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
        ),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: iconBgColor,
                    ),
                    child: Center(
                      child: icon,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        heading,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: majorText,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        body,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: minorText,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.chevron_right,
                color: minorText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
