import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tinder_pet/controller/profile_controller.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa o url_launcher para abrir o link do WhatsApp

class PetDetailView extends StatefulWidget {
  final Map<String, dynamic> pet;

  const PetDetailView({super.key, required this.pet});

  @override
  _PetDetailViewState createState() => _PetDetailViewState();
}

class _PetDetailViewState extends State<PetDetailView> {
  String? _donorPhone;

  @override
  void initState() {
    super.initState();
    _fetchDonorTelefone(); // Busca o telefone do doador
  }

  // Busca o telefone do doador a partir do ID do doador
  Future<void> _fetchDonorTelefone() async {
    final ProfileController profileController = ProfileController();

    try {
      final donorId = widget.pet['doador'] as String;

      // Busca o usuário no Supabase para obter o telefone
      final response = await Supabase.instance.client
          .from('usuario') // Ajuste o nome da tabela se necessário
          .select('telefone')
          .eq('id', donorId)
          .single();
      if (response != null) {
        setState(() {
          _donorPhone = response['telefone'].toString();
        });
      } else {
        print('Erro ao buscar telefone do doador: ${response}');
      }
    } catch (e) {
      print('Erro ao buscar telefone do doador: $e');
    }
  }

  // Função para abrir o WhatsApp
  Future<void> _launchWhatsApp() async {
    final phone = _donorPhone;
    if (phone != null) {
      final whatsappUrl =
          "https://wa.me/$phone"; // Link do WhatsApp com o número do doador
      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        print('Could not launch $whatsappUrl');
      }
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
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Card com imagem do pet (se disponível)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome do pet com ícone de gênero
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.pet['nome'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          widget.pet['sexo'] == 'macho'
                              ? Icons.male
                              : Icons.female,
                          color: widget.pet['sexo'] == 'macho'
                              ? Colors.blue
                              : const Color.fromARGB(255, 233, 30, 182),
                          size: 28,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Idade
                    ListTile(
                      leading: const Icon(Icons.pets),
                      title: Text('Idade: ${widget.pet['idade']} anos'),
                    ),
                    const Divider(),
                    // Localização
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text('Endereço: ${widget.pet['localizacao']}'),
                    ),
                    const Divider(),
                    // Temperamento
                    ListTile(
                      leading: const Icon(Icons.mood),
                      title:
                          Text('Temperamento: ${widget.pet['temperamento']}'),
                    ),
                    const Divider(),
                    // Status
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: Text('Status: ${widget.pet['status']}'),
                    ),
                    const Divider(),
                    // Telefone do doador
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(
                          'Telefone do Doador: ${_donorPhone ?? 'Carregando...'}'),
                      trailing: _donorPhone != null
                          ? IconButton(
                              icon: const Icon(Icons.message),
                              onPressed: _launchWhatsApp, // Chama o WhatsApp
                              color: Colors.green,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
