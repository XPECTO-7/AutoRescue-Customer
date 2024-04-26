import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomepageLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/loading_animation.json', // Path to your Lottie animation file
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      ),
    );
  }
}
