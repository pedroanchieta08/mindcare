import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../data/sentiment_store.dart';
import '../models/app_user.dart';
import '../services/professional_service.dart';
import '../services/shared_report_service.dart';

class RelatoriosUser extends StatefulWidget {
  final AppUser user;

  const RelatoriosUser({super.key, required this.user});

  @override
  State<RelatoriosUser> createState() => _RelatoriosUserState();
}

class _RelatoriosUserState extends State<RelatoriosUser> {
  static const List<String> _monthNames = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];

  static const List<String> _weekdayNames = [
    'Segunda-feira',
    'Terca-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sabado',
    'Domingo',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWide = screenWidth > 800;
    final double horizontalPadding = isWide ? screenWidth * 0.12 : 16.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: StreamBuilder<List<SentimentEntry>>(
          stream: SentimentStore().watchEntries(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Erro ao carregar relatorios: ${snapshot.error}',
                    style: const TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final sentiments = snapshot.data ?? [];
            final report = _buildReport(sentiments);

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildTopHeader(isWide),
                  if (sentiments.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 12,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () => _openShareReportDialog(sentiments),
                          icon: const Icon(Icons.share_outlined),
                          label: const Text('Compartilhar relatório'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.smallDetail,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      isWide ? 40 : 12,
                      horizontalPadding,
                      40,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              report.currentMonth.name,
                              style: TextStyle(
                                color: AppColors.smallDetail,
                                fontSize: isWide ? 28 : 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 10),
                            CircleAvatar(
                              radius: isWide ? 22 : 17,
                              backgroundColor: AppColors.smallDetail,
                              child: Icon(
                                Icons.calendar_today_rounded,
                                color: Colors.white,
                                size: isWide ? 20 : 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isWide ? 30 : 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: isWide ? 260 : 170,
                              height: isWide ? 260 : 170,
                              child: _SimplePieChart(
                                slices: report.currentMonth.slices,
                              ),
                            ),
                            SizedBox(width: isWide ? 40 : 16),
                            Expanded(
                              child: _MonthlyRegisterCard(
                                isWide: isWide,
                                entries: report.currentMonthEntries,
                                onTap: () =>
                                    _openAllRecordsSheet(report.allEntries),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isWide ? 50 : 36),
                        if (report.months.isNotEmpty)
                          Row(
                            children: report.months
                                .map(
                                  (month) => Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isWide ? 12 : 6,
                                      ),
                                      child: _MonthCard(
                                        month: month,
                                        isWide: isWide,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _ReportData _buildReport(List<SentimentEntry> sentiments) {
    final now = DateTime.now();
    final allEntries = sentiments.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final months = List.generate(
      3,
      (index) => DateTime(now.year, now.month - (2 - index), 1),
    );

    final summaries = months
        .map((monthDate) => _buildMonthSummary(monthDate, allEntries))
        .toList();

    final currentMonthEntries =
        allEntries.where((entry) => _isSameMonth(entry.date, now)).toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    final mappedEntries = currentMonthEntries
        .map(
          (entry) => _MonthlyEntry(
            icon: _iconForLabel(entry.label),
            text: _formatEntryDate(entry.date),
          ),
        )
        .toList();

    final allEntriesDesc = allEntries.reversed.toList();

    return _ReportData(
      currentMonth: summaries.last,
      currentMonthEntries: mappedEntries,
      months: summaries.where((summary) => summary.totalEntries > 0).toList(),
      allEntries: allEntriesDesc,
    );
  }

  _MonthSummary _buildMonthSummary(
    DateTime month,
    List<SentimentEntry> entries,
  ) {
    final monthEntries = entries.where(
      (entry) => _isSameMonth(entry.date, month),
    );

    final Map<String, int> counts = {};
    for (final entry in monthEntries) {
      final key = entry.label.trim();
      if (key.isEmpty) {
        continue;
      }

      counts[key] = (counts[key] ?? 0) + 1;
    }

    if (counts.isEmpty) {
      return _MonthSummary(
        name: _formatMonthYear(month),
        slices: const [
          _ChartSlice(
            label: 'Sem registros',
            value: 100,
            color: Color(0xFFBDBDBD),
          ),
        ],
        totalEntries: 0,
      );
    }

    final total = counts.values.fold<int>(0, (sum, value) => sum + value);
    final sortedLabels = counts.keys.toList()..sort();

    final slices = sortedLabels
        .map(
          (label) => _ChartSlice(
            label: label,
            value: (counts[label]! * 100) / total,
            color: _colorForLabel(label),
          ),
        )
        .toList();

    return _MonthSummary(
      name: _formatMonthYear(month),
      slices: slices,
      totalEntries: total,
    );
  }

  bool _isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  String _formatMonthYear(DateTime date) {
    final monthName = _monthNames[date.month - 1];
    return '$monthName/${date.year}';
  }

  String _formatEntryDate(DateTime date) {
    final dayName = _weekdayNames[date.weekday - 1];
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$dayName $day/$month';
  }

  String _formatFullEntryDate(DateTime date) {
    final dayName = _weekdayNames[date.weekday - 1];
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$dayName $day/$month/${date.year}';
  }

  void _openAllRecordsSheet(List<SentimentEntry> entries) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              children: [
                Container(
                  width: 54,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Text(
                  'Todos os registros (${entries.length})',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: entries.isEmpty
                      ? const Center(
                          child: Text(
                            'Este usuario ainda nao possui registros.',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.separated(
                          itemCount: entries.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final entry = entries[index];
                            return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        _iconForLabel(entry.label),
                                        color: _colorForLabel(entry.label),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          entry.label,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _formatFullEntryDate(entry.date),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (entry.text.trim().isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(entry.text.trim()),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openShareReportDialog(List<SentimentEntry> entries) async {
    final professionals = await ProfessionalService().getAllProfessionals();

    if (professionals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum profissional cadastrado.')),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 54,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Text(
                  'Compartilhar relatório com profissional',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                if (entries.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('Não há registros para compartilhar.'),
                  ),
                ...professionals.map((professional) {
                  return ListTile(
                    title: Text(professional.name),
                    subtitle: Text(professional.email),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await _shareReportWithProfessional(
                        professionalUid: professional.uid,
                        entries: entries,
                      );
                    },
                  );
                }).toList(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _shareReportWithProfessional({
    required String professionalUid,
    required List<SentimentEntry> entries,
  }) async {
    final trimmedProfessionalUid = professionalUid.trim();
    if (trimmedProfessionalUid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profissional inválido. Tente novamente.'),
        ),
      );
      return;
    }

    final counts = <String, int>{};

    for (final entry in entries) {
      final label = entry.label.trim();
      if (label.isEmpty) continue;
      counts[label] = (counts[label] ?? 0) + 1;
    }

    try {
      await SharedReportService().shareReport(
        professionalUid: trimmedProfessionalUid,
        userId: widget.user.uid,
        patientName: widget.user.name,
        counts: counts,
        totalEntries: entries.length,
        sharedAt: DateTime.now(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Relatório compartilhado com sucesso.')),
      );
    } on FirebaseException catch (e) {
      final message = switch (e.code) {
        'permission-denied' =>
          'Sem permissão no Firebase para compartilhar. Verifique as regras do Firestore.',
        'unavailable' =>
          'Firebase indisponível no momento. Tente novamente em instantes.',
        _ => 'Erro no Firebase ao compartilhar relatório (${e.code}).',
      };

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao compartilhar relatório: $e')),
      );
    }
  }

  IconData _iconForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'feliz':
        return Icons.sentiment_satisfied_alt_rounded;
      case 'calmo':
        return Icons.sentiment_neutral_rounded;
      case 'triste':
        return Icons.sentiment_dissatisfied_rounded;
      case 'ansioso':
        return Icons.mood_bad_rounded;
      case 'irritado':
        return Icons.sentiment_very_dissatisfied_rounded;
      default:
        return Icons.sentiment_neutral_rounded;
    }
  }

  Color _colorForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'feliz':
        return const Color(0xFFF8ED00);
      case 'calmo':
        return const Color(0xFFE51616);
      case 'triste':
        return const Color(0xFF1727FF);
      case 'irritado':
        return const Color(0xFF05940B);
      case 'ansioso':
        return const Color(0xFF8A7A00);
      default:
        return const Color(0xFF8A8A8A);
    }
  }

  Widget _buildTopHeader(bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 10, bottom: isWide ? 40 : 20),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 16,
            top: 0,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.blueGrey,
                size: isWide ? 32 : 24,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: isWide ? 30 : 40),
              Container(
                width: isWide ? 180 : 128,
                height: isWide ? 180 : 128,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade600, width: 4),
                ),
                child: Icon(
                  Icons.person_outline,
                  size: isWide ? 110 : 78,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: isWide ? 24 : 16),
              _UserChip(name: widget.user.name, isWide: isWide),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserChip extends StatelessWidget {
  final String name;
  final bool isWide;

  const _UserChip({required this.name, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isWide ? 64 : 54,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 40 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isWide ? 38 : 34,
              color: const Color(0xFF808080),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyRegisterCard extends StatelessWidget {
  final List<_MonthlyEntry> entries;
  final bool isWide;
  final VoidCallback onTap;

  const _MonthlyRegisterCard({
    required this.entries,
    required this.isWide,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final visibleEntries = entries.take(3).toList();
    final remainingCount = entries.length - visibleEntries.length;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isWide ? 24 : 14),
        decoration: BoxDecoration(
          color: AppColors.smallDetail,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Registro Mensal',
              style: TextStyle(
                color: Colors.white,
                fontSize: isWide ? 32 : 26,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: isWide ? 16 : 8),
            if (entries.isEmpty)
              Text(
                'Sem registros neste mes.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isWide ? 18 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ...visibleEntries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 20 : 10,
                    vertical: isWide ? 14 : 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEDED),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        entry.icon,
                        size: isWide ? 24 : 18,
                        color: const Color(0xFF8A7A00),
                      ),
                      SizedBox(width: isWide ? 14 : 8),
                      Expanded(
                        child: Text(
                          entry.text,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF707070),
                            fontSize: isWide ? 18 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (remainingCount > 0) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 20 : 10,
                  vertical: isWide ? 14 : 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDEDEDE),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'Veja mais',
                  style: TextStyle(
                    color: const Color(0xFF4A4A4A),
                    fontSize: isWide ? 18 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MonthCard extends StatelessWidget {
  final _MonthSummary month;
  final bool isWide;

  const _MonthCard({required this.month, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isWide ? 280 : 200,
      padding: EdgeInsets.all(isWide ? 20 : 12),
      decoration: BoxDecoration(
        color: AppColors.smallDetail,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            month.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: isWide ? 20 : 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Center(
              child: SizedBox(
                width: isWide ? 110 : 64,
                height: isWide ? 110 : 64,
                child: _SimplePieChart(slices: month.slices),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportData {
  final _MonthSummary currentMonth;
  final List<_MonthlyEntry> currentMonthEntries;
  final List<_MonthSummary> months;
  final List<SentimentEntry> allEntries;

  const _ReportData({
    required this.currentMonth,
    required this.currentMonthEntries,
    required this.months,
    required this.allEntries,
  });
}

class _SimplePieChart extends StatelessWidget {
  final List<_ChartSlice> slices;
  final bool showLabels;

  const _SimplePieChart({required this.slices, this.showLabels = true});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _SimplePiePainter(slices: slices, showLabels: showLabels),
      ),
    );
  }
}

class _SimplePiePainter extends CustomPainter {
  final List<_ChartSlice> slices;
  final bool showLabels;

  _SimplePiePainter({required this.slices, required this.showLabels});

  @override
  void paint(Canvas canvas, Size size) {
    if (slices.isEmpty) {
      return;
    }

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -math.pi / 2;
    for (final slice in slices) {
      final sweepAngle = (slice.value / 100) * 2 * math.pi;

      final paint = Paint()
        ..color = slice.color
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);

      if (showLabels && size.shortestSide >= 90 && slice.value >= 8) {
        final percentageText = '${slice.value.round()}%';
        final textPainter = TextPainter(
          text: TextSpan(
            text: percentageText,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: (size.shortestSide * 0.11).clamp(10.0, 18.0),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        final midAngle = startAngle + (sweepAngle / 2);
        final labelRadius = radius * 0.62;
        final labelOffset = Offset(
          center.dx + math.cos(midAngle) * labelRadius,
          center.dy + math.sin(midAngle) * labelRadius,
        );

        textPainter.paint(
          canvas,
          Offset(
            labelOffset.dx - (textPainter.width / 2),
            labelOffset.dy - (textPainter.height / 2),
          ),
        );
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _SimplePiePainter oldDelegate) {
    if (oldDelegate.slices.length != slices.length) {
      return true;
    }

    for (var i = 0; i < slices.length; i++) {
      if (oldDelegate.slices[i].value != slices[i].value ||
          oldDelegate.slices[i].color != slices[i].color) {
        return true;
      }
    }

    return false;
  }
}

class _ChartSlice {
  final String label;
  final double value;
  final Color color;
  final bool showTitle;

  const _ChartSlice({
    required this.label,
    required this.value,
    required this.color,
    this.showTitle = true,
  });
}

class _MonthlyEntry {
  final IconData icon;
  final String text;

  const _MonthlyEntry({required this.icon, required this.text});
}

class _MonthSummary {
  final String name;
  final List<_ChartSlice> slices;
  final int totalEntries;

  const _MonthSummary({
    required this.name,
    required this.slices,
    required this.totalEntries,
  });
}
