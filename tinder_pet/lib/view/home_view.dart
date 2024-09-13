import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void _navigateToLogin() {
    Navigator.pushNamed(context, '/login'); // Substitua '/login' pelo nome da rota da tela de login
  }

  void _navigateToRegister() {
    Navigator.pushNamed(context, '/register'); // Substitua '/register' pelo nome da rota da tela de cadastro
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Tenho uma conta'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToRegister,
              child: const Text('Criar uma conta'),
            ),
          ],
        ),
      ),
    );
  }
}