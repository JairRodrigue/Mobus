import 'package:flutter/material.dart';
import 'login_page.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); 
          },
    ***REMOVED***
        title: const Text(
          'Criar Conta',
          style: TextStyle(color: Colors.white),
    ***REMOVED***
        centerTitle: true,
  ***REMOVED***
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.directions_bus,
                size: 100,
                color: Colors.white,
          ***REMOVED***
              const SizedBox(height: 20),

              // Campo Nome
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
              ***REMOVED***
                  prefixIcon: const Icon(Icons.person, color: Colors.white),
            ***REMOVED***
          ***REMOVED***
              const SizedBox(height: 20),

              // Campo E-mail
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
              ***REMOVED***
                  prefixIcon: const Icon(Icons.email, color: Colors.white),
            ***REMOVED***
          ***REMOVED***
              const SizedBox(height: 20),

              // Campo Senha
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
              ***REMOVED***
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                ***REMOVED***
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
              ***REMOVED***
            ***REMOVED***
          ***REMOVED***
              const SizedBox(height: 30),

              // Botão Criar Conta
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Criar Conta pressionado!')),
                ***REMOVED***
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
              ***REMOVED***
            ***REMOVED***
                child: const Text(
                  'Criar Conta',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ***REMOVED***
          ***REMOVED***
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Já tem uma conta? ",
                    style: TextStyle(color: Colors.white70),
              ***REMOVED***
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                      ***REMOVED***
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                    ***REMOVED***
                  ***REMOVED***
                ***REMOVED***
              ***REMOVED***
                ],
          ***REMOVED***
              const SizedBox(height: 40),
            ],
      ***REMOVED***
    ***REMOVED***
  ***REMOVED***
  ***REMOVED***
  }
}
