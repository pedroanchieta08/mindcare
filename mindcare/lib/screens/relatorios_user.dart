import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/user_model.dart';

class RelatoriosUser extends StatelessWidget {
  final UserModel user;

  const RelatoriosUser({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios do Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome: ${user.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('E-mail: ${user.email}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              'Relatórios de Saúde Mental:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(),
          ],
        ),
      ),
    );
  }
}
