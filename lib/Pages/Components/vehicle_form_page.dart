import 'dart:ui';

import 'package:autorescue_customer/Colors/appcolor.dart';
import 'package:autorescue_customer/Pages/View/bottom_nav_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class VehicleFormPage extends StatefulWidget {
  const VehicleFormPage({Key? key}) : super(key: key);

  @override
  _VehicleFormPageState createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends State<VehicleFormPage> {
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _vehicleNameController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _kilometersController = TextEditingController();
  String? _selectedFuelType;
  File? _pickedVehicleImage;
  File? _pickedRCimage;
  bool isLoading = false;
  List<String> addedVehicles = [];

  final _hintTextStyle = const TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  final _labelTextStyle = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  Future<void> _pickImage(ImageSource source) async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 500,
    );

    if (pickedImageFile == null) return;

    setState(() {
      _pickedVehicleImage = File(pickedImageFile.path);
    });
  }

  Future<void> _pickRC(ImageSource source) async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 500,
    );

    if (pickedImageFile == null) return;

    setState(() {
      _pickedRCimage = File(pickedImageFile.path);
    });
  }

  Future<String> _uploadImageToFirebase(File imageFile) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('vehicle_RCimages')
        .child(
            '${currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');

    await storageRef.putFile(imageFile);

    final vehicleImageURL = await storageRef.getDownloadURL();
    return vehicleImageURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'lib/images/addcar.png',
              color: AppColors.appTertiary,
              width: 35,
              height: 35,
            ),
            const SizedBox(
                width: 10), // Add spacing between the icon and the title
            const Text(
              'ADD',
              style: TextStyle(
                color: AppColors.appTertiary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                ' Vehicle Image',
                style: _labelTextStyle,
              ),
              const SizedBox(height: 8),
              Container(
                height: 200,
                color: Colors.grey[200],
                child: Center(
                  child: _pickedVehicleImage == null
                      ? IconButton(
                          icon: const Icon(
                            Icons.photo_camera,
                            size: 150,
                          ),
                          onPressed: () {
                            _pickImage(ImageSource.gallery);
                          },
                        )
                      : Image.file(
                          _pickedVehicleImage!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                ' RC BOOK Image',
                style: _labelTextStyle,
              ),
              const SizedBox(height: 8),
              Container(
                height: 200,
                color: Colors.grey[200],
                child: Center(
                  child: _pickedRCimage == null
                      ? IconButton(
                          icon: const Icon(
                            Icons.photo_camera,
                            size: 150,
                          ),
                          onPressed: () {
                            _pickRC(ImageSource.gallery);
                          },
                        )
                      : Image.file(
                          _pickedRCimage!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Manufacture',
                style: _labelTextStyle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _manufacturerController,
                decoration: InputDecoration(
                  hintText: 'Eg: Kia, Ola, Yamaha',
                  hintStyle: _hintTextStyle,
                  suffixIcon: const Icon(Icons.business, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Vehicle Name',
                style: _labelTextStyle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _vehicleNameController,
                decoration: InputDecoration(
                  hintText: 'Eg: Seltos, S1, R15 V4',
                  hintStyle: _hintTextStyle,
                  suffixIcon:
                      const Icon(Icons.directions_car, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Manufacture Year',
                style: _labelTextStyle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  hintText: 'Eg: 2020',
                  hintStyle: _hintTextStyle,
                  suffixIcon:
                      const Icon(Icons.calendar_today, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Registration Number',
                style: _labelTextStyle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _registrationNumberController,
                decoration: InputDecoration(
                  hintText: 'Eg: KL 7 CG 369',
                  hintStyle: _hintTextStyle,
                  suffixIcon:
                      const Icon(Icons.numbers_rounded, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Kilometers',
                style: _labelTextStyle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _kilometersController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  hintText: 'Eg: 2000',
                  hintStyle: _hintTextStyle,
                  suffixIcon: const Icon(Icons.speed, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Fuel Type',
                style: _labelTextStyle,
              ),
              const SizedBox(height: 8),
              Container(
                height: 60,
                child: DropdownButtonFormField<String>(
                  value: _selectedFuelType,
                  onChanged: (value) {
                    setState(() {
                      _selectedFuelType = value!;
                    });
                  },
                  items: <String?>['Electric', 'CNG', 'Petrol', 'Diesel']
                      .map((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    hintText: 'Select Fuel Type',
                    hintStyle: _hintTextStyle,
                    suffixIcon: const Icon(Icons.local_gas_station,
                        color: Colors.white),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final manufacturer = _manufacturerController.text;
                      final year = _yearController.text;
                      final vehicleName = _vehicleNameController.text;
                      final registrationNumber =
                          _registrationNumberController.text;
                      final kilometers = _kilometersController.text;
                      final fuelType = _selectedFuelType;

                      if (_pickedVehicleImage == null ||
                          _pickedRCimage == null ||
                          manufacturer.isEmpty ||
                          year.isEmpty ||
                          vehicleName.isEmpty ||
                          registrationNumber.isEmpty ||
                          kilometers.isEmpty ||
                          fuelType == null) {
                        // Show error message if any field is empty
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Error",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.strait().fontFamily,
                                ),
                              ),
                              content: _pickedVehicleImage == null ||
                                      _pickedRCimage == null
                                  ? const Text(
                                      "Please select both vehicle and RC book images.")
                                  : const Text("Please fill in all fields."),
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
                        return; // Stop execution if any field is empty
                      }

                      setState(() {
                        isLoading = true;
                      });

                      // Upload image to Firebase Storage
                      final vehicleImageURL =
                          await _uploadImageToFirebase(_pickedVehicleImage!);
                      // Upload RCimage to Firebase Storage
                      final vehicleRCImageURL =
                          await _uploadImageToFirebase(_pickedRCimage!);

                      // Add the vehicle details to the database
                      final currentUser = FirebaseAuth.instance.currentUser!;
                      final vehicleRef = FirebaseFirestore.instance
                          .collection('USERS')
                          .doc(currentUser.email)
                          .collection('VEHICLES');

                      // Use the registration number as the document ID
                      final vehicleDocRef = vehicleRef.doc(registrationNumber);

                      await vehicleDocRef.set({
                        'Manufacturer': manufacturer,
                        'Year': year,
                        'VehicleName': vehicleName,
                        'RegistrationNumber': registrationNumber,
                        'Kilometers': kilometers,
                        'FuelType': fuelType,
                        'vehicleImageURL': vehicleImageURL,
                        'vehicleRCImageURL': vehicleRCImageURL
                      });

                      setState(() {
                        addedVehicles.add(vehicleName);
                        isLoading = false;
                      });

                      // Clear the text fields after submission
                      _manufacturerController.clear();
                      _yearController.clear();
                      _vehicleNameController.clear();
                      _registrationNumberController.clear();
                      _kilometersController.clear();
                      setState(() {
                        _selectedFuelType = null;
                        _pickedVehicleImage = null;
                        _pickedRCimage = null;
                      });

                      // Show a dialog to indicate successful submission
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Vehicle Added Successfully",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: GoogleFonts.strait().fontFamily,
                                  fontWeight: FontWeight.bold),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const BottomNavPage(),
                                    ),
                                  );
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      'ADD VEHICLE',
                      style: TextStyle(
                          fontSize: 19,
                          fontFamily: GoogleFonts.strait().fontFamily,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Circular progress indicator
                  if (isLoading)
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(
                            color: AppColors.appPrimary,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _manufacturerController.dispose();
    _yearController.dispose();
    _vehicleNameController.dispose();
    _registrationNumberController.dispose();
    _kilometersController.dispose();
    super.dispose();
  }
}
