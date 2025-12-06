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

class LocationPageCohab extends StatefulWidget {
  const LocationPageCohab({super.key});

  @override
  State<LocationPageCohab> createState() => _LocationPageCohabState();
}

class _LocationPageCohabState extends State<LocationPageCohab> {
  final MapController _mapController = MapController();
  final DatabaseReference _onibusRef = FirebaseDatabase.instance.ref(
    'onibus/cohab',
  );

  Stream<DatabaseEvent>? _busStream;

  bool _popupAberto = false;
  bool _rotaAnteriorFinalizada = false;
  bool _compartilhandoAnterior = false;
  bool _primeiraLeitura = true;

  bool _showFinishedRouteNotification = true;
  Timer? _notificationTimer;

  static const double _averageSpeedMps = 7.77;

  final List<LatLng> _fixedRouteCoordinates = [
    LatLng(-8.34867, -36.40927), LatLng(-8.34862, -36.4093), LatLng(-8.34857, -36.40932),
    LatLng(-8.34851, -36.40935), LatLng(-8.34845, -36.40937), LatLng(-8.3484, -36.40939),
    LatLng(-8.34822, -36.40943), LatLng(-8.34822, -36.40943), LatLng(-8.34812, -36.40945),
    LatLng(-8.34808, -36.40947), LatLng(-8.348, -36.40951), LatLng(-8.34793, -36.40956),
    LatLng(-8.34667, -36.41102), LatLng(-8.3462, -36.41154), LatLng(-8.34598, -36.41178),
    LatLng(-8.34553, -36.4123), LatLng(-8.34521, -36.41267), LatLng(-8.3449, -36.41301),
    LatLng(-8.34453, -36.41343), LatLng(-8.3445, -36.41347), LatLng(-8.3444, -36.41359),
    LatLng(-8.34416, -36.41389), LatLng(-8.34416, -36.41389), LatLng(-8.34416, -36.41389),
    LatLng(-8.34407, -36.41401), LatLng(-8.34338, -36.41479), LatLng(-8.34328, -36.41492),
    LatLng(-8.34278, -36.41547), LatLng(-8.34268, -36.41558), LatLng(-8.3426, -36.41566),
    LatLng(-8.34258, -36.41568), LatLng(-8.34245, -36.41591), LatLng(-8.34235, -36.41618),
    LatLng(-8.34231, -36.41643), LatLng(-8.34231, -36.41645), LatLng(-8.34231, -36.41681),
    LatLng(-8.34231, -36.41681), LatLng(-8.34231, -36.41681), LatLng(-8.34231, -36.41707),
    LatLng(-8.34231, -36.41715), LatLng(-8.34231, -36.41715), LatLng(-8.34229, -36.41717),
    LatLng(-8.34227, -36.41719), LatLng(-8.34227, -36.41719), LatLng(-8.34218, -36.41726),
    LatLng(-8.34213, -36.4173), LatLng(-8.34206, -36.41736), LatLng(-8.34095, -36.41793),
    LatLng(-8.34091, -36.41794), LatLng(-8.34084, -36.41798), LatLng(-8.34011, -36.41835),
    LatLng(-8.33993, -36.41844), LatLng(-8.33962, -36.4186), LatLng(-8.33943, -36.4187),
    LatLng(-8.33873, -36.41905), LatLng(-8.33837, -36.41932), LatLng(-8.33832, -36.41937),
    LatLng(-8.33821, -36.4195), LatLng(-8.3381, -36.41962), LatLng(-8.3381, -36.41962),
    LatLng(-8.33802, -36.41958), LatLng(-8.33774, -36.41941), LatLng(-8.33741, -36.41909),
    LatLng(-8.33735, -36.41902), LatLng(-8.33731, -36.41897), LatLng(-8.33729, -36.41893),
    LatLng(-8.33729, -36.41893), LatLng(-8.33729, -36.41893), LatLng(-8.33713, -36.41871),
    LatLng(-8.33692, -36.4184), LatLng(-8.3369, -36.41829), LatLng(-8.33676, -36.41737),
    LatLng(-8.33676, -36.41737), LatLng(-8.33651, -36.4173), LatLng(-8.33621, -36.41722),
    LatLng(-8.33613, -36.4172), LatLng(-8.33595, -36.41715), LatLng(-8.33582, -36.41711),
    LatLng(-8.33546, -36.41703), LatLng(-8.33546, -36.41703), LatLng(-8.33534, -36.41704),
    LatLng(-8.33528, -36.41707), LatLng(-8.33517, -36.41714), LatLng(-8.33436, -36.41793),
    LatLng(-8.3341, -36.41817), LatLng(-8.33401, -36.41826), LatLng(-8.33389, -36.4184),
    LatLng(-8.33389, -36.4184), LatLng(-8.33386, -36.4184), LatLng(-8.33383, -36.41839),
    LatLng(-8.33375, -36.41838), LatLng(-8.33375, -36.41838), LatLng(-8.33371, -36.41827),
    LatLng(-8.33371, -36.41827), LatLng(-8.33371, -36.41827), LatLng(-8.33356, -36.41786),
    LatLng(-8.33343, -36.41755), LatLng(-8.33336, -36.41738), LatLng(-8.33333, -36.41729),
    LatLng(-8.33329, -36.41721), LatLng(-8.33309, -36.4167), LatLng(-8.33257, -36.41539),
    LatLng(-8.33234, -36.41477), LatLng(-8.33188, -36.41351), LatLng(-8.33183, -36.41341),
    LatLng(-8.33183, -36.41341), LatLng(-8.33183, -36.41341), LatLng(-8.33161, -36.41287),
    LatLng(-8.33142, -36.41238), LatLng(-8.33137, -36.41226), LatLng(-8.33114, -36.41166),
    LatLng(-8.33103, -36.4114), LatLng(-8.33103, -36.4114), LatLng(-8.33096, -36.41128),
    LatLng(-8.33087, -36.41118), LatLng(-8.33079, -36.41111), LatLng(-8.33062, -36.41101),
    LatLng(-8.33017, -36.41073), LatLng(-8.32973, -36.41046), LatLng(-8.32962, -36.41038),
    LatLng(-8.32953, -36.4103), LatLng(-8.32942, -36.4102), LatLng(-8.32933, -36.41012),
    LatLng(-8.32924, -36.41003), LatLng(-8.32919, -36.40996), LatLng(-8.3291, -36.40985),
    LatLng(-8.32897, -36.40965), LatLng(-8.32864, -36.40913), LatLng(-8.32795, -36.4081),
    LatLng(-8.32766, -36.40765), LatLng(-8.32743, -36.40731), LatLng(-8.32708, -36.40682),
    LatLng(-8.3268, -36.40641), LatLng(-8.32662, -36.40613), LatLng(-8.32648, -36.40592),
    LatLng(-8.32637, -36.40575), LatLng(-8.32626, -36.4056), LatLng(-8.32623, -36.40545),
    LatLng(-8.32623, -36.40538), LatLng(-8.32623, -36.40531), LatLng(-8.32624, -36.40525),
    LatLng(-8.32627, -36.40516), LatLng(-8.32627, -36.40516), LatLng(-8.32643, -36.4052),
    LatLng(-8.32661, -36.40524), LatLng(-8.32688, -36.40523), LatLng(-8.32688, -36.40523),
    LatLng(-8.32688, -36.40523), LatLng(-8.32706, -36.40523), LatLng(-8.32719, -36.40523),
    LatLng(-8.32733, -36.40518), LatLng(-8.3275, -36.40518), LatLng(-8.32762, -36.40518),
    LatLng(-8.3278, -36.40518), LatLng(-8.3279, -36.40519), LatLng(-8.32801, -36.40521),
    LatLng(-8.3281, -36.40523), LatLng(-8.32819, -36.40526), LatLng(-8.32829, -36.4053),
    LatLng(-8.32842, -36.40537), LatLng(-8.32852, -36.40542), LatLng(-8.32925, -36.40587),
    LatLng(-8.32925, -36.40587), LatLng(-8.32923, -36.40568), LatLng(-8.3292, -36.40553),
    LatLng(-8.32891, -36.40362), LatLng(-8.32891, -36.40362), LatLng(-8.32848, -36.4037),
    LatLng(-8.32802, -36.40379), LatLng(-8.32757, -36.40389), LatLng(-8.32715, -36.40399),
    LatLng(-8.32671, -36.40409), LatLng(-8.32625, -36.40418), LatLng(-8.3256, -36.40431),
    LatLng(-8.32549, -36.40437), LatLng(-8.32549, -36.40437), LatLng(-8.32538, -36.40425),
    LatLng(-8.32531, -36.40415), LatLng(-8.32468, -36.40323), LatLng(-8.32386, -36.40198),
    LatLng(-8.32371, -36.40174), LatLng(-8.32277, -36.40031), LatLng(-8.32242, -36.39975),
    LatLng(-8.32117, -36.39779), LatLng(-8.32089, -36.39733), LatLng(-8.3208, -36.39715),
    LatLng(-8.32074, -36.39699), LatLng(-8.32069, -36.39685), LatLng(-8.32053, -36.39627),
    LatLng(-8.32047, -36.396), LatLng(-8.32045, -36.39594), LatLng(-8.32041, -36.39579),
    LatLng(-8.32041, -36.39579), LatLng(-8.32018, -36.39587), LatLng(-8.32018, -36.39587),
  ];

