import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tinder_pet/view/login_view.dart';
import 'package:tinder_pet/view/pet_view.dart'; // Importa o PetGrid
import 'package:tinder_pet/controller/profile_controller.dart'; // Importa o controller

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController profileController = ProfileController();
  List<Map<String, dynamic>> userPets =
      []; // Lista para armazenar os pets doados pelo usuário

  @override
  void initState() {
    super.initState();
    _fetchUserPets(); // Chama a função para buscar os pets ao inicializar a tela
  }

  Future<void> _fetchUserPets() async {
    // Busca os dados do usuário
    final userData = await profileController.fetchUserData();
    if (userData == null || userData['id'] == null) {
      return; // Se não houver dados do usuário, interrompe a execução
    }

    // Busca os pets do usuário no Supabase
    final response = await Supabase.instance.client
        .from('pet')
        .select()
        .eq('doador', userData['id']); // Filtra os pets pelo campo 'doador'

    setState(() {
      userPets = List<Map<String, dynamic>>.from(
          response as List); // Atualiza o estado
    });

    print(userPets); // Confirma que os dados estão corretos
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Perfil'),
    ),
    body: FutureBuilder<Map<String, dynamic>?>(
      future: profileController.fetchUserData(), // Chama o método do controller
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

        return SingleChildScrollView( // Adiciona a rolagem
          child: Padding(
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
                  'Número de Pets Cadastrados: ${userPets.length}', // Atualiza o número com base no tamanho do array
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Supabase.instance.client.auth.signOut(); // Lógica de logout
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                    );
                  },
                  child: const Text('Logout'),
                ),
                const SizedBox(height: 40),

                // Garante que o PetGrid só seja exibido após os dados serem carregados
                userPets.isEmpty 
                  ? const Text("Nenhum pet doado ainda.") // Mensagem quando não há pets
                  : PetGrid(pets: userPets), // Exibe o PetGrid com os pets
              ],
            ),
          ),
        );
      },
    ),
  );
}
}