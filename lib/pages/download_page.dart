import 'package:flutter/material.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _accent = Color(0xFF1EC878);

  final _downloading = const [
    _DownloadItem('七里香', '周杰伦', 0.65, '2.3MB/s', '4.8MB/7.4MB'),
    _DownloadItem('光年之外', '邓紫棋', 0.23, '1.1MB/s', '1.2MB/5.2MB'),
    _DownloadItem('稻香', '周杰伦', 0.91, '3.2MB/s', '5.7MB/6.3MB'),
  ];

  final _downloaded = const [
    _DownloadedItem('夜曲', '周杰伦', '8.3MB', 'HQ'),
    _DownloadedItem('起风了', '买辣椒也用券', '7.1MB', 'HQ'),
    _DownloadedItem('孤勇者', '陈奕迅', '5.8MB', '标准'),
    _DownloadedItem('晴天', '周杰伦', '6.2MB', 'HQ'),
    _DownloadedItem('说好不哭', '周杰伦', '5.5MB', '标准'),
    _DownloadedItem('倒带', '蔡依林', '4.9MB', '标准'),
    _DownloadedItem('年少有为', '李荣浩', '6.7MB', 'HQ'),
    _DownloadedItem('平凡之路', '朴树', '7.4MB', 'HQ'),
    _DownloadedItem('告白气球', '周杰伦', '5.3MB', '标准'),
    _DownloadedItem('后来', '刘若英', '6.1MB', 'HQ'),
    _DownloadedItem('体面', '于文文', '4.7MB', '标准'),
    _DownloadedItem('消愁', '毛不易', '5.9MB', '标准'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('下载管理', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('已清空已完成下载')));
            },
            child: const Text('清空已完成', style: TextStyle(color: _accent)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _accent,
          labelColor: _accent,
          unselectedLabelColor: Colors.white54,
          tabs: [
            Tab(text: '正在下载(${_downloading.length})'),
            Tab(text: '已下载(${_downloaded.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDownloadingTab(),
          _buildDownloadedTab(),
        ],
      ),
    );
  }

  Widget _buildDownloadingTab() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _downloading.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final item = _downloading[index];
        return _buildDownloadingItem(item, index);
      },
    );
  }

  Widget _buildDownloadingItem(_DownloadItem item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(item.artist,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.white54)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.pause_circle_outline,
                    color: Colors.white70, size: 28),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('已暂停: ${item.title}')));
                },
              ),
              IconButton(
                icon:
                    const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 28),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('已取消: ${item.title}')));
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item.progress,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(_accent),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('${(item.progress * 100).toInt()}%',
                  style: const TextStyle(fontSize: 12, color: _accent)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.sizeInfo,
                  style: const TextStyle(fontSize: 11, color: Colors.white38)),
              Row(
                children: [
                  const Icon(Icons.speed, size: 12, color: Colors.white38),
                  const SizedBox(width: 2),
                  Text(item.speed,
                      style:
                          const TextStyle(fontSize: 11, color: Colors.white38)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadedTab() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _downloaded.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final item = _downloaded[index];
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
          title: Text(item.title,
              style: const TextStyle(fontSize: 15)),
          subtitle: Text('${item.artist}  ·  ${item.size}',
              style: const TextStyle(fontSize: 13, color: Colors.white54)),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: item.quality == 'HQ'
                  ? _accent.withValues(alpha: 0.15)
                  : Colors.white10,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: item.quality == 'HQ' ? _accent : Colors.white24,
                width: 0.5,
              ),
            ),
            child: Text(item.quality,
                style: TextStyle(
                  fontSize: 11,
                  color: item.quality == 'HQ' ? _accent : Colors.white54,
                )),
          ),
          onTap: () {},
        );
      },
    );
  }
}

class _DownloadItem {
  final String title;
  final String artist;
  final double progress;
  final String speed;
  final String sizeInfo;

  const _DownloadItem(
      this.title, this.artist, this.progress, this.speed, this.sizeInfo);
}

class _DownloadedItem {
  final String title;
  final String artist;
  final String size;
  final String quality;

  const _DownloadedItem(this.title, this.artist, this.size, this.quality);
}
