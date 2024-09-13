import 'package:flutter/material.dart';

class PetDetailView extends StatelessWidget {
  final String petImage = 'pet.png'; // Substitua pela imagem do pet
  final String petName = 'Cat';
  final String address = '123 Anywhere St., Any City';
  final String gender = 'Female';
  final int age = 2;
  final double weight = 22;
  final String ownerImage = 'package:tinder_pet/assets/images/owner.jpg'; // Substitua pela imagem do dono
  final String ownerName = 'Marceline';
  final String ownerDescription = 'Are you looking for a new furry friend? Search resident pets near you and discover their adoption details.';
  final String whatsappUrl = 'https://wa.me/551234567890';

  const PetDetailView({super.key}); // Substitua pelo número do WhatsApp do dono

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(petName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.asset(petImage),
              const SizedBox(height: 16),
              Text(
                address,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ... seus cards de sexo, idade e peso aqui
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset('asssets/images/dog.png')
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ownerName),
                      Text(ownerDescription),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.chat),
                    onPressed: () {
                      // Abrir o WhatsApp com o número do dono
                      // ...
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Lógica para iniciar o processo de adoção
                },
                child: const Text('Adotar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}