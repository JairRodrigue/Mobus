import 'package:flutter/material.dart';
import 'location_driver_cohab.dart'; 
import 'location_driver_santo_antonio.dart'; 

class BusChoiceDriver extends StatelessWidget {
  const BusChoiceDriver({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(20),
                child: const Icon(
                  Icons.directions_bus,
                  size: 120,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'Qual ônibus você dirige?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black26,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LocationDriverCohab()), 
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Você escolheu Ônibus Cohab (Compartilhar Localização)')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade700,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Ônibus Cohab'),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {                 
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LocationDriverSantoAntonio()), 
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Você escolheu Ônibus Santo Antônio (Compartilhar Localização)')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade700,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Ônibus Santo Antônio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
