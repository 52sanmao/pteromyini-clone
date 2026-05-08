import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  static const _accent = Color(0xFF1EC878);

  static const _songs = [
    _FavSong('夜曲', '周杰伦', '4:35', '网易云'),
    _FavSong('起风了', '买辣椒也用券', '5:14', '酷我'),
    _FavSong('孤勇者', '陈奕迅', '4:12', 'QQ音乐'),
    _FavSong('晴天', '周杰伦', '4:29', '网易云'),
    _FavSong('平凡之路', '朴树', '4:46', '酷狗'),
    _FavSong('年少有为', '李荣浩', '4:03', '网易云'),
    _FavSong('消愁', '毛不易', '5:01', 'QQ音乐'),
    _FavSong('体面', '于文文', '3:52', '酷我'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我喜欢', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: CustomScrollView(
        slivers: [
          // Stats bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: const [
                  Icon(Icons.favorite, color: _accent, size: 18),
                  SizedBox(width: 6),
                  Text('共 56 首歌曲 · 2小时38分',
                      style: TextStyle(fontSize: 13, color: Colors.white54)),
                ],
              ),
            ),
          ),

          // Action buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('正在播放全部我喜欢')));
                      },
                      icon: const Icon(Icons.play_arrow,
                          color: Colors.white, size: 20),
                      label: const Text('播放全部',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('随机播放我喜欢')));
                      },
                      icon: const Icon(Icons.shuffle,
                          color: _accent, size: 20),
                      label: const Text('随机播放',
                          style: TextStyle(color: _accent)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _accent),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: Divider(height: 1)),

          // Song list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = _songs[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: Stack(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.music_note, color: _accent),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: _accent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.favorite,
                              size: 10, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  title: Text(song.title,
                      style: const TextStyle(fontSize: 15)),
                  subtitle: Text(song.artist,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.white54)),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(song.source,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.white38)),
                  ),
                  onTap: () {},
                );
              },
              childCount: _songs.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _FavSong {
  final String title;
  final String artist;
  final String duration;
  final String source;

  const _FavSong(this.title, this.artist, this.duration, this.source);
}
