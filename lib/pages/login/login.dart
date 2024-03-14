import 'package:admin_office/pages/home.dart';
import 'package:admin_office/pages/login/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controllers to release resources
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String _selected1Domain = '@gmail.com';
  String chosenEmail = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  void _goToLoginPage() {
    // Navigate to the login page
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignUp()));
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final String password = _password.text;
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (chosenEmail.isNotEmpty && password.isNotEmpty) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: chosenEmail,
          password: password,
        );
        await prefs.setString('authToken', userCredential.user!.uid);
        // Navigate to the next screen upon successful login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false, // Remove all routes
        );
      } else {
        // Show a snackbar if email or password is empty
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Veuillez saisir votre adresse e-mail et votre mot de passe.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Show a snackbar if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Échec de la connexion. Veuillez vérifier vos identifiants.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,

        title: Text(
          'Connexion',
          style: GoogleFonts.robotoCondensed(
            color: Colors.white,
          ),
          // Set text color to white
        ),
        centerTitle: true, // Center the title
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20.0, vertical: 10.0), // Add vertical padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 60), // Add space between the logo and the text
              Text(
                'Bienvenue',
                style: GoogleFonts.robotoCondensed(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 70),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 250, // Set the desired width
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
                                controller: _email,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: GoogleFonts.robotoCondensed(
                                      color: Colors.grey),
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: Colors.green,
                                  ),
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Add space between email and domain
                            DropdownButton<String>(
                              value: _selected1Domain,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selected1Domain = newValue;
                                    chosenEmail =
                                        _email.text.trim() +
                                            _selected1Domain;
                                  });
                                }
                              },
                              underline: Container(),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors
                                    .green, // Set the color of the dropdown icon
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
                      width: 250, // Set the desired width
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
                                controller: _password,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Mot de passe',
                                  hintStyle: GoogleFonts.robotoCondensed(
                                      color: Colors.grey),
                                  prefixIcon: const Icon(
                                    Icons.password,
                                    color: Colors.green,
                                  ),
                                  border: InputBorder.none,
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
              const SizedBox(height: 40),
              SizedBox(
                width: 500, // Set the desired width
                height: 70,
                child: ElevatedButton(
                  onPressed: _signInWithEmailAndPassword,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  child: Text('Connexion',
                      style: GoogleFonts.robotoCondensed(
                          color: Colors.white, fontSize: 26)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Vous n\'avez pas de compte?',
                    style: GoogleFonts.robotoCondensed(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: _goToLoginPage,
                    child: Text(
                      'Inscription',
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
    );
  }
}
