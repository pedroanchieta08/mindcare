import 'package:flutter/material.dart';
import 'package:mindcare/constants/app_colors.dart';
import 'package:mindcare/widgets/bottombar.dart';
import '../models/app_user.dart';

class ProfileItem {
  final IconData icon;
  final String title;
  final String subtitle;

  ProfileItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class ProfileScreen extends StatelessWidget {
  final AppUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final List<ProfileItem> accountItems = [
      ProfileItem(
        icon: Icons.person_outline,
        title: 'Dados pessoais',
        subtitle: 'Nome, email, foto',
      ),
      ProfileItem(
        icon: Icons.lock_outline,
        title: 'Segurança',
        subtitle: 'Senha e autenticação',
      ),
      ProfileItem(
        icon: Icons.shield_outlined,
        title: 'Privacidade',
        subtitle: 'Controle de dados',
      ),
    ];

    final List<ProfileItem> appItems = [
      ProfileItem(
        icon: Icons.notifications_none,
        title: 'Notificações',
        subtitle: 'Lembretes e frases diárias',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blueGrey),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.blueGrey),
            tooltip: 'Sair',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.minimum,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              'Usuário Teste',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.minimum,
              ),
            ),
            const Text(
              'Usuário desde abr/2026',
              style: TextStyle(color: AppColors.text),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatCard('0', 'Registros'),
                _buildStatCard('0', 'Semanas'),
                _buildStatCard('0.0', 'Média'),
              ],
            ),
            const SizedBox(height: 0),
            _buildSection('MINHA CONTA', accountItems),
            _buildSection('App', appItems),
          ],
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

  Widget _buildStatCard(String value, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<ProfileItem> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.largeDetail,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(item.icon, color: AppColors.smallDetail),
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    item.subtitle,
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.smallDetail,
                  ),
                  onTap: () {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
