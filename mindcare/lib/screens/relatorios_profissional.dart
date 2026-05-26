import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/profissional_model.dart';
import 'login_screen.dart';

class EmotionDistribution {
  final String label;
  final int percent;
  final Color color;
  final IconData icon;

  const EmotionDistribution({
    required this.label,
    required this.percent,
    required this.color,
    required this.icon,
  });
}

class ReportItem {
  final String name;
  final String subtitle;
  bool isSeen;
  final List<EmotionDistribution> emotions;

  ReportItem({
    required this.name,
    required this.subtitle,
    required this.isSeen,
    required this.emotions,
  });
}

class RelatoriosProfissional extends StatefulWidget {
  final ProfissionalModel profissional;

  const RelatoriosProfissional({super.key, required this.profissional});

  @override
  State<RelatoriosProfissional> createState() => _RelatoriosProfissionalState();
}

class _RelatoriosProfissionalState extends State<RelatoriosProfissional> {
  late final List<ReportItem> _reports;

  @override
  void initState() {
    super.initState();
    _reports = [
      ReportItem(
        name: 'Fatima',
        subtitle: 'Relatorio · 01 abr - 07 abr · 2026',
        isSeen: false,
        emotions: const [
          EmotionDistribution(
            label: 'Calmo',
            percent: 45,
            color: Color(0xFF188D14),
            icon: Icons.sentiment_satisfied,
          ),
          EmotionDistribution(
            label: 'Feliz',
            percent: 25,
            color: Color(0xFF2E91D9),
            icon: Icons.sentiment_very_satisfied,
          ),
          EmotionDistribution(
            label: 'Ansioso',
            percent: 20,
            color: Color(0xFFE5C92E),
            icon: Icons.sentiment_neutral,
          ),
          EmotionDistribution(
            label: 'Irritado',
            percent: 5,
            color: Color(0xFFF25E5E),
            icon: Icons.sentiment_dissatisfied,
          ),
          EmotionDistribution(
            label: 'Triste',
            percent: 5,
            color: Color(0xFFF25E5E),
            icon: Icons.sentiment_very_dissatisfied,
          ),
        ],
      ),
      ReportItem(
        name: 'Otavio',
        subtitle: 'Relatorio · 12 fev - 18 jun · 2026',
        isSeen: true,
        emotions: const [
          EmotionDistribution(
            label: 'Calmo',
            percent: 30,
            color: Color(0xFF188D14),
            icon: Icons.sentiment_satisfied,
          ),
          EmotionDistribution(
            label: 'Feliz',
            percent: 35,
            color: Color(0xFF2E91D9),
            icon: Icons.sentiment_very_satisfied,
          ),
          EmotionDistribution(
            label: 'Ansioso',
            percent: 15,
            color: Color(0xFFE5C92E),
            icon: Icons.sentiment_neutral,
          ),
          EmotionDistribution(
            label: 'Irritado',
            percent: 10,
            color: Color(0xFFF25E5E),
            icon: Icons.sentiment_dissatisfied,
          ),
          EmotionDistribution(
            label: 'Triste',
            percent: 10,
            color: Color(0xFFF25E5E),
            icon: Icons.sentiment_very_dissatisfied,
          ),
        ],
      ),
    ];
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _toggleSeen(int index) {
    setState(() {
      _reports[index].isSeen = !_reports[index].isSeen;
    });
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
            ...List.generate(
              _reports.length,
              (index) =>
                  _buildReportCard(report: _reports[index], index: index),
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

  Widget _buildReportCard({required ReportItem report, required int index}) {
    final status = report.isSeen ? 'Visto' : 'NOVO';
    final statusColor = report.isSeen ? Colors.teal : Colors.redAccent;
    final seenButtonLabel = report.isSeen ? 'Desmarcar visto' : 'Marcar visto';

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
                        report.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.subtitle,
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
                    'Ver relatorio',
                    AppColors.smallDetail,
                    onPressed: () =>
                        _showReportDialog(report: report, index: index),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    seenButtonLabel,
                    AppColors.largeDetail,
                    onPressed: () => _toggleSeen(index),
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

  void _showReportDialog({required ReportItem report, required int index}) {
    final markLabel = report.isSeen ? 'Desmarcar visto' : 'Marcar visto';

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
              Expanded(child: Text('Relatorio de ${report.name}')),
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
                Text(
                  report.subtitle,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Distribuição de emoções:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildEmotionDistributionChart(report.emotions),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _toggleSeen(index);
                Navigator.of(context).pop();
              },
              child: Text(markLabel),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmotionDistributionChart(List<EmotionDistribution> emotions) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDEEEF),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          ...emotions.map(_buildEmotionRow),
        ],
      ),
    );
  }

  Widget _buildEmotionRow(EmotionDistribution emotion) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            height: 34,
            child: Center(
              child: Icon(emotion.icon, color: Colors.black87, size: 22),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final barWidth =
                            constraints.maxWidth * (emotion.percent / 100);

                        return Stack(
                          children: [
                            Container(height: 14, color: Colors.transparent),
                            Container(
                              width: barWidth,
                              height: 14,
                              decoration: BoxDecoration(
                                color: emotion.color,
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 48,
                  child: Text(
                    '${emotion.percent}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
