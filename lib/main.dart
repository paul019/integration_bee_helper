import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:integration_bee_helper/screens/auth_screen.dart';
import 'package:integration_bee_helper/screens/home_screen.dart';
import 'package:integration_bee_helper/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
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
    return StreamProvider<User?>.value(
        initialData: null,
        value: AuthService.onAuthStateChanged,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Heidelberg Integration Bee',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            home: const Wrapper(),
          );
        });
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<User?>(context);

    if (authModel == null) {
      return const AuthScreen();
    } else {
      return const HomeScreen();
    }
  }
}