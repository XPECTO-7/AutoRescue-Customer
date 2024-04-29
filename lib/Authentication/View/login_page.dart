
import 'package:autorescue_customer/Authentication/View/forgot_password_page.dart';
import 'package:autorescue_customer/Colors/appcolor.dart';
import 'package:autorescue_customer/Components/log_pfield.dart';
import 'package:autorescue_customer/Components/log_textfield.dart';
import 'package:autorescue_customer/Components/myalert_box.dart';
import 'package:autorescue_customer/Components/mybutton.dart';
import 'package:autorescue_customer/Pages/View/bottom_nav_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

void signIn() async {
  setState(() {
    isLoading = true; // Assuming isLoading is a boolean variable to track loading state
  });

  try {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // Navigate to homepage if sign-in is successful
    if (userCredential.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavPage()), 
      );
    }
  } on FirebaseAuthException catch (e) {
    // If there's an error signing in
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(e.message ?? "An error occurred"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              setState(() {
                isLoading = false; // Set isLoading to false to remove the loading indicator
              });
            },
            child: const Text("OK"),
          ),
        ],
      ),
    ).then((_) {
      // After the dialog is closed, navigate back to the login page
      // Navigator.pop(context); // Remove this line as it navigates back immediately after showing the dialog
    });
  } finally {
    // You can optionally perform any cleanup here
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.appPrimary),
                ),
              )
            : SingleChildScrollView(
                child: SafeArea(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'lib/images/cserv.png',
                              color: Colors.white,
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'AutoRescue',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: GoogleFonts.ubuntu().fontFamily,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'User ',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontFamily:
                                              GoogleFonts.ubuntu().fontFamily,
                                          color: AppColors.appPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: Transform.translate(
                                          offset: const Offset(0, -8),
                                          child: const Text(
                                            '®', // Replace '®' with your company symbol
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            LogTextField(
                              controller: emailController,
                              hintText: 'Email',
                              obscureText: false,
                              iconData: Icons.mail,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            LogPField(
                              controller: passwordController,
                              hintText: 'Password',
                              obscureText: true,
                              iconData: Icons.remove_red_eye_rounded,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return  ForgotPasswordPage();
                                      }));
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            GestureDetector(
                              onTap: signIn,
                              child: MyButton(
                                buttonColor: AppColors.appPrimary,
                                textColor: Colors.black,
                                text: 'Sign In',
                                onTap: () {
                                  if (emailController.text.isNotEmpty &&
                                      passwordController.text.isNotEmpty) {
                                    signIn();
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => const MyAlertBox(
                                              message: 'Fill all the Fields',
                                            ));
                                  }
                                },
                              ),
                            ),
                           
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Not a member ?',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                GestureDetector(
                                  onTap: widget.showRegisterPage,
                                  child: const Text(
                                    'Create an account!',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors.appPrimary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ));
  }
}
