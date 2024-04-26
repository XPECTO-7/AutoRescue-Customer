import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CustomAlert {
  static void show({
    required BuildContext context,
    String title = "Alert",
    String message = "",
    Color messageTextColor = Colors.black,
    Color backgroundColor = Colors.white,
    Color buttonColor = Colors.blue,
  }) {
    Alert(
      context: context,
      type: AlertType.error,
      title: title,
      desc: message,
      style: AlertStyle(
        descStyle: TextStyle(color: messageTextColor),
        overlayColor: backgroundColor.withOpacity(0.7),
        backgroundColor: backgroundColor,
        isCloseButton: false,
        animationDuration: Duration(milliseconds: 500),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
          color: buttonColor,
        )
      ],
    ).show();
  }
}
