import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  const ShowImage({
    super.key,
    required this.show,
    required this.width,
    required this.height,
    this.original = false,
  });

  final Map<String, dynamic> show;
  final double width;
  final double height;
  final bool original;

  @override
  Widget build(BuildContext context) {
    final image = show['image'];
    final url = image is Map
        ? (image[original ? 'original' : 'medium'] ?? image['medium'])
              ?.toString()
        : null;
    if (url == null) {
      return SizedBox(
        width: width,
        height: height,
        child: const Icon(Icons.tv),
      );
    }
    return Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => SizedBox(
        width: width,
        height: height,
        child: const Icon(Icons.broken_image),
      ),
    );
  }
}
