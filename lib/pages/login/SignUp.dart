import 'package:admin_office/pages/home.dart';
import 'package:admin_office/pages/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../params/params.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _selectedHospital = '';
  String _selectedDomain = '@gmail.com';
  String chosenEmail = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void _goToLoginPage() {
    // Navigate to the login page
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  Future<void> _signUpWithEmailAndPassword() async {
    try {
      final String email = chosenEmail;
      final String password = _passwordController.text;
      final String fullName = _fullNameController.text;
      final String service = _serviceController.text;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(userCredential.user!.uid)
            .set({
          'email': email,
          'fullName': fullName,
          'service': service,
          'hospital': _selectedHospital,
        });
        await prefs.setString('authToken', userCredential.user!.uid);
        // Navigate to the home page upon successful signup
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false, // Remove all routes
        );
      } else {
        // Show a snackbar if email or password is empty
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Veuillez saisir votre adresse e-mail et votre mot de passe.',
                style: GoogleFonts.robotoCondensed()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Show a snackbar if signup fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Échec de l\'inscription. Veuillez vérifier vos informations.',
              style: GoogleFonts.robotoCondensed()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (hospitals.isNotEmpty) {
      _selectedHospital = hospitals[0]; // Initialize with the first hospital
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers to release resources
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Inscription',
          style: GoogleFonts.robotoCondensed(
              color: Colors.white), // Set text color to white
        ),
        centerTitle: true, // Center the title
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 60), // Add space between the logo and the text
                Text(
                  'Créez votre compte',
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 40,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                    height:
                        50), // Adjust the space according to your preference
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 250,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5.0,
                              blurRadius: 5.0,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _fullNameController,
                                  decoration: InputDecoration(
                                    hintText: 'Nom complet',
                                    hintStyle: GoogleFonts.robotoCondensed(
                                        color: Colors.grey),
                                    prefixIcon: const Icon(
                                      Icons.account_circle_outlined,
                                      color: Colors.green,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 15.0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 250,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5.0,
                              blurRadius: 5.0,
                              offset: const Offset(0, 3),
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
                                    hintStyle: GoogleFonts.robotoCondensed(
                                        color: Colors.grey),
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Colors.green,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 15.0),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              const SizedBox(width: 10),
                              DropdownButton<String>(
                                value: _selectedDomain,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedDomain = newValue;
                                      chosenEmail =
                                          _emailController.text.trim() +
                                              _selectedDomain;
                                    });
                                  }
                                },
                                underline: Container(),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.green,
                                ),
                                items: <String>[
                                  '@gmail.com',
                                  '@yahoo.com',
                                  '@hotmail.com',
                                  '@outlook.com',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: GoogleFonts.robotoCondensed(
                                          color: Colors.grey),
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
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 250,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5.0,
                              blurRadius: 5.0,
                              offset: const Offset(0, 3),
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
                                    hintStyle: GoogleFonts.robotoCondensed(
                                        color: Colors.grey),
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.green,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 15.0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 400,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5.0,
                                  blurRadius: 5.0,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.local_hospital, // Your hospital icon
                                    color: Colors.green,
                                  ),
                                  const SizedBox(
                                      width:
                                          10), // Add spacing between icon and dropdown button
                                  Expanded(
                                    child: DropdownButton<String>(
                                      value: _selectedHospital,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedHospital = newValue!;
                                        });
                                      },
                                      underline: Container(),
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.green,
                                      ),
                                      items: hospitals
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: GoogleFonts.robotoCondensed(
                                                color: Colors.grey),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 250,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5.0,
                              blurRadius: 5.0,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _serviceController,
                                  decoration: InputDecoration(
                                    hintText: 'Service',
                                    hintStyle: GoogleFonts.robotoCondensed(
                                        color: Colors.grey),
                                    prefixIcon: const Icon(
                                      Icons.home_repair_service_rounded,
                                      color: Colors.green,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 15.0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: _signUpWithEmailAndPassword,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: Text('Inscription',
                        style: GoogleFonts.robotoCondensed(
                            color: Colors.white, fontSize: 26)),
                  ),
                ),
                const SizedBox(height: 20), // Adjust the height to reduce space
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Avez-vous un compte ?',
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: _goToLoginPage,
                      child: Text(
                        'Connexion',
                        style: GoogleFonts.robotoCondensed(
                          color: Colors.green,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
