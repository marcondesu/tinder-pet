import 'package:flutter/material.dart';
import 'package:tinder_pet/view/add_pet_view.dart';
import 'package:tinder_pet/view/perfil_view.dart';
import 'package:tinder_pet/controller/pet_controller.dart';
import 'package:tinder_pet/view/pet_view.dart';

class MainScreen extends StatefulWidget {
  final PetController? petController;

  const MainScreen({Key? key, this.petController}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Lista das telas para navegação
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      const PetsView(), // Home Page
      AddPetView(), // Add Pet Page
      const ProfileView(), // Profile Page
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Exibe a página selecionada
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Pet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
