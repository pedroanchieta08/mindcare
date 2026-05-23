import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/user_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RelatorioData {
  final String categoria;
  final String? descricao;
  final String? porcentagem;
  RelatorioData(this.categoria, this.porcentagem, {this.descricao});
}

class RelatoriosUser extends StatelessWidget {
  final UserModel user;

  final List<RelatorioData> dados = [
    RelatorioData('Jan', '30%', descricao: 'Relatório de Janeiro'),
    RelatorioData('Fev', '40%', descricao: 'Relatório de Fevereiro'),
    RelatorioData('Mar', '20%', descricao: 'Relatório de Março'),
    RelatorioData('Abr', '35%', descricao: 'Relatório de Abril'),
    RelatorioData('Mai', '25%', descricao: 'Relatório de Maio'),
    RelatorioData('Jun', '45%', descricao: 'Relatório de Junho'),
  ];

  RelatoriosUser({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios do Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Relatórios de Saúde Mental:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: SfCircularChart(
                series: <CircularSeries<RelatorioData, String>>[
                  PieSeries<RelatorioData, String>(
                    dataSource: dados,
                    xValueMapper: (RelatorioData data, _) => data.categoria,
                    yValueMapper: (RelatorioData data, _) => data.porcentagem != null
                        ? double.tryParse(data.porcentagem!.replaceAll('%', '')) ?? 0
                        : 0,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
