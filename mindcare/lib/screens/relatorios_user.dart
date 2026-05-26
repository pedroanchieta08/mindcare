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
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWide = screenWidth > 800;
    final double horizontalPadding = isWide ? screenWidth * 0.12 : 16.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopHeader(isWide),
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
                          'Abr/2026',
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
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isWide ? 260 : 170,
                          height: isWide ? 260 : 170,
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
                              sections: _showingSections(isWide),
                            ),
                          ),
                        ),
                        SizedBox(width: isWide ? 40 : 16),
                        Expanded(
                          child: _MonthlyRegisterCard(
                            isWide: isWide,
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
                    SizedBox(height: isWide ? 50 : 36),
                    Row(
                      children: _months
                          .map(
                            (month) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isWide ? 12 : 6,
                                ),
                                child: _MonthCard(month: month, isWide: isWide),
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
                Icons.arrow_back_ios_new,
                color: AppColors.smallDetail,
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

  List<PieChartSectionData> _showingSections(bool isWide) {
    return List.generate(_slices.length, (index) {
      final data = _slices[index];
      final isTouched = index == touchedIndex;

      final double baseRadius = isWide ? 120 : 78;
      final double touchedRadius = isWide ? 130 : 85;

      return PieChartSectionData(
        color: data.color,
        value: data.value,
        title: '${data.value.toInt()}%',
        radius: isTouched ? touchedRadius : baseRadius,
        titleStyle: TextStyle(
          fontSize: isTouched ? (isWide ? 18 : 15) : (isWide ? 15 : 13),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
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

  const _MonthlyRegisterCard({required this.entries, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          ...entries.map(
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
        ],
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
                          radius: isWide ? 55 : 32,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
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
