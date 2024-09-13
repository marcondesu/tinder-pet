import 'package:flutter/material.dart';
import 'package:tinder_pet/controller/login_controller.dart';

class LoginView extends StatelessWidget {
  final LoginController controller = LoginController(); // Create an instance of the controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'E-mail',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              // Call the controller's handleLogin method
              onPressed: () => controller.handleLogin(context),
              child: Text('Entrar'),
            ),
            TextButton(
              onPressed: () {
                // Logic for forgot password screen (remains the same)
              },
              child: Text('Esqueci a senha'),
            ),
          ],
        ),
      ),
    );
  }
}