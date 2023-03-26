import 'package:flutter/widgets.dart';
import 'app.dart';
import 'services/firebase_crashlytics.dart';
import 'services/firebase_messaging.dart';
import 'services/system_style.dart';
import 'services/initialize_firebase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  //await initializeFcm();
  catchError();
  setUIStyle();
  runApp(const Application());
}