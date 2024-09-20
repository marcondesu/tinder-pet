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
    _addManualMarkers(); // Adiciona marcadores manuais
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

  // Adiciona marcadores manuais em locais específicos
  void _addManualMarkers() {
    final List<LatLng> locations = [
      const LatLng(-5.066945696570198, -42.75402667100506), // Rua Cruzilha 1217
      const LatLng(-5.067034318407777, -42.754089112820346), // Rua Cruzilha 1209
      const LatLng(-5.038671083714811, -42.83355875915915), // Rua Des Vaz da Costa 863
      const LatLng(-5.042541777000579, -42.747617162875684), // Av Zequinha Freire
    ];

    setState(() {
      for (var i = 0; i < locations.length; i++) {
        _markers.add(
          Marker(
            markerId: MarkerId('manual_marker_$i'),
            position: locations[i],
            infoWindow: InfoWindow(title: 'Local $i'),
          ),
        );
      }
    });
  }

  // Busca os endereços dos animais no banco de dados
  Future<void> _fetchAnimalMarkers() async {
    final response = await Supabase.instance.client
        .from('pet')
        .select('localizacao');

    if (response != null) {
      print('Erro na consulta ao Supabase: ${response}');
      return;
    }

    final pets = List<Map<String, dynamic>>.from(response as List);
    for (var pet in pets) {
      String logradouro = pet['localizacao'];
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
