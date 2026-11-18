import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/shows_controller.dart';
import '../../service/tvmaze_api.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.id});

  final int id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final controller = Get.find<ShowsController>();
  late Future<Map<String, dynamic>> show;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    show = controller.getShow(widget.id);
  }

  Future<void> toggleFavorite(Map<String, dynamic> data) async {
    setState(() => saving = true);
    try {
      await controller.toggleFavorite(data);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan favorit')),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: show,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Gagal memuat detail show.'),
                  TextButton(
                    onPressed: () =>
                        setState(() => show = controller.getShow(widget.id)),
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }
          final data = snapshot.data!;
          final genres = (data['genres'] as List?)?.join(', ') ?? '-';
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final image = data['image'];
                  final url = image is Map
                      ? (image['original'] ?? image['medium'])?.toString()
                      : null;
                  return SizedBox(
                    width: double.infinity,
                    child: url == null
                        ? const AspectRatio(
                            aspectRatio: 2 / 3,
                            child: Icon(Icons.tv, size: 64),
                          )
                        : Image.network(
                            url,
                            width: constraints.maxWidth,
                            fit: BoxFit.fitWidth,
                            errorBuilder: (_, _, _) => const AspectRatio(
                              aspectRatio: 2 / 3,
                              child: Icon(Icons.broken_image, size: 64),
                            ),
                          ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                data['name']?.toString() ?? 'Tanpa judul',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                '★ ${showRating(data)}',
                style: const TextStyle(color: Colors.amber),
              ),
              Text(
                genres.isEmpty ? '-' : genres,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Nonton'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFF44336),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(
                    () => IconButton.filled(
                      tooltip: controller.isFavorite(widget.id)
                          ? 'Hapus dari favorit'
                          : 'Tambah ke favorit',
                      onPressed: saving ? null : () => toggleFavorite(data),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF202020),
                        foregroundColor: controller.isFavorite(widget.id)
                            ? const Color(0xFFF44336)
                            : Colors.white,
                        side: const BorderSide(color: Colors.white24),
                      ),
                      icon: Icon(
                        controller.isFavorite(widget.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Overview',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(plainSummary(data['summary'] as String?)),
            ],
          );
        },
      ),
    );
  }
}