  final List<BusStopData> _fixedBusStops = [
    BusStopData(
      id: 'p1',
      name: 'Entrada da BR',
      position: LatLng(-8.348653123556376, -36.409243068163),
    ),
    BusStopData(
      id: 'p2',
      name: 'Praça das crianças',
      position: LatLng(-8.343889377713843, -36.413837818197614),
    ),
    BusStopData(
      id: 'p3',
      name: 'Sebastião Cabral',
      position: LatLng(-8.34210767354571, -36.41681422352121),
    ),
    BusStopData(
      id: 'p4',
      name: 'Fórum',
      position: LatLng(-8.33711239401202, -36.41898671794646),
    ),
    BusStopData(
      id: 'p5',
      name: 'Colegial',
      position: LatLng(-8.33377120753406, -36.41841024066295),
    ),
    BusStopData(
      id: 'p6',
      name: 'Santa Fé',
      position: LatLng(-8.331888692413065, -36.41357140284076),
    ),
    BusStopData(
      id: 'p7',
      name: 'UABJ',
      position: LatLng(-8.326865277108523, -36.40530664721273),
    ),
    BusStopData(
      id: 'p8',
      name: 'AEB',
      position: LatLng(-8.320094221176046, -36.39561876255546),
    ),
  ];

  late final Map<String, String> _stopNames;

