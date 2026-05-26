import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      decoration: const BoxDecoration(
        color: AppColors.largeDetail,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomBarItem(
            icon: Icons.description,
            label: 'Relatórios',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _BottomBarItem(
            icon: Icons.notifications,
            label: 'Avisos',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _EmergencyBottomBarItem(
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _BottomBarItem(
            icon: Icons.calendar_month,
            label: 'Calendário',
            isSelected: currentIndex == 3,
            onTap: () => onTap(3),
          ),
          _BottomBarItem(
            icon: Icons.person,
            label: 'Perfil',
            isSelected: currentIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color itemColor = isSelected
        ? AppColors.smallDetail
        : AppColors.text.withOpacity(0.55);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 66,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: itemColor, size: 25),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: itemColor,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyBottomBarItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _EmergencyBottomBarItem({
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color itemColor = isSelected
        ? AppColors.smallDetail
        : AppColors.text.withOpacity(0.55);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: SizedBox(
        width: 66,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.smallDetail,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.smallDetail.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.sos, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 3),
            Text(
              'SOS',
              style: TextStyle(
                color: itemColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
