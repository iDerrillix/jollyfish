import 'package:flutter/material.dart';
import 'package:jollyfish/constants.dart';

class Utilities {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? text, MaterialColor color) {
    if (text == null) return;

    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static showLoadingIndicator(context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: accentColor,
        ),
      ),
    );
  }

  static showLoadingIndicatorReworked(context, buildcontext) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          buildcontext = context;
          return Center(
            child: CircularProgressIndicator(
              color: accentColor,
            ),
          );
        });
  }
}
