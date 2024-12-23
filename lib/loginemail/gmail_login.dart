
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../mainscreen/mainscreen.dart';
import '../registration/profiecreate.dart';
import '../registration/registration.dart';

class GmailLoginPage extends StatefulWidget {
  @override
  _GmailLoginPageState createState() => _GmailLoginPageState();
}

class _GmailLoginPageState extends State<GmailLoginPage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String name, gender, phoneNumber, gmail, password;
  late int age;
  bool _isLoading = false;
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // Get the signed-in user
    User? user = userCredential.user;
    if (user != null) {
      String uid = user.uid;
      String? email = user.email;

      print('User signed in with Google successfully');
      print('User UID: $uid');
      print('User Email: $email');
      if(uid!=null){
        fetchProfile(uid,email!,"");
      }
    }
    // Once signed in, return the UserCredential
    return userCredential;
  }

  Future<void> signInWithEmailAndPassword() async {
    // setState(() {
    //   _isLoading = true; // Show loading indicator
    // });
    if (_formKey.currentState?.validate() ?? false) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        String uid = userCredential.user?.uid ?? '';
        // Notify user of successful sign-in or navigate to another page
        fetchProfile(uid,_emailController.text.trim(),_passwordController.text.trim());
        print('User signed in successfully');
        // Navigate to the next screen after successful login (Optional)
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        print('Failed to sign in with email and password: $e');
        // Display error to user if needed
        _emailController.clear();
        _passwordController.clear();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to sign in. Please check your credentials and try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false; // Show loading indicator
      });
      print('Form is invalid');
    }
    setState(() {
      _isLoading = false; // Show loading indicator
    });
  }


// Function to fetch profile data
  Future<void> fetchProfile(String _uid,String gmaill,String passwordd) async {
    try {
      // Get the document from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(_uid)
          .get();
    print(_uid);
    print(snapshot.exists);
      if (snapshot.exists) {
        // Extract the data from the document
        var profileData = snapshot.data() as Map<String, dynamic>;
        print('ddn');
        name = profileData['name'] ?? '';
        age = profileData['age'] ?? 0;
        gender = profileData['gender'] ?? '';
        phoneNumber = profileData['phoneNumber'] ?? '';
        gmail = profileData['gmail'] ?? '';
        password = profileData['password'] ?? '';
        print('Name: $name');
        print('Age: $age');
        print('Gender: $gender');
        print('Phone Number: $phoneNumber');
        print('Gmail: $gmail');
        print('Password: $password');

        if(name!= null){
          Navigator.push(context, MaterialPageRoute(builder: (context) => mainscreen(_uid,name,gmail,phoneNumber,gender,age)));
        }

        // Use the profile data as needed

      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileForm(_uid,gmaill,passwordd)));
        print('No profile found');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
    setState(() {
      _isLoading = false; // Show loading indicator
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'ConnectChat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:  _isLoading
          ? CircularProgressIndicator() : Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 200.0, // Set your desired height
                child: Image(image: AssetImage("assets/logo.png")),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Validate email format
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: signInWithEmailAndPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 12.0,
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              // Add TextButton for "Don't have an account? Sign up"
              TextButton(
                onPressed: () {
                  // Navigate to the registration page or show a dialog for registration
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                ),
                child: Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue, // Text color for the sign-up link
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: TextButton(
                    onPressed: () {
                      signInWithGoogle();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24.0, // Set your desired width
                          height: 24.0, // Set your desired height
                          child: Image(image: AssetImage("assets/google.png")),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black, // Set text color
                          ),
                        ),
                      ],
                    ),
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
