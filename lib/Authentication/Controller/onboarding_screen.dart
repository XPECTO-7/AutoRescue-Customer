
import 'package:autorescue_customer/Authentication/Controller/auth_page.dart';
import 'package:autorescue_customer/Authentication/Controller/onboarding_data.dart';
import 'package:autorescue_customer/Colors/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = OnboardingData();
  final pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          body(),
          buildDots(),
          button(),
        ],
      ),
    );
  }

  Widget body() {
    return Expanded(
      child: Center(
        child: PageView.builder(
          onPageChanged: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(controller.items[currentIndex].image),
                  const SizedBox(height: 15),
                  Text(
                    controller.items[currentIndex].title,
                    style:  TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold,fontFamily: GoogleFonts.ubuntu().fontFamily),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      controller.items[currentIndex].description,
                      style:  TextStyle(color: Colors.grey, fontSize: 16,fontFamily: GoogleFonts.ubuntu().fontFamily),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        controller.items.length,
        (index) => AnimatedContainer(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: currentIndex == index ? AppColors.appPrimary : Colors.grey,
          ),
          height: 7,
          width: currentIndex == index ? 30 : 7,
          duration: const Duration(milliseconds: 700),
        ),
      ),
    );
  }

  Widget button() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColors.appPrimary,
      ),
      child: TextButton(
        onPressed: () {
          if (currentIndex == controller.items.length - 1) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const AuthPage(),
              ),
            );
          } else {
            setState(() {
              currentIndex++;
            });
          }
        },
        child: Text(
          currentIndex == controller.items.length - 1 ? "Get started" : "Continue",
          style:  TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold,fontFamily: GoogleFonts.ubuntu().fontFamily),
        ),
      ),
    );
  }
}