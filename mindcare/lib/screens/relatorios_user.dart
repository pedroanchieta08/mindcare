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
    _ChartSlice(label: 'Alegria', value: 41, color: Color(0xFFF8ED00)),
    _ChartSlice(label: 'Calma', value: 31, color: Color(0xFFE51616)),
    _ChartSlice(label: 'Tristeza', value: 12, color: Color(0xFF1727FF)),
    _ChartSlice(label: 'Estresse', value: 10, color: Color(0xFF05940B)),
    _ChartSlice(label: 'Ansiedade', value: 11, color: Color(0xFF8A7A00)),
  ];

  static const List<_MonthSummary> _months = [
    _MonthSummary(
      name: 'Jan/2026',
      slices: [
        _ChartSlice(label: 'Alegria', value: 20, color: Color(0xFFF8ED00)),
        _ChartSlice(label: 'Calma', value: 20, color: Color(0xFFE51616)),
        _ChartSlice(label: 'Tristeza', value: 30, color: Color(0xFF1727FF)),
        _ChartSlice(label: 'Estresse', value: 30, color: Color(0xFF05940B)),
      ],
    ),
    _MonthSummary(
      name: 'Fev/2026',
      slices: [
        _ChartSlice(label: 'Alegria', value: 35, color: Color(0xFFF8ED00)),
        _ChartSlice(label: 'Calma', value: 12, color: Color(0xFFE51616)),
        _ChartSlice(label: 'Tristeza', value: 28, color: Color(0xFF1727FF)),
        _ChartSlice(label: 'Estresse', value: 25, color: Color(0xFF05940B)),
      ],
    ),
    _MonthSummary(
      name: 'Mar/2026',
      slices: [
        _ChartSlice(label: 'Alegria', value: 25, color: Color(0xFFF8ED00)),
        _ChartSlice(label: 'Calma', value: 25, color: Color(0xFFE51616)),
        _ChartSlice(label: 'Tristeza', value: 20, color: Color(0xFF1727FF)),
        _ChartSlice(label: 'Estresse', value: 30, color: Color(0xFF05940B)),
        _ChartSlice(label: 'Ansiedade', value: 10, color: Color(0xFF8A7A00)),
      ],
    ),
  ];

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Abr/2026',
                          style: TextStyle(
                            color: AppColors.smallDetail,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 17,
                          backgroundColor: AppColors.smallDetail,
                          child: Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback: (_, pieTouchResponse) {
                                    setState(() {
                                      touchedIndex =
                                          pieTouchResponse
                                              ?.touchedSection
                                              ?.touchedSectionIndex ??
                                          -1;
                                    });
                                  },
                                ),
                                centerSpaceRadius: 0,
                                sectionsSpace: 0,
                                borderData: FlBorderData(show: false),
                                sections: _showingSections(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MonthlyRegisterCard(
                            entries: const [
                              _MonthlyEntry(
                                icon: Icons.sentiment_satisfied_alt_rounded,
                                text: 'Terça-feira 01/04',
                              ),
                              _MonthlyEntry(
                                icon: Icons.sentiment_dissatisfied_rounded,
                                text: 'Quarta-feira 02/04',
                              ),
                              _MonthlyEntry(
                                icon: Icons.mood_bad_rounded,
                                text: 'Quinta-feira 03/04',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    Row(
                      children: _months
                          .map(
                            (month) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: _MonthCard(month: month),
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
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return SizedBox(
      height: 235,
      child: Stack(
        children: [
          Positioned(
            left: 4,
            top: 6,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.smallDetail,
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 64,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade600, width: 4),
              ),
              child: const Icon(Icons.person_outline, size: 78),
            ),
          ),
          Positioned(
            top: 98,
            left: 162,
            right: 20,
            child: _UserChip(name: widget.user.name),
          ),
        ],
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
        radius: isTouched ? 85 : 78,
        titleStyle: TextStyle(
          fontSize: isTouched ? 15 : 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}

class _UserChip extends StatelessWidget {
  final String name;

  const _UserChip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Center(
        child: Text(
          name,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 34,
            color: Color(0xFF808080),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _MonthlyRegisterCard extends StatelessWidget {
  final List<_MonthlyEntry> entries;

  const _MonthlyRegisterCard({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.smallDetail,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Registro Mensal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ...entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEDED),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Icon(entry.icon, size: 18, color: const Color(0xFF8A7A00)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.text,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF707070),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthCard extends StatelessWidget {
  final _MonthSummary month;

  const _MonthCard({required this.month});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.smallDetail,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            month.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 0,
                sectionsSpace: 0,
                borderData: FlBorderData(show: false),
                sections: month.slices
                    .map(
                      (slice) => PieChartSectionData(
                        color: slice.color,
                        value: slice.value,
                        title: '',
                        radius: 32,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
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

class _MonthlyEntry {
  final IconData icon;
  final String text;

  const _MonthlyEntry({required this.icon, required this.text});
}

class _MonthSummary {
  final String name;
  final List<_ChartSlice> slices;

  const _MonthSummary({required this.name, required this.slices});
}
