import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ReqServiceDetail extends StatefulWidget {
  final String providerID;
  final String serviceRequestType;
  final String requestedTime;
  final String status;

  const ReqServiceDetail({
    required this.providerID,
    required this.serviceRequestType,
    required this.requestedTime,
    required this.status,
  });

  @override
  State<ReqServiceDetail> createState() => _ReqServiceDetailState();
}

class _ReqServiceDetailState extends State<ReqServiceDetail> {
  late Stream<DocumentSnapshot> providerStream;
  late String profilePhotoUrl; // Define profilePhotoUrl variable

  @override
  void initState() {
    super.initState();
    providerStream = FirebaseFirestore.instance
        .collection("PROVIDERS")
        .doc(widget.providerID)
        .snapshots();
  }

  TextStyle sstyle = TextStyle(
    fontFamily: GoogleFonts.ubuntu().fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Row(
          children: [
            Text(
              '${widget.status}',
              style: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Provider Details',
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.ubuntu().fontFamily),
            ),
            const SizedBox(height: 17),
            StreamBuilder<DocumentSnapshot>(
              stream: providerStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final providerData = snapshot.data!;
                final providerName = providerData["Fullname"];
                final providerCompany = providerData["Company Name"];
                final providerPH = providerData["Phone Number"];
                final providerEmail = providerData["Email"];
                profilePhotoUrl =
                    providerData["Profile Photo"]; // Retrieve profile photo URL

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Container(
                            height: 150,
                            width: 150,
                            color: Colors.grey[300],
                            child: profilePhotoUrl != null &&
                                    profilePhotoUrl.isNotEmpty
                                ? Image.network(
                                    profilePhotoUrl,
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.blue,
                                        ),
                                      );
                                    },
                                  )
                                : const Icon(
                                    Icons.account_circle,
                                    size: 150,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('Name:  $providerName', style: sstyle),
                    const SizedBox(height: 5),
                    Text('Company Name:   $providerCompany', style: sstyle),
                    const SizedBox(height: 5),
                    Text('Phone Number:   $providerPH', style: sstyle),
                    const SizedBox(height: 5),
                    Text('Email Address:  $providerEmail', style: sstyle),
                    const SizedBox(height: 5),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Service Request Details',
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.ubuntu().fontFamily),
            ),
            const SizedBox(height: 8),
            Text('Service Request Type:   ${widget.serviceRequestType}',
                style: sstyle),
            const SizedBox(height: 5),
            Text(
                'Requested Time:   ${DateFormat('MMMM dd, yyyy hh:mm a').format(DateTime.parse(widget.requestedTime))}',
                style: sstyle), // Modified line
            const SizedBox(height: 5),
            Row(
              children: [
                Text('Status:', style: sstyle),
                Text(
                  ' ${widget.status}',
                  style: TextStyle(
                    color: widget.status == "Pending"
                        ? Colors.yellow
                        : widget.status == "Accepted"
                            ? Colors.green
                            : widget.status == "Declined"
                                ? Colors.red
                                : widget.status == "Completed"
                                    ? Colors.white
                                    : Colors
                                        .black, // Default text color for unknown status
                    fontFamily: GoogleFonts.ubuntu().fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.3,
                    isFirst: true,
                    indicatorStyle: const IndicatorStyle(
                      width: 15,
                      color: Colors.blue,
                      indicatorXY: 0.5,
                    ),
                    startChild: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Requested',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    endChild: Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${widget.requestedTime}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (widget.status == "Accepted" ||
                      widget.status == "Declined")
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.3,
                      indicatorStyle: const IndicatorStyle(
                        width: 20,
                        color: Colors.green,
                        indicatorXY: 0.5,
                      ),
                      startChild: Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          widget.status == "Accepted" ? 'Accepted' : 'Declined',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      endChild: Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          '${DateFormat('MMMM dd, yyyy hh:mm a').format(DateTime.now())}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (widget.status == "Accepted")
                    StreamBuilder<DocumentSnapshot>(
                      stream: providerStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final providerData = snapshot.data!;
                          final providerPH = providerData[
                              "Phone Number"]; // Define providerPH here

                          return TimelineTile(
                            alignment: TimelineAlign.manual,
                            lineXY: 0.3,
                            indicatorStyle: const IndicatorStyle(
                              width: 25,
                              color: Colors.orange,
                              indicatorXY: 0.5,
                            ),
                            startChild: Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text(
                                'On the Way',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            endChild: Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text(
                                'Service assistant will be with you shortly.',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  if (widget.status == "Completed")
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.3,
                      isLast: true,
                      indicatorStyle: const IndicatorStyle(
                        width: 30,
                        color: Colors.red,
                        indicatorXY: 0.5,
                      ),
                      startChild: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          'Service Completed',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      endChild: Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'Completed On: ${DateFormat('MMMM dd, yyyy hh:mm a').format(DateTime.now())}',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  if (widget.status == "Accepted")
                    Container(
                      padding: const EdgeInsets.all(7),
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white, // Change background color to grey
                      ),
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: providerStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final providerData = snapshot.data!;
                            final providerPH = providerData[
                                "Phone Number"]; // Define providerPH here

                            return Row(
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    '   $providerPH',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            GoogleFonts.ubuntu().fontFamily),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: providerPH));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Copied to clipboard'),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.phone,
                                      color: Colors.black),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
