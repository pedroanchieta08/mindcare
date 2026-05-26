import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../constants/app_colors.dart';
import '../models/profissional_model.dart';
import 'login_screen.dart';

class GraphData {
  final String mes;
  final double valor;
  GraphData(this.mes, this.valor);
}

class RelatoriosProfissional extends StatefulWidget {
  final ProfissionalModel profissional;

  const RelatoriosProfissional({super.key, required this.profissional});

  @override
  State<RelatoriosProfissional> createState() => _RelatoriosProfissionalState();
}

class _RelatoriosProfissionalState extends State<RelatoriosProfissional> {
  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Sair',
          onPressed: () => _logout(),
        ),
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
          insetPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Expanded(child: Text('Relatório de $name')),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Fechar'),
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(subtitle, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 16),
                const Text(
                  'Resumo do Relatório:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  padding: const EdgeInsets.only(right: 12),
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      axisLine: const AxisLine(width: 1, color: Colors.black54),
                      labelStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),

                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: 35,
                      interval: 10,
                      axisLine: const AxisLine(width: 1, color: Colors.black54),
                      majorGridLines: const MajorGridLines(
                        width: 0.5,
                        color: Colors.black12,
                      ),
                    ),
                    series: <CartesianSeries<GraphData, String>>[
                      BarSeries<GraphData, String>(
                        dataSource: [
                          GraphData('Jan', 20),
                          GraphData('Fev', 30),
                          GraphData('Mar', 15),
                          GraphData('Abr', 25),
                          GraphData('Mai', 10),
                          GraphData('Jun', 30),
                        ],
                        xValueMapper: (GraphData data, _) => data.mes,
                        yValueMapper: (GraphData data, _) => data.valor,
                        color: AppColors.smallDetail,
                        width: 0.6,
                        borderRadius: BorderRadius.zero,

                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
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
