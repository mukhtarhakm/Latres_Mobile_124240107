import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/shows_controller.dart';
import '../widgets/show_tile.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShowsController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Daftar Favorit', style: TextStyle(fontSize: 18)),
        ),
        Expanded(
          child: Obx(() {
            if (controller.favorites.isEmpty) {
              return const Center(child: Text('Belum ada show favorit'));
            }
            return ListView.builder(
              itemCount: controller.favorites.length,
              itemBuilder: (context, index) {
                final show = controller.favorites[index];
                return ShowTile(
                  show: show,
                  onRemove: () async {
                    try {
                      await controller.removeFavorite(show);
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gagal menghapus favorit')),
                        );
                      }
                    }
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
