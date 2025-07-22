import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class AudioController with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration(seconds: 1);

  String _songUrl = '';
  bool _isLoading = false;
  bool _listenersAdded = false;
  String? _lastError;

  AudioPlayer get player => _audioPlayer;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  bool get isPlaying => _audioPlayer.playing;
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  Future<void> playSong(String fileName) async {
    _setLoading(true);
    _lastError = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
          'https://alisonsnewdemo.online/audio-player/public/api/songs/$fileName',
        ),
        headers: {'Accept': 'text/plain'},
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response headers: ${response.headers}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Server returned ${response.statusCode}');
      }

      _songUrl =
          'https://alisonsnewdemo.online/audio-player/public/api/songs/$fileName';

      // Validate and format URL
      if (!_songUrl.startsWith('http')) {
        _songUrl = 'https://$_songUrl';
      }

      if (!_isValidUrl(_songUrl)) {
        throw Exception('Invalid URL format: $_songUrl');
      }

      debugPrint('Attempting to play from URL: $_songUrl');

      await _setAudioSource(_songUrl);
      _addListeners();
      await _audioPlayer.play();
    } catch (e) {
      _lastError = 'Failed to play audio: ${e.toString()}';
      debugPrint('Error playing song: $_lastError');
      await _audioPlayer.stop();
      _currentPosition = Duration.zero;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  Future<void> _setAudioSource(String url) async {
    try {
      await _audioPlayer.setUrl(url);
    } catch (e) {
      debugPrint('Error setting audio source: $e');
      rethrow;
    }
  }

  void _addListeners() {
    if (_listenersAdded) return;

    // Track duration changes
    _audioPlayer.durationStream.listen((duration) {
      _totalDuration = duration ?? const Duration(seconds: 1);
      notifyListeners();
    });

    // Track playback position
    _audioPlayer.positionStream.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });

    // Track player state changes
    _audioPlayer.playerStateStream.listen((state) {
      debugPrint('Player state: $state');

      // Detect failed playback
      if (state.processingState == ProcessingState.idle &&
          !_audioPlayer.playing &&
          !_isLoading) {
        _lastError = 'Playback failed to start';
        notifyListeners();
      }
    });

    // Track audio errors
    //_audioPlayer.playbackEventStream.listen((event) {
    //  if (event.type == AudioEventType.error) {
    //    _lastError = 'Audio playback error occurred';
    //    notifyListeners();
    //  }
    //});

    _listenersAdded = true;
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
      _lastError = 'Playback control error: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      notifyListeners();
    } catch (e) {
      _lastError = 'Seek error: ${e.toString()}';
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentPosition = Duration.zero;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
