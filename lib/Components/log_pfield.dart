import 'package:autorescue_customer/Colors/appcolor.dart';
import 'package:flutter/material.dart';

class LogPField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData iconData;

  const LogPField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.iconData,
  }) : super(key: key);

  @override
  _LogPFieldState createState() => _LogPFieldState();
}

class _LogPFieldState extends State<LogPField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.appPrimary),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          fillColor: Colors.black,
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Colors.white,
          ),
          contentPadding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
          suffixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(end: 12.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            ),
          ),
        ),
      ),
    );
  }
}
