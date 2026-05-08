import 'package:flutter/material.dart';

class PlaylistImportPage extends StatelessWidget {
  const PlaylistImportPage({super.key});

  static const _accent = Color(0xFF1EC878);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('导入歌单', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _buildImportOption(
            context,
            icon: Icons.cloud_circle,
            iconColor: Colors.redAccent,
            title: '从网易云音乐导入',
            subtitle: '支持歌单、收藏、每日推荐',
          ),
          _buildImportOption(
            context,
            icon: Icons.music_note,
            iconColor: _accent,
            title: '从QQ音乐导入',
            subtitle: '支持歌单、我喜欢',
          ),
          _buildImportOption(
            context,
            icon: Icons.album,
            iconColor: Colors.blueAccent,
            title: '从酷我音乐导入',
            subtitle: '支持歌单、收藏歌单',
          ),
          _buildImportOption(
            context,
            icon: Icons.headphones,
            iconColor: Colors.orangeAccent,
            title: '从酷狗音乐导入',
            subtitle: '支持歌单、我的收藏',
          ),
          _buildImportOption(
            context,
            icon: Icons.folder_outlined,
            iconColor: Colors.white54,
            title: '从本地文件导入',
            subtitle: '支持 .m3u / .pls / .csv 格式',
          ),

          // Recent imports
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
            child: Row(
              children: const [
                Icon(Icons.history, size: 18, color: Colors.white38),
                SizedBox(width: 6),
                Text('最近导入',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70)),
              ],
            ),
          ),
          _buildRecentImport(
            context,
            title: '华语经典合集',
            source: '网易云音乐',
            songCount: 86,
            time: '今天 14:32',
          ),
          _buildRecentImport(
            context,
            title: '2026年度热歌',
            source: 'QQ音乐',
            songCount: 52,
            time: '昨天 20:15',
          ),
        ],
      ),
    );
  }

  Widget _buildImportOption(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.white38)),
      trailing:
          const Icon(Icons.chevron_right, color: Colors.white24, size: 22),
      onTap: () => _showImportDialog(context, title),
    );
  }

  Widget _buildRecentImport(
    BuildContext context, {
    required String title,
    required String source,
    required int songCount,
    required String time,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.playlist_play, color: _accent, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      subtitle: Text('$source  ·  $songCount 首  ·  $time',
          style: const TextStyle(fontSize: 12, color: Colors.white38)),
      onTap: () {},
    );
  }

  void _showImportDialog(BuildContext context, String source) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(source, style: const TextStyle(fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('请输入歌单链接',
                style: TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              style: const TextStyle(fontSize: 14, color: Colors.white),
              decoration: InputDecoration(
                hintText: 'https://...',
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _accent),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                const Text('取消', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('正在导入歌单...')));
            },
            child: const Text('导入', style: TextStyle(color: _accent)),
          ),
        ],
      ),
    );
  }
}
