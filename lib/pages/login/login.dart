import 'package:admin_office/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _selectedDomain = '@gmail.com';
  String chosenEmail = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    try {
      print(chosenEmail);
      final String password = _passwordController.text;
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (chosenEmail.isNotEmpty && password.isNotEmpty) {
        print(chosenEmail);
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: chosenEmail,
          password: password,
        );
        await prefs.setString('authToken', userCredential.user!.uid);
        // Navigate to the next screen upon successful login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false, // Remove all routes
        );
      } else {
        // Show a snackbar if email or password is empty
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Veuillez saisir votre adresse e-mail et votre mot de passe.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Show a snackbar if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de la connexion. Veuillez vérifier vos identifiants.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0), // Add vertical padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Start from the top
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            // Your logo here
            Image.asset(
              'assets/logo.png',
              width: 200,
              height: 150, // Set the desired height here
              fit: BoxFit.contain, // Adjust the fit property to maintain aspect ratio
            ),
            SizedBox(height: 70),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: 250, // Set the desired width
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),


                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5.0,
                          blurRadius: 5.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle:  TextStyle(color: Colors.grey),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.green,
                                ),

                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0), // Adjust width and height

                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),

                          ),
                          SizedBox(width: 10),
                          // Add space between email and domain
                          DropdownButton<String>(
                            value: _selectedDomain,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedDomain = newValue;
                                   chosenEmail = _emailController.text.trim() + _selectedDomain;
                                });
                              }
                            },
                            underline: Container(),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.green, // Set the color of the dropdown icon
                            ),
                            items: <String>[
                              '@gmail.com',
                              '@yahoo.com',
                              '@hotmail.com',
                              '@outlook.com',
                              // Add more domain options as needed
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],

            ),




            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: 250, // Set the desired width
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),


                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5.0,
                          blurRadius: 5.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Mot de passe',

                                hintStyle:  TextStyle(color: Colors.grey),
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: Colors.green,
                                ),

                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0), // Adjust width and height

                              ),

                            ),

                          ),
                          SizedBox(width: 10),

                        ],
                      ),
                    ),
                  ),
                ),
              ],

            ),
            SizedBox(height: 40),
            Container(
              width: 500, // Set the desired width
              height: 70,
              child: ElevatedButton(
                onPressed: _signInWithEmailAndPassword,
                child: Text('Connexion',style: TextStyle(color: Colors.white,fontSize: 26)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),

                ),
              ),
            ),
          ],
        ),
      ),

      ),
    );
  }
}