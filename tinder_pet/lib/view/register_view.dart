import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tinder_pet/view/login_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  //Sign Up User
  Future<void> signUp() async {
    try {
      // Cadastro do usuário com Supabase Auth
      final response = await Supabase.instance.client.auth.signUp(
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
        data: {'username': nameController.text.trim()},
      );

      // Verifica se o cadastro foi bem-sucedido
      if (response.user != null) {
        // Obtém o ID do usuário criado
        final userId = response.user!.id;

        // Insere o usuário na tabela 'usuario' com os dados adicionais
        final insertResponse = await Supabase.instance.client
            .from('usuario')
            .insert({
          'id': userId,
          'nome': nameController.text.trim(),
          'email': emailController.text.trim(),
          'telefone': phoneController.text.trim(),
        });

        if (insertResponse != null) {
          debugPrint('Erro ao inserir na tabela usuario: ${insertResponse}');
        }

        // Redireciona para a tela de login após o cadastro
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      } else {
        debugPrint('Erro ao cadastrar usuário: ${response}');
      }
    } on AuthException catch (e) {
      debugPrint(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
              ),
              const SizedBox(height: 16),
              IntlPhoneField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'BR',
                showCountryFlag: false,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: signUp, // Chama a função de cadastro
                child: const Text('Cadastrar'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginView(),
                    ),
                  );
                },
                child: const Text('Já tenho conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
