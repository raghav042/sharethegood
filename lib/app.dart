import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:sharethegood/ui/auth_service.dart';
import 'package:sharethegood/ui/login/signup_screen.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        theme: lightTheme(lightColorScheme),
        darkTheme: darkTheme(darkColorScheme, context),
        themeMode: ThemeMode.system,
        home: const AuthService(),
      );
    });
  }
}
