// list_controller.dart

import 'package:flutter/material.dart';
import 'package:music_player/must_list/list_model.dart';
import 'package:music_player/services/api_services.dart';

class ListController extends ChangeNotifier {
  List<Song> _songs = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Song> get songs => _songs;

  Future<void> fetchSongs() async {
  _isLoading = true;
  //notifyListeners();
  try {
    _songs = await ApiService.fetchSongs();
  } catch (e) {
    debugPrint("Error fetching songs: $e");
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

Future<void> deleteSong(String songFilename) async {
  _isLoading = true;
  notifyListeners();

  try {
    String message = await ApiService.deleteSongs(songFilename);
    debugPrint("Delete message: $message");

    // Only remove from list if delete was successful
    if (message == "Deleted successfully") {
      _songs.removeWhere((song) => song.filename == songFilename);
    } else {
      debugPrint("Delete failed: $message");
    }
  } catch (e) {
    debugPrint("Error deleting song: $e");
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  //void deleteSong(int index) {
  //  _songs.removeAt(index);
  //  notifyListeners();
  //}
}
