import "package:flutter/material.dart";
import "package:jollyfish/constants.dart";
import "package:jollyfish/widgets/notif_item.dart";

class ProfileButton extends StatelessWidget {
  final Color iconColor;
  final String name;
  final Icon icon;
  final VoidCallback action;
  const ProfileButton({
    Key? key,
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: icon,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: majorText),
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
