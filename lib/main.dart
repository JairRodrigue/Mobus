import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'who_is_using.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  const apiKeyFromEnv = String.fromEnvironment('API_KEY');
  final apiKey = apiKeyFromEnv.isEmpty ? null : apiKeyFromEnv;

  const authDomainFromEnv = String.fromEnvironment('AUTH_DOMAIN');
  final authDomain = authDomainFromEnv.isEmpty ? null : authDomainFromEnv;

  const projectIdFromEnv = String.fromEnvironment('PROJECT_ID');
  final projectId = projectIdFromEnv.isEmpty ? null : projectIdFromEnv;

  const storageBucketFromEnv = String.fromEnvironment('STORAGE_BUCKET');
  final storageBucket = storageBucketFromEnv.isEmpty ? null : storageBucketFromEnv;

  const messagingSenderIdFromEnv = String.fromEnvironment('MESSAGING_SENDER_ID');
  final messagingSenderId = messagingSenderIdFromEnv.isEmpty ? null : messagingSenderIdFromEnv;

  const appIdFromEnv = String.fromEnvironment('APP_ID');
  final appId = appIdFromEnv.isEmpty ? null : appIdFromEnv;

  const measurementIdFromEnv = String.fromEnvironment('MEASUREMENT_ID');
  final measurementId = measurementIdFromEnv.isEmpty ? null : measurementIdFromEnv;

  if (apiKey == null || projectId == null || appId == null || messagingSenderId == null) {
    runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Erro de Configuração: As chaves do Firebase (API_KEY, PROJECT_ID, APP_ID, MESSAGING_SENDER_ID) não foram encontradas. Verifique se o arquivo .env está correto e se o build foi executado com a flag '--dart-define-from-file'.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ));

    return;
  }


  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      authDomain: authDomain,
      projectId: projectId,
      storageBucket: storageBucket,
      messagingSenderId: messagingSenderId,
      measurementId: measurementId,
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
                style: TextStyle(fontSize: 18, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WhoIsUsingPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
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

