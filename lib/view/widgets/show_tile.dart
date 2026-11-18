import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../service/tvmaze_api.dart';
import '../pages/detail_page.dart';
import 'show_image.dart';

class ShowTile extends StatelessWidget {
  const ShowTile({
    super.key,
    required this.show,
    this.onRemove,
    this.isGrid = false,
  });

  final Map<String, dynamic> show;
  final VoidCallback? onRemove;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      return Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () => Get.to(() => DetailPage(id: show['id'] as int)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ShowImage(
                    show: show,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(7, 6, 7, 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      show['name']?.toString() ?? 'Tanpa judul',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '★ ${showRating(show)}',
                      style: const TextStyle(color: Colors.amber, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: ShowImage(show: show, width: 40, height: 40),
        ),
        title: Text(show['name']?.toString() ?? 'Tanpa judul'),
        subtitle: Text(
          '★ ${showRating(show)}',
          style: const TextStyle(color: Colors.amber),
        ),
        trailing: onRemove == null
            ? const Icon(Icons.chevron_right)
            : IconButton(
                tooltip: 'Hapus favorit',
                icon: const Icon(Icons.delete, color: Color(0xFFF44336)),
                onPressed: onRemove,
              ),
        onTap: () => Get.to(() => DetailPage(id: show['id'] as int)),
      ),
    );
  }
}