  @override
  void initState() {
    super.initState();
    _busStream = _onibusRef.onValue;
    _stopNames = Map.fromIterable(_fixedBusStops,
        key: (stop) => stop.id, value: (stop) => stop.name);
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
            child: Icon(Icons.directions_bus_filled_outlined,
                color: color, size: 30),
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
    List<Polyline> layers = [];

    if (_fixedRouteCoordinates.isNotEmpty) {
      layers.add(
        Polyline(
          points: _fixedRouteCoordinates,
          strokeWidth: 8.0,
          color: Colors.red.withValues(alpha: 0.6),
        ),
      );
    }

    final rotaData = fullData?['rota'] as Map?;
    if (rotaData != null && rotaData.isNotEmpty) {
      final List<LatLng> rotaPontos = rotaData.values
          .whereType<Map>()
          .map(
            (ponto) => LatLng(
              (ponto['lat'] as num).toDouble(),
              (ponto['lng'] as num).toDouble(),
            ),
          )
          .toList();

      if (rotaPontos.isNotEmpty) {
        layers.add(
          Polyline(
              points: rotaPontos, strokeWidth: 5.0, color: Colors.blueAccent),
        );
      }
    }

    return layers;
  }

  int _findNearestPointIndex(LatLng point, List<LatLng> route) {
    int bestIndex = 0;
    double bestDistance = double.infinity;
    const Distance distance = Distance();

    for (int i = 0; i < route.length; i++) {
      double d = distance.as(LengthUnit.Meter, point, route[i]);
      if (d < bestDistance) {
        bestDistance = d;
        bestIndex = i;
      }
    }
    return bestIndex;
  }

