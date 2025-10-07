import 'package:flutter/material.dart';

class LocationDriverSantoAntonio extends StatelessWidget {
  const LocationDriverSantoAntonio({super.key});

  void _shareLocation(BuildContext context) {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          "Compartilhar: Ônibus Santo Antônio",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bus_alert,
                size: 100,
                color: Colors.red.shade700, 
              ),
              const SizedBox(height: 30),
              Text(
                "Motorista Santo Antônio: Iniciar Compartilhamento",
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
                label: const Text('Compartilhar Localização', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
