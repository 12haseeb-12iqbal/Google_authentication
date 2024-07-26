import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Apple Sign-In Demo',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isavailable = false;
  String message = '';
String platformMessage='';
bool run=true;
  @override
  void initState() {
    super.initState();
    _checkPlatform();
    _checkAppleSignInAvailability();
  }



  Future<void> _checkAppleSignInAvailability() async {
    final available = await SignInWithApple.isAvailable();
    setState(() {
      isavailable = available;
      if (!available) {
        message = "no supported-----";
      }
    });
  }

  void _checkPlatform() {
    if (Platform.isAndroid) {
    setState(() {
      run=true;
    });
      platformMessage = "This device is running on Android.";
    } else if (Platform.isIOS) {
      setState(() {
        run=false;
      });
      platformMessage = "This device is running on iOS.";
    } else {
      platformMessage = "This device is running on an unsupported platform.";
    }}

      Future<void> _signin() async {
    if (isavailable) {
      try {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        if (credential.userIdentifier != null) {
          print(" ID: ${credential.userIdentifier}");
          print("email: ${credential.email}");
          print("Name: ${credential.givenName} ${credential.familyName}");
          setState(() {
            message = "Signed in successfully!";
          });
        } else {
          setState(() {
            message = "No valid Apple account found.";
          });
        }
      } catch (e) {
        print("Error during Apple Sign-In: $e");

      }
    }
  }
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
    // print(user.user?.displayName);
    // print(user.user?.emailVerified);
    // return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apple Sign-In Demo'),
      ),
      body: run?Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white30
            ),
            onPressed: (){
          signInWithGoogle();
        }, child: Text("Sign in with Google ")),
      ):Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green

            ),
            onPressed: (){
          _signin();
        }, child: Text("Sign in with Apple ")),
      )


    );
  }
}

