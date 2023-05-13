import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/services/firebase_helper.dart';
import 'package:sharethegood/ui/home/home_screen.dart';
import 'package:sharethegood/ui/login/registration_screen.dart';
import 'signin_screen.dart';
import '../../services/get_location.dart';

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
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  static const List<String> listUserType = ["Individual", "Ngo", "Library"];
  CountryCode countryCode = CountryCode.fromDialCode("+91");
  String userType = "Individual";
  AppLocation? appLocation;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
                height: 60,
                width: double.infinity,
              ),
              const Text(
                "Share The Goods",
                style: TextStyle(fontSize: 25),
              ),
              const Text("Welcomes you"),
              const SizedBox(height: 10),
              // Image.asset(
              //   "assets/signup.jpg",
              //   height: 250,
              // ),
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 25,
                ),
                child: TextFormField(
                  controller: nameController,
                  validator: validateName,
                  keyboardType: TextInputType.name,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 25,
                ),
                child: TextFormField(
                  controller: emailController,
                  validator: validateMail,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.alternate_email),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 25,
                ),
                child: TextFormField(
                  controller: phoneController,
                  validator: validatePhone,
                  keyboardType: TextInputType.phone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: "Phone number",
                    //prefixIcon: Icon(Icons.call),
                    prefixIcon: CountryCodePicker(
                      onChanged: (value) {
                        setState(() {
                          countryCode = value;
                        });
                      },
                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                      initialSelection: 'IN',
                      favorite: const ['+91', 'IN'],
                      // optional. Shows only country name and flag
                      showCountryOnly: false,
                      // optional. Shows only country name and flag when popup is closed.
                      showOnlyCountryWhenClosed: false,
                      // optional. aligns the flag and the Text left
                      alignLeft: false,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              buildUserType(colorScheme),
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
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              appLocation == null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                      child: SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          onPressed: () async {
                            appLocation = await getLocation();
                            setState(() {});
                          },
                          child: Text(
                            "get Location",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),

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

  Widget buildUserType(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 25,
      ),
      child: InputDecorator(
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(6),
          border: OutlineInputBorder(),
        ),
        child: DropdownButton<String>(
            isExpanded: true,
            value: userType,
            hint: const Row(
              children: [
                Icon(Icons.category),
                SizedBox(width: 15),
                Text("User Type"),
              ],
            ),
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onBackground,
            ),
            borderRadius: BorderRadius.circular(8.0),
            underline: const SizedBox(),
            items: listUserType
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Row(
                        children: [
                          const Icon(Icons.category),
                          const SizedBox(width: 15),
                          Text(e),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                userType = value!;
              });
            }),
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
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(mail)) {
      return "enter valid mail";
    } else {
      return null;
    }
  }

  String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return "Enter Phone Number";
    } else if (phone.length < 6) {
      return "phone number should be equals to 10 digits";
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
        final data = {
          "uid": user.uid,
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "type": userType,
          "joinAt": DateTime.now().minute,
          "give": 0,
          "take": 0,
          "latitude": appLocation?.latitude ?? 0.0,
          "longitude": appLocation?.longitude ?? 0.0,
          "address": "",

          "phone": countryCode.dialCode! + phoneController.text.trim(),
          "photoUrl": "https://firebasestorage.googleapis.com/v0/b/share-the-good.appspot.com/o/appdata%2FprofileImage%2Fuser.png?alt=media&token=c4a1261c-ea59-422a-be82-8310d613f114",
        };

        //save user data to firestore
        await firestore
            .collection("users")
            .doc(user.uid)
            .set(data)
            .then((value) async {
          await FirebaseHelper.saveUserData(data);

          // stop loading indicator
          setState(() {
            isLoading = false;
          });

          // navigate to HomeScreen
          navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (_) => userType != "Individual"
                      ? RegistrationScreen(accountType: userType)
                      : const HomeScreen()),
              (route) => false);
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
