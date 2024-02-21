import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integration_bee_helper/services/auth_service.dart';
import 'package:integration_bee_helper/widgets/max_width_wrapper.dart';

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
      return "Please enter a valid email";
    }
    return null;
  }

  String? passwordValidator(String? password) {
    if (password == null || password.length < 5) {
      return "Password must be at least 5 characters";
    } else if (password.length > 25) {
      return "Password must be at most 25 characters";
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
      appBar: AppBar(
        title: const Text("Authentication"),
      ),
      body: MaxWidthWrapper(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 32.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: "Email",
                  ),
                  validator: emailAddressValidator,
                  onSaved: (value) {
                    email = value ?? "";
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 32.0,
                ),
                child: TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: "Password",
                  ),
                  validator: passwordValidator,
                  onSaved: (value) {
                    password = value ?? "";
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 32.0,
                ),
                child: Center(
                  child: Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 32.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: onRegisterFormSubmitted,
                      child: const Text('Register'),
                    ),
                    ElevatedButton(
                      onPressed: onLoginFormSubmitted,
                      child: const Text('Login'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
