import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class PetController {
  List<Map<String, dynamic>> pets = [];
  Set<String> speciesCategories = {};

  // Carrega os dados do arquivo JSON e extrai as categorias (espécies)
  Future<void> loadPetsFromFile() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/pets.json');
      List<dynamic> jsonResponse = jsonDecode(jsonString);
      pets = jsonResponse.cast<Map<String, dynamic>>();

      // Extrai as categorias únicas de espécies
      speciesCategories = pets.map((pet) => pet['especie'] as String).toSet();
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

  // Filtra pets por endereço
  List<Map<String, dynamic>> searchPetsByAddress(String address) {
    return pets.where((pet) {
      final addressLower = pet['endereco'].toLowerCase();
      final queryLower = address.toLowerCase();
      return addressLower.contains(queryLower);
    }).toList();
  }

  // Adiciona um novo pet e salva no arquivo JSON
  Future<void> addPet(Map<String, dynamic> newPet) async {
    pets.add(newPet);
    await _savePetsToFile();
  }

  // Remove um pet com base no ID
  Future<void> removePet(int id) async {
    pets.removeWhere((pet) => pet['id'] == id);
    await _savePetsToFile();
  }

  // Edita um pet existente
  Future<void> editPet(int id, Map<String, dynamic> updatedPet) async {
    final index = pets.indexWhere((pet) => pet['id'] == id);
    if (index != -1) {
      pets[index] = updatedPet;
      await _savePetsToFile();
    }
  }

  // Salva a lista atualizada de pets no arquivo JSON
  Future<void> _savePetsToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/assets/data/pets.json');
      final jsonString = jsonEncode(pets);
      await file.writeAsString(jsonString);
    } catch (e) {
      print("Erro ao salvar pets: $e");
    }
  }
}
