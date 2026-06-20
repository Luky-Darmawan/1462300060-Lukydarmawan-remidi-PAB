import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/article.dart';
import '../services/firestore_service.dart';

class DetailScreen extends StatefulWidget {
  final Article article;

  const DetailScreen({super.key, required this.article});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isProcessing = false;

  Future<void> _toggleFavorite(bool isCurrentlyFavorite) async {
    setState(() => _isProcessing = true);
    try {
      if (isCurrentlyFavorite) {
        await _firestoreService.removeFavorite(widget.article.id);
      } else {
        await _firestoreService.addFavorite(widget.article);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui favorite: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF0B1320),
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black45,
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              StreamBuilder<bool>(
                stream: _firestoreService.isFavorite(article.id),
                builder: (context, snapshot) {
                  final isFavorite = snapshot.data ?? false;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      icon: CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: _isProcessing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.redAccent : Colors.white,
                              ),
                      ),
                      onPressed: _isProcessing
                          ? null
                          : () => _toggleFavorite(isFavorite),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: article.imageUrl,
                fit: BoxFit.cover,
                placeholder: (c, u) => Container(color: const Color(0xFF16213A)),
                errorWidget: (c, u, e) => Container(
                  color: const Color(0xFF16213A),
                  child: const Icon(Icons.image_not_supported_outlined,
                      color: Colors.white38, size: 48),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Chip(
                        label: Text(article.newsSite),
                        backgroundColor: const Color(0xFF16213A),
                        labelStyle: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('dd MMMM yyyy, HH:mm').format(article.publishedAt),
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),
                  const Divider(height: 32, color: Colors.white12),
                  Text(
                    article.summary,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
