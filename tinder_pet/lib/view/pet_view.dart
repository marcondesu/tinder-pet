import 'package:flutter/material.dart';

class PetsView extends StatelessWidget {
  const PetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Adoption',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const PetAdoptionHomePage(),
    );
  }
}

class PetAdoptionHomePage extends StatelessWidget {
  const PetAdoptionHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PET ADOPTION'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          SearchBar(),
          SizedBox(height: 20),
          CategorySection(),
          SizedBox(height: 20),
          PetGrid(),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
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
  const CategorySection({Key? key}) : super(key: key);

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
  const PetGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: const [
        PetCard(name: 'Olivia', age: '2 years', imageUrl: 'assets/cat.png'),
        PetCard(name: 'Pedro', age: '3 years', imageUrl: 'assets/dog.png'),
        PetCard(name: 'Fluffy', age: '1 year', imageUrl: 'assets/rabbit.png'),
        PetCard(name: 'Max', age: '4 years', imageUrl: 'assets/dog.png'),
      ],
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
          Image.asset(imageUrl, height: 80),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(age),
        ],
      ),
    );
  }
}
