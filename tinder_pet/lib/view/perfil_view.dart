import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tinder_pet/view/login_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Nenhum dado encontrado.'));
          }

          final userData = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.person, // Ícone de usuário
                    size: 50, // Tamanho do ícone
                  ),
                  /* backgroundImage: AssetImage(
                      'assets/profile_picture.png'), // Substitua por uma imagem de perfil real */
                ),
                const SizedBox(height: 20),
                Text(
                  userData['nome'] ?? 'Nome do Usuário',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Email: ${userData['email'] ?? 'usuario@exemplo.com'}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Número de Pets Adotados: ${userData['num_pets'] ?? '0'}', // Substitua com dados reais
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Lógica de logout
                    Supabase.instance.client.auth.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                    );
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> _fetchUserData() async {
    // Obter o usuário autenticado
    final user = Supabase.instance.client.auth.currentUser;

    // Verifica se o usuário está autenticado
    if (user == null) {
      return null;
    }

    // Converter os dados do usuário em um Map<String, dynamic>
    final Map<String, dynamic> userData = {
      'id': user.id,
      'email': user.email,
      'createdAt': user.createdAt.toString(),
      'updatedAt': user.updatedAt?.toString(),
      'appMetadata': user.appMetadata,
      'userMetadata': user.userMetadata,
      'lastSignInAt': user.lastSignInAt?.toString(),
      'role': user.role,
    };

    return userData;
  }
}
