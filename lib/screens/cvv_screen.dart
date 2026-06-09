import 'package:flutter/material.dart';
import 'package:mindcare/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class CvvScreen extends StatelessWidget {
  const CvvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('CVV - Centro de Valorização da Vida'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.smallDetail,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Formado exclusivamente por voluntários, o CVV oferece apoio emocional e prevenção do suicídio gratuitamente. Quem procura, normalmente está se sentido solitário ou precisa conversar de forma sigilosa, sem julgamentos, críticas ou comparações.',
              style: TextStyle(fontSize: 18, height: 1.6),
            ),
            SizedBox(height: 20),
            Text(
              'Atuam nacionalmente com atendimento realizado pelo telefone 188 (24 horas por dia e sem custo de ligação), chat, e-mail e pessoalmente em alguns endereços.',
              style: TextStyle(fontSize: 18, height: 1.6),
            ),
            SizedBox(height: 20),
            Text(
              'O CVV é uma entidade nacional fundada em 1962, financeira e ideologicamente independente. Sem viés religioso, político-partidário ou empresarial.',
              style: TextStyle(fontSize: 18, height: 1.6),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => launchUrl(Uri.parse('https://cvv.org.br/')),
              child: const Text(
                'Saiba mais sobre o CVV',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.smallDetail,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
