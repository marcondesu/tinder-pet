import 'dart:convert'; // Para manipular JSON
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class LoginController {
  // Função para carregar os usuários do arquivo JSON
  Future<List<dynamic>> _loadUsers() async {
    final String response = await rootBundle.loadString('data/usuarios.json');
    final List<dynamic> users = jsonDecode(response);
    return users;
  }

  // Função de login
  void handleLogin(BuildContext context, String email, String senha) async {
    final List<dynamic> users = await _loadUsers();
    final user = users.firstWhere(
      (user) => user['email'] == email,
      orElse: () => null,
    );

    if (user == null) {
      _showDialog(context, 'Erro', 'E-mail não cadastrado.');
    } else if (user['senha'] != senha) {
      _showDialog(context, 'Erro', 'Senha incorreta.');
    } else {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) =>
      //           PetsView()), // Substitua PetsView pela sua tela de pets
      // );
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  // Função auxiliar para exibir diálogos
  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
