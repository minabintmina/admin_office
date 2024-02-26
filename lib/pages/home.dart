import 'package:admin_office/pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<QuerySnapshot> _usersStream;

  @override
  void initState() {
    super.initState();
    _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Set the background color to green
        title: Text('Liste de patients'),
        actions: [
          // Add a PopupMenuButton for the dropdown
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.white), // Use a white dropdown icon
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.green), // Use a green logout icon
                      SizedBox(width: 10),
                      Text('Déconnexion'),
                    ],
                  ),
                  value: 'logout',
                ),
                // Add more menu items as needed
              ];
            },
            onSelected: (value) async {
              if (value == 'logout') {
                try {
                  // Sign out from Firebase

                  // Clear authentication token from shared preferences
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.remove('authToken');

                  // Navigate to the login screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                        (Route<dynamic> route) => false, // Remove all routes
                  );
                } catch (e) {
                  print('Error during logout: $e');
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 10, // Adjust the spacing between columns if needed
                  columns: [
                    DataColumn(
                      label: Container(
                        width: MediaQuery.of(context).size.width * 0.3, // Set the desired width, adjust as needed
                        child: Text(
                          'Nom',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        width: MediaQuery.of(context).size.width * 0.3, // Set the desired width, adjust as needed
                        child: Text(
                          'Prénom',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        width: MediaQuery.of(context).size.width * 0.3, // Set the desired width, adjust as needed
                        child: Text(
                          'Contact',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                    // Extracting values from Firestore document
                    String nom = data['nom'];
                    String prenom = data['prenom'];
                    String telephone = data['number'];
                    String email = data['email'];

                    return DataRow(cells: [
                      DataCell(Container(
                        width: MediaQuery.of(context).size.width * 0.3, // Set the desired width, adjust as needed
                        child: Text(nom),
                      )),
                      DataCell(Container(
                        width: MediaQuery.of(context).size.width * 0.3, // Set the desired width, adjust as needed
                        child: Text(prenom),
                      )),
                      DataCell(
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3, // Set the desired width, adjust as needed
                          child: GestureDetector(
                            onTap: () {
                              // Show a popup dialog with email and number
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Contact'),
                                    content: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.email, color: Colors.green), // Green email icon
                                            SizedBox(width: 20),
                                            GestureDetector(
                                              onTap: () {
                                                _launchEmail(email);
                                              },
                                              child: Text(
                                                email,
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height:20),
                                        Row(
                                          children: [
                                            Icon(Icons.phone, color: Colors.green), // Green phone icon
                                            SizedBox(width: 20),
                                            GestureDetector(
                                              onTap: () {
                                                _launchPhone(telephone);
                                              },
                                              child: Text(
                                                telephone,
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  decoration: TextDecoration.underline,
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
                                        child: Text('Fermer'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Row(
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
_launchEmail(String email) async {
  if (await canLaunch('mailto:$email')) {
    await launch('mailto:$email');
  } else {
    throw 'Could not launch email';
  }
}_launchPhone(String phone) async {
  if (await canLaunch('tel:$phone')) {
    await launch('tel:$phone');
  } else {
    throw 'Could not launch phone';
  }
}
