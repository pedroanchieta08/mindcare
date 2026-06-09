import 'package:flutter/material.dart';
import 'package:mindcare/screens/perfil_screen.dart';
import 'package:mindcare/screens/sentimental.dart';
import 'package:mindcare/screens/notification_screen.dart';
import '../constants/app_colors.dart';
import 'package:mindcare/widgets/bottombar.dart';
import 'calendar.dart';
import 'relatorios_user.dart';
import '../models/app_user.dart';
import '../models/pubmed_artigo.dart';
import '../services/pubmed_service.dart';
import '../widgets/pubmed_card.dart';
import 'package:mindcare/screens/cvv_screen.dart';
import 'package:mindcare/widgets/sentimentos_semana.dart';

class HomeScreen extends StatelessWidget {
  final AppUser user;

  HomeScreen({super.key, required this.user});

  final PubMedService _pubMedService = PubMedService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: Stack(
                children: [
                  Transform.scale(
                    scaleX: 1.4,
                    scaleY: 1.43,
                    alignment: Alignment(0, 1.5),
                    child: Image.asset(
                      'assets/imagens/fundo.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(top: 16, left: 0, right: 0, child: WeekBar()),
                  Positioned(
                    top: 90,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SentimentalPage(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 120,
                          backgroundColor: AppColors.minimum,
                          child: Icon(
                            Icons.favorite,
                            size: 120,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CvvScreen()),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(top: 0),
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
                      'Você já conhece o CVV?',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Estudos sobre saúde mental',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),

            FutureBuilder<List<PubMedArtigo>>(
              future: _pubMedService.fetchMentalHealthArticles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.largeDetail,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'Não foi possível carregar os estudos agora.',
                      style: TextStyle(color: AppColors.text),
                    ),
                  );
                }

                final artigos = snapshot.data ?? [];

                if (artigos.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.largeDetail,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'Nenhum estudo encontrado.',
                      style: TextStyle(color: AppColors.text),
                    ),
                  );
                }

                return Column(
                  children: artigos
                      .map((artigo) => PubMedArtigoCard(artigo: artigo))
                      .toList(),
                );
              },
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
              MaterialPageRoute(
                builder: (context) => RelatoriosUser(user: user),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationScreen(user: user),
              ),
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
              MaterialPageRoute(
                builder: (context) => ProfileScreen(user: user),
              ),
            );
          }
        },
      ),
    );
  }
}
