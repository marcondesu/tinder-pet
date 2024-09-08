import 'package:flutter/material.dart';
import '../controller/pet_controller.dart';
import '../model/pet_model.dart';

class PetView extends StatefulWidget {
  @override
  _PetViewState createState() => _PetViewState();
}

class _PetViewState extends State<PetView> {
  final PetController _controller = PetController();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();

  Especie _especie = Especie.cachorro;
  Porte _porte = Porte.medio;
  Temperamento _temperamento = Temperamento.brincalhao;
  bool _vacinado = false;
  bool _castrado = false;
  bool _sociavel = false;
  Sexo sexo = Sexo.femea;

  void _addPet() {
    final nome = _nomeController.text;
    final idade = int.tryParse(_idadeController.text) ?? 0;

    final pet = Pet(
      nome: nome,
      idade: idade,
      sexo: sexo,
      especie: _especie,
      porte: _porte,
      temperamento: _temperamento,
      vacinado: _vacinado,
      castrado: _castrado,
      sociavel: _sociavel,
    );

    _controller.addPet(pet);
    _nomeController.clear();
    _idadeController.clear();
    _sexoController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Pets'),
      ),
      body: Padding(  
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _idadeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Idade'),
            ),
            DropdownButton<Sexo>(
              value: sexo,
              onChanged: (Sexo? newValue) {
                setState(() {
                  sexo = newValue!;
                });
              },
              items: Sexo.values.map<DropdownMenuItem<Sexo>>((Sexo value) {
                return DropdownMenuItem<Sexo>(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
              hint: Text('Escolha a espécie'),
            ),
            DropdownButton<Especie>(
              value: _especie,
              onChanged: (Especie? newValue) {
                setState(() {
                  _especie = newValue!;
                });
              },
              items: Especie.values.map<DropdownMenuItem<Especie>>((Especie value) {
                return DropdownMenuItem<Especie>(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
              hint: Text('Escolha a espécie'),
            ),
            DropdownButton<Porte>(
              value: _porte,
              onChanged: (Porte? newValue) {
                setState(() {
                  _porte = newValue!;
                });
              },
              items: Porte.values.map<DropdownMenuItem<Porte>>((Porte value) {
                return DropdownMenuItem<Porte>(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
              hint: Text('Escolha o porte'),
            ),
            DropdownButton<Temperamento>(
              value: _temperamento,
              onChanged: (Temperamento? newValue) {
                setState(() {
                  _temperamento = newValue!;
                });
              },
              items: Temperamento.values.map<DropdownMenuItem<Temperamento>>((Temperamento value) {
                return DropdownMenuItem<Temperamento>(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
              hint: Text('Escolha o temperamento'),
            ),
            CheckboxListTile(
              title: Text('Vacinado'),
              value: _vacinado,
              onChanged: (bool? newValue) {
                setState(() {
                  _vacinado = newValue!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Castrado'),
              value: _castrado,
              onChanged: (bool? newValue) {
                setState(() {
                  _castrado = newValue!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Sociável'),
              value: _sociavel,
              onChanged: (bool? newValue) {
                setState(() {
                  _sociavel = newValue!;
                });
              },
            ),
            ElevatedButton(
              onPressed: _addPet,
              child: Text('Adicionar Pet'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _controller.getPets().length,
                itemBuilder: (context, index) {
                  final pet = _controller.getPets()[index];
                  return ListTile(
                    title: Text(pet.descricao),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
