import 'dart:ui';

import 'package:autorescue_customer/Components/mybutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UploadDocPage extends StatefulWidget {
  const UploadDocPage({Key? key}) : super(key: key);

  @override
  _UploadDocPageState createState() => _UploadDocPageState();
}

class _UploadDocPageState extends State<UploadDocPage> {
  File? dlImage;
  String? dlImageUrl;
  bool uploading = false;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && dlImage != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection("USERS")
          .doc(currentUser.email)
          .get();
      if (userDoc.exists) {
        setState(() {
          dlImageUrl = userDoc.get('DlImage');
        });
      }
    } else {
      // Handle the case where currentUser is null
    }
  }

  Future<void> pickDLImage() async {
    final picker = ImagePicker();
    final pickedImageFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImageFile != null) {
      setState(() {
        dlImage = File(pickedImageFile.path.replaceAll('file://', ''));
        dlImageUrl = null;
      });
    } else {
      // Handle the case where pickedImageFile is null
    }
  }

  Future<void> uploadImages() async {
    if (dlImage != null) {
      setState(() {
        uploading = true;
      });

      final Reference storageReference =
          FirebaseStorage.instance.ref().child('Users');
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final Reference userReference =
            storageReference.child(currentUser.email!);
        final Reference dlReference =
            userReference.child("Vehicle_Details").child("Dl_Image");

        try {
          await dlReference.putFile(dlImage!);
          dlImageUrl = await dlReference.getDownloadURL();
        } catch (e) {
          print(e.toString());
        }

        if (dlImageUrl != null) {
          // Update Firestore with the DL image URL
          await FirebaseFirestore.instance
              .collection("USERS")
              .doc(currentUser.email!)
              .update({"DlImage": dlImageUrl});

          // Update the 'Complete' field to true
          await FirebaseFirestore.instance
              .collection("USERS")
              .doc(currentUser.email!)
              .update({"Complete": true});

          // Show a SnackBar to indicate successful upload
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Driving License uploaded successfully'),
              duration: Duration(seconds: 2), // Adjust the duration as needed
            ),
          );
          Navigator.pop(context);
        }
      } else {
        // Handle the case where currentUser is null
      }

      setState(() {
        uploading = false;
      });
    } else {
      // Handle the case where dlImage is null
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 17,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: InkWell(
                    onTap: pickDLImage,
                    child: SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey,
                          border: Border.all(color: Colors.white),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                dlImage == null && dlImageUrl == null
                                    ? "Choose from device"
                                    : "Update Driving License Image",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.habibi().fontFamily),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.photo_library_outlined,
                                  color: Colors.white),
                              onPressed: pickDLImage,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[950],
                    child: Center(
                      child: dlImageUrl != null
                          ? Image.network(
                              dlImageUrl!,
                              fit: BoxFit.cover,
                            )
                          : (dlImage != null
                              ? Image.file(
                                  dlImage!,
                                  fit: BoxFit.cover,
                                )
                              : const Text(
                                  'Nothing',
                                  style: TextStyle(color: Colors.white),
                                )),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                MyButton(
                  onTap: uploadImages,
                  text: "UPLOAD DRIVING LICENSE",
                  textColor: Colors.black,
                  buttonColor: Colors.white,
                ),
              ],
            ),
          ),
          if (uploading)
            Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}