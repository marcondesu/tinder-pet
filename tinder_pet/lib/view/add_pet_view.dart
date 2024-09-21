import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Importa o geolocator para obter a localização
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:diacritic/diacritic.dart';
import 'package:tinder_pet/view/main_view.dart';
import 'package:tinder_pet/controller/profile_controller.dart';

class AddPetView extends StatefulWidget {
  const AddPetView({super.key});

  @override
  _AddPetViewState createState() => _AddPetViewState();
}

class _AddPetViewState extends State<AddPetView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final ProfileController _profileController = ProfileController();

  String _selectedSpecies = '';
  String _selectedSex = 'Fêmea';
  String _selectedSize = 'Pequeno';
  String? _userId;
  String? _currentLocationAddress; // Armazena a localização atual do usuário

  Set<String> _selectedTemperaments = {};

  bool _isVaccinated = false;
  bool _isCastrated = false;
  bool _isSociable = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Chama a função para obter os dados do usuário
    _getCurrentLocation(); // Chama a função para obter a localização atual
  }

  // Obtém os dados do usuário logado
  Future<void> _fetchUserData() async {
    final userData = await _profileController.fetchUserData();
    setState(() {
      _userId = userData?['id'];
    });
  }

  // Obtém a localização atual do usuário e converte para um endereço legível
  Future<void> _getCurrentLocation() async {
    try {
      // Obtém a posição atual com o geolocator
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // print('position');
      // print(position);

      setState(() {
        _currentLocationAddress = '${position.latitude}, ${position.longitude}';
            // "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      print('Erro ao obter a localização: $e');
    }
  }

  // Função para salvar os dados no Supabase
  Future<void> _savePetToSupabase() async {
    if (_nameController.text.isEmpty ||
        _selectedSpecies.isEmpty ||
        _userId == null ||
        _currentLocationAddress == null) {
      // Verifica se a localização foi carregada
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Por favor, preencha todos os campos e aguarde a localização!')),
      );
      return;
    }

    // Transformar a lista de temperamentos em uma string
    String temperamentosString =
        _selectedTemperaments.map((t) => _normalizeEnumValue(t)).join(',');

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
      'localizacao': _currentLocationAddress, // Atribui o endereço legível
      'status': 'disponivel',
      'doador': _userId,
    };

    final response = await Supabase.instance.client.from('pet').insert(newPet);

    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet cadastrado com sucesso!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Erro ao cadastrar o pet: ${response.error!.message}')),
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
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Pet',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _speciesButton('Cachorro'),
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

  Widget _genderButton(String sex) {
    return ElevatedButton(
      onPressed: () => _selectSex(sex),
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedSex == sex ? Colors.blue : Colors.grey,
      ),
      child: Text(sex),
    );
  }

  Widget _sizeButton(String size) {
    return ElevatedButton(
      onPressed: () => _selectSize(size),
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedSize == size ? Colors.blue : Colors.grey,
      ),
      child: Text(size),
    );
  }

  void _toggleTemperament(String temperament) {
    setState(() {
      if (_selectedTemperaments.contains(temperament)) {
        _selectedTemperaments.remove(temperament);
      } else {
        _selectedTemperaments.add(temperament);
      }
    });
  }

  void _selectSpecies(String species) {
    setState(() {
      _selectedSpecies = species;
    });
  }

  void _selectSex(String sex) {
    setState(() {
      _selectedSex = sex;
    });
  }

  void _selectSize(String size) {
    setState(() {
      _selectedSize = size;
    });
  }

  String _normalizeEnumValue(String value) {
    return removeDiacritics(value.toLowerCase());
  }
}
