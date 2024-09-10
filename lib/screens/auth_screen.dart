import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integration_bee_helper/services/basic_services/auth_service.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/widgets/max_width_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    monitorAuthenticationState();
    super.initState();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  String errorMessage = "";
  String email = "";
  String password = "";
  User? user;

  void monitorAuthenticationState() {
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        print("Authentication: User logged in");
      } else {
        print("Authentication: User logged out");
      }
      setState(() {
        this.user = user;
      });
    });
  }

  // Form

  final formKey = GlobalKey<FormState>();

  String? emailAddressValidator(String? email) {
    if (email == null || !email.contains("@")) {
      return MyIntl.of(context).pleaseEnterAValidEmail;
    }
    return null;
  }

  String? passwordValidator(String? password) {
    if (password == null || password.length < 5) {
      return MyIntl.of(context).passwordTooShort;
    } else if (password.length > 25) {
      return MyIntl.of(context).passwordTooLong;
    }
    return null;
  }

  onRegisterFormSubmitted() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      AuthService.registerAccountUsingEmail(
        email: email,
        password: password,
        onError: (error) => setState(() => errorMessage = error),
      );
    }
  }

  onLoginFormSubmitted() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      AuthService.loginUsingEmail(
        email: email,
        password: password,
        onError: (error) => setState(() => errorMessage = error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Image.asset(
              'assets/images/background.png',
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.24),
            ),
            MaxWidthWrapper(
              maxWidth: 550,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              MyIntl.of(context).authentication,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                icon: const Icon(Icons.email),
                                labelText: MyIntl.of(context).email,
                              ),
                              validator: emailAddressValidator,
                              onSaved: (value) {
                                email = value ?? "";
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                icon: const Icon(Icons.lock),
                                labelText: MyIntl.of(context).password,
                              ),
                              validator: passwordValidator,
                              onSaved: (value) {
                                password = value ?? "";
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: onRegisterFormSubmitted,
                                    child: Text(MyIntl.of(context).register),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: onLoginFormSubmitted,
                                    child: Text(MyIntl.of(context).login),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  MyIntl.of(context).copyrightNotice(DateTime.now().year),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    final Uri url = Uri.parse(
                      'https://github.com/paul019/integration_bee_helper',
                    );
                    launchUrl(url);
                  },
                  icon: Image.asset(
                    'assets/images/github-mark.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
