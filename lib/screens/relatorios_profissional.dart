import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String userId;
  final String name;
  final String subtitle;
  final List<EmotionDistribution> emotions;

  const ReportItem({
    required this.userId,
    required this.name,
    required this.subtitle,
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  final Map<String, bool> _seenByUser = {};

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _toggleSeen(String userId) {
    setState(() {
      _seenByUser[userId] = !(_seenByUser[userId] ?? false);
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
          onPressed: _logout,
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, usersSnapshot) {
          if (usersSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (usersSnapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Erro ao carregar usuarios: ${usersSnapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final usersById = {
            for (final doc
                in usersSnapshot.data?.docs ??
                    <QueryDocumentSnapshot<Map<String, dynamic>>>[])
              doc.id: doc.data(),
          };

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _firestore.collectionGroup('sentiments').snapshots(),
            builder: (context, sentimentsSnapshot) {
              if (sentimentsSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (sentimentsSnapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Erro ao carregar sentimentos: ${sentimentsSnapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final reports = _buildReports(
                usersById: usersById,
                sentimentDocs: sentimentsSnapshot.data?.docs ?? const [],
              );

              final filteredReports = reports.where((report) {
                if (_searchQuery.trim().isEmpty) {
                  return true;
                }

                return report.name.toLowerCase().contains(
                  _searchQuery.trim().toLowerCase(),
                );
              }).toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 24),
                    const Text(
                      'RELATORIOS RECEBIDOS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (filteredReports.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Nenhum registro compartilhado encontrado.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ...filteredReports.map(
                      (report) => _buildReportCard(report: report),
                    ),
                  ],
                ),
              );
            },
          );
        },
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
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: Colors.black54),
          hintText: 'Buscar paciente...',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildReportCard({required ReportItem report}) {
    final isSeen = _seenByUser[report.userId] ?? false;
    final status = isSeen ? 'Visto' : 'NOVO';
    final statusColor = isSeen ? Colors.teal : Colors.redAccent;
    final seenButtonLabel = isSeen ? 'Desmarcar visto' : 'Marcar visto';

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
                    onPressed: () => _showReportDialog(report: report),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    seenButtonLabel,
                    AppColors.largeDetail,
                    onPressed: () => _toggleSeen(report.userId),
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

  void _showReportDialog({required ReportItem report}) {
    final isSeen = _seenByUser[report.userId] ?? false;
    final markLabel = isSeen ? 'Desmarcar visto' : 'Marcar visto';

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
                  'Distribuicao de emocoes:',
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
                _toggleSeen(report.userId);
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

  List<ReportItem> _buildReports({
    required Map<String, Map<String, dynamic>> usersById,
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> sentimentDocs,
  }) {
    final Map<String, _UserSentimentAggregate> byUser = {};

    for (final doc in sentimentDocs) {
      final userRef = doc.reference.parent.parent;
      if (userRef == null) {
        continue;
      }

      final data = doc.data();
      if (!_isSharedWithProfessional(data)) {
        continue;
      }

      final rawLabel = (data['label'] ?? '').toString().trim();
      if (rawLabel.isEmpty) {
        continue;
      }

      final dateValue = data['date'];
      DateTime? date;
      if (dateValue is Timestamp) {
        date = dateValue.toDate();
      }

      final aggregate = byUser.putIfAbsent(
        userRef.id,
        () => _UserSentimentAggregate(),
      );

      aggregate.total += 1;
      aggregate.counts[rawLabel] = (aggregate.counts[rawLabel] ?? 0) + 1;

      if (date != null) {
        aggregate.firstDate =
            aggregate.firstDate == null || date.isBefore(aggregate.firstDate!)
            ? date
            : aggregate.firstDate;

        aggregate.lastDate =
            aggregate.lastDate == null || date.isAfter(aggregate.lastDate!)
            ? date
            : aggregate.lastDate;
      }
    }

    final reports = byUser.entries.map((entry) {
      final userId = entry.key;
      final aggregate = entry.value;
      final userMap = usersById[userId];
      final userName = (userMap?['name'] ?? '').toString().trim();

      final emotions = _buildEmotionDistribution(
        counts: aggregate.counts,
        total: aggregate.total,
      );

      final subtitle = _buildSubtitle(
        firstDate: aggregate.firstDate,
        lastDate: aggregate.lastDate,
        total: aggregate.total,
      );

      return ReportItem(
        userId: userId,
        name: userName.isEmpty ? 'Paciente sem nome' : userName,
        subtitle: subtitle,
        emotions: emotions,
      );
    }).toList();

    reports.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return reports;
  }

  bool _isSharedWithProfessional(Map<String, dynamic> data) {
    final hasAnyShareFlag =
        data.containsKey('sharedWithProfessional') ||
        data.containsKey('shared') ||
        data.containsKey('isShared');

    if (!hasAnyShareFlag) {
      // Backward compatibility: if no sharing flag exists yet, keep showing records.
      return true;
    }

    return data['sharedWithProfessional'] == true ||
        data['shared'] == true ||
        data['isShared'] == true;
  }

  List<EmotionDistribution> _buildEmotionDistribution({
    required Map<String, int> counts,
    required int total,
  }) {
    final labels = counts.keys.toList()
      ..sort((a, b) => counts[b]!.compareTo(counts[a]!));

    return labels
        .map((label) {
          final percent = ((counts[label]! / total) * 100).round();
          return EmotionDistribution(
            label: label,
            percent: percent,
            color: _colorForLabel(label),
            icon: _iconForLabel(label),
          );
        })
        .where((emotion) => emotion.percent > 0)
        .toList();
  }

  String _buildSubtitle({
    required DateTime? firstDate,
    required DateTime? lastDate,
    required int total,
  }) {
    final monthNames = [
      'jan',
      'fev',
      'mar',
      'abr',
      'mai',
      'jun',
      'jul',
      'ago',
      'set',
      'out',
      'nov',
      'dez',
    ];

    if (firstDate == null || lastDate == null) {
      return 'Relatorio compartilhado · $total registros';
    }

    final firstLabel =
        '${firstDate.day.toString().padLeft(2, '0')} ${monthNames[firstDate.month - 1]}';
    final lastLabel =
        '${lastDate.day.toString().padLeft(2, '0')} ${monthNames[lastDate.month - 1]}';

    return 'Relatorio · $firstLabel - $lastLabel · ${lastDate.year}';
  }

  IconData _iconForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'calmo':
        return Icons.sentiment_satisfied;
      case 'feliz':
        return Icons.sentiment_very_satisfied;
      case 'ansioso':
        return Icons.sentiment_neutral;
      case 'irritado':
        return Icons.sentiment_dissatisfied;
      case 'triste':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.mood;
    }
  }

  Color _colorForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'calmo':
        return const Color(0xFF188D14);
      case 'feliz':
        return const Color(0xFF2E91D9);
      case 'ansioso':
        return const Color(0xFFE5C92E);
      case 'irritado':
        return const Color(0xFFF25E5E);
      case 'triste':
        return const Color(0xFF8E4EC6);
      default:
        return Colors.grey;
    }
  }
}

class _UserSentimentAggregate {
  final Map<String, int> counts = {};
  int total = 0;
  DateTime? firstDate;
  DateTime? lastDate;
}
