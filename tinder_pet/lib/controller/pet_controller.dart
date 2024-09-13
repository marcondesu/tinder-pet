import 'package:flutter/material.dart';

class PetController {
  // Função para buscar a lista de pets
  List<Map<String, String>> fetchPets() {
    // Simulando a obtenção de pets (normalmente isso viria de uma API ou banco de dados)
    return [
      {'name': 'Olivia', 'age': '2 years', 'imageUrl': 'assets/cat.png'},
      {'name': 'Pedro', 'age': '3 years', 'imageUrl': 'assets/dog.png'},
      {'name': 'Fluffy', 'age': '1 year', 'imageUrl': 'rabbit.jpeg'},
      {'name': 'Max', 'age': '4 years', 'imageUrl': 'assets/dog.png'},
      {'name': 'Max', 'age': '4 years', 'imageUrl': 'assets/dog.png'},
      {'name': 'Max', 'age': '4 years', 'imageUrl': 'assets/dog.png'},
    ];
  }

  // Função de busca para filtrar pets
  List<Map<String, String>> searchPets(String query, List<Map<String, String>> pets) {
    return pets
        .where((pet) => pet['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
