import 'package:autorescue_customer/Colors/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegNumField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final IconData iconData;

  const RegNumField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ], //
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(const Radius.circular(8)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.appPrimary),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          fillColor: Colors.black,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          suffixIcon: Icon(iconData),
        ),
      ),
    );
  }
}
