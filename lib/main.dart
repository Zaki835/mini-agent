import 'package:flutter/material.dart';
import 'package:mini_agent_browser/screens/browser_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Agent Browser',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.blue.shade800,
          secondary: Colors.blue.shade600,
          surface: Colors.grey.shade900,
          background: Colors.grey.shade900,
        ),
        scaffoldBackgroundColor: Colors.grey.shade900,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade850,
          elevation: 1,
        ),
      ),
      home: const BrowserScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
