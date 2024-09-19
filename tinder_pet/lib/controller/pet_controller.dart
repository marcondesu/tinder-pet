import 'package:supabase_flutter/supabase_flutter.dart';

class PetController {
  final SupabaseClient _client = Supabase.instance.client;
  List<Map<String, dynamic>> _pets = [];

  Future<void> loadPetsFromSupabase() async {
    final response = await _client
        .from('pet')
        .select();

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
    final Set<String> categories = {};
    for (var pet in _pets) {
      final species = pet['especie'] as String?;
      if (species != null && species.isNotEmpty) {
        categories.add(species.toLowerCase());
      }
    }
    return categories;
  }
}
