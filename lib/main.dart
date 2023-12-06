import 'package:flutter/material.dart';
import 'package:to_do/ui/home/home_screen.dart';
import 'package:to_do/ui/login/login_screen.dart';
import 'package:to_do/ui/register/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
void main()async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        RegisterScreen.routeName : (buildContext)=> RegisterScreen(),
        LoginScreen.routeName : (buildContext)=> LoginScreen(),
        HomeScreen.routeName : (buildContext)=>  HomeScreen(),
      },
      initialRoute: RegisterScreen.routeName,
      theme: ThemeData(
        textTheme: TextTheme(
          headline4: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black
          )
        ),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0XFFDFECDB),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0
        )
      ),
    );
  }
}

