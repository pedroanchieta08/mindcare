import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'sentiment_store.dart';
import '../data/sentiment_store.dart';
import '../constants/app_colors.dart';
import 'package:mindcare/models/user_model.dart';
import 'home_screen.dart';
import '../widgets/bottombar.dart';

const _backgroundColor = Color(0xFFDEF0F3);
const _curveColor = Color(0xFFB2DDE2);
const _cardColor = Color(0xFFB8A9E0);

final _calendarFirstDay = DateTime.utc(2020, 1, 1);
final _calendarLastDay = DateTime.utc(2030, 12, 31);

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  final UserModel user;

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
    SentimentStore().addListener(_refresh);
  }

  @override
  void dispose() {
    SentimentStore().removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _onDaySelected(DateTime selected, DateTime focused) {
    setState(() {
      _selectedDay = selected;
      _focusedMonth = focused;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          _CurvedBackground(height: size.height * 0.78),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: _CalendarCard(
                width: size.width * 0.92,
                focusedMonth: _focusedMonth,
                selectedDay: _selectedDay,
                onDaySelected: _onDaySelected,
                onPageChanged: (focused) => _focusedMonth = focused,
              ),
            ),
          ),
        ],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 110),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height),
            child: Stack(
              children: [
                _CurvedBackground(height: size.height * 0.78),

                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: _CalendarCard(
                      width: size.width * 0.92,
                      focusedMonth: _focusedMonth,
                      selectedDay: _selectedDay,
                      onDaySelected: _onDaySelected,
                      onPageChanged: (focused) {
                        setState(() {
                          _focusedMonth = focused;
                        });
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
        color: _curveColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(90),
          bottomRight: Radius.circular(90),
        ),
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.width,
    required this.focusedMonth,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  final double width;
  final DateTime focusedMonth;
  final DateTime? selectedDay;
  final void Function(DateTime selected, DateTime focused) onDaySelected;
  final void Function(DateTime focused) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
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
                final emoji = SentimentStore().get(date);
                if (emoji == null) return const SizedBox.shrink();
                return Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 20)),
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
}
