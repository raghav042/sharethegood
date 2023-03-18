import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/functions/profile_image.dart';
import 'package:sharethegood/ui/screens/home_screen.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String status = "";
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Hi ${widget.name}",
                    style: TextStyle(fontSize: 30, color: colorScheme.primary),
                  ),
                  const SizedBox(
                    height: 10,
                    width: double.infinity,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Complete profile for ",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 150,
                    width: 320,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          status = "Individual";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: status == "Individual"
                              ? colorScheme.surface
                              : colorScheme.primaryContainer,
                          foregroundColor: status == "Individual"
                              ? colorScheme.onSurface
                              : colorScheme.onPrimaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.person,
                            size: 40,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Individual",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          status = "NGO";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: status == "NGO"
                              ? colorScheme.surface
                              : colorScheme.secondaryContainer,
                          foregroundColor: status == "NGO"
                              ? colorScheme.onSurface
                              : colorScheme.onSecondaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.volunteer_activism,
                            size: 40,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "NGO",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          status = "Library";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: status == "Library"
                              ? colorScheme.surface
                              : colorScheme.tertiaryContainer,
                          foregroundColor: status == "Library"
                              ? colorScheme.onSurface
                              : colorScheme.onTertiaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.local_library,
                            size: 40,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Library",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 50,
              width: 320,
              child: ElevatedButton(
                  onPressed: status != ""
                      ? () {
                          saveInfo();
                        }
                      : null,
                  child: const Text("Save")),
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveInfo() async {
    final navigator = Navigator.of(context);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      "type": status,
      "photoUrl": profileImage(status)!,
    }).then((value) {
      navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }
}
