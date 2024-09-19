import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:diacritic/diacritic.dart';
import 'package:tinder_pet/view/pet_view.dart'; // Import necessário para remover acentos

class AddPetView extends StatefulWidget {
  const AddPetView({super.key});

  @override
  _AddPetViewState createState() => _AddPetViewState();
}

class _AddPetViewState extends State<AddPetView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _selectedSpecies = '';
  String _selectedSex = 'Fêmea';
  String _selectedSize = 'Pequeno';

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

  // Função para salvar os dados no Supabase
// Função para remover acentos e converter para minúsculas
  String _normalizeEnumValue(String value) {
    return removeDiacritics(value.toLowerCase());
  }

Future<void> _savePetToSupabase() async {
  // Verificar se todos os campos obrigatórios estão preenchidos
  if (_nameController.text.isEmpty ||
      _selectedSpecies.isEmpty ||
      _imageBytes == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor, preencha todos os campos!')),
    );
    return;
  }

  // Transformar a lista de temperamentos em uma string
  String temperamentosString =
      _selectedTemperaments.map((t) => _normalizeEnumValue(t)).join(',');

  // Mapa com os dados do pet, normalizando os valores dos enums
  Map<String, dynamic> newPet = {
    'nome': _nameController.text,
    'especie': _normalizeEnumValue(_selectedSpecies),
    'sexo': _normalizeEnumValue(_selectedSex),
    'idade': int.tryParse(_ageController.text) ?? 0,
    'porte': _normalizeEnumValue(_selectedSize),
    'temperamento': temperamentosString,
    'vacinado': _isVaccinated,
    'castrado': _isCastrated,
    'sociavel': _isSociable,
    'localizacao': _addressController.text,
    'status': 'disponivel',
  };

  // Inserir os dados no Supabase
  final response = await Supabase.instance.client.from('pet').insert(newPet);

  if (response == null) {
    // Cadastro bem-sucedido
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pet cadastrado com sucesso!')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PetsView(),
      ),
    );
  } else {
    // Mostrar erro
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao cadastrar o pet: ${response.error!.message}')),
    );
  }
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
                // _speciesButton('Coelho'),
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
                _sizeButton('Pequeno'),
                _sizeButton('Médio'),
                _sizeButton('Grande'),
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
              onPressed: _savePetToSupabase,
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
        backgroundColor: _selectedSize == size ? Colors.blue : Colors.grey,
      ),
      child: Text(size),
    );
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

  // Função para selecionar a espécie
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

  // Função para selecionar o porte
  void _selectSize(String size) {
    setState(() {
      _selectedSize = size;
    });
  }
}
