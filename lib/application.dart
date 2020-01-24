
import 'package:flutter/material.dart';
import 'package:weather_oauth/screens/login_screen.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather OAuth',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
