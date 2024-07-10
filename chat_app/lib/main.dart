import 'package:flutter/material.dart';
import 'package:chat_app/screen/home.dart';
import 'package:chat_app/screen/auth.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FlutterChat',
        theme: ThemeData().copyWith(
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: Color.fromARGB(255, 255, 220, 24),
          ),
        ),
        home: AuthScreen());
  }
}
