import 'package:flutter/material.dart';

class PetDetailView extends StatelessWidget {
  final Map<String, dynamic> pet;

  const PetDetailView({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet['nome']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${pet['nome']}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Idade: ${pet['idade']} anos'),
            SizedBox(height: 10),
            Text('Endereço: ${pet['localizacao']}'),
            SizedBox(height: 10),
            Text('Sexo: ${pet['sexo']}'),
            SizedBox(height: 10),
            Text('Temperamento: ${pet['temperamento']}'),
            SizedBox(height: 10),
            Text('Status: ${pet['status']}'),
          ],
        ),
      ),
    );
  }
}
