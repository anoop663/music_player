class Song {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String filename;
  final String? thumbnail;
  final String path;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.filename,
    this.thumbnail,
    required this.path,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      filename: json['filename'],
      thumbnail: json['thumbnail'],
      path: json['path'],
    );
  }
}
