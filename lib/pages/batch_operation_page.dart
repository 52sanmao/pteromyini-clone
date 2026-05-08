import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../models/song.dart';

class BatchOperationPage extends StatefulWidget {
  const BatchOperationPage({super.key});

  @override
  State<BatchOperationPage> createState() => _BatchOperationPageState();
}

class _BatchOperationPageState extends State<BatchOperationPage> {
  static final List<Song> songs = PlayerProvider.demoSongs;

  late final List<bool> _selected;

  @override
  void initState() {
    super.initState();
    // Pre-select first 8 (or all if fewer)
    _selected = List.generate(songs.length, (i) => i < 8);
  }

  bool get _allSelected => _selected.every((s) => s);
  int get _selectedCount => _selected.where((s) => s).length;

  void _toggleAll(bool value) {
    setState(() {
      for (var i = 0; i < _selected.length; i++) {
        _selected[i] = value;
      }
    });
  }

  void _playSelected() {
    final selectedSongs = <Song>[];
    for (var i = 0; i < songs.length; i++) {
      if (_selected[i]) selectedSongs.add(songs[i]);
    }
    if (selectedSongs.isEmpty) return;
    context.read<PlayerProvider>().play(
          selectedSongs.first,
          playlist: selectedSongs,
          index: 0,
        );
    context.read<PlayerProvider>().showPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('批量操作'),
        actions: [
          TextButton(
            onPressed: () => _toggleAll(!_allSelected),
            child: Text(
              _allSelected ? '取消全选' : '全选',
              style: const TextStyle(color: Color(0xFF1EC878)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Selection count
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFF16213E),
            child: Text(
              '已选择 $_selectedCount 首',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          // Song list with checkboxes
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return CheckboxListTile(
                  value: _selected[index],
                  activeColor: const Color(0xFF1EC878),
                  checkColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      _selected[index] = value ?? false;
                    });
                  },
                  title: Text(song.title, style: const TextStyle(fontSize: 15)),
                  subtitle: Text(
                    '${song.artist} - ${song.album}',
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                  secondary: Container(
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
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _selectedCount == 0
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFF16213E),
                  border: Border(
                    top: BorderSide(color: Colors.white12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionButton(Icons.play_arrow, '播放', _playSelected),
                    _actionButton(Icons.playlist_add, '添加到歌单', () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('已添加 $_selectedCount 首歌曲到歌单')),
                      );
                    }),
                    _actionButton(Icons.download, '下载', () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('开始下载 $_selectedCount 首歌曲')),
                      );
                    }),
                    _actionButton(Icons.delete_outline, '删除', () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('已移除选中歌曲')),
                      );
                    }),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
