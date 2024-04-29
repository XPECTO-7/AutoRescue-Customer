import 'package:autorescue_customer/Colors/appcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColors.appTertiary,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email, color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 50, // Adjust as needed
                width: double.infinity, // Takes up full width
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: _emailController.text.trim(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Password reset email sent!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  },
                  child: const Text('Send Password Reset Email'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      // Makes the button rectangular
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.appTertiary,
    );
  }
}
