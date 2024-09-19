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

  @override
  void initState() {
    super.initState();
    _loadPets(); // Carrega os pets quando a tela inicia
  }

  Future<void> _loadPets() async {
    await controller.loadPetsFromSupabase(); // Carrega os pets do Supabase
    setState(() {
      pets = controller.fetchPets(); // Carrega a lista de pets
      filteredPets = pets; // Inicializa a lista de pets filtrados
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      filteredPets = controller.searchPets(query); // Atualiza a busca
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tinder Pet'),
        centerTitle: true,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.add), // Ícone de adição para cadastrar um pet
            onPressed: () {
              // Navegar para a tela de cadastro de pet
              Navigator.pushNamed(context, '/add-pet');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: ListView(
          children: [
            SearchBar(onSearchChanged: _onSearchChanged), // Campo de busca
            const SizedBox(height: 20),
            const FindPetSection(), // Seção "Encontre um pet"
            const SizedBox(height: 20),
            CategorySection(
                categories: controller
                    .speciesCategories), // Seção de categorias de espécies
            const SizedBox(height: 20),
            PetGrid(pets: filteredPets), // Grade de pets filtrados
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
                  builder: (context) =>
                      const MapView(), // Navegar para a tela do mapa
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

// Seção que exibe as categorias de espécies
class CategorySection extends StatelessWidget {
  final Set<String> categories;

  const CategorySection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((category) {
        return CategoryItem(label: category, icon: Icons.pets);
      }).toList(),
    );
  }
}

// Item de categoria
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

// Grade que exibe os pets
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
      ),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return PetCard(
          name: pet['nome'] ?? '',
          age: pet['idade']?.toString() ?? '',
          address: pet['localizacao'] ?? 'Endereço desconhecido',
          pet: pet, // Passa o objeto completo para a página de detalhes
        );
      },
    );
  }
}

// Cartão que exibe as informações de um pet
// Cartão que exibe as informações de um pet
class PetCard extends StatelessWidget {
  final String name;
  final String age;
  final String address;
  final Map<String, dynamic> pet;

  const PetCard({
    super.key,
    required this.name,
    required this.age,
    required this.address,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetDetailView(
                pet: pet), // Redireciona para a página de detalhes
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('$age anos'),
            Text(address),
          ],
        ),
      ),
    );
  }
}
