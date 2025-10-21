import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LocationDriverCohab extends StatefulWidget {
  const LocationDriverCohab({super.key});

  @override
  State<LocationDriverCohab> createState() => _LocationDriverCohabState();
}

class _LocationDriverCohabState extends State<LocationDriverCohab> {
  bool _showMap = false; // controla se o mapa aparece
  LatLng _currentPosition = LatLng(-8.05, -34.9); // posição inicial (Recife)
  final MapController _mapController = MapController();

  void _shareLocation(BuildContext context) async {
    // pede permissão de localização
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permissão de localização negada")),
      );
      return;
    }

    // ativa mapa
    setState(() {
      _showMap = true;
    });

    // escuta localização em tempo real
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5, // atualiza a cada 5 metros
      ),
    ).listen((Position pos) {
      LatLng newPos = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _currentPosition = newPos;
      });

      // move a câmera para nova posição
      _mapController.move(newPos, 17);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          "Compartilhar: Ônibus Cohab I",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: _showMap
            ? FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentPosition,
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentPosition,
                        width: 80,
                        height: 80,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.directions_bus_rounded,
                      size: 100,
                      color: Colors.red.shade700,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Motorista Cohab I: Iniciar Compartilhamento",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Pressione o botão abaixo para começar a transmitir a localização do seu ônibus em tempo real para os passageiros.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: () => _shareLocation(context),
                      icon: const Icon(Icons.share_location, size: 28),
                      label: const Text(
                        'Compartilhar Localização',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
