import 'package:flutter/material.dart';
import 'package:tinder_pet/view/pet_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MVC',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PetView(),
    );
  }
}