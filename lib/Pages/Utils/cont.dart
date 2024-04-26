import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyContainer extends StatelessWidget {
  final String text;
  const MyContainer({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Container(
        width: 300,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black, 
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.white70),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: GoogleFonts.ubuntu().fontFamily,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
