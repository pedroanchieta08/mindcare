import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../data/sentiment_store.dart';
import '../constants/app_colors.dart';
import 'package:mindcare/widgets/bottombar.dart';
import '../models/app_user.dart';

final _calendarFirstDay = DateTime.utc(2020, 1, 1);
final _calendarLastDay = DateTime.utc(2030, 12, 31);

class CalendarPage extends StatefulWidget {
  final AppUser user;

  const CalendarPage({super.key, required this.user});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedMonth;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime.now();
    _selectedDay = _focusedMonth;
  }

  void _onDaySelected(DateTime selected, DateTime focused) {
    setState(() {
      _selectedDay = selected;
      _focusedMonth = focused;
    });
  }

  Map<String, SentimentEntry> _groupEntriesByDay(List<SentimentEntry> entries) {
    final grouped = <String, SentimentEntry>{};

    for (final entry in entries) {
      final key = _dateKey(entry.date);
      final existing = grouped[key];

      if (existing == null || entry.date.isAfter(existing.date)) {
        grouped[key] = entry;
      }
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.largeDetail,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.smallDetail),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 110),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height),
            child: Stack(
              children: [
                _CurvedBackground(height: size.height * 0.68),

                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: StreamBuilder<List<SentimentEntry>>(
                      stream: SentimentStore().watchEntries(),
                      builder: (context, snapshot) {
                        final entries = snapshot.data ?? [];
                        final sentiments = _groupEntriesByDay(entries);

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 80),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        return _CalendarCard(
                          width: size.width * 0.92,
                          focusedMonth: _focusedMonth,
                          selectedDay: _selectedDay,
                          sentiments: sentiments,
                          onDaySelected: _onDaySelected,
                          onPageChanged: (focused) {
                            setState(() {
                              _focusedMonth = focused;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 3) return;

          Navigator.pop(context);
        },
      ),
    );
  }
}

class _CurvedBackground extends StatelessWidget {
  const _CurvedBackground({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        color: AppColors.largeDetail,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(90),
          bottomRight: Radius.circular(90),
        ),
      ),
    );
  }
}

String _dateKey(DateTime d) {
  return '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.width,
    required this.focusedMonth,
    required this.selectedDay,
    required this.sentiments,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  final double width;
  final DateTime focusedMonth;
  final DateTime? selectedDay;
  final Map<String, SentimentEntry> sentiments;
  final void Function(DateTime selected, DateTime focused) onDaySelected;
  final void Function(DateTime focused) onPageChanged;

  String _key(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.destaque,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          TableCalendar(
            locale: 'pt_BR',
            firstDay: _calendarFirstDay,
            lastDay: _calendarLastDay,
            focusedDay: focusedMonth,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: onDaySelected,
            onPageChanged: onPageChanged,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, _) {
                final sentiment = sentiments[_key(date)];

                if (sentiment == null) {
                  return const SizedBox.shrink();
                }

                return Center(
                  child: Text(
                    sentiment.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
        ],
      ),
    );
  }
}
