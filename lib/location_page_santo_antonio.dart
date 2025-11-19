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
  
  bool _showFinishedRouteNotification = true;
  Timer? _notificationTimer;

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

  late final Map<String, String> _stopNames;

  @override
  void initState() {
    super.initState();
    _busStream = _onibusRef.onValue;
    _stopNames = Map.fromIterable(
        _fixedBusStops, key: (stop) => stop.id, value: (stop) => stop.name);
  }
  
  @override
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
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
            child: Icon(Icons.directions_bus_filled_outlined, color: color, size: 30),
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

  Widget _buildNotificationPanel(Map? fullData) {
    final estimativas = fullData?['estimativas'] as Map?;
    final rotaFinalizada = fullData?['status']?['finalizada'] == true;

    if (rotaFinalizada && !_showFinishedRouteNotification) {
      return Container();
    }

    if (estimativas == null) {
       return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        color: Colors.grey.shade400,
        child: const Text(
          "Aguardando dados de estimativa...",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      );
    }

    final double tempoMin = (estimativas['tempo_proxima_min'] as num?)?.toDouble() ?? 0.0;
    final String proximaParadaId = estimativas['proxima_parada_id'] as String? ?? '';
    final double distanciaM = (estimativas['distancia_proxima_m'] as num?)?.toDouble() ?? 0.0;
    final double tempoTotalMin = (estimativas['tempo_total_min'] as num?)?.toDouble() ?? 0.0;
    
    final String nomeParada = _stopNames[proximaParadaId] ?? 'Nenhuma Parada';
    final int tempoRestante = tempoMin.round();
    final int tempoTotalRestante = tempoTotalMin.round();

    String message;
    Color color;

    if (rotaFinalizada) {
        message = "A rota foi finalizada. Tempo total de rota: **$tempoTotalRestante min**.";
        color = Colors.grey.shade600;
        
        if (_showFinishedRouteNotification) {
          _notificationTimer?.cancel(); 
          _notificationTimer = Timer(const Duration(seconds: 5), () {
            if (mounted) {
              setState(() {
                _showFinishedRouteNotification = false;
              });
            }
          });
        }
    } 
    else {
      if (!_showFinishedRouteNotification) {
         WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _showFinishedRouteNotification = true;
              });
            }
          });
      }
      
      _notificationTimer?.cancel(); 

      if (tempoMin < 1.5 && distanciaM < 150) { 
          message = "Estamos no ponto: **$nomeParada**! (Total restante: $tempoTotalRestante min)";
          color = Colors.green.shade700;
          
      } 
      else if (tempoRestante >= 1 && tempoRestante <= 5) {
          message = "Faltam **$tempoRestante min** para chegar em **$nomeParada**! (Total: $tempoTotalRestante min)";
          color = Colors.deepOrange.shade700;
          
      } 
      else {
          message = "O ônibus está a **$tempoRestante min** de **$nomeParada**. (Total: $tempoTotalRestante min)";
          color = Colors.blue.shade700;
      }
    }

    final parts = message.split('**');
    final formattedText = <TextSpan>[];
    for (int i = 0; i < parts.length; i++) {
        formattedText.add(
          TextSpan(
            text: parts[i],
            style: TextStyle(
              fontWeight: i % 2 != 0 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: color,
      child: Text.rich(
        TextSpan(
          children: formattedText,
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _busStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LinearProgressIndicator());
          }

          final fullData = snapshot.data?.snapshot.value as Map?;
          
          Widget notification = _buildNotificationPanel(fullData);

          final bool locationIsMissing = fullData == null || fullData['localizacao_atual'] == null;
          final bool rotaFinalizada = fullData?['status']?['finalizada'] == true;
          
          if (locationIsMissing || (rotaFinalizada && !_showFinishedRouteNotification)) {
            
            final status = fullData?['status'] as Map?;
            final compartilhando = status?['compartilhando'] == true;
            
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

            return Column(
              children: [
                notification,
                const Expanded(
                  child: Center(
                    child: Text("Ônibus Santo Antônio inativo ou sem localização."),
                  ),
                ),
              ],
            );
          }

          final status = fullData['status'] as Map?;
          final compartilhando = status?['compartilhando'] == true;
          
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

          return Column(
            children: [
              notification,
              Expanded(
                child: FlutterMap(
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
