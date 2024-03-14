import 'dart:convert';
import 'dart:developer';

import 'package:admin_office/pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<QuerySnapshot> _usersStream = const Stream.empty();
  User? user = FirebaseAuth.instance.currentUser;
  String displayName = '';
  @override
  void initState() {
    super.initState();
    _loadDoctorFullName();
    _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('SelectedDoctor', isEqualTo: '')
        .snapshots();
  }

  Future<void> _loadDoctorFullName() async {
    try {
      DocumentSnapshot doctorSnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (doctorSnapshot.exists) {
        String doctorFullName = doctorSnapshot['fullName'];
        displayName=doctorFullName;

        setState(() {
          _usersStream = FirebaseFirestore.instance
              .collection('users')
              .where('SelectedDoctor', isEqualTo: doctorFullName)
              .snapshots();
        });
      } else {
      }
    } catch (error) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Set the background color to green
        title: const Text('Liste de patients'),
        actions: [
          // Add a PopupMenuButton for the dropdown
          PopupMenuButton(
            icon: const Icon(Icons.more_vert,
                color: Colors.white), // Use a white dropdown icon
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout,
                          color: Colors.green), // Use a green logout icon
                      SizedBox(width: 10),
                      Text('Déconnexion'),
                    ],
                  ),
                ),
                // Add more menu items as needed
              ];
            },
            onSelected: (value) async {
              if (value == 'logout') {
                try {
                  // Sign out from Firebase

                  // Clear authentication token from shared preferences
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('authToken');

                  // Navigate to the login screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (Route<dynamic> route) => false, // Remove all routes
                  );
                } catch (e) {
                }
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing:
                      10, // Adjust the spacing between columns if needed
                  columns: [
                    DataColumn(
                      label: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.3, // Set the desired width, adjust as needed
                        child: const Text(
                          'Nom',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.3, // Set the desired width, adjust as needed
                        child: const Text(
                          'Prénom',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.3, // Set the desired width, adjust as needed
                        child: const Text(
                          'Contact',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    // Extracting values from Firestore document
                    String nom = data['Firstname'];
                    String prenom = data['Lastname'];
                    String telephone = data['Phone Number'];
                    String email = data['Email Adresse'];
                    String request = data['Request'];

                    return DataRow(cells: [
                      DataCell(SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.3, // Set the desired width, adjust as needed
                        child: Text(nom),
                      )),
                      DataCell(SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.3, // Set the desired width, adjust as needed
                        child: Text(prenom),
                      )),
                      DataCell(
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.3, // Set the desired width, adjust as needed
                          child: GestureDetector(
                            onTap: () {
                              // Show a popup dialog with email and number
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Contact'),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.email,
                                                color: Colors
                                                    .green), // Green email icon
                                            const SizedBox(width: 20),
                                            GestureDetector(
                                              onTap: () {
                                                _launchEmail(email);
                                              },
                                              child: Text(
                                                email,
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            const Icon(Icons.phone,
                                                color: Colors
                                                    .green), // Green phone icon
                                            const SizedBox(width: 20),
                                            GestureDetector(
                                              onTap: () {
                                                _launchPhone(telephone);
                                              },
                                              child: Text(
                                                telephone,
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            const Icon(Icons.check,
                                                color: Colors
                                                    .green), // Green check icon
                                            const SizedBox(width: 20),
                                            GestureDetector(
                                              onTap: () async {
                                                // Change the request from pending to accepted
                                                String updatedRequest =
                                                    changeRequest(request);

                                                // Update the request value in the Firestore database
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(document
                                                        .id) // Assuming 'document' represents the user document
                                                    .update({
                                                  'Request': updatedRequest
                                                }).then((value) {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                }).catchError((error) {
                                                });
                                                const fcmToken= 'token';

                                                log("FCMToken $fcmToken");
                                                await sendFCMNotification(fcmToken,displayName);
                                              },
                                              child: Text(
                                                changeRequest(request) ==
                                                        'accepted'
                                                    ? 'Accept'
                                                    : 'Wait',
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Fermer'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.contact_phone), // Contact icon
                                SizedBox(width: 5),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


}
Future<void> sendFCMNotification(String fcmToken,String displayName) async {
  try {
    const String serverKey = 'AAAAbK5weXw:APA91bEhcPL21jEfG2eY64jJ-EHLT4hQ0KZELoR0OWk9vr6K9RJsp5lwZqasfU4xEUwobXnK0FZt04BGe8GGFN0AegcWRWA3uVZ7RnZ0tHWyzWkGvDvlxLu6zAJZbHLXU3PZ0fGj139t';
    const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    // Construct the FCM message
    Map<String, dynamic> message = {
      'notification': {
        'title': 'Réponse de $displayName',
        'body': displayName,
        'style': 'bigtext',
      },
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      },
      'priority': 'high',
      'to': fcmToken,
    };


    // Send the FCM message to the specific device using its FCM token
    final http.Response response = await http.post(
      Uri.parse(fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
    } else {
    }
  } catch (error) {
  }
}


String changeRequest(String request) {
  if (request == 'pending') {

    return 'accepted';
  } else {
    return 'pending'; // return the original value if it's not 'pending'
  }
}

_launchEmail(String email) async {
  if (await canLaunch('mailto:$email')) {
    await launch('mailto:$email');
  } else {
    throw 'Could not launch email';
  }
}

_launchPhone(String phone) async {
  if (await canLaunch('tel:$phone')) {
    await launch('tel:$phone');
  } else {
    throw 'Could not launch phone';
  }
}
