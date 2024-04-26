import 'package:flutter/material.dart';

class dAlert extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final String routeName;

  const dAlert({
    Key? key,
    required this.title,
    required this.content,
    required this.buttonText,
    required this.routeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, routeName);
                  },
                  child: Text(buttonText),
                ),
              ],
            );
          },
        );
      },
      child: const Text('Show Alert'),
    );
  }
}
