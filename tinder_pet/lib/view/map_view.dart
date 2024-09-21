import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
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
    _fetchAnimalMarkers(); // Adiciona marcadores manuais
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
    });
  }

  // Busca os endereços dos animais no banco de dados
Future<void> _fetchAnimalMarkers() async {
  final response = await Supabase.instance.client
      .from('pet')
      .select('localizacao');

  if (response == null) {
    print('Erro na consulta ao Supabase');
    return;
  }

  final pets = List<Map<String, dynamic>>.from(response as List);
  for (var pet in pets) {
    String localizacao = pet['localizacao'];
    await _addAnimalMarker(localizacao); // Adiciona o marcador no mapa
  }
}

// Adiciona um marcador no mapa usando as coordenadas salvas
Future<void> _addAnimalMarker(String localizacao) async {
  try {
    // Quebra a string 'latitude, longitude' em dois valores
    List<String> coordenadas = localizacao.split(',');
    double latitude = double.parse(coordenadas[0].trim());
    double longitude = double.parse(coordenadas[1].trim());

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(localizacao),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: 'Animal encontrado', snippet: localizacao),
        ),
      );
    });
  } catch (e) {
    print('Erro ao adicionar o marcador: $e');
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
