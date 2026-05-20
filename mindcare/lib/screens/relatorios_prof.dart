import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/user_model.dart';

class RelatoriosProf extends StatefulWidget {
  final UserModel user;

  const RelatoriosProf({super.key, required this.user});

  @override
  State<RelatoriosProf> createState() => _RelatoriosProfState();
}

class _RelatoriosProfState extends State<RelatoriosProf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Meus Pacientes'),
        backgroundColor: AppColors.smallDetail,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 24),
            const Text(
              'RELATÓRIOS RECEBIDOS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            _buildReportCard(
              name: 'Fátima',
              subtitle: 'Relatório · 01 abr - 07 abr · 2026',
              status: 'NOVO',
              positiveButton: 'Ver relatório',
              negativeButton: 'Marcar visto',
            ),
            _buildReportCard(
              name: 'Otávio',
              subtitle: 'Relatório · 01 abr - 07 abr · 2026',
              status: 'Visto',
              positiveButton: 'Ver relatório',
              negativeButton: 'Desmarcar visto',
              statusColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: Colors.black54),
          hintText: 'Buscar paciente...',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required String name,
    required String subtitle,
    required String status,
    required String positiveButton,
    required String negativeButton,
    Color statusColor = Colors.redAccent,
  }) {
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.smallDetail,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha((0.15 * 255).round()),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    positiveButton,
                    AppColors.smallDetail,
                    onPressed: () =>
                        _showReportDialog(name: name, subtitle: subtitle),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    negativeButton,
                    AppColors.largeDetail,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    Color color, {
    VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed ?? () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showReportDialog({required String name, required String subtitle}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle),
              const SizedBox(height: 12),
              const Text('Resumo do relatório:'),
              const SizedBox(height: 8),
              const Text('- Item 1: informação...'),
              const SizedBox(height: 4),
              const Text('- Item 2: informação...'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Aqui você pode adicionar ação de marcar como visto
                Navigator.of(context).pop();
              },
              child: const Text('Marcar visto'),
            ),
          ],
        );
      },
    );
  }
}
