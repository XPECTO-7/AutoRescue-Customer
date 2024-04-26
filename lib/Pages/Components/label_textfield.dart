import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabelTextField
 extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData iconData;

  const LabelTextField
  (
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.iconData,
      required this.labelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontFamily: GoogleFonts.montserrat().fontFamily),
          labelText: labelText,
          labelStyle: TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontFamily: GoogleFonts.montserrat().fontFamily),
          suffixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(end: 12.0),
            child: GestureDetector(child: Icon(iconData)),
          ),
        ),
      ),
    );
  }
}
