import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NormalTextField extends StatelessWidget {
  final String hintText;
  final IconData icondata;
  final TextEditingController controller;

   const NormalTextField({required this.controller,
   required this.hintText,
   required this.icondata,
   super.key});

   @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: GoogleFonts.montserrat().fontFamily),
          
          suffixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(end: 12.0),
            child: GestureDetector(child: Icon(icondata)),
          ),
        ),
      ),
    );
  }
}
