import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_database/firebase_database.dart';

class LocationPageSantoAntonio extends StatefulWidget {
  const LocationPageSantoAntonio({super.key});

  @override
  State<LocationPageSantoAntonio> createState() =>
      _LocationPageSantoAntonioState();
}

class _LocationPageSantoAntonioState extends State<LocationPageSantoAntonio> {
  final MapController _mapController = MapController();
  LatLng _busPosition = LatLng(-8.05, -34.9); // posição inicial padrão (Recife)
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _listenToBusLocation();
  }

  void _listenToBusLocation() {
    final ref = FirebaseDatabase.instance.ref('onibus/santo_antonio');
    ref.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null && data['lat'] != null && data['lng'] != null) {
        LatLng newPos = LatLng(data['lat'], data['lng']);
        setState(() {
          _busPosition = newPos;
          _isLoading = false;
        });
        _mapController.move(newPos, 16);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          "Localização: Ônibus Santo Antônio",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(initialCenter: _busPosition, initialZoom: 15),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _busPosition,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.directions_bus,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
