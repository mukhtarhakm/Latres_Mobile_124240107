import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../service/tvmaze_api.dart';

class ShowsController extends GetxController {
  final TvMazeApi _api = TvMazeApi();
  final Box _favoritesBox = Hive.box('favorites');
  final shows = <Map<String, dynamic>>[].obs;
  final favorites = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    favorites.assignAll(
      _favoritesBox.values.map(
        (value) => Map<String, dynamic>.from(value as Map),
      ),
    );
    super.onInit();
    fetchShows();
  }

  Future<void> fetchShows() async {
    isLoading.value = true;
    error.value = '';
    try {
      shows.assignAll(await _api.getShows());
    } catch (_) {
      error.value = 'Gagal memuat shows. Periksa koneksi internet.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> getShow(int id) => _api.getShow(id);

  bool isFavorite(int id) => favorites.any((show) => show['id'] == id);

  Future<void> toggleFavorite(Map<String, dynamic> show) async {
    final id = show['id'] as int;
    if (isFavorite(id)) {
      await _favoritesBox.delete(id);
      favorites.removeWhere((favorite) => favorite['id'] == id);
    } else {
      await _favoritesBox.put(id, show);
      favorites.add(show);
    }
  }

  Future<void> removeFavorite(Map<String, dynamic> show) async {
    final id = show['id'] as int;
    await _favoritesBox.delete(id);
    favorites.removeWhere((favorite) => favorite['id'] == id);
  }
}
