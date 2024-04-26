import 'package:autorescue_customer/Colors/appcolor.dart';
import 'package:flutter/material.dart';

class MyPWTField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  MyPWTField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});
  onPasswordChanged(String password) {}

  @override
  State<MyPWTField> createState() => _MyPWTFieldState();
}

class _MyPWTFieldState extends State<MyPWTField> {
  bool _isVisible = false;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
            ),
            child: TextField(
              style: const TextStyle(),
              onChanged: (password) => onPasswordChanged(password),
              controller: widget.controller,
              obscureText: !_isVisible,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      },
                      icon: _isVisible
                          ? const Icon(
                              Icons.visibility,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            )),
                  enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: const BorderSide(color: AppColors.appPrimary)),
                  filled: true,
                  fillColor: Colors.black,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const SizedBox(
              width: 35,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  color: _isPasswordEightCharacters
                      ? AppColors.appPrimary
                      : Colors.transparent,
                  border: _isPasswordEightCharacters
                      ? Border.all(color: Colors.transparent)
                      : Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: Icon(
                  Icons.check,
                  color:
                      _isPasswordEightCharacters ? Colors.black : Colors.white,
                  size: 15,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Contains at least 8 characters',
              style: TextStyle(),
            )
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            const SizedBox(
              width: 35,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  color:
                      _hasPasswordOneNumber ? AppColors.appPrimary : Colors.transparent,
                  border: _hasPasswordOneNumber
                      ? Border.all(color: Colors.transparent)
                      : Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: Icon(
                  Icons.check,
                  color: _hasPasswordOneNumber ? Colors.black : Colors.white,
                  size: 15,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text('Contains at least 1 number', style: TextStyle()),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8) _isPasswordEightCharacters = true;
      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) _hasPasswordOneNumber = true;
    });
  }
}
