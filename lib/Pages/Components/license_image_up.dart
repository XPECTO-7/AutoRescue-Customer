import 'dart:io';
import 'package:autorescue_customer/Colors/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class LicenseImage extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Function(File) onImageSelected;
  final String? dlImageURL;

  const LicenseImage({
    Key? key,
    required this.label,
    required this.controller,
    required this.onImageSelected,
    required this.dlImageURL,
  }) : super(key: key);

  @override
  State<LicenseImage> createState() => _LicenseImageState();
}

class _LicenseImageState extends State<LicenseImage> {
  XFile? pickedDLImage;

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        pickedDLImage = image;
      });
      widget.onImageSelected(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: InkWell(
        onTap: pickImage,
        child: SizedBox(
          height: 60,
          width: 180,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: pickedDLImage == null && widget.dlImageURL == null
                      ? Text(
                          "DRIVING LICENSE",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.strait().fontFamily,
                          ),
                        )
                      : Text(
                          "UPDATE DL IMAGE",
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.dlImageURL != null || pickedDLImage != null
                                ? AppColors.appTertiary
                                : Colors.white,
                            fontFamily: GoogleFonts.strait().fontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add_a_photo, color: Colors.white, size: 30),
                  onPressed: pickImage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
