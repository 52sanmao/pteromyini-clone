import 'package:flutter/material.dart';

class PlaylistManagePage extends StatefulWidget {
  const PlaylistManagePage({super.key});

  @override
  State<PlaylistManagePage> createState() => _PlaylistManagePageState();
}

class _PlaylistManagePageState extends State<PlaylistManagePage> {
  static const _green = Color(0xFF1EC878);

  final List<_PlaylistItem> _playlists = [
    _PlaylistItem(
        name: '我喜欢的音乐',
        songCount: 128,
        gradient: const [Color(0xFF1EC878), Color(0xFF0D9B5A)]),
    _PlaylistItem(
        name: '华语经典',
        songCount: 56,
        gradient: const [Color(0xFFE85D75), Color(0xFFC0382B)]),
    _PlaylistItem(
        name: '运动节奏',
        songCount: 32,
        gradient: const [Color(0xFFFF9800), Color(0xFFE65100)]),
    _PlaylistItem(
        name: '深夜安静',
        songCount: 45,
        gradient: const [Color(0xFF7C4DFF), Color(0xFF4527A0)]),
  ];

  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showNewPlaylistDialog() {
    _nameController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('新建歌单'),
        content: TextField(
          controller: _nameController,
          autofocus: true,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: '请输入歌单名称',
            hintStyle: TextStyle(color: Colors.grey.shade600),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade700),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: _green),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                const Text('取消', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (_nameController.text.trim().isNotEmpty) {
                setState(() {
                  _playlists.add(_PlaylistItem(
                    name: _nameController.text.trim(),
                    songCount: 0,
                    gradient: const [Color(0xFF26A69A), Color(0xFF00796B)],
                  ));
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('创建', style: TextStyle(color: _green)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(int index) {
    _nameController.text = _playlists[index].name;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('编辑歌单'),
        content: TextField(
          controller: _nameController,
          autofocus: true,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: '请输入歌单名称',
            hintStyle: TextStyle(color: Colors.grey.shade600),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade700),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: _green),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                const Text('取消', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (_nameController.text.trim().isNotEmpty) {
                setState(() {
                  _playlists[index] = _PlaylistItem(
                    name: _nameController.text.trim(),
                    songCount: _playlists[index].songCount,
                    gradient: _playlists[index].gradient,
                  );
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('保存', style: TextStyle(color: _green)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('歌单管理'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('完成',
                style: TextStyle(
                    color: _green,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Column(
        children: [
          // New playlist button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: _showNewPlaylistDialog,
                icon: const Icon(Icons.add, color: _green, size: 20),
                label: const Text('新建歌单',
                    style: TextStyle(color: _green, fontSize: 15)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _green),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _playlists.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = _playlists.removeAt(oldIndex);
                  _playlists.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                final playlist = _playlists[index];
                return _buildPlaylistTile(playlist, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistTile(_PlaylistItem playlist, int index) {
    return Container(
      key: ValueKey(playlist.name),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.drag_handle, color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 8),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: playlist.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.music_note, color: Colors.white, size: 24),
            ),
          ],
        ),
        title: Text(playlist.name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        subtitle: Text('${playlist.songCount}首',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined,
                  color: Colors.grey.shade500, size: 20),
              onPressed: () => _showEditDialog(index),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline,
                  color: Colors.grey.shade500, size: 20),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: Colors.grey.shade900,
                    title: const Text('删除歌单'),
                    content: Text('确定要删除「${playlist.name}」吗？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('取消',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() => _playlists.removeAt(index));
                          Navigator.pop(ctx);
                        },
                        child: const Text('删除',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaylistItem {
  final String name;
  final int songCount;
  final List<Color> gradient;
  _PlaylistItem(
      {required this.name, required this.songCount, required this.gradient});
}
