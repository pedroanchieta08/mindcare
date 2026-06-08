class PubMedArtigo {
  final String id;
  final String title;
  final String source;
  final String pubDate;
  final String url;

  PubMedArtigo({
    required this.id,
    required this.title,
    required this.source,
    required this.pubDate,
    required this.url,
  });

  factory PubMedArtigo.fromSummary(Map<String, dynamic> data) {
    final id = data['uid']?.toString() ?? '';

    return PubMedArtigo(
      id: id,
      title: data['title']?.toString() ?? 'Título não disponível',
      source: data['source']?.toString() ?? 'PubMed',
      pubDate: data['pubdate']?.toString() ?? '',
      url: 'https://pubmed.ncbi.nlm.nih.gov/$id/',
    );
  }
}
