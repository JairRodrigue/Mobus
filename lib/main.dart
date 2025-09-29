import 'package:flutter/material.dart';
import 'home_page.dart'; 

void main() {
  runApp(MobusApp());
}

class MobusApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
  ***REMOVED***
      home: StartPage(), 
  ***REMOVED***
  }
}

class StartPage extends StatelessWidget {
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
      ***REMOVED***
    ***REMOVED***
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo/ícone
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
            ***REMOVED***
                padding: EdgeInsets.all(20),
                child: Icon(
                  Icons.directions_bus,
                  size: 120,
                  color: Colors.white,
            ***REMOVED***
          ***REMOVED***
              SizedBox(height: 30),

              // Texto de boas-vindas
              Text(
                'Bem-vindo ao Mobus!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black26,
                      offset: Offset(2, 2),
                ***REMOVED***
                  ],
            ***REMOVED***
                textAlign: TextAlign.center,
          ***REMOVED***
              SizedBox(height: 10),

              Text(
                'Acompanhe o transporte em tempo real',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
            ***REMOVED***
                textAlign: TextAlign.center,
          ***REMOVED***
              SizedBox(height: 40),

              // Botão principal
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()), // 👉 abre home_page.dart
                ***REMOVED***
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade700,
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
              ***REMOVED***
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
              ***REMOVED***
            ***REMOVED***
                child: Text('Começar'),
          ***REMOVED***
            ],
      ***REMOVED***
    ***REMOVED***
  ***REMOVED***
  ***REMOVED***
  }
}
