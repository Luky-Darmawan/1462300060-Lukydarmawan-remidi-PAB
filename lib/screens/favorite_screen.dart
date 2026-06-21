import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/firestore_service.dart';
import '../widgets/news_card.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getFavoritesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Gagal memuat favorite: ${snapshot.error}',
                  style: const TextStyle(color: Colors.black87)),
            );
          }

          final favorites = snapshot.data ?? [];
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 56, color: Colors.black26),
                  const SizedBox(height: 12),
                  const Text(
                    'Belum ada berita favorit',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final article = Article.fromFavoriteMap(favorites[index]);
              return NewsCard(
                article: article,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => DetailScreen(article: article)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
