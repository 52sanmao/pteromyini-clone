import 'package:flutter/material.dart';

class PlayerListPage extends StatefulWidget {
  const PlayerListPage({super.key});

  @override
  State<PlayerListPage> createState() => _PlayerListPageState();
}

class _PlayerListPageState extends State<PlayerListPage> {
  static const _green = Color(0xFF1EC878);

  int _currentIndex = 3;

  final List<_SongItem> _songs = [
    _SongItem(title: '晴天', artist: '周杰伦'),
    _SongItem(title: '起风了', artist: '买辣椒也用券'),
    _SongItem(title: '光年之外', artist: '邓紫棋'),
    _SongItem(title: '夜曲', artist: '周杰伦'),
    _SongItem(title: '稻香', artist: '周杰伦'),
    _SongItem(title: '说好不哭', artist: '周杰伦'),
    _SongItem(title: '孤勇者', artist: '陈奕迅'),
    _SongItem(title: '漠河舞厅', artist: '柳爽'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('当前播放列表'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('列表已清空'), duration: Duration(seconds: 1)),
              );
            },
            child: const Text('清空',
                style: TextStyle(color: Colors.white70, fontSize: 15)),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              '共${_songs.length}首',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                final song = _songs[index];
                final isPlaying = index == _currentIndex;
                return _buildSongTile(song, index, isPlaying);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongTile(_SongItem song, int index, bool isPlaying) {
    return Container(
      color: isPlaying ? _green.withValues(alpha: 0.08) : null,
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.drag_handle, color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 4),
            if (isPlaying)
              const Icon(Icons.bar_chart, color: _green, size: 20)
            else
              Text('${index + 1}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          ],
        ),
        title: Text(
          song.title,
          style: TextStyle(
            fontSize: 15,
            color: isPlaying ? _green : Colors.white,
            fontWeight: isPlaying ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          song.artist,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),
        trailing: IconButton(
          icon: Icon(Icons.close, color: Colors.grey.shade600, size: 18),
          onPressed: () {
            setState(() {
              _songs.removeAt(index);
              if (_currentIndex >= _songs.length) {
                _currentIndex = _songs.length - 1;
              }
            });
          },
        ),
        onTap: () {
          setState(() => _currentIndex = index);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('正在播放: ${song.title}'),
                duration: const Duration(seconds: 1)),
          );
        },
      ),
    );
  }
}

class _SongItem {
  final String title;
  final String artist;
  _SongItem({required this.title, required this.artist});
}
