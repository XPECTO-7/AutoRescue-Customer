import 'package:autorescue_customer/Constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;


class PinLocationMap extends StatelessWidget {
  final double currentLocationX, currentLocationY;
  final Function(TapPosition, latlong.LatLng)? onTap;

  const PinLocationMap({
    Key? key,
    required this.onTap,
    required this.currentLocationX,
    required this.currentLocationY,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FlutterMap(
            options: MapOptions(
              onTap: onTap,
              initialZoom: 13,
              initialCenter: latlong.LatLng(currentLocationX, currentLocationY),
            ),
            children: [
               TileLayer(
                urlTemplate: AppStrings.urlTemplate,
                additionalOptions: const {
                  'accessToken': AppStrings.accessToken,
                  'id': AppStrings.id,
                },
              ),
            ],
          ),
        ),
        const Positioned(
          top: 32, // Adjust this value to position the text vertically
          left: 16.0, // Adjust this value to position the text horizontally
          child: Text(
            'TAP WHERE YOU WANT TO SET YOUR LOCATION',
            style: TextStyle(color: Colors.black,fontSize: 14,backgroundColor: Colors.yellow),
          ),
        ),
      ],
    );
  }
}
