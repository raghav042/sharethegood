import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:sharethegood/services/preferences.dart';
import 'app.dart';
import 'services/firebase_crashlytics.dart';
import 'services/system_style.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  catchError();
  await Preferences.initPreferences();
  setUIStyle();
  runApp(const Application());
}