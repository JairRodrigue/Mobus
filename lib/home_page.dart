import 'package:flutter/material.dart';
import 'login_page.dart'; // Import da página de login

class HomePage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  HomePage({super.key});

  // Função para rolar até a seção
  void _scrollTo(double position) {
    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          "Mobus",
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
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            color: Colors.blue.shade700,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavButton("Início", () => _scrollTo(0)),
                _buildNavButton("Funcionalidades", () => _scrollTo(400)),
                _buildNavButton("Sobre", () => _scrollTo(800)),
                _buildNavButton("Contato", () => _scrollTo(1200)),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              "Bem-vindo ao Mobus!",
              "Acompanhe o transporte em tempo real e saiba tudo sobre o seu trajeto.",
              Icons.directions_bus,
            ),
            _buildSection(
              "Funcionalidades",
              "Veja horários, rotas, localização em tempo real e muito mais.",
              Icons.map,
            ),
            _buildSection(
              "Sobre",
              "O Mobus é um aplicativo criado para facilitar a vida dos passageiros.",
              Icons.info,
            ),
            _buildSection(
              "Contato",
              "Entre em contato com nossa equipe de suporte.",
              Icons.contact_mail,
            ),
          ],
        ),
      ),
    );
  }

  // Botões do menu superior
  Widget _buildNavButton(String text, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Blocos de conteúdo
  Widget _buildSection(String title, String description, IconData icon) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          Icon(icon, size: 80, color: Colors.blue.shade700),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}