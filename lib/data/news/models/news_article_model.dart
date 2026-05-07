class NewsArticleModel {
  const NewsArticleModel({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.source,
  });

  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final String source;

  factory NewsArticleModel.fromJson(Map<String, dynamic> json) {
    final sourceMap = json['source'] as Map<String, dynamic>?;

    return NewsArticleModel(
      title: (json['title'] as String?) ?? 'Untitled article',
      description: json['description'] as String?,
      url: (json['url'] as String?) ?? '',
      urlToImage: json['urlToImage'] as String?,
      source: (sourceMap?['name'] as String?) ?? 'Unknown source',
    );
  }
}
