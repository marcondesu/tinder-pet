import 'package:flutter/material.dart';
import 'package:tinder_pet/view/home_view.dart';
import 'package:tinder_pet/view/login_view.dart';
import 'package:tinder_pet/view/pet_detail_view.dart';
import 'package:tinder_pet/view/pet_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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
        // '/register': (context) => const RegisterView(),
        '/pets': (context) => const PetsView(),
        '/pet-detail': (context) => const PetDetailView(),
      },
    );
  }
}

/* import 'package:flutter/material.dart';
import 'package:tinder_pet/view/pet_view.dart';
import 'package:tinder_pet/view/login_view.dart';
import 'package:tinder_pet/view/home_view.dart';
import 'package:tinder_pet/view/pet_detail_view.dart';
import 'package:tinder_pet/view/cadastro_pet_view.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomeView(),
      '/login': (context) => LoginView(),
      '/pet': (context) => PetDetailView(),
      '/pets': (context) => PetsView(),
      '/cadastropet': (context) => PetCadastroView(),
      // '/register': (context) => RegisterScreen(),
    },
  ));
} */