import 'package:flutter/material.dart';
import 'package:music_player/must_list/list_controller.dart';
import 'package:music_player/must_list/list_view.dart';
import 'package:music_player/play_music/play_controller.dart';
import 'package:music_player/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ListController()),
        ChangeNotifierProvider(create: (_) => AudioController()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const  MusicList(),
     // home: const  PlayView(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
    );
  }
}
