import 'package:autorescue_customer/Pages/Utils/alert_error.dart';
import 'package:autorescue_customer/Pages/Utils/sqauretile.dart';
import 'package:autorescue_customer/Pages/View/manage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class VehicleServiceSelection extends StatefulWidget {
  final String vehicleID;
  const VehicleServiceSelection({Key? key, required this.vehicleID}) : super(key: key);

  @override
  State<VehicleServiceSelection> createState() => _VehicleServiceSelectionState();
}

class _VehicleServiceSelectionState extends State<VehicleServiceSelection> {
  String selectedService = "";
  bool isLoading = false;

  void updateSelectedService(String service) {
    setState(() {
      if (selectedService == service) {
        // Deselect if the same service is clicked again
        selectedService = '';
      } else {
        // Select the clicked service
        selectedService = service;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Services",
          style: TextStyle(
            fontFamily: GoogleFonts.ubuntu().fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.white], // Adjust colors as per your preference
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Squaretile(
                      text: 'TYRE WORKS',
                      imagePath: 'lib/images/tyre.png',
                      isSelected: selectedService == 'TYRE WORKS',
                      onTap: () => updateSelectedService('TYRE WORKS'),
                    ),
                    const SizedBox(width: 7),
                    Squaretile(
                      text: 'MECHANICAL WORKS',
                      imagePath: 'lib/images/automotive.png',
                      isSelected: selectedService == 'Mechanical Service',
                      onTap: () => updateSelectedService('Mechanical Service'),
                    ),
                    const SizedBox(width: 7),
                    Squaretile(
                      text: 'EV CHARGING',
                      imagePath: 'lib/images/charging-station.png',
                      isSelected: selectedService == 'EV Charging service',
                      onTap: () => updateSelectedService('EV Charging service'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Squaretile(
                      text: 'FUEL DELIVERY',
                      imagePath: 'lib/images/fuel.png',
                      isSelected: selectedService == 'Fuel Delivery Service',
                      onTap: () => updateSelectedService('Fuel Delivery Service'),
                    ),
                    const SizedBox(width: 7),
                    Squaretile(
                      text: 'TOWING',
                      imagePath: 'lib/images/tow-truck.png',
                      isSelected: selectedService == 'Emergency Towing Service',
                      onTap: () => updateSelectedService('Emergency Towing Service'),
                    ),
                    const SizedBox(width: 7),
                    Squaretile(
                      text: 'KEY LOCKOUT',
                      imagePath: 'lib/images/key.png',
                      isSelected: selectedService == 'KEY LOCKOUT',
                      onTap: () => updateSelectedService('KEY LOCKOUT'),
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19.50),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      // Fetch user data from Firestore
                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser != null) {
                        final userData = await FirebaseFirestore.instance
                            .collection("USERS")
                            .doc(currentUser.email!)
                            .get();
                        final isComplete = userData.data()?['Complete'];

                        // Check if the user data is complete
                        if (userData.data()?['Complete'] == true) {
                          // Check if a service and a vehicle are selected
                          if (selectedService.isNotEmpty) {
                            // Proceed to request service
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManagePage(
                                  servicetype: selectedService,
                                  vehicleID: widget.vehicleID,
                                  userEmail: currentUser.email!,
                                ),
                              ),
                            );
                          } else {
                            // Show alert if service or vehicle is not selected
                            CustomAlert.show(
                              context: context,
                              title: "Missing Information",
                              message: "Please select a service and a vehicle.",
                              messageTextColor: Colors.red,
                              backgroundColor: Colors.white,
                              buttonColor: Colors.grey,
                            );
                          }
                        } else {
                          // Show alert if user data is not complete
                          CustomAlert.show(
                            context: context,
                            title: "Incomplete Profile",
                            message: "Upload your Driving License",
                            messageTextColor: Colors.red,
                            backgroundColor: Colors.white,
                            buttonColor: Colors.grey,
                          );
                        }
                      } else {
                        // Handle the case where currentUser is null
                        print("Current user is null.");
                      }

                      setState(() {
                        isLoading = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'REQUEST SERVICE',
                            style: TextStyle(
                              fontFamily: GoogleFonts.ubuntu().fontFamily,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8), // Space between text and icon
                          const Icon(
                            FontAwesomeIcons.chevronRight,
                            size: 26,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
