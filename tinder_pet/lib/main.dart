import 'package:flutter/material.dart';
import 'package:tinder_pet/controller/pet_controller.dart';
import 'package:tinder_pet/view/add_pet_view.dart';
import 'package:tinder_pet/view/login_view.dart';
import 'package:tinder_pet/view/main_view.dart';
import 'package:tinder_pet/view/pet_view.dart';
import 'package:tinder_pet/view/register_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://agzmhzmfelypeykycwsb.supabase.co/',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFnem1oem1mZWx5cGV5a3ljd3NiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjY2ODY5OTAsImV4cCI6MjA0MjI2Mjk5MH0.7vgRhiRuX_iQKfTOzj1fRYZjgi5kSEoHKK13ftbKI0o',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final PetController petController = PetController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tinder Pet',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginView(),
      routes: {
        '/register': (context) => const SignupView(),
        '/pets': (context) => const PetsView(),
        '/add-pet': (context) => AddPetView(controller: petController),
        '/main': (context) => MainScreen(petController: petController),
      },
    );
  }
}
