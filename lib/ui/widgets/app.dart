import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:sharethegood/ui/screens/welcome/login_screen.dart';
import '../../core/dark_theme.dart';
import '../../core/light_theme.dart';
import 'auth_service.dart';

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        theme: lightTheme(lightColorScheme),
        darkTheme: darkTheme(darkColorScheme, context),
        themeMode: ThemeMode.system,
        home: AuthService(),
      );
    });
  }

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from a terminated state.
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    // if (message.data['type'] == 'chat') {
    //   Navigator.pushNamed(context, '/chat',
    //     arguments: ChatArguments(message),
    //   );
    // }
  }
}
