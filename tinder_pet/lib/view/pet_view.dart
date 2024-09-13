import 'package:flutter/material.dart';
import 'package:tinder_pet/controller/pet_controller.dart';

class PetsView extends StatefulWidget {
  const PetsView({super.key});

  @override
  _PetsViewState createState() => _PetsViewState();
}

class _PetsViewState extends State<PetsView> {
  final PetController controller = PetController();
  List<Map<String, String>> pets = [];
  List<Map<String, String>> filteredPets = [];

  @override
  void initState() {
    super.initState();
    pets = controller.fetchPets(); // Carrega a lista de pets
    filteredPets = pets; // Inicialmente, todos os pets são exibidos
  }

  void _onSearchChanged(String query) {
    setState(() {
      filteredPets = controller.searchPets(query, pets); // Filtra os pets com base na busca
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tinder Pet'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: ListView(
          children: [
            SearchBar(onSearchChanged: _onSearchChanged),
            const SizedBox(height: 20),
            const CategorySection(),
            const SizedBox(height: 20),
            PetGrid(pets: filteredPets),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;

  const SearchBar({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Search for pets',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CategoryItem(label: 'Cat', icon: Icons.pets),
        CategoryItem(label: 'Dog', icon: Icons.pets),
        CategoryItem(label: 'Rabbit', icon: Icons.pets),
      ],
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String label;
  final IconData icon;

  const CategoryItem({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          child: Icon(icon, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

class PetGrid extends StatelessWidget {
  final List<Map<String, String>> pets;

  const PetGrid({super.key, required this.pets});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return PetCard(
          name: pet['name']!,
          age: pet['age']!,
          imageUrl: pet['imageUrl']!,
        );
      },
    );
  }
}

class PetCard extends StatelessWidget {
  final String name;
  final String age;
  final String imageUrl;

  const PetCard({
    super.key,
    required this.name,
    required this.age,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /* ClipRect(
            child: Image.asset(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ), */
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(age),
        ],
      ),
    );
  }
}
