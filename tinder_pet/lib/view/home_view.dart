import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
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
              child: Text('Tenho uma conta'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToRegister,
              child: Text('Criar uma conta'),
            ),
          ],
        ),
      ),
    );
  }
}