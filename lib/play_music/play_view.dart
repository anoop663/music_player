import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/play_music/play_controller.dart';
import 'package:provider/provider.dart';
import 'package:music_player/must_list/list_view.dart';
import 'package:music_player/theme/app_theme.dart';

class PlayView extends StatelessWidget {
  final int songId;

  const PlayView({super.key, required this.songId});

  void _playInitialSong(BuildContext context) {
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      final controller = Provider.of<AudioController>(context, listen: false);
      controller.playSong(songId);
    });
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    _playInitialSong(context);

    return Consumer<AudioController>(
      builder: (context, controller, _) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MusicList()),
                  (route) => false,
                );
              },
            ),
            title: Text('Now Playing', style: AppTheme.robotoBold(20)),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.bodyColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: SizedBox(
                          width: 300,
                          height: 300,
                          child: Image.network(
                            controller.songThumbnail,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.songTitle, style: AppTheme.robotoBold(20)),
                        const SizedBox(height: 2),
                        Text(controller.songArtist, style: AppTheme.robotoSubtitiles(16)),
                        const SizedBox(height: 10),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color.fromARGB(
                              255,
                              109,
                              227,
                              205,
                            ),
                            inactiveTrackColor: Colors.grey.shade600,
                            thumbColor: const Color.fromARGB(
                              255,
                              109,
                              227,
                              205,
                            ),
                            overlayColor: const Color.fromARGB(
                              80,
                              109,
                              227,
                              205,
                            ),
                            trackHeight: 3.0,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8.0,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 14.0,
                            ),
                          ),
                          child: Slider(
                            value: controller.currentPosition.inSeconds
                                .toDouble()
                                .clamp(
                                  0,
                                  controller.totalDuration.inSeconds.toDouble(),
                                ),
                            min: 0,
                            max: controller.totalDuration.inSeconds.toDouble(),
                            onChanged: (value) {
                              controller.seekTo(
                                Duration(seconds: value.toInt()),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatTime(controller.currentPosition),
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              formatTime(controller.totalDuration),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildUpNextSection(),
                    const SizedBox(height: 30),
                    _buildControlButtons(controller),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpNextSection() {
    return Opacity(
      opacity: 0.6,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0x01e95995),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'UP NEXT',
                  style: TextStyle(
                    color: Color(0xFFF2F2F2),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SvgPicture.asset(
                  'assets/icons/bullet.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildNextTrackRow('I’m Fine', 'Ashe', '2:16'),
            const SizedBox(height: 6),
            _buildNextTrackRow('Drown', 'Dabin', '4:19'),
          ],
        ),
      ),
    );
  }

  Widget _buildNextTrackRow(String title, String artist, String duration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFFF2F2F2),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          artist,
          style: const TextStyle(
            color: Color(0xFFF2F2F2),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 20),
        Text(
          duration,
          style: const TextStyle(
            color: Color(0xFFF2F2F2),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildControlButtons(AudioController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.shuffle, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.skip_previous,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(12),
            child: IconButton(
              iconSize: 40,
              icon: Icon(
                controller.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.black,
              ),
              onPressed: controller.togglePlayPause,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.repeat, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
