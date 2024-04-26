
import 'package:autorescue_customer/Authentication/Controller/main_page.dart';
import 'package:autorescue_customer/Pages/View/account.dart';
import 'package:autorescue_customer/Pages/View/bottom_nav_page.dart';
import 'package:autorescue_customer/Theme/dark_theme.dart';
import 'package:autorescue_customer/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Geolocator.checkPermission();
    await Geolocator.requestPermission();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darktheme,
      home: const MainPage(),
      routes: {
        '/HomePage': (context) => const BottomNavPage(),
        '/AccountPage': (context) => const AccountPage(),
      },
    );
  }
}
