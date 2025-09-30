import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_page.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( 
   options: const FirebaseOptions(
    apiKey: "AIzaSyAbuVHYRRGTDlmwBq0nfCELDoK2TIqLUrM",
    authDomain: "mobus-ca8a4.firebaseapp.com",
    projectId: "mobus-ca8a4",
    storageBucket: "mobus-ca8a4.firebasestorage.app",
    messagingSenderId: "852129377639",
    appId: "1:852129377639:web:71c41cd742c71da2fb13c2",
    measurementId: "G-7VG2N4HCLM"
    ),
  );
  runApp(const MobusApp());
}

class MobusApp extends StatelessWidget {
  const MobusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

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
              // Ícone do app
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

              // Texto de boas-vindas
              const Text(
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
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              const Text(
                'Acompanhe o transporte em tempo real',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Botão "Começar"
              ElevatedButton(
                onPressed: () {
                  final user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    // Usuário já está logado → vá direto para HomePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else {
                    // Usuário não logado → vá para LoginPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  }
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
                child: const Text('Começar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
