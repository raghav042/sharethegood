import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'info_screen.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signupKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

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
          key: _signupKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
                width: double.infinity,
              ),
              const Text(
                "Share The Goods",
                style: TextStyle(fontSize: 25),
              ),
              const Text("Welcomes you"),
              const SizedBox(height: 15),
              Image.asset(
                "assets/signup.jpg",
                height: 250,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: TextFormField(
                  controller: nameController,
                  validator: validateName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                      labelText: "Name",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder()),
                ),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: showConfirmPassword,
                  validator: validateConfirmPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: const Icon(Icons.vpn_key),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showConfirmPassword = !showConfirmPassword;
                          });
                        },
                        icon: Icon(showConfirmPassword
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
                      signUpWithEmail();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLoading ? "Signing up" : "Register",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 20),
                        isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already Registered?"),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                      },
                      child: const Text("Login"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return "enter valid name";
    } else {
      return null;
    }
  }

  String? validateMail(String? mail) {
    if (mail == null || mail.isEmpty) {
      return "enter email";
    } else if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(mail)) {
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

  String? validateConfirmPassword(String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Enter ConfirmPassword";
    } else if (confirmPassword != passwordController.text) {
      return "password and confirm password must be same";
    } else {
      return null;
    }
  }

  Future<void> signUpWithEmail() async {
    final navigator = Navigator.of(context);

    //validate user details
    _signupKey.currentState?.save();
    if (!_signupKey.currentState!.validate()) {
      return;
    }
    //show loading indicator
    setState(() {
      isLoading = true;
    });
    try {
      //create user
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = userCredential.user;
      if (user != null) {
        //save user data to firestore
        await firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "type": "",
          "joinAt": DateTime.now(),
          "photoUrl": "",

        }).then((value) {
          // stop loading indicator
          setState(() {
            isLoading = false;
          });
          // navigate to HomeScreen
          navigator.pushReplacement(MaterialPageRoute(
              builder: (context) => InfoScreen(
                    name: nameController.text.trim(),
                  )));
        });
      }
      //catch error
    } on FirebaseAuthException catch (e) {
      //stop loading indicator
      setState(() {
        isLoading = false;
      });
      //show error in snackbar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Something went wrong")),
      );
    }
  }
}
