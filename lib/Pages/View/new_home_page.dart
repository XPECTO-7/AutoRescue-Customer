import 'package:autorescue_customer/Colors/appcolor.dart';
import 'package:autorescue_customer/Pages/Utils/sqauretile.dart';
import 'package:autorescue_customer/Pages/View/service_selection_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  String selectedService = "";
  void selectService(String vehicleId) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return VehicleServiceSelection(
          vehicleID: vehicleId,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('USERS')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('VEHICLES')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.appPrimary,
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          List list = snapshot.data!.docs;
          List<Widget> vehicleLists = [];
          for (var value in list) {
            vehicleLists.add(GestureDetector(
              onTap: () {
                selectService(value["RegistrationNumber"]);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.appDarktheme,
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 200,
                        width: 200,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    value["vehicleImageURL"],
                                  ),
                                  fit: BoxFit.cover)),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(value["Manufacturer"]),
                        const Text(" "),
                        Text(value["VehicleName"]),
                      ],
                    ),
                    Text(value["Year"]),
                    Text(value["FuelType"]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Register Number : "),
                        Text(value["RegistrationNumber"]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Kilometers : "),
                        Text(value["Kilometers"]),
                      ],
                    ),
                  ],
                ),
              ),
            ));
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 80,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/images/cserv.png',
                    color: AppColors.appPrimary,
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    'AutoRescue',
                    style: TextStyle(
                      fontFamily: GoogleFonts.ubuntu().fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Select your vehicle for service",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CarouselSlider(
                      items: vehicleLists,
                      options: CarouselOptions(
                        height: 400,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: false,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        scrollDirection: Axis.horizontal,
                      ))
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.appPrimary,
              ),
            ),
          );
        }
      },
    );
  }
}
