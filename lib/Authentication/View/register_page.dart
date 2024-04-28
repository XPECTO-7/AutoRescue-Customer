
import 'package:autorescue_customer/Colors/appcolor.dart';
import 'package:autorescue_customer/Components/myalert_box.dart';
import 'package:autorescue_customer/Components/mybutton.dart';
import 'package:autorescue_customer/Components/pwcontrol.dart';
import 'package:autorescue_customer/Components/reg_textfield.dart';
import 'package:autorescue_customer/Pages/View/bottom_nav_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final numberController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final numericRegex = RegExp(r'[0-9]');
  bool isLoading = false;

 void validation(BuildContext context) {
  if (emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      fullNameController.text.isNotEmpty &&
      confirmPasswordController.text.isNotEmpty) {
    if (EmailValidator.validate(emailController.text)) {
      if (passwordController.text.length >= 8 &&
          numericRegex.hasMatch(passwordController.text)) {
        if (passwordController.text == confirmPasswordController.text) {
          signUp(context); // Pass the context to signUp
        } else {
          //pw didnt match
          showDialog(
            context: context,
            builder: (context) => const MyAlertBox(
              message: "Password didn't match",
            ),
          );
        }
      } else {
        //Display pw didnt meet requirements
        showDialog(
          context: context,
          builder: (context) => const MyAlertBox(
            message: "Password didn't meet requirements",
          ),
        );
      }
    } else {
      //Display invalid email
      showDialog(
        context: context,
        builder: (context) => const MyAlertBox(
          message: "Enter a valid email address",
        ),
      );
    }
  } else {
    //Display fill all fields
    showDialog(
      context: context,
      builder: (context) => const MyAlertBox(
        message: "Fill all fields",
      ),
    );
  }
}


  void signUp(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      await FirebaseFirestore.instance
          .collection("USERS")
          .doc(emailController.text)
          .set({
        'Fullname': fullNameController.text.trim(),
        'Phone Number': numberController.text.trim(),
        'Email': emailController.text.trim(),
        "DlImage": "",
        'Complete':false
      });
     
      // Navigate to the homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavPage()),
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => MyAlertBox(
          message: e.code,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[950],
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.appPrimary),
              ),
            )
          : SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.person_outlined,
                              size: 40,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              'Create Your Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          child: Divider(
                            thickness: 0.7,
                            color: AppColors.appTertiary,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //F U L L N A M E
                        RegTextField(
                          controller: fullNameController,
                          hintText: 'Full name',
                          obscureText: false,
                          iconData: Icons.person,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: IntlPhoneField(
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.appPrimary),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                fillColor: Colors.black,
                                filled: true,
                                hintStyle: TextStyle(color: Colors.white),
                                hintText: 'Phone Number',
                                suffixIcon: Icon(Icons.phone)),
                            initialCountryCode: 'IN',
                            controller: numberController,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        //E M A I L
                        RegTextField(
                          controller: emailController,
                          hintText: 'Email',
                          obscureText: false,
                          iconData: Icons.mail,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //P A S S W O R D
                        MyPWTField(
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: true,
                        ),
                        //C O N F I R M P A S S W O R D
                        RegTextField(
                          controller: confirmPasswordController,
                          hintText: 'Confirm Password',
                          obscureText: true,
                          iconData: Icons.lock,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MyButton(
                          text: 'Sign Up',
                          onTap: () => validation(context),
                          textColor: Colors.black,
                          buttonColor: AppColors.appPrimary,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already a member ?',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            GestureDetector(
                              onTap: widget.showLoginPage,
                              child: const Text(
                                'Login',
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
    );
  }
}
