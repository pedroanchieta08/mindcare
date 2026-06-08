import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../models/pubmed_artigo.dart';

class PubMedArtigoCard extends StatelessWidget {
  final PubMedArtigo artigo;

  const PubMedArtigoCard({super.key, required this.artigo});

  Future<void> _abrirArtigo() async {
    final uri = Uri.parse(artigo.url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Não foi possível abrir o artigo.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _abrirArtigo,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.largeDetail,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PubMed',
              style: TextStyle(
                color: AppColors.smallDetail,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              artigo.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
