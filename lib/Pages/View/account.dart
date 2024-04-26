
import 'package:autorescue_customer/Authentication/Controller/main_page.dart';
import 'package:autorescue_customer/Colors/appcolor.dart';
import 'package:autorescue_customer/Pages/Components/edit_vehicle.dart';
import 'package:autorescue_customer/Pages/Components/vehicle_form_page.dart';
import 'package:autorescue_customer/Pages/View/uploaddoc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController drLicenseImgController;
  late TextEditingController rcImgController;
  File? pickedDLimage;
  File? pickedRCimage;
  String? dlImageURL;
  String? rcImageURL;
  bool isExpanded = false;
  bool isTrue = false;

  List<Map<String, dynamic>> addedVehicles = [];
  // Define variables to hold the previous DL and RC image paths
  String? previousDLimage;
  String? previousRCimage;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    drLicenseImgController = TextEditingController();
    rcImgController = TextEditingController();
    getUserData();
    getAddedVehicles();
  }

  Future<void> getUserData() async {
    setState(() {
      isLoading = true;
    });
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userSnapshot = await FirebaseFirestore.instance
        .collection('USERS')
        .doc(currentUser.email)
        .get();

    if (userSnapshot.exists) {
      final userDetails = userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = userDetails['Fullname'] ?? '';
        _emailController.text = userDetails['Email'] ?? '';
        _phoneNumberController.text = userDetails['Phone Number'] ?? '';

        if (userDetails.containsKey('DL ImageURL')) {
          dlImageURL = userDetails['DL ImageURL'];
        }

        if (userDetails.containsKey('RC ImageURL')) {
          rcImageURL = userDetails['RC ImageURL'];
        }
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  // Function to update the previous DL and RC image paths
  void updatePreviousImagePaths() {
    if (pickedDLimage != null) {
      previousDLimage = pickedDLimage!.path;
    }
    if (pickedRCimage != null) {
      previousRCimage = pickedRCimage!.path;
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateUserData() async {
    setState(() {
      isLoading = true;
    });
    final currentUser = FirebaseAuth.instance.currentUser!;

    String? DLimageUrl;
    String? RCimageUrl;

    // Update previous image paths before checking renewal
    updatePreviousImagePaths();

    // Function to check if DL image is renewed
    bool checkIfDLRenewed(File? pickedDLimage, String? previousDLimage) {
      // Implement your logic here to determine if DL image is renewed
      // For example, you might check if a new DL image is selected compared to the previous one
      // Return true if DL image is renewed, false otherwise
      // Example logic:
      return pickedDLimage != null && pickedDLimage.path != previousDLimage;
    }

    bool checkIfRCRenewed(File? pickedRCimage, String? previousRCimage) {
      // Implement your logic here to determine if RC image is renewed
      // For example, you might check if a new RC image is selected compared to the previous one
      // Return true if RC image is renewed, false otherwise
      // Example logic:
      return pickedRCimage != null && pickedRCimage.path != previousRCimage;
    }

    // Assuming you have a function to upload the DL image
    if (checkIfDLRenewed(pickedDLimage, previousDLimage)) {
      DLimageUrl = await uploadLicenseImage();
    }

    // Assuming you have a function to upload the RC image
    if (checkIfRCRenewed(pickedRCimage, previousRCimage)) {
      RCimageUrl = await uploadRCBookImage();
    }

    // Update only DL and RC image URLs if renewed, otherwise update all data
    Map<String, dynamic> userData = {
      'Fullname': _nameController.text,
      'Phone Number': _phoneNumberController.text,
      'Email': _emailController.text,
    };

    if (DLimageUrl != null) {
      userData['DL ImageURL'] = DLimageUrl;
    }

    if (RCimageUrl != null) {
      userData['RC ImageURL'] = RCimageUrl;
    }

    // Update Firestore document
    await FirebaseFirestore.instance
        .collection('USERS')
        .doc(currentUser.email)
        .update(userData);

    // Show success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(
            "Updated Successfully",
            style:TextStyle(
                                color: AppColors.appTertiary,
                                fontFamily: GoogleFonts.ubuntu().fontFamily,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  Future<String> uploadLicenseImage() async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('user_LicenseImage');
    final UploadTask uploadTask = storageReference.putFile(pickedDLimage!);

    await uploadTask.whenComplete(() {});
    return storageReference.getDownloadURL();
  }

  Future<String> uploadRCBookImage() async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('user_RCimage');
    final UploadTask uploadTask = storageReference.putFile(pickedRCimage!);

    await uploadTask.whenComplete(() {});
    return storageReference.getDownloadURL();
  }

  Future<void> getAddedVehicles() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
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
      });
    });

    setState(() {
      addedVehicles = vehicles;
    });
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const MainPage();
        },
      ),
      (route) => false,
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Logout Successful",
            style: TextStyle(
                color: AppColors.appTertiary,
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            const Icon(
              Icons.person_pin_rounded,
              size: 30,
              color: AppColors.appTertiary,
            ),
            const SizedBox(width: 10),
            Text(
              'My Profile',
              style: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: AppColors.appTertiary,
            ),
            onPressed: () => logout(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.appPrimary),
              ),
            )
          : Center(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const FaIcon(FontAwesomeIcons.bicycle),
                            iconSize: 20,
                            color: AppColors.appPrimary,
                            onPressed: () {},
                          ),
                          Text(
                            "Hello there!",
                            style: TextStyle(
                                color: AppColors.appTertiary,
                                fontFamily: GoogleFonts.ubuntu().fontFamily,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      buildEditableField("Fullname", _nameController),
                      const SizedBox(
                        height: 17,
                      ),
                      buildEditableField("Email", _emailController),
                      const SizedBox(
                        height: 17,
                      ),
                      buildEditableField(
                          "Phone Number", _phoneNumberController),
                      const SizedBox(
                        height: 17,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isTrue = !isTrue;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            padding: const EdgeInsets.only(left: 17),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey[700],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('ADD VEHICLE',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily:
                                            GoogleFonts.strait().fontFamily,
                                        fontWeight: FontWeight.bold)),
                                Transform.rotate(
                                  angle: isTrue ? 3.14 : 0, // Rotate arrow
                                  child: IconButton(
                                    icon: const FaIcon(
                                        FontAwesomeIcons.squareArrowUpRight),
                                    splashRadius: 1,
                                    iconSize: 30,
                                    onPressed: () {
                                      setState(() {
                                        isTrue = !isTrue;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (isTrue)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 10, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display added vehicles
                              // Display added vehicles
                              ...addedVehicles.map((vehicleDetails) {
                                return GestureDetector(
                                  onTap: () {
                                    // Navigate to the edit vehicle details page
                                    // You can pass the vehicle details as arguments if needed
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditVehiclePage(
                                            vehicleDetails: vehicleDetails),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.grey[300],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.directions_car,
                                          color: AppColors.appSecondary,
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    vehicleDetails[
                                                        'manufacturer'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontFamily:
                                                            GoogleFonts.strait()
                                                                .fontFamily,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    vehicleDetails[
                                                        'vehicleName'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontFamily:
                                                            GoogleFonts.strait()
                                                                .fontFamily,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                vehicleDetails[
                                                    'registrationNumber'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily:
                                                        GoogleFonts.strait()
                                                            .fontFamily,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),

                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to the vehicle adding page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const VehicleFormPage(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.grey,
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 17,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UploadDocPage(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            padding: const EdgeInsets.only(left: 17),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey[700],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('UPLOAD DRIVING LICENSE',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily:
                                            GoogleFonts.strait().fontFamily,
                                        fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const FaIcon(FontAwesomeIcons.file),
                                  splashRadius: 1,
                                  iconSize: 30,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UploadDocPage(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 17,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ElevatedButton(
                          onPressed: updateUserData,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: AppColors.appPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(
                            'UPDATE PROFILE',
                            style: TextStyle(
                                fontSize: 19,
                                fontFamily: GoogleFonts.strait().fontFamily,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildEditableField(String label, TextEditingController controller) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: controller.text.isEmpty
                ? const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
