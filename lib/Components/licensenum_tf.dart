import 'package:autorescue_customer/Colors/appcolor.dart';
import 'package:flutter/material.dart';

class LicenseTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData iconData;

  const LicenseTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.iconData,
  }) : super(key: key);

  @override
  _LicenseTextFieldState createState() => _LicenseTextFieldState();
}

class _LicenseTextFieldState extends State<LicenseTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: TextInputType.number, // Ensure only numeric input
            maxLength: widget.hintText == 'Driving License Number' ? 16 : null,
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
              hintStyle: const TextStyle(color: Colors.white),
              suffixIcon: Icon(widget.iconData),
            ),
          ),
        ],
      ),
    );
  }
}
