class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String coverUrl;
  final Duration duration;
  final String source; // 'netease', 'kuwo', 'qq', 'kugou'

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.coverUrl,
    required this.duration,
    this.source = 'netease',
  });

  String get sourceLabel {
    switch (source) {
      case 'netease':
        return '网易云';
      case 'kuwo':
        return '酷我';
      case 'qq':
        return 'QQ音乐';
      case 'kugou':
        return '酷狗';
      default:
        return '未知';
    }
  }
}

class Playlist {
  final String id;
  final String name;
  final String coverUrl;
  final List<Song> songs;
  final String creator;

  const Playlist({
    required this.id,
    required this.name,
    required this.coverUrl,
    required this.songs,
    this.creator = '',
  });
}
