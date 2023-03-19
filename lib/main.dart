import 'package:flutter/widgets.dart';
import 'package:sharethegood/core/data/user_data.dart';
import 'ui/widgets/app.dart';
import 'functions/firebase_crashlytics.dart';
import 'functions/firebase_messaging.dart';
import 'functions/system_style.dart';
import 'functions/initialize_firebase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  await initializeFcm();
  await UserData.getUserData();
  catchError();
  setUIStyle();
  runApp(const Application());
}
