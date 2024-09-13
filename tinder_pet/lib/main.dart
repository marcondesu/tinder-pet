import 'package:flutter/material.dart';
import 'package:tinder_pet/view/home_view.dart';
import 'package:tinder_pet/view/login_view.dart';
import 'package:tinder_pet/view/pet_view.dart';
import 'package:tinder_pet/view/register_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tinder Pet',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeView(),
      routes: {
        '/login': (context) => LoginView(),
        '/register': (context) => const SignupView(),
        '/pets': (context) => const PetsView(),
      },
    );
  }
}