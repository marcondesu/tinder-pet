import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io'; // Para manipular arquivos

class SignupController {
  Future<List<dynamic>> _loadUsers() async {
    final String response = await rootBundle.loadString('data/usuarios.json');
    final List<dynamic> users = jsonDecode(response);
    return users;
  }

  Future<void> _saveUsers(List<dynamic> users) async {
    final String jsonString = jsonEncode(users);
    final file = File('assets/users.json');
    await file.writeAsString(jsonString); // Atualiza o arquivo com os novos dados
  }

  void handleSignup(
    BuildContext context,
    String nome,
    String email,
    String senha,
    String confirmacaoSenha,
    // String dataNascimento,
    // String endereco,
    // bool temOutrosPets,
    // bool temCriancas,
    // String tipoMoradia,
  ) async {
    final List<dynamic> users = await _loadUsers();
    final userExists = users.any((user) => user['email'] == email);

    if (userExists) {
      _showDialog(context, 'Erro', 'E-mail já cadastrado.');
    } else {
      final newUser = {
        'id': 'u${users.length + 1}',
        'nome': nome,
        // 'dataNascimento': dataNascimento,
        // 'endereco': endereco,
        'email': email,
        'senha': senha,
        'confirmacao_senha': confirmacaoSenha,
        // 'temOutrosPets': temOutrosPets,
        // 'temCriancas': temCriancas,
        // 'tipoMoradia': tipoMoradia,
      };

      users.add(newUser);
      await _saveUsers(users);
      _showDialog(context, 'Sucesso', 'Cadastro realizado com sucesso!');
    }
  }

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
