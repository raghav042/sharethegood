import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/services/firebase_helper.dart';
import 'package:sharethegood/ui/home/home_screen.dart';
import 'package:sharethegood/ui/login/signup_screen.dart';
import 'package:sharethegood/ui/main_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _loginKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  bool showPassword = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: _loginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
                width: double.infinity,
              ),
              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 25),
              ),
              const Text("Welcomes you"),
              const SizedBox(height: 15),
              Image.asset(
                "assets/login.jpg",
                height: 250,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: TextFormField(
                  controller: emailController,
                  validator: validateMail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.alternate_email),
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: showPassword,
                  validator: validatePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.vpn_key),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: Icon(showPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                      border: const OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 40, 25, 20),
                child: SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    onPressed: () {
                      signInWithEmail();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLoading ? "Signing In" : "Login",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 20),
                        isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                      },
                      child: const Text("Register"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateMail(String? mail) {
    if (mail == null || mail.isEmpty) {
      return "enter email";
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(mail)) {
      return "enter valid mail";
    } else {
      return null;
    }
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Enter password";
    } else if (password.length < 6) {
      return "password should be greater than 6";
    } else {
      return null;
    }
  }

  Future<void> signInWithEmail() async {
    final navigator = Navigator.of(context);
    //validate user details
    _loginKey.currentState?.save();
    if (!_loginKey.currentState!.validate()) {
      return;
    }
    //show loading indicator
    setState(() {
      isLoading = true;
    });
    try {
      // login with email and password
      UserCredential? userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = userCredential.user;
      if (user != null) {
        await FirebaseHelper.getUserData(user.uid).then(
          (value) async => await FirebaseHelper.saveUserData(value),
        );

        //stop loading indicator
        setState(() {
          isLoading = false;
        });
        // navigate to HomeScreen

        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      //stop loading indicator
      setState(() {
        isLoading = false;
      });
      //show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Something went wrong")),
      );
    }
  }
}
