import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:music_player/must_list/list_model.dart';
import 'package:music_player/play_music/play_model.dart';

class ApiService {
  static const String baseUrl =
      'https://alisonsnewdemo.online/audio-player/public';

  static Future<List<Song>> fetchSongs() async {
    final response = await http.get(Uri.parse('$baseUrl/api/songs'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List songsJson = data['songs'];
      return songsJson.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load songs');
    }
  }

  static Future<String> deleteSongs(String fileName) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/songs/$fileName'),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['message'];
    } else {
      throw Exception('Failed to delete song');
    }
  }

  static Future<String> playSongs(String fileName, int songId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/songs/$fileName'),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final String audioUrl = result['message'];
      return audioUrl;
    } else {
      throw Exception('Failed to play song');
    }
  }


  static Future<SongModel> playSongWithId(int songId) async {
  final response = await http.get(Uri.parse('$baseUrl/api/song-by-id/$songId'));

  if (response.statusCode == 200) {
    final result = json.decode(response.body);
    return SongModel.fromJson(result);
  } else {
    throw Exception('Failed to fetch song data');
  }
}



}
