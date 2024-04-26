import 'package:autorescue_customer/Colors/appcolor.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const PasswordTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required Function(dynamic password) onChanged,
  }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
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
          hintStyle: const TextStyle(color: Colors.white),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: _obscureText ? Colors.grey : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
