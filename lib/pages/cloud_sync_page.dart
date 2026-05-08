import 'package:flutter/material.dart';

class CloudSyncPage extends StatefulWidget {
  const CloudSyncPage({super.key});

  @override
  State<CloudSyncPage> createState() => _CloudSyncPageState();
}

class _CloudSyncPageState extends State<CloudSyncPage> {
  bool _playlistSync = true;
  bool _historySync = true;
  bool _favoriteSync = true;
  bool _searchSync = false;
  bool _autoSync = true;
  bool _syncing = false;

  void _startSync() {
    setState(() => _syncing = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _syncing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('同步完成'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('云同步')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sync status card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1EC878).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: const Color(0xFF1EC878).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1EC878),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('同步状态',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('上次同步: 2026-05-08 16:30',
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey.shade400)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sync items
          const Text('同步项目',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _syncItem(
            icon: Icons.queue_music,
            label: '播放列表',
            detail: '12个歌单',
            value: _playlistSync,
            onChanged: (v) => setState(() => _playlistSync = v),
          ),
          _syncItem(
            icon: Icons.history,
            label: '播放历史',
            detail: '1234条记录',
            value: _historySync,
            onChanged: (v) => setState(() => _historySync = v),
          ),
          _syncItem(
            icon: Icons.favorite,
            label: '我喜欢',
            detail: '56首',
            value: _favoriteSync,
            onChanged: (v) => setState(() => _favoriteSync = v),
          ),
          _syncItem(
            icon: Icons.search,
            label: '搜索历史',
            value: _searchSync,
            onChanged: (v) => setState(() => _searchSync = v),
          ),
          const SizedBox(height: 32),

          // Sync button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _syncing ? null : _startSync,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1EC878),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: _syncing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('立即同步', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 24),

          // Auto sync toggle
          SwitchListTile(
            title: const Text('自动同步', style: TextStyle(fontSize: 15)),
            subtitle: Text('Wi-Fi 下自动同步数据',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            value: _autoSync,
            activeColor: const Color(0xFF1EC878),
            onChanged: (v) => setState(() => _autoSync = v),
          ),
        ],
      ),
    );
  }

  Widget _syncItem({
    required IconData icon,
    required String label,
    String? detail,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade400, size: 22),
      title: Text(label, style: const TextStyle(fontSize: 15)),
      subtitle: detail != null
          ? Text(detail,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500))
          : null,
      trailing: Switch(
        value: value,
        activeColor: const Color(0xFF1EC878),
        onChanged: onChanged,
      ),
    );
  }
}
