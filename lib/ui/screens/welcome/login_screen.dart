import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sharethegood/ui/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? accountType;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage()),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.none,
        ),
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black,
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isLoading
                    ? SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : SizedBox(),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 25,
                  ),
                  child: Text(
                    "I want to login as ${accountType ?? ""}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26, color: Colors.white),
                  ),
                ),
                // const Text(
                //   "ShareTheGoods uses Google login because it is secure and trusted",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontSize: 16,
                //     color: Colors.white,
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 55,
                      width: size / 2 - 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            accountType = "Library";
                          });
                        },
                        style:
                            buttonStyle(colorScheme, accountType == "Library"),
                        icon: const Icon(Icons.local_library),
                        label: Text(
                          "Library",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 55,
                      width: size / 2 - 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            accountType = "NGO";
                          });
                        },
                        style: buttonStyle(colorScheme, accountType == "NGO"),
                        icon: const Icon(Icons.volunteer_activism),
                        label: Text(
                          "NGO",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 55,
                  width: size,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        accountType = "Individual";
                      });
                    },
                    style:
                        buttonStyle(colorScheme, accountType == "Individual"),
                    icon: const Icon(Icons.person),
                    label: Text(
                      "Individual",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: accountType != null
                        ? () {
                            signInWithGoogle();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/google.png",
                          height: 55,
                          width: 55,
                        ),
                        Text(
                          "SignIn With Google",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 50),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signInWithGoogle() async {
    final navigator = Navigator.of(context);
    setState(() {
      isLoading = true;
    });
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;

    final authCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(authCredential);
    final user = userCredential.user;

    if (user != null) {
      if (userCredential.additionalUserInfo!.isNewUser) {
        //save user data to firestore
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "name": user.displayName,
          "email": user.email,
          "type": accountType,
          "joinAt": DateTime.now(),
          "photoUrl": user.photoURL,
        }).then((value) {
          // stop loading indicator
          setState(() {
            isLoading = false;
          });
        });
      }
      // navigate to HomeScreen
      navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false);
    }
  }

  ButtonStyle buttonStyle(ColorScheme colorScheme, bool isSelected) {
    return isSelected
        ? ElevatedButton.styleFrom()
        : ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          );
  }

  String backgroundImage() {
    late String image;
    switch (accountType) {
      case "Individual":
        image = "assets/donations/volunteer.jpg";
        break;
      case "Library":
        image = "assets/donations/books.jpg";
        break;
      case "NGO":
        image = "assets/donations/food.jpg";
        break;
      case null:
        image = "assets/donations/poor1.jpg";
        break;
    }
    return image;
  }
}
