import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/user_model.dart';

class RelatoriosUser extends StatefulWidget {
  final UserModel user;

  const RelatoriosUser({super.key, required this.user});

  @override
  State<RelatoriosUser> createState() => _RelatoriosUserState();
}

class _RelatoriosUserState extends State<RelatoriosUser> {
  static const List<_ChartSlice> _slices = [
    _ChartSlice(label: 'Ansiedade', value: 40, color: Color(0xFF4C78A8)),
    _ChartSlice(label: 'Tristeza', value: 30, color: Color(0xFFF2B134)),
    _ChartSlice(label: 'Estresse', value: 15, color: Color(0xFFE76F51)),
    _ChartSlice(label: 'Bem-estar', value: 15, color: Color(0xFF2A9D8F)),
  ];

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Relatórios'),
        backgroundColor: AppColors.smallDetail,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, ${widget.user.name}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Resumo emocional da semana',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Distribuição por sentimento',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AspectRatio(
                    aspectRatio: 1.4,
                    child: Row(
                      children: [
                        Expanded(
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback: (_, pieTouchResponse) {
                                  setState(() {
                                    if (pieTouchResponse
                                            ?.touchedSection
                                            ?.touchedSectionIndex ==
                                        null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse!
                                        .touchedSection!
                                        .touchedSectionIndex;
                                  });
                                },
                              ),
                              sectionsSpace: 2,
                              centerSpaceRadius: 38,
                              borderData: FlBorderData(show: false),
                              sections: _showingSections(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _slices
                                .map(
                                  (slice) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: _LegendItem(
                                      color: slice.color,
                                      label:
                                          '${slice.label} (${slice.value.toInt()}%)',
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(_slices.length, (index) {
      final data = _slices[index];
      final isTouched = index == touchedIndex;

      return PieChartSectionData(
        color: data.color,
        value: data.value,
        title: '${data.value.toInt()}%',
        radius: isTouched ? 58 : 50,
        titleStyle: TextStyle(
          fontSize: isTouched ? 16 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.text, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _ChartSlice {
  final String label;
  final double value;
  final Color color;

  const _ChartSlice({
    required this.label,
    required this.value,
    required this.color,
  });
}
