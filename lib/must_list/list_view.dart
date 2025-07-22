// music_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:music_player/constants/constants.dart';
import 'package:music_player/must_list/list_controller.dart';
import 'package:music_player/play_music/play_view.dart';
import 'package:provider/provider.dart';
import 'package:music_player/theme/app_theme.dart';

class MusicList extends StatelessWidget {
  const MusicList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ListController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Songs', style: AppTheme.robotoBold(20)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),

        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: AppTheme.bodyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: FutureBuilder(
              future: controller.fetchSongs(),
              builder: (context, snapshot) {
                final isLoading = context.watch<ListController>().isLoading;
                final songs = context.watch<ListController>().songs;

                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (songs.isEmpty) {
                  return const Center(child: Text('No songs found.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(14),
                  itemCount: songs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    final fileName = song.filename;
                    final songId = song.id;
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlayView(songId: songId),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              Constants.sampleImage,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(song.title, style: AppTheme.robotoBold(22)),
                              const SizedBox(height: 6),
                              Text(
                                song.artist,
                                style: AppTheme.robotoSubtitiles(16),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Delete Song"),
                                content: const Text(
                                  "Are you sure you want to delete this song?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              controller.deleteSong(fileName);
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: SvgPicture.asset(
                            'assets/icons/delete.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
