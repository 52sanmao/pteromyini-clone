import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../models/song.dart';

class RecommendPage extends StatelessWidget {
  const RecommendPage({super.key});

  static final List<Song> recommendSongs = [
    const Song(id: 'r1', title: '暮色回响', artist: 'TIGO', album: '暮色回响', coverUrl: '', duration: Duration(minutes: 3, seconds: 42), source: 'netease'),
    const Song(id: 'r2', title: '在加纳共和国离婚', artist: '江辰', album: '在加纳共和国离婚', coverUrl: '', duration: Duration(minutes: 4, seconds: 15), source: 'kuwo'),
    const Song(id: 'r3', title: '孤勇者', artist: '陈奕迅', album: '孤勇者', coverUrl: '', duration: Duration(minutes: 4, seconds: 16), source: 'qq'),
    const Song(id: 'r4', title: '半生雪', artist: '是七叔呢', album: '半生雪', coverUrl: '', duration: Duration(minutes: 3, seconds: 28), source: 'kugou'),
    const Song(id: 'r5', title: '光年之外', artist: '邓紫棋', album: '光年之外', coverUrl: '', duration: Duration(minutes: 3, seconds: 56), source: 'netease'),
    const Song(id: 'r6', title: '若把你', artist: 'Kirsty刘瑾睿', album: '若把你', coverUrl: '', duration: Duration(minutes: 4, seconds: 8), source: 'kuwo'),
    const Song(id: 'r7', title: '平凡之路', artist: '朴树', album: '猎户星座', coverUrl: '', duration: Duration(minutes: 4, seconds: 46), source: 'netease'),
    const Song(id: 'r8', title: '可能', artist: '程响', album: '可能', coverUrl: '', duration: Duration(minutes: 4, seconds: 22), source: 'qq'),
    const Song(id: 'r9', title: '星辰大海', artist: '黄霄雲', album: '星辰大海', coverUrl: '', duration: Duration(minutes: 3, seconds: 38), source: 'netease'),
    const Song(id: 'r10', title: '起风了', artist: '买辣椒也用券', album: '起风了', coverUrl: '', duration: Duration(minutes: 5, seconds: 14), source: 'kuwo'),
  ];

  static const List<Color> dayColors = [
    Color(0xFFE53935), Color(0xFFEF6C00), Color(0xFFFFCA28),
    Color(0xFF66BB6A), Color(0xFF26A69A), Color(0xFF42A5F5),
    Color(0xFF5C6BC0), Color(0xFFAB47BC), Color(0xFFEC407A),
    Color(0xFFFF7043),
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = '${now.month}月${now.day}日';

    return Scaffold(
      appBar: AppBar(
        title: const Text('每日推荐'),
      ),
      body: Column(
        children: [
          // Top banner
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1EC878), Color(0xFF17A86B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      dateStr,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '根据你的音乐口味，每天为你推荐30首歌曲',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _bannerButton(context, Icons.play_arrow, '播放全部', () {
                      context.read<PlayerProvider>().play(
                        recommendSongs.first,
                        playlist: recommendSongs,
                        index: 0,
                      );
                      context.read<PlayerProvider>().showPlayer();
                    }),
                    const SizedBox(width: 12),
                    _bannerButton(context, Icons.shuffle, '随机播放', () {
                      final shuffled = List<Song>.from(recommendSongs)..shuffle();
                      context.read<PlayerProvider>().play(
                        shuffled.first,
                        playlist: shuffled,
                        index: 0,
                      );
                      context.read<PlayerProvider>().showPlayer();
                    }),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Song list
          Expanded(
            child: ListView.builder(
              itemCount: recommendSongs.length,
              itemBuilder: (context, index) {
                final song = recommendSongs[index];
                return ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: dayColors[index % dayColors.length],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 24,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(color: Colors.white54, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  title: Text(song.title, style: const TextStyle(fontSize: 15)),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Text(
                          song.artist,
                          style: const TextStyle(fontSize: 12, color: Colors.white54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1EC878).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          song.sourceLabel,
                          style: const TextStyle(fontSize: 10, color: Color(0xFF1EC878)),
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white54, size: 20),
                    onPressed: () {},
                  ),
                  onTap: () {
                    context.read<PlayerProvider>().play(song, playlist: recommendSongs, index: index);
                    context.read<PlayerProvider>().showPlayer();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _bannerButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
