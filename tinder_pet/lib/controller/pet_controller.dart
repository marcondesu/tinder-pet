import 'dart:convert';
import 'package:flutter/services.dart';

class PetController {
  List<Map<String, dynamic>> pets = [];
  Set<String> speciesCategories = {};

  // Carrega os dados do arquivo JSON e extrai as categorias (espécies)
  Future<void> loadPetsFromFile() async {
    try {
      String jsonString = await rootBundle.loadString('data/pets.json');
      List<dynamic> jsonResponse = jsonDecode(jsonString);
      pets = jsonResponse.cast<Map<String, dynamic>>();

      // Extrai as categorias únicas de espécies
      speciesCategories = pets.map((pet) => pet['especie'] as String).toSet();
      print('Categorias encontradas: $speciesCategories');
    } catch (e) {
      print("Erro ao carregar pets: $e");
    }
  }

  // Retorna a lista de pets carregados
  List<Map<String, dynamic>> fetchPets() {
    return pets;
  }

  // Filtra os pets com base na busca por nome
  List<Map<String, dynamic>> searchPets(String query) {
    return pets.where((pet) {
      final nameLower = pet['nome'].toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();
  }
}
