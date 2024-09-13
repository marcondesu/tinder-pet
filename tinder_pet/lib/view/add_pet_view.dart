import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'package:tinder_pet/controller/pet_controller.dart';

class AddPetView extends StatefulWidget {
  final PetController controller;

  const AddPetView({super.key, required this.controller});

  @override
  _AddPetViewState createState() => _AddPetViewState();
}

class _AddPetViewState extends State<AddPetView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _selectedSpecies = '';
  String _selectedSex = 'Fêmea';
  String _selectedSize = 'P';

  Set<String> _selectedTemperaments = {};
  Uint8List? _imageBytes;

  bool _isVaccinated = false;
  bool _isCastrated = false;
  bool _isSociable = false;

  // Função para selecionar a imagem
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  // Função para definir a espécie selecionada
  void _selectSpecies(String species) {
    setState(() {
      _selectedSpecies = species;
    });
  }

  // Função para selecionar o sexo
  void _selectSex(String sex) {
    setState(() {
      _selectedSex = sex;
    });
  }

  // Função para salvar os dados do pet
  Future<void> _savePet() async {
    if (_nameController.text.isNotEmpty &&
        _selectedSpecies.isNotEmpty &&
        _imageBytes != null) {
      // Cria o Map com os dados do pet
      Map<String, dynamic> newPet = {
        'id': Random().nextInt(1000),
        'nome': _nameController.text,
        'especie': _selectedSpecies,
        'sexo': _selectedSex,
        'idade': _ageController.text,
        'porte': _selectedSize,
        'temperamento': _selectedTemperaments.toList(),
        'vacinado': _isVaccinated,
        'castrado': _isCastrated,
        'sociavel': _isSociable,
        'foto': _imageBytes,
        'endereco': _addressController.text,
      };

      await widget.controller.addPet(newPet);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet cadastrado com sucesso!')),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
    }
  }

  // Função para alternar temperamentos
  void _toggleTemperament(String temperament) {
    setState(() {
      if (_selectedTemperaments.contains(temperament)) {
        _selectedTemperaments.remove(temperament);
      } else {
        _selectedTemperaments.add(temperament);
      }
    });
  }

  // Função para selecionar o porte
  void _selectSize(String size) {
    setState(() {
      _selectedSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Pet'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _imageBytes == null
                    ? const Center(
                        child: Text('Clique para adicionar uma foto'))
                    : Image.memory(_imageBytes!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Pet',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Endereço',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Idade (em anos)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            const Text(
              'Espécie do Pet:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _speciesButton('Cachorro'),
                _speciesButton('Coelho'),
                _speciesButton('Gato'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Sexo:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _genderButton('Fêmea'),
                _genderButton('Macho'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Porte:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _sizeButton('P'),
                _sizeButton('M'),
                _sizeButton('G'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Temperamento:'),
            Wrap(
              spacing: 10,
              children: [
                'Agressivo',
                'Brincalhão',
                'Curioso',
                'Hiperativo',
                'Quieto',
                'Medroso'
              ]
                  .map((temperament) => FilterChip(
                        label: Text(temperament),
                        selected: _selectedTemperaments.contains(temperament),
                        onSelected: (_) => _toggleTemperament(temperament),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Vacinado'),
              value: _isVaccinated,
              onChanged: (value) {
                setState(() {
                  _isVaccinated = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Castrado'),
              value: _isCastrated,
              onChanged: (value) {
                setState(() {
                  _isCastrated = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Sociável'),
              value: _isSociable,
              onChanged: (value) {
                setState(() {
                  _isSociable = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePet,
              child: const Text('Salvar Pet'),
            ),
          ],
        ),
      ),
    );
  }

  // Botão para seleção de espécie
  Widget _speciesButton(String species) {
    return ElevatedButton(
      onPressed: () => _selectSpecies(species),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _selectedSpecies == species ? Colors.blue : Colors.grey,
      ),
      child: Text(species),
    );
  }

  // Botão para seleção de sexo
  Widget _genderButton(String sex) {
    return ElevatedButton(
      onPressed: () => _selectSex(sex),
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedSex == sex ? Colors.blue : Colors.grey,
      ),
      child: Text(sex),
    );
  }

  // Botão para seleção de porte
  Widget _sizeButton(String size) {
  return ElevatedButton(
    onPressed: () => _selectSize(size),
    style: ElevatedButton.styleFrom(
      backgroundColor: _selectedSize == size ? Colors.blue : const Color.fromARGB(255, 221, 221, 221),
    ),
    child: Column(
      children: [
        Icon(
          Icons.pets,
          size: size == 'P' ? 30 : size == 'M' ? 40 : 50,
        ),
        const SizedBox(height: 5),
        Text(size),
      ],
    ),
  );
}

}