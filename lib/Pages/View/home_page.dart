import 'package:autorescue_customer/Colors/appcolor.dart';
import 'package:autorescue_customer/Pages/Components/custom_button.dart';
import 'package:autorescue_customer/Pages/Utils/alert_error.dart';
import 'package:autorescue_customer/Pages/Utils/sqauretile.dart';
import 'package:autorescue_customer/Pages/View/manage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  bool isValid = false;
  bool isTrue = false;
  String selectedVehicleName = "", selectedService = "", lat = "", long = "";
  Position? position;
  String? dlImageUrl;
  String userEmail = "";
  String vehicleID = "";
  late TextEditingController expchController;
  late TextEditingController cuLockController;

  @override
  void initState() {
    super.initState();
    selectedService = '';
    getAddedVehicles();
    expchController = TextEditingController();
    cuLockController = TextEditingController();
  }

  @override
  void dispose() {
    expchController.dispose();
    cuLockController.dispose();
    super.dispose();
  }

  void setLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    if (position != null) {
      setState(() {
        lat = position!.latitude.toString();
        long = position!.longitude.toString();
      });
    }
  }

  void getAddedVehicles() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    setState(() {
      userEmail = currentUser.email!;
    });
    final vehicleRef = FirebaseFirestore.instance
        .collection('USERS')
        .doc(currentUser.email)
        .collection('VEHICLES');

    final querySnapshot = await vehicleRef.get();

    final List<Map<String, dynamic>> vehicles = [];
    querySnapshot.docs.forEach((doc) {
      final data = doc.data();
      vehicles.add({
        'vehicleName': data['VehicleName'],
        'manufacturer': data['Manufacturer'],
        'registrationNumber': data['RegistrationNumber'],
        'year': data['Year'],
        'kilometers': data['Kilometers'],
        'fueltype': data['FuelType'],
        'vehicleImageURL': data['vehicleImageURL'],
        'vehicleRCImageURL': data['vehicleRCImageURL'],
      });
    });

    setState(() {
      addedVehicles = vehicles;
    });
  }

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

  List<Map<String, dynamic>> addedVehicles = [];
  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomButton(
                        borderRadius: 2,
                        text: 'Select Service',
                        fsize: 16,
                        iconsize: 16,
                        onPressed: () {},
                        textColor: Colors.black,
                        buttonColor: AppColors.appPrimary,
                        suffixIcon: FontAwesomeIcons.wrench,
                        h: 34,
                      ),
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
                            onTap: () =>
                                updateSelectedService('Mechanical Service'),
                          ),
                          const SizedBox(width: 7),
                          Squaretile(
                            text: 'EV CHARGING',
                            imagePath: 'lib/images/charging-station.png',
                            isSelected:
                                selectedService == 'EV Charging service',
                            onTap: () =>
                                updateSelectedService('EV Charging service'),
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
                            isSelected:
                                selectedService == 'Fuel Delivery Service',
                            onTap: () =>
                                updateSelectedService('Fuel Delivery Service'),
                          ),
                          const SizedBox(width: 7),
                          Squaretile(
                            text: 'TOWING',
                            imagePath: 'lib/images/tow-truck.png',
                            isSelected:
                                selectedService == 'Emergency Towing Service',
                            onTap: () => updateSelectedService(
                                'Emergency Towing Service'),
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
                      const SizedBox(
                        height: 12,
                      ),
                      CustomButton(
                        borderRadius: 2,
                        text: 'Select Vehicle',
                        fsize: 16,
                        iconsize: 16,
                        onPressed: () {},
                        textColor: Colors.black,
                        buttonColor: AppColors.appPrimary,
                        suffixIcon: FontAwesomeIcons.car,
                        h: 34,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 0, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...addedVehicles.map((vehicleDetails) {
                              final isSelected = selectedVehicleName ==
                                  '${vehicleDetails['manufacturer']} ${vehicleDetails['vehicleName']} ${vehicleDetails['registrationNumber']}';
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    vehicleID =
                                        vehicleDetails["registrationNumber"];
                                    selectedVehicleName =
                                        '${vehicleDetails['manufacturer']} ${vehicleDetails['vehicleName']} ${vehicleDetails['registrationNumber']}';
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 7),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(2),
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  vehicleDetails[
                                                          'manufacturer'] +
                                                      " " +
                                                      vehicleDetails[
                                                          'vehicleName'],
                                                  style: TextStyle(
                                                    color: isSelected
                                                        ? Colors.black
                                                        : Colors.white,
                                                    fontSize: 16,
                                                    fontFamily:
                                                        GoogleFonts.strait()
                                                            .fontFamily,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                Text(
                                                  "[" +
                                                      vehicleDetails[
                                                          'registrationNumber'] +
                                                      "]",
                                                  style: TextStyle(
                                                    color: isSelected
                                                        ? Colors.black
                                                        : Colors.white,
                                                    fontSize: 16,
                                                    fontFamily:
                                                        GoogleFonts.strait()
                                                            .fontFamily,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (isSelected)
                                              Icon(
                                                Icons.check,
                                                size: 17,
                                                color: isSelected
                                                    ? Colors.black
                                                    : Colors.white,
                                              )
                                            // Placeholder for check icon
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 19.50),
                          child: ElevatedButton(
                            onPressed: () async {
                              // Fetch user data from Firestore
                              final currentUser =
                                  FirebaseAuth.instance.currentUser;
                              if (currentUser != null) {
                                final userData = await FirebaseFirestore
                                    .instance
                                    .collection("USERS")
                                    .doc(currentUser.email!)
                                    .get();
                                final isComplete = userData.exists &&
                                    userData.data()?['Complete'] == true;

                                // Check if the user data is complete
                                if (isComplete) {
                                  // Check if a service and a vehicle are selected
                                  if (selectedService.isNotEmpty &&
                                      selectedVehicleName.isNotEmpty) {
                                    // Proceed to request service
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ManagePage(
                                          servicetype: selectedService,
                                          vehicleID: vehicleID,
                                          userEmail: userEmail,
                                        ),
                                      ),
                                    );
                                    return; // Exit onPressed method
                                  } else {
                                    // Show alert if service or vehicle is not selected
                                    CustomAlert.show(
                                      context: context,
                                      title: "Missing Information",
                                      message:
                                          "Please select a service and a vehicle.",
                                      messageTextColor: Colors.red,
                                      backgroundColor: Colors.white,
                                      buttonColor: Colors.grey,
                                    );
                                    return; // Exit onPressed method
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
                                  return; // Exit onPressed method
                                }
                              } else {
                                // Handle the case where currentUser is null
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              
                              padding: const EdgeInsets.all(20),
                              backgroundColor: AppColors
                                  .appPrimary, // Change this to your desired color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'REQUEST SERVICE',
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.ubuntu().fontFamily,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                      width: 8), // Space between text and icon
                                  const Icon(
                                    FontAwesomeIcons.chevronRight,
                                    size: 26,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ))
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
