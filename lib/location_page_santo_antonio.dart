import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_database/firebase_database.dart';

class BusStopData {
  final String id;
  final LatLng position;
  final String name;
  bool passed;

  BusStopData({
    required this.id,
    required this.position,
    required this.name,
    this.passed = false,
  });
}

class LocationPageSantoAntonio extends StatefulWidget {
  const LocationPageSantoAntonio({super.key});

  @override
  State<LocationPageSantoAntonio> createState() =>
      _LocationPageSantoAntonioState();
}

class _LocationPageSantoAntonioState extends State<LocationPageSantoAntonio> {
  final MapController _mapController = MapController();
  final DatabaseReference _onibusRef = FirebaseDatabase.instance.ref(
    'onibus/santo_antonio',
  );

  Stream<DatabaseEvent>? _busStream;

  bool _popupAberto = false;
  bool _rotaAnteriorFinalizada = false;
  bool _compartilhandoAnterior = false;
  bool _primeiraLeitura = true;

  final List<BusStopData> _fixedBusStops = [
    BusStopData(
      id: 's1',
      name: 'Erem João Monteiro',
      position: LatLng(-8.339067752350099, -36.43255993416365),
    ),
    BusStopData(
      id: 's2',
      name: 'Posto Petrovia',
      position: LatLng(-8.337454040898562, -36.43059339723894),
    ),
    BusStopData(
      id: 's3',
      name: 'Bradesco',
      position: LatLng(-8.337935253551777, -36.425932851649314),
    ),
    BusStopData(
      id: 's4',
      name: 'Fórum',
      position: LatLng(-8.33711239401202, -36.41898671794646),
    ),
    BusStopData(
      id: 's5',
      name: 'Colegial',
      position: LatLng(-8.33377120753406, -36.41841024066295),
    ),
    BusStopData(
      id: 's6',
      name: 'Santa Fé',
      position: LatLng(-8.331888692413065, -36.41357140284076),
    ),
    BusStopData(
      id: 's7',
      name: 'UABJ',
      position: LatLng(-8.326865277108523, -36.40530664721273),
    ),
    BusStopData(
      id: 's8',
      name: 'AEB',
      position: LatLng(-8.320094221176046, -36.39561876255546),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _busStream = _onibusRef.onValue;
  }

  List<Marker> _buildMarkers(Map? fullData) {
    final List<Marker> markers = [];

    final busData = fullData?['localizacao_atual'] as Map?;
    LatLng? busPosition;

    if (busData != null && busData.containsKey('lat')) {
      busPosition = LatLng(
        (busData['lat'] as num).toDouble(),
        (busData['lng'] as num).toDouble(),
      );

      markers.add(
        Marker(
          point: busPosition,
          width: 80,
          height: 80,
          child: const Icon(
            Icons.directions_bus,
            color: Colors.blueAccent,
            size: 40,
          ),
        ),
      );
    }

    final pointsPassed =
        fullData?['pontos_passados'] as Map<dynamic, dynamic>? ?? {};
    final Set<String> passedIds = pointsPassed.keys.cast<String>().toSet();

    for (var stop in _fixedBusStops) {
      final isPassed = passedIds.contains(stop.id);
      final color = isPassed ? Colors.grey : Colors.red;

      markers.add(
        Marker(
          point: stop.position,
          width: 40,
          height: 40,
          child: Tooltip(
            message: stop.name,
            child: Icon(Icons.location_on, color: color, size: 30),
          ),
        ),
      );
    }

    if (busPosition != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(busPosition!, 16);
      });
    }

    return markers;
  }

  List<Polyline> _buildPolylines(Map? fullData) {
    final rotaData = fullData?['rota'] as Map?;
    if (rotaData == null || rotaData.isEmpty) return const [];

    final List<LatLng> rotaPontos = rotaData.values
        .whereType<Map>()
        .map(
          (ponto) => LatLng(
            (ponto['lat'] as num).toDouble(),
            (ponto['lng'] as num).toDouble(),
          ),
        )
        .toList();

    if (rotaPontos.isEmpty) return const [];

    return [
      Polyline(points: rotaPontos, strokeWidth: 5.0, color: Colors.blueAccent),
    ];
  }

  void _mostrarPopupAvaliacao(BuildContext context) {
    if (_popupAberto) return;
    _popupAberto = true;

    double _avaliacao = 0;
    final TextEditingController _comentarioController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Avalie a rota",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _avaliacao ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            _avaliacao = (index + 1).toDouble();
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _comentarioController,
                    decoration: const InputDecoration(
                      labelText: "Comentário (opcional)",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("❌ Não avaliar"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final comentario = _comentarioController.text.trim();
                    final ref = FirebaseDatabase.instance.ref(
                      'avaliacoes/santo_antonio',
                    );

                    await ref.push().set({
                      'avaliacao': _avaliacao,
                      'comentario': comentario,
                      'data': DateTime.now().toIso8601String(),
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Avaliação enviada com sucesso!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text("Enviar"),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      _popupAberto = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          "Ônibus Santo Antônio em Tempo Real",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _busStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final fullData = snapshot.data?.snapshot.value as Map?;
          if (fullData == null || fullData['localizacao_atual'] == null) {
            return const Center(
              child: Text("Ônibus Santo Antônio inativo ou sem localização."),
            );
          }

          final status = fullData['status'] as Map?;
          final compartilhando = status?['compartilhando'] == true;
          final rotaFinalizada = status?['finalizada'] == true;

          if (_primeiraLeitura) {
            _compartilhandoAnterior = compartilhando;
            _rotaAnteriorFinalizada = rotaFinalizada;
            _primeiraLeitura = false;
          } else {
            final finalizouAgora =
                !_rotaAnteriorFinalizada && rotaFinalizada == true;

            if (finalizouAgora && !_popupAberto) {
              Future.microtask(() {
                _mostrarPopupAvaliacao(context);
              });
            }

            _compartilhandoAnterior = compartilhando;
            _rotaAnteriorFinalizada = rotaFinalizada;
          }

          return FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(-8.343481, -36.420045),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.mobus',
              ),
              PolylineLayer(polylines: _buildPolylines(fullData)),
              MarkerLayer(markers: _buildMarkers(fullData)),
            ],
          );
        },
      ),
    );
  }
}
