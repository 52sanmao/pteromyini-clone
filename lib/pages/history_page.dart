import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  static const _accent = Color(0xFF1EC878);

  static const _today = [
    _HistorySong('夜曲', '周杰伦', '14:32'),
    _HistorySong('孤勇者', '陈奕迅', '11:05'),
    _HistorySong('起风了', '买辣椒也用券', '09:48'),
  ];

  static const _yesterday = [
    _HistorySong('晴天', '周杰伦', '22:15'),
    _HistorySong('平凡之路', '朴树', '19:30'),
  ];

  static const _earlier = [
    _HistorySong('年少有为', '李荣浩', '5月6日 20:10'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('最近播放', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('历史记录已清空')));
            },
            child: const Text('清空历史', style: TextStyle(color: _accent)),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Play all button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('正在播放全部历史歌曲')));
                  },
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  label: const Text('播放全部',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ),

          // Today
          _buildSectionHeader('今天'),
          _buildSongList(_today),

          // Yesterday
          _buildSectionHeader('昨天'),
          _buildSongList(_yesterday),

          // Earlier
          _buildSectionHeader('更早'),
          _buildSongList(_earlier),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String label) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(label,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white70)),
      ),
    );
  }

  Widget _buildSongList(List<_HistorySong> songs) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final song = songs[index];
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            leading: SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.music_note, color: _accent),
                ),
              ),
            ),
            title: Text(song.title,
                style: const TextStyle(fontSize: 15)),
            subtitle: Text(song.artist,
                style: const TextStyle(fontSize: 13, color: Colors.white54)),
            trailing: Text(song.playTime,
                style: const TextStyle(fontSize: 12, color: Colors.white38)),
            onTap: () {},
          );
        },
        childCount: songs.length,
      ),
    );
  }
}

class _HistorySong {
  final String title;
  final String artist;
  final String playTime;

  const _HistorySong(this.title, this.artist, this.playTime);
}
