import 'package:flutter/material.dart';

class CacheLimitPage extends StatefulWidget {
  const CacheLimitPage({super.key});

  @override
  State<CacheLimitPage> createState() => _CacheLimitPageState();
}

class _CacheLimitPageState extends State<CacheLimitPage> {
  static const _green = Color(0xFF1EC878);

  String _selectedLimit = '1GB';
  bool _autoCacheWifi = true;

  final _cacheLimits = [
    _CacheOption(label: '无限', value: '无限'),
    _CacheOption(label: '500MB', value: '500MB'),
    _CacheOption(label: '1GB', value: '1GB'),
    _CacheOption(label: '2GB', value: '2GB'),
    _CacheOption(label: '5GB', value: '5GB'),
  ];

  final _cacheBreakdown = [
    _CacheItem(icon: Icons.music_note, label: '音乐缓存', size: '180MB'),
    _CacheItem(icon: Icons.image, label: '图片缓存', size: '45MB'),
    _CacheItem(icon: Icons.lyrics, label: '歌词缓存', size: '13.5MB'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('缓存管理')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current cache size
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('已使用',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 8),
                const Text('238.5 MB',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _green)),
                const SizedBox(height: 4),
                Text('限制: $_selectedLimit',
                    style:
                        TextStyle(fontSize: 13, color: Colors.grey.shade500)),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Cache limit setting
          const Text('缓存上限',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _cacheLimits.map((opt) {
              final selected = opt.value == _selectedLimit;
              return GestureDetector(
                onTap: () => setState(() => _selectedLimit = opt.value),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? _green.withValues(alpha: 0.15)
                        : Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selected ? _green : Colors.grey.shade600,
                    ),
                  ),
                  child: Text(
                    opt.label,
                    style: TextStyle(
                      fontSize: 14,
                      color: selected ? _green : Colors.grey.shade300,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Cache breakdown
          const Text('缓存详情',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: _cacheBreakdown.asMap().entries.map((entry) {
                final item = entry.value;
                final isLast = entry.key == _cacheBreakdown.length - 1;
                return Column(
                  children: [
                    ListTile(
                      leading:
                          Icon(item.icon, color: Colors.grey.shade400, size: 22),
                      title: Text(item.label,
                          style: const TextStyle(fontSize: 15)),
                      trailing: Text(item.size,
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade400)),
                    ),
                    if (!isLast)
                      Divider(height: 1, indent: 56, color: Colors.grey.shade800),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Auto cache toggle
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              value: _autoCacheWifi,
              activeColor: _green,
              title: const Text('WIFI下自动缓存播放过的歌曲',
                  style: TextStyle(fontSize: 15)),
              onChanged: (v) => setState(() => _autoCacheWifi = v),
            ),
          ),
          const SizedBox(height: 28),

          // Clear cache button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: Colors.grey.shade900,
                    title: const Text('清除缓存'),
                    content: const Text('确定要清除所有缓存吗？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('取消',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('缓存已清除'),
                                duration: Duration(seconds: 1)),
                          );
                        },
                        child: const Text('确定',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                elevation: 0,
              ),
              child: const Text('清除缓存',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _CacheOption {
  final String label;
  final String value;
  _CacheOption({required this.label, required this.value});
}

class _CacheItem {
  final IconData icon;
  final String label;
  final String size;
  _CacheItem({required this.icon, required this.label, required this.size});
}
