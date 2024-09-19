import 'package:flutter/material.dart';
import 'package:tinder_pet/controller/pet_controller.dart';
import 'package:tinder_pet/view/add_pet_view.dart';
import 'package:tinder_pet/view/login_view.dart';
import 'package:tinder_pet/view/main_view.dart';
import 'package:tinder_pet/view/pet_view.dart';
import 'package:tinder_pet/view/register_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
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
        '/add-pet': (context) => AddPetView(),
        '/main': (context) => MainScreen(petController: petController),
      },
    );
  }
}
