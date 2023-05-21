import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/services/firebase_helper.dart';
import 'package:sharethegood/ui/login/welcome_screen.dart';
import 'main_screen.dart';

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
            return FirebaseHelper.userType == "Individual"? const IndividualMainScreen():


              const MainScreen();
          } else {
            return const WelcomeScreen();
          }
        });
  }
}
