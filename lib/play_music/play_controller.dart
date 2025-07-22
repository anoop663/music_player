import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/constants/constants.dart';
import 'package:music_player/services/api_services.dart';

class AudioController with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = const Duration(seconds: 1);

  String _songUrl = '';
  String _title = 'Unknown Title';
  String _artist = 'Unknown Artist';
  String _album = 'Unknown Album';
  String _thumbnail = Constants.sampleGif;
  bool _isLoading = false;
  bool _listenersAdded = false;
  String? _lastError;

  // Public Getters
  AudioPlayer get player => _audioPlayer;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  bool get isPlaying => _audioPlayer.playing;
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  String get songTitle => _title;
  String get songArtist => _artist;
  String get songAlbum => _album;
  String get songThumbnail => _thumbnail;

  // Play song by songId using API
  Future<void> playSong(int songId) async {
    try {
      _setLoading(true);

      final result = await ApiService.playSongWithId(songId);

      final String fileName = result.filename;
      if (fileName.isEmpty) {
        _lastError = 'File not found';
        _setLoading(false);
        notifyListeners();
        return;
      }

      final String audioUrl =
          'https://alisonsnewdemo.online/audio-player/public/api/songs/$fileName';

      if (!_isValidUrl(audioUrl)) {
        _lastError = 'Invalid audio URL';
        _setLoading(false);
        notifyListeners();
        return;
      }

      _songUrl = audioUrl;
      _title = result.title;
      _artist = result.artist;
      _album = result.album;
      _thumbnail = result.thumbnail!;

      await _setAudioSource(audioUrl);
      _addListeners();

      await _audioPlayer.play();
    } catch (e) {
      _lastError = 'Error playing song: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    notifyListeners();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentPosition = Duration.zero;
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    try {
      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
      notifyListeners();
    } catch (e) {
      _lastError = 'Playback control error: $e';
      notifyListeners();
    }
  }

  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      notifyListeners();
    } catch (e) {
      _lastError = 'Seek error: $e';
      notifyListeners();
    }
  }

  // Helpers

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (_) {
      return false;
    }
  }

  Future<void> _setAudioSource(String url) async {
    try {
      await _audioPlayer.setUrl(url);
    } catch (e) {
      _lastError = 'Error setting audio source: $e';
      rethrow;
    }
  }

  void _addListeners() {
    if (_listenersAdded) return;

    _audioPlayer.durationStream.listen((duration) {
      _totalDuration = duration ?? const Duration(seconds: 1);
      notifyListeners();
    });

    _audioPlayer.positionStream.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });

    _audioPlayer.playerStateStream.listen((state) {
      debugPrint('Player state: $state');

      if (state.processingState == ProcessingState.idle &&
          !_audioPlayer.playing &&
          !_isLoading) {
        _lastError = 'Playback failed to start';
        notifyListeners();
      }
    });

    _listenersAdded = true;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void disposePlayer() {
    _audioPlayer.dispose();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
