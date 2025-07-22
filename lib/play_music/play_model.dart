class SongModel {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String filename;
  final String? thumbnail;
  final String path;
  final String url;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.filename,
    this.thumbnail,
    required this.path,
    required this.url,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      filename: json['filename'],
      thumbnail: json['thumbnail'],
      path: json['path'],
      url: json['url'],
    );
  }
}
