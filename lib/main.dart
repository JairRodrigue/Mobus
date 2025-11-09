import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mobus/bus_choice_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String firebaseApiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );
  const String firebaseAuthDomain = String.fromEnvironment(
    'AUTH_DOMAIN',
    defaultValue: '',
  );
  const String firebaseDatabaseUrl = String.fromEnvironment(
    'DATABASE_URL',
    defaultValue: '',
  );
  const String firebaseProjectId = String.fromEnvironment(
    'PROJECT_ID',
    defaultValue: '',
  );
  const String firebaseStorageBucket = String.fromEnvironment(
    'STORAGE_BUCKET',
    defaultValue: '',
  );
  const String firebaseMessagingSenderId = String.fromEnvironment(
    'MESSAGING_SENDER_ID',
    defaultValue: '',
  );
  const String firebaseAppId = String.fromEnvironment(
    'APP_ID',
    defaultValue: '',
  );
  const String firebaseMeasurementId = String.fromEnvironment(
    'MEASUREMENT_ID',
    defaultValue: '',
  );

  if (!kIsWeb) {
    await dotenv.load(fileName: "mobus.env");
  }

  FirebaseOptions options;

  if (kIsWeb) {
    options = FirebaseOptions(
      apiKey: firebaseApiKey,
      authDomain: firebaseAuthDomain,
      databaseURL: firebaseDatabaseUrl,
      projectId: firebaseProjectId,
      storageBucket: firebaseStorageBucket,
      messagingSenderId: firebaseMessagingSenderId,
      appId: firebaseAppId,
      measurementId: firebaseMeasurementId,
    );
  } else {
    options = FirebaseOptions(
      apiKey: dotenv.env['API_KEY'] ?? '',
      authDomain: dotenv.env['AUTH_DOMAIN'] ?? '',
      databaseURL: dotenv.env['DATABASE_URL'] ?? '',
      projectId: dotenv.env['PROJECT_ID'] ?? '',
      storageBucket: dotenv.env['STORAGE_BUCKET'] ?? '',
      messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? '',
      appId: dotenv.env['APP_ID'] ?? '',
      measurementId: dotenv.env['MEASUREMENT_ID'] ?? '',
    );
  }

  if (options.apiKey.isEmpty) {
    throw Exception(
      "ERRO CRÍTICO: A chave API_KEY do Firebase está vazia. Verifique seu mobus.env e o comando de build.",
    );
  }

  await Firebase.initializeApp(options: options);

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
                    MaterialPageRoute(
                      builder: (context) => const BusChoicePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 18,
                  ),
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
