import 'package:flutter/material.dart';
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
}