import 'package:autorescue_customer/Colors/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MyAlertBox extends StatelessWidget {
  final String? message;

  const MyAlertBox({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
    backgroundColor: Colors.black,
    title:Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         if (message != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                message!,
                textAlign: TextAlign.center,
                style:  TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontFamily: GoogleFonts.montserrat().fontFamily
                ),
              ),
            ),
      ],
    ) ,
  actions: [
    MaterialButton(
      
      onPressed: () {
      Navigator.pop(context);
    },
    child:const  Text("OK",style: TextStyle(fontSize:18,color: AppColors.appPrimary,fontWeight: FontWeight.bold),),
    )
  ],
   );
  }
}