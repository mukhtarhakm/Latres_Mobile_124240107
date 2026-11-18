import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/shows_controller.dart';
import '../widgets/show_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShowsController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.error.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(controller.error.value),
              TextButton(
                onPressed: controller.fetchShows,
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        );
      }
      return CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Text('Skuy Nonton!', style: TextStyle(fontSize: 18)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: .66,
        ),
        itemCount: controller.shows.length,
        itemBuilder: (context, index) =>
            ShowTile(show: controller.shows[index], isGrid: true),
            ),
          ),
        ],
      );
    });
  }
}
