import 'package:supabase_flutter/supabase_flutter.dart';

class PetController {
  final SupabaseClient _client = Supabase.instance.client;
  List<Map<String, dynamic>> _pets = [];

  Future<void> loadPetsFromSupabase() async {
    final response = await _client
        .from('pet')
        .select();

    // if (response.isEmpty) {
    //   // Tratar erros, exibir uma mensagem para o usuário, etc.
    //   print('Erro ao carregar pets: ${response}');
    //   return;
    // }

    _pets = List<Map<String, dynamic>>.from(response as List);
  }

  List<Map<String, dynamic>> fetchPets() {
    return _pets;
  }

  List<Map<String, dynamic>> searchPets(String query) {
    if (query.isEmpty) {
      return _pets;
    }

    return _pets.where((pet) {
      final name = pet['nome']?.toLowerCase() ?? '';
      return name.contains(query.toLowerCase());
    }).toList();
  }

  Set<String> get speciesCategories {
    // Exemplo de categorias, você pode buscar isso do banco também
    return {'Cachorro', 'Gato', 'Outro'};
  }
}
