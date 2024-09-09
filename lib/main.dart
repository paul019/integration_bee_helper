import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';
import 'package:integration_bee_helper/screens/auth_screen.dart';
import 'package:integration_bee_helper/screens/home_screen.dart';
import 'package:integration_bee_helper/services/basic_services/auth_service.dart';
import 'package:integration_bee_helper/services/settings_service/settings_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          final user = Provider.of<User?>(context);

          return StreamProvider<SettingsModel?>.value(
            initialData: null,
            value: user != null
                ? SettingsService().onSettingsChanged(user.uid)
                : null,
            builder: (context, snapshot) {
              final settings = Provider.of<SettingsModel?>(context);

              return MaterialApp(
                title: 'Heidelberg Integration Bee',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color.fromARGB(255, 6, 81, 158),
                  ),
                  useMaterial3: true,
                ),
                debugShowCheckedModeBanner: false,
                home: const Wrapper(),
                locale: settings?.locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: SettingsModel.availableLanguages
                    .map((languageCode) => Locale(languageCode))
                    .toList(),
              );
            },
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
