import 'package:flutter/material.dart';
import '../models/profissional_model.dart';
import 'package:mindcare/screens/login_screen.dart';

class RelatoriosProfissional extends StatelessWidget {
  final ProfissionalModel profissional;

  const RelatoriosProfissional({super.key, required this.profissional});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEEF0),
      appBar: AppBar(
        title: const Text('Relatórios'),
        backgroundColor: const Color(0xFF6A9E96),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.assignment_rounded,
                size: 72,
                color: Color(0xFF6A9E96),
              ),
              const SizedBox(height: 20),
              Text(
                'Bem-vindo, ${profissional.name}!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF2E5F58),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                profissional.email,
                style: const TextStyle(
                  color: Color(0xFF4A7A72),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A9E96),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Sair'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