  Map<String, dynamic> _calcularEstimativasLocais(
      LatLng busPosition, Set<String> passedIds) {
    
    BusStopData? nextStop;
    for (var stop in _fixedBusStops) {
      if (!passedIds.contains(stop.id)) {
        nextStop = stop;
        break;
      }
    }

    if (nextStop == null) {
      return {
        'nomeParada': 'Fim da Linha',
        'tempoRestanteMin': 0,
        'tempoTotalMin': 0,
        'distanciaM': 0.0,
      };
    }

    int busIndex = _findNearestPointIndex(busPosition, _fixedRouteCoordinates);
    int stopIndex = _findNearestPointIndex(nextStop.position, _fixedRouteCoordinates);

    double distanceToNext = 0.0;
    const Distance distanceCalc = Distance();

    if (stopIndex > busIndex) {
      for (int i = busIndex; i < stopIndex; i++) {
        distanceToNext += distanceCalc.as(
            LengthUnit.Meter, _fixedRouteCoordinates[i], _fixedRouteCoordinates[i + 1]);
      }
    } else {
      distanceToNext = distanceCalc.as(LengthUnit.Meter, busPosition, nextStop.position);
    }

    double distanceTotal = distanceToNext;
    for (int i = stopIndex; i < _fixedRouteCoordinates.length - 1; i++) {
        distanceTotal += distanceCalc.as(
            LengthUnit.Meter, _fixedRouteCoordinates[i], _fixedRouteCoordinates[i + 1]);
    }

    double timeNextMin = (distanceToNext / _averageSpeedMps) / 60;
    double timeTotalMin = (distanceTotal / _averageSpeedMps) / 60;

    return {
      'nomeParada': nextStop.name,
      'tempoRestanteMin': timeNextMin.ceil(),
      'tempoTotalMin': timeTotalMin.ceil(),
      'distanciaM': distanceToNext,
    };
  }

  Widget _buildNotificationPanel(Map? fullData) {
    final rotaFinalizada = fullData?['status']?['finalizada'] == true;

    if (rotaFinalizada && !_showFinishedRouteNotification) {
      return Container();
    }

    if (rotaFinalizada) {
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
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade600,
          child: const Text(
            "A rota foi finalizada.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        );
    }

    final busData = fullData?['localizacao_atual'] as Map?;
    if (busData == null || !busData.containsKey('lat')) {
       return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        color: Colors.grey.shade400,
        child: const Text(
          "Aguardando sinal do ônibus...",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      );
    }

    final busPos = LatLng(
        (busData['lat'] as num).toDouble(),
        (busData['lng'] as num).toDouble(),
    );
    final pointsPassed = fullData?['pontos_passados'] as Map<dynamic, dynamic>? ?? {};
    final Set<String> passedIds = pointsPassed.keys.cast<String>().toSet();

    final estimativas = _calcularEstimativasLocais(busPos, passedIds);

    final String nomeParada = estimativas['nomeParada'];
    final int tempoRestante = estimativas['tempoRestanteMin'];
    final int tempoTotal = estimativas['tempoTotalMin'];
    final double distanciaM = estimativas['distanciaM'];

    String message;
    Color color;

    if (tempoRestante < 1 && distanciaM < 150) { 
        message = "Estamos chegando em: **$nomeParada**!";
        color = Colors.green.shade700;
    } 
    else if (tempoRestante <= 5) {
        message = "Faltam **$tempoRestante min** para chegar em **$nomeParada**! (Total: $tempoTotal min)";
        color = Colors.deepOrange.shade700;
    } 
    else {
        message = "O ônibus está a **$tempoRestante min** de **$nomeParada**. (Total: $tempoTotal min)";
        color = Colors.blue.shade700;
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
        TextSpan(children: formattedText),
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

    double avaliacao = 0;
    TextEditingController comentarioController = TextEditingController();

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
                          index < avaliacao ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            avaliacao = (index + 1).toDouble();
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: comentarioController,
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
                    final comentario = comentarioController.text.trim();
                    final ref = FirebaseDatabase.instance.ref(
                      'avaliacoes/cohab',
                    );

                    await ref.push().set({
                      'avaliacao': avaliacao,
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
          "Ônibus Cohab em Tempo Real",
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

          final bool locationIsMissing =
              fullData == null || fullData['localizacao_atual'] == null;
          final bool rotaFinalizada = fullData?['status']?['finalizada'] == true;

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

          if (locationIsMissing) {
            return Column(
              children: [
                notification,
                const Expanded(
                  child: Center(
                    child: Text(
                      "Localização do ônibus indisponível no momento",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            );
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