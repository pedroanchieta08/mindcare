import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/user_model.dart';
import 'login_screen.dart';
import '../widgets/bottombar.dart';
import 'calendar.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.largeDetail,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, ${user.name}!',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Como você está se sentindo hoje?',
                    style: TextStyle(fontSize: 16, color: AppColors.text),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Ações rápidas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: const [
                Expanded(
                  child: _ActionCard(
                    icon: Icons.document_scanner,
                    title: 'Relatório',
                    subtitle: 'Consultar relatórios',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _ActionCard(
                    icon: Icons.notifications,
                    title: 'Notificações',
                    subtitle: 'Configurações de notificação',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: const [
                Expanded(
                  child: _ActionCard(
                    icon: Icons.calendar_month,
                    title: 'Calendário',
                    subtitle: 'Calendário de emoções',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _ActionCard(
                    icon: Icons.person,
                    title: 'Menu',
                    subtitle: 'Menu de configurações',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      bottomNavigationBar: BottomBar(
        currentIndex: -1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalendarPage(user: user)),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
            );
          }
        },
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.largeDetail),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 34, color: AppColors.smallDetail),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: AppColors.text),
          ),
        ],
      ),
    );
  }
}
