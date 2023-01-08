import 'dart:developer';

import 'package:authandforget/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Auth and Forget")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(hintText: "Email"),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(hintText: "Password"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () => login(), child: const Text("Login")),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () => signUp(), child: const Text("Signup")),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () => forgotPassword(),
                  child: const Text("Forgot Password"))
            ],
          ),
        ),
      ),
    );
  }

  void forgotPassword() async {
    if (emailController.text.isEmpty) {
      log("Email is empty");
    } else {
      FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text)
          .whenComplete(() {
        log("A password reset email has been sent on the email");
      }).onError((error, stackTrace) {
        log(error.toString());
      });
    }
  }

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      log("One of the fields is empty");
    } else {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      }).onError((error, stackTrace) {
        log(error.toString());
      });
    }
  }

  void signUp() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      log("One of the fields is empty");
    } else {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        log("Signed up");
      }).onError((error, stackTrace) {
        log(error.toString());
      });
    }
  }
}
