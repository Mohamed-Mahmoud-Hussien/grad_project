
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/auth/screens/splash_screen.dart';
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(); 
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tamkeen',

      theme: ThemeData.light(),

      
      darkTheme: ThemeData.dark().copyWith(
  scaffoldBackgroundColor: const Color(0xFF121212),

  cardColor: const Color(0xFF1E1E1E),
),

      themeMode:
          isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

      home: const SplashScreen(),
    );
  }
}
