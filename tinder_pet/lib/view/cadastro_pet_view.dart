import 'package:flutter/material.dart';

class PetCadastroView extends StatefulWidget {
  const PetCadastroView({super.key});

  @override
  _PetCadastroViewState createState() => _PetCadastroViewState();
}

class _PetCadastroViewState extends State<PetCadastroView> {
  final _formKey = GlobalKey<FormState>();
  String? _nome;
  String? _endereco;
  String _especie = 'Cachorro'; // Valor inicial
  String _sexo = 'Macho'; // Valor inicial
  String _raca = 'Selecione'; // Valor inicial
  final List<String> _racasCachorro = ['Labrador', 'Pastor Alemão', 'Golden Retriever'];
  final List<String> _racasGato = ['Siamês', 'Persa', 'Angorá'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Pet'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ... Widget para adicionar imagem
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nome'),
                  onChanged: (value) => _nome = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do pet';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Endereço'),
                  onChanged: (value) => _endereco = value,
                ),
                // ... Botões para espécie
                // ... Botões para sexo
                DropdownButtonFormField(
                  value: _raca,
                  items: _getRacas(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _raca = newValue!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Raça'),
                ),
                // ... Botões de salvar e cancelar
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getRacas() {
    List<DropdownMenuItem<String>> items = [];
    if (_especie == 'Cachorro') {
      for (var raca in _racasCachorro) {
        items.add(DropdownMenuItem(
          value: raca,
          child: Text(raca),
        ));
      }
    } else {
      for (var raca in _racasGato) {
        items.add(DropdownMenuItem(
          value: raca,
          child: Text(raca),
        ));
      }
    }
    return items;
  }
}