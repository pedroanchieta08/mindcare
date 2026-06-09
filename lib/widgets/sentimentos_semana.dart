import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/sentiment_store.dart';

class WeekBar extends StatelessWidget {
  final _store = SentimentStore();

  static const _dayLabels = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

  WeekBar({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday % 7));

    final days = List.generate(
      7,
      (i) => DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + i),
    );

    return StreamBuilder<Map<String, SentimentEntry>>(
      stream: _store.watchAll(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? {};

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((day) {
              final key =
                  '${day.year.toString().padLeft(4, '0')}-'
                  '${day.month.toString().padLeft(2, '0')}-'
                  '${day.day.toString().padLeft(2, '0')}';

              final entry = data[key];
              final isToday =
                  day.day == today.day &&
                  day.month == today.month &&
                  day.year == today.year;

              return Container(
                width: 40,
                height: 48,
                decoration: BoxDecoration(
                  color: isToday
                      ? AppColors.smallDetail.withOpacity(0.3)
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (entry != null)
                      Text(entry.emoji, style: const TextStyle(fontSize: 18))
                    else
                      Text(
                        _dayLabels[day.weekday % 7],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isToday
                              ? AppColors.white
                              : AppColors.smallDetail,
                        ),
                      ),
                    const SizedBox(height: 2),
                    Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isToday
                            ? AppColors.minimum
                            : AppColors.smallDetail,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
