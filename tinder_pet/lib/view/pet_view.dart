import 'package:flutter/material.dart';
import 'package:tinder_pet/controller/pet_controller.dart';
import 'package:tinder_pet/view/map_view.dart';
import 'package:tinder_pet/view/pet_detail_view.dart';

class PetsView extends StatefulWidget {
  const PetsView({super.key});

  @override
  _PetsViewState createState() => _PetsViewState();
}

class _PetsViewState extends State<PetsView> {
  final PetController controller = PetController();
  List<Map<String, dynamic>> pets = [];
  List<Map<String, dynamic>> filteredPets = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    await controller.loadPetsFromSupabase();
    setState(() {
      pets = controller.fetchPets();
      filteredPets = pets;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      filteredPets = controller.searchPets(query);
      if (selectedCategory != null) {
        filteredPets = filteredPets.where((pet) {
          final species = pet['especie']?.toLowerCase() ?? '';
          return species == selectedCategory!.toLowerCase();
        }).toList();
      }
    });
  }

  void _clearFilters() {
    setState(() {
      selectedCategory = null;
      filteredPets = pets;
    });
  }

  void _onCategorySelected(String category) {
    if (category == 'todos') {
      _clearFilters();
    } else {
      setState(() {
        selectedCategory = category;
        filteredPets = pets.where((pet) {
          final species = pet['especie']?.toLowerCase() ?? '';
          return species == selectedCategory!.toLowerCase();
        }).toList();
      });
    }
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
            const FindPetSection(),
            const SizedBox(height: 20),
            const Text(
              "Categorias",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            CategorySection(
              categories: {'todos', ...controller.speciesCategories},
              onCategorySelected: _onCategorySelected,
            ),
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
        hintText: 'Pesquise um pet',
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

class FindPetSection extends StatelessWidget {
  const FindPetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Encontre um pet perto de você',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapView(),
                ),
              );
            },
            child: const Text('Procurar agora'),
          ),
        ],
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final Set<String> categories;
  final Function(String) onCategorySelected;

  const CategorySection({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((category) {
        return CategoryItem(
          label: category,
          icon: Icons.pets,
          onTap: () => onCategorySelected(category),
        );
      }).toList(),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              child: Icon(icon, size: 30),
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class PetGrid extends StatelessWidget {
  final List<Map<String, dynamic>> pets;

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
        childAspectRatio: 3 / 2, // Ajuste de tamanho dos cards
      ),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return PetCard(
          name: pet['nome'] ?? '',
          age: pet['idade']?.toString() ?? '',
          // address: pet['localizacao'] ?? 'Endereço desconhecido',
          pet: pet,
        );
      },
    );
  }
}

class PetCard extends StatelessWidget {
  final String name;
  final String age;
  // final String address;
  final Map<String, dynamic> pet;

  const PetCard({
    super.key,
    required this.name,
    required this.age,
    // required this.address,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    // Supondo que o campo de URL da imagem seja 'imagem_url'
    final String? imageUrl = pet['imagem_url'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetDetailView(pet: pet),
          ),
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover, // Preenche todo o card
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3), // Para escurecer a imagem
                        BlendMode.darken,
                      ),
                    )
                  : null, // Se não houver imagem, não aplica background
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white, // Para ficar visível sobre a imagem
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$age anos',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white, // Cor branca para melhor contraste
                    ),
                  ),
                  // const SizedBox(height: 4),
                  // Text(
                  //   address,
                  //   style: const TextStyle(
                  //     fontSize: 14,
                  //     color: Colors.white, // Cor branca para o endereço
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
