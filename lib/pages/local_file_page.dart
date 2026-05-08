import 'package:flutter/material.dart';

class LocalFilePage extends StatefulWidget {
  const LocalFilePage({super.key});

  @override
  State<LocalFilePage> createState() => _LocalFilePageState();
}

class _LocalFilePageState extends State<LocalFilePage> {
  static const _accent = Color(0xFF1EC878);

  int _sortIndex = 0;
  final Set<int> _selected = {};

  final _songs = const [
    _LocalSong('夜曲', '周杰伦', '4:35', '8.3MB'),
    _LocalSong('起风了', '买辣椒也用券', '5:14', '7.1MB'),
    _LocalSong('孤勇者', '陈奕迅', '4:12', '5.8MB'),
    _LocalSong('晴天', '周杰伦', '4:29', '6.2MB'),
    _LocalSong('平凡之路', '朴树', '4:46', '7.4MB'),
    _LocalSong('年少有为', '李荣浩', '4:03', '6.7MB'),
    _LocalSong('消愁', '毛不易', '5:01', '5.9MB'),
    _LocalSong('体面', '于文文', '3:52', '4.7MB'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('本地音乐', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Scan button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('正在扫描本地音乐文件...')));
                },
                icon: const Icon(Icons.refresh, color: _accent),
                label: const Text('扫描本地音乐',
                    style: TextStyle(color: _accent)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _accent),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('共找到 23 首本地歌曲',
                  style: TextStyle(fontSize: 13, color: Colors.white54)),
            ),
          ),

          // Sort options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _buildSortChip('按名称', 0),
                const SizedBox(width: 8),
                _buildSortChip('按时间', 1),
                const SizedBox(width: 8),
                _buildSortChip('按大小', 2),
              ],
            ),
          ),

          const Divider(height: 1),

          // Song list
          Expanded(
            child: ListView.separated(
              itemCount: _songs.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 72),
              itemBuilder: (context, index) {
                final song = _songs[index];
                final isSelected = _selected.contains(index);
                return ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.music_note, color: _accent),
                  ),
                  title: Text(song.title,
                      style: const TextStyle(fontSize: 15)),
                  subtitle: Text(
                      '${song.artist}  ·  ${song.duration}  ·  ${song.size}',
                      style:
                          const TextStyle(fontSize: 13, color: Colors.white54)),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: _accent, size: 22)
                      : const Icon(Icons.radio_button_unchecked,
                          color: Colors.white24, size: 22),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selected.remove(index);
                      } else {
                        _selected.add(index);
                      }
                    });
                  },
                );
              },
            ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        if (_selected.length == _songs.length) {
                          _selected.clear();
                        } else {
                          _selected
                              .addAll(List.generate(_songs.length, (i) => i));
                        }
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _accent),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                        _selected.length == _songs.length ? '取消全选' : '全选',
                        style: const TextStyle(color: _accent)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selected.isEmpty
                        ? null
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    '正在播放 ${_selected.length} 首歌曲')));
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('播放选中${_selected.isNotEmpty ? "(${_selected.length})" : ""}'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, int index) {
    final selected = _sortIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _sortIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? _accent.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: selected ? _accent : Colors.white24, width: 0.8),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13, color: selected ? _accent : Colors.white54)),
      ),
    );
  }
}

class _LocalSong {
  final String title;
  final String artist;
  final String duration;
  final String size;

  const _LocalSong(this.title, this.artist, this.duration, this.size);
}
