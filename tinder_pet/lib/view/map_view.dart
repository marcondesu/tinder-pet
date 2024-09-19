import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Para converter endereços em coordenadas
import 'package:supabase_flutter/supabase_flutter.dart'; // Importa Supabase para buscar dados do banco

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Obtém a localização atual do usuário
  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: 'Sua localização'),
        ),
      );
      _fetchAnimalMarkers(); // Busca e adiciona os marcadores de animais
    });
  }

  // Busca os endereços dos animais no banco de dados
  Future<void> _fetchAnimalMarkers() async {
  final response = await Supabase.instance.client
      .from('pet')
      .select('localizacao'); // Seleciona a coluna 'endereco' da tabela 'pets'

  final pets = List<Map<String, dynamic>>.from(response as List);
  for (var pet in pets) {
    String logradouro = pet['localizacao']; // Obtém o logradouro de cada pet
    print('Logradouro: $logradouro'); // Adiciona um print para depuração
    await _addAnimalMarker(logradouro); // Adiciona o marcador no mapa
  }
}

Future<void> _addAnimalMarker(String logradouro) async {
  try {
    List<Location> locations = await locationFromAddress(logradouro); // Converte o endereço em coordenadas
    print('Localizações: $locations'); // Adiciona um print para depuração

    if (locations.isNotEmpty) {
      Location location = locations.first;
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(logradouro),
            position: LatLng(location.latitude, location.longitude),
            infoWindow: InfoWindow(title: 'Animal encontrado', snippet: logradouro),
          ),
        );
      });
    } else {
      print('Nenhuma localização encontrada para o endereço: $logradouro');
    }
  } catch (e) {
    print('Erro ao converter o endereço: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa dos Animais'),
        centerTitle: true,
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 14.0,
              ),
              markers: _markers, // Exibe os marcadores no mapa
            ),
    );
  }
}
