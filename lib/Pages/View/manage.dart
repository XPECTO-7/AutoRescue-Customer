import 'package:autorescue_customer/Colors/appcolor.dart';
import 'package:autorescue_customer/Constants/app_strings.dart';
import 'package:autorescue_customer/Pages/Components/custom_button.dart';
import 'package:autorescue_customer/Pages/Components/text_area_simple.dart';
import 'package:autorescue_customer/Pages/View/bottom_nav_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart' as latlong;

import 'package:cloud_firestore/cloud_firestore.dart';

class ManagePage extends StatefulWidget {
  final String servicetype, vehicleID, userEmail;

  const ManagePage({
    Key? key,
    required this.servicetype,
    required this.vehicleID,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  bool isLoading = false;
  Position? position;
  String service = "";
  List<Marker> services = [];

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });
    if (widget.servicetype == "KEY LOCKOUT") {
      setState(() {
        service = "Mechanical Service";
      });
    } else {
      setState(() {
        service = widget.servicetype;
      });
    }
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    setState(() {
      isLoading = false;
    });
  }

  void getServiceLocations({
    required List<dynamic> providerList,
    required String lattitude,
    required String longitude,
  }) async {
    String asset = "";
    List providers = providerList;

    providerList.forEach((element) {
      // Convert _JsonQueryDocumentSnapshot to Map
      Map<String, dynamic> data = element.data() as Map<String, dynamic>;

      switch (data["Service Type"]) {
        case "Fuel Delivery Service":
          asset = "lib/images/fuel.png";
          break;
        case "Mechanical Service":
          asset = "lib/images/automotive.png";
          break;
        case "TYRE WORKS":
          asset = "lib/images/tyre.png";
          break;
        case "Emergency Towing Service":
          asset = "lib/images/tow-truck.png";
          break;
        case "EV Charging service":
          asset = "lib/images/charging-station.png";
          break;
        default:
          asset = "lib/images/cserv.png.png";
      }

      // Check if "Profile Photo" field exists in the document
      String profilePhotoUrl = data.containsKey("Profile Photo")
          ? data["Profile Photo"]
          : const Icon(
              Icons.account_circle,
              color: AppColors.appPrimary,
            ); // Use empty string as default value if field doesn't exist

      if (data["Service Type"] == service) {
        services.add(Marker(
          point: latlong.LatLng(
            double.parse(data[lattitude]),
            double.parse(data[longitude]),
          ),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey[950],
                    surfaceTintColor: Colors.transparent,
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height / 1.6,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            ClipOval(
                              child: Container(
                                height: 100,
                                width: 100,
                                color: Colors.grey[300],
                                child: Image.network(
                                  profilePhotoUrl,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.appPrimary,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SimpleTextArea(
                              content: data["Company Name"],
                              title: "Name : ",
                            ),
                            SimpleTextArea(
                              content: data["Experience"],
                              title: "Experience : ",
                            ),
                            SimpleTextArea(
                              content: data["Phone Number"],
                              title: "Ph : ",
                            ),
                            SimpleTextArea(
                              content: data["Service Type"],
                              title: "",
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            CustomButton(
                              text: 'CONTINUE',
                              onPressed: () {
                                sentRequest(
                                  providerID: data["Email"],
                                  vehicleID: widget.vehicleID,
                                  userID: widget.userEmail,
                                );
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BottomNavPage(),
                                  ),
                                );
                              },
                              buttonColor: AppColors.appPrimary,
                              textColor: AppColors.appSecondary,
                              suffixIcon: FontAwesomeIcons.arrowRight,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Transform.scale(
              scale: 1.7,
              child: Image.asset(asset),
            ),
          ),
        ));
      }
    });
  }

  void sentRequest({
    required String providerID,
    required String vehicleID,
    required String userID,
  }) async {
    setState(() {
      isLoading = true;
    });
    DateTime dateTime = DateTime.now();

    await FirebaseFirestore.instance.collection("SERVICE-REQUEST").add({
      "UserLocation-Lat": position!.latitude.toString(),
      "UserLocation-Long": position!.longitude.toString(),
      "UserID": userID,
      "VehicleID": vehicleID,
      "Service-Request-Type": service,
      "Requested-Time": dateTime,
      "Status": "Pending",
      "ProviderID": providerID,
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("PROVIDERS")
          .where('Approved', isEqualTo: 'Accepted')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          getServiceLocations(
            providerList: snapshot.data!.docs,
            lattitude: "location - lattitude",
            longitude: "location - longitude",
          );
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              title: Row(
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    color: AppColors.appTertiary,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Service Providers Nearby',
                    style: TextStyle(
                      fontFamily: GoogleFonts.ubuntu().fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.appPrimary,
                    ),
                  )
                : Center(
                    child: FlutterMap(
                      options: MapOptions(
                        minZoom: 5,
                        maxZoom: 24,
                        initialZoom: 18,
                        initialCenter: latlong.LatLng(
                          position!.latitude,
                          position!.longitude,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: AppStrings.urlTemplate,
                          additionalOptions: const {
                            'accessToken': AppStrings.accessToken,
                            'id': AppStrings.id,
                          },
                        ),
                        MarkerLayer(markers: services),
                      ],
                    ),
                  ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.appPrimary,
            ),
          );
        }
      },
    );
  }
}
