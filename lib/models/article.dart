class Article {
  final int id;
  final String title;
  final String? authors;
  final String url;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final DateTime publishedAt;

  Article({
    required this.id,
    required this.title,
    this.authors,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? 0,
      title: json['title'] ?? '-',
      url: json['url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      newsSite: json['news_site'] ?? '-',
      summary: json['summary'] ?? '-',
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  // Digunakan saat membaca dokumen favorit dari Firestore
  factory Article.fromFavoriteMap(Map<String, dynamic> map) {
    return Article(
      id: map['articleId'] ?? 0,
      title: map['title'] ?? '-',
      url: map['url'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      newsSite: map['newsSite'] ?? '-',
      summary: map['summary'] ?? '-',
      publishedAt: map['publishedAt'] != null
          ? DateTime.tryParse(map['publishedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFavoriteMap() {
    return {
      'articleId': id,
      'title': title,
      'url': url,
      'imageUrl': imageUrl,
      'newsSite': newsSite,
      'summary': summary,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }
}
