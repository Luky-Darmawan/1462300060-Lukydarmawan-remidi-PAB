import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../widgets/news_card.dart';
import 'detail_screen.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  final ApiService _apiService = ApiService();
  late Future<List<Article>> _futureArticles;

  @override
  void initState() {
    super.initState();
    _futureArticles = _apiService.fetchArticles();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureArticles = _apiService.fetchArticles();
    });
    await _futureArticles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceNews Core'),
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.rocket_launch_rounded,
              color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Article>>(
          future: _futureArticles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return ListView(
                children: [
                  const SizedBox(height: 100),
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                  const SizedBox(height: 12),
                  Center(
                    child: Text('Gagal memuat berita:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70)),
                  ),
                ],
              );
            }

            final articles = snapshot.data ?? [];
            if (articles.isEmpty) {
              return const Center(
                child: Text('Belum ada berita', style: TextStyle(color: Colors.white70)),
              );
            }

            final headline = articles.first;
            final feedArticles = articles.skip(1).toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Headline News Banner
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => DetailScreen(article: headline)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: headline.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (c, u) => Container(
                              height: 200, color: const Color(0xFF16213A)),
                          errorWidget: (c, u, e) => Container(
                            height: 200,
                            color: const Color(0xFF16213A),
                            child: const Icon(Icons.image_not_supported_outlined,
                                color: Colors.white38, size: 40),
                          ),
                        ),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.85),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 14,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text('HEADLINE',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                headline.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Berita Terbaru',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...feedArticles.map(
                  (article) => NewsCard(
                    article: article,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => DetailScreen(article: article)),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
