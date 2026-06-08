import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mindcare/models/pubmed_artigo.dart';

class PubMedService {
  static const String _baseUrl =
      'https://eutils.ncbi.nlm.nih.gov/entrez/eutils';

  Future<List<PubMedArtigo>> fetchMentalHealthArticles() async {
    final searchUrl = Uri.parse(
      '$_baseUrl/esearch.fcgi'
      '?db=pubmed'
      '&term=mental%20health%20OR%20anxiety%20OR%20depression'
      '&retmode=json'
      '&retmax=3'
      '&sort=pub+date',
    );

    final searchResponse = await http.get(searchUrl);

    if (searchResponse.statusCode != 200) {
      throw Exception('Erro ao buscar artigos no PubMed.');
    }

    final searchData = jsonDecode(searchResponse.body);
    final List ids = searchData['esearchresult']['idlist'];

    if (ids.isEmpty) {
      return [];
    }

    final idsText = ids.join(',');

    final summaryUrl = Uri.parse(
      '$_baseUrl/esummary.fcgi'
      '?db=pubmed'
      '&id=$idsText'
      '&retmode=json',
    );

    final summaryResponse = await http.get(summaryUrl);

    if (summaryResponse.statusCode != 200) {
      throw Exception('Erro ao carregar detalhes dos artigos.');
    }

    final summaryData = jsonDecode(summaryResponse.body);
    final result = summaryData['result'];

    final artigos = <PubMedArtigo>[];

    for (final id in ids) {
      final item = result[id];

      if (item != null) {
        artigos.add(PubMedArtigo.fromSummary(item));
      }
    }
    return artigos;
  }
}
