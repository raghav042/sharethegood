import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/ui/screens/welcome/welcome_screen.dart';
import '../screens/home_screen.dart';
import '../screens/signin_screen.dart';
import '../screens/signup_screen.dart';

class AuthService extends StatelessWidget {
  const AuthService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const WelcomeScreen();
          } else if (snapshot.data != null) {
            return const HomeScreen();
          } else {
            return const WelcomeScreen();
          }
        });
  }
}
