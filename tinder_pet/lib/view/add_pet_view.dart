import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Importa o geolocator para obter a localização
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:diacritic/diacritic.dart';
import 'package:tinder_pet/view/main_view.dart';
import 'package:tinder_pet/controller/profile_controller.dart';
import 'dart:typed_data';
// import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart'; // Pacote compatível com Web

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

  Uint8List? _imageBytes;

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

  // Função para selecionar a imagem
  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     final bytes = await pickedFile.readAsBytes();
  //     setState(() {
  //       _imageBytes = bytes;
  //     });
  //   }
  // }
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Permitir apenas arquivos de imagem
      allowMultiple: false,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _imageBytes = result.files.single.bytes;
      });
    }
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

  // Função para fazer upload da imagem para o Supabase
  Future<String?> _uploadImage(Uint8List imageBytes) async {
    try {
      // Gerar um nome único para a imagem, com base no timestamp atual
      final fileName = 'pet-${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = 'pet-images/$fileName'; // Define o caminho no bucket

      // Fazer o upload da imagem para o bucket "pet-images"
      final response = await Supabase.instance.client.storage
          .from('pet-images')
          .uploadBinary(filePath, imageBytes,
              fileOptions: const FileOptions(upsert: false));

      // print(response);

      if (response != null) {
        // Se o upload for bem-sucedido, retorna a URL pública da imagem
        final publicUrl = Supabase.instance.client.storage
            .from('pet-images')
            .getPublicUrl(filePath);

          print(publicUrl);
          
        return publicUrl;
      } else {
        // Se houver erro no upload
        // print('Erro ao fazer upload da imagem: ${response}');
        return null;
      }
    } catch (e) {
      // print('Erro durante o upload da imagem: $e');
      return null;
    }
  }

  // Função para salvar os dados no Supabase
  Future<void> _savePetToSupabase() async {
    if (_nameController.text.isEmpty ||
        _selectedSpecies.isEmpty ||
        _userId == null ||
        _currentLocationAddress == null ||
        _imageBytes == null) {
      // Verifica se uma imagem foi selecionada
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Por favor, preencha todos os campos e selecione uma imagem!')),
      );
      return;
    }

    // Fazer upload da imagem antes de salvar o pet
    String? imageUrl = await _uploadImage(_imageBytes!);
    // print("imagem: ${imageUrl}");

    if (imageUrl == null) {
      // Se houver erro no upload da imagem, mostrar uma mensagem
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao fazer upload da imagem!')),
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
      'localizacao': _currentLocationAddress,
      'imagem_url': imageUrl, // Adiciona a URL da imagem
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
        SnackBar(content: Text('Erro ao cadastrar o pet: ${response}')),
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
