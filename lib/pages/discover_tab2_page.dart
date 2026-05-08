import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _DemoPlaylist {
  final String name;
  final Color color1;
  final Color color2;
  final int playCount;
  final int songCount;
  const _DemoPlaylist({
    required this.name,
    required this.color1,
    required this.color2,
    required this.playCount,
    required this.songCount,
  });
}

class DiscoverTab2Page extends StatefulWidget {
  const DiscoverTab2Page({super.key});

  @override
  State<DiscoverTab2Page> createState() => _DiscoverTab2PageState();
}

class _DiscoverTab2PageState extends State<DiscoverTab2Page> {
  String _selectedCategory = '全部';
  bool _refreshing = false;

  static const _categories = [
    '全部', '华语', '流行', '摇滚', '民谣', '电子', '古典', 'R&B',
  ];

  static final List<_DemoPlaylist> _playlists = [
    _DemoPlaylist(name: '华语经典回忆', color1: Colors.red, color2: Colors.orange, playCount: 128453, songCount: 66),
    _DemoPlaylist(name: '深夜听的歌', color1: Colors.indigo, color2: Colors.purple, playCount: 98231, songCount: 45),
    _DemoPlaylist(name: '2024年度最佳流行', color1: Colors.pink, color2: Colors.redAccent, playCount: 256789, songCount: 100),
    _DemoPlaylist(name: '摇滚不死', color1: Colors.deepOrange, color2: Colors.amber, playCount: 45123, songCount: 38),
    _DemoPlaylist(name: '民谣时光机', color1: Colors.brown, color2: Colors.green, playCount: 67890, songCount: 52),
    _DemoPlaylist(name: '电子脉冲', color1: Colors.cyan, color2: Colors.blue, playCount: 183456, songCount: 80),
    _DemoPlaylist(name: '古典音乐入门', color1: Colors.amber, color2: Colors.deepOrange, playCount: 34567, songCount: 30),
    _DemoPlaylist(name: 'R&B灵魂之夜', color1: Colors.deepPurple, color2: Colors.pink, playCount: 78901, songCount: 42),
    _DemoPlaylist(name: '治愈系轻音乐', color1: Colors.teal, color2: Colors.lightGreen, playCount: 312456, songCount: 55),
    _DemoPlaylist(name: '90后青春歌单', color1: Colors.blue, color2: Colors.indigo, playCount: 156789, songCount: 73),
    _DemoPlaylist(name: '跑步运动节拍', color1: Colors.green, color2: Colors.teal, playCount: 209345, songCount: 60),
    _DemoPlaylist(name: '雨天咖啡馆', color1: Colors.grey, color2: Colors.blueGrey, playCount: 87654, songCount: 35),
  ];

  Future<void> _onRefresh() async {
    setState(() => _refreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _refreshing = false);
  }

  String _formatPlayCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}万';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('歌单广场',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),

          // Category chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final selected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.primaryColor
                            : theme.brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 13,
                          color: selected
                              ? Colors.white
                              : theme.textTheme.bodyLarge?.color,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Refresh indicator
          SliverToBoxAdapter(
            child: _refreshing
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Grid
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final pl = _playlists[index];
                  return _PlaylistCard(playlist: pl, formatCount: _formatPlayCount);
                },
                childCount: _playlists.length,
              ),
            ),
          ),

          // Pull to refresh hint
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: GestureDetector(
                onTap: _onRefresh,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text('下拉刷新',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _PlaylistCard extends StatelessWidget {
  final _DemoPlaylist playlist;
  final String Function(int) formatCount;

  const _PlaylistCard({required this.playlist, required this.formatCount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [playlist.color1, playlist.color2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(Icons.music_note,
                        size: 40, color: Colors.white.withOpacity(0.3)),
                  ),
                  // Play count badge
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.play_arrow, color: Colors.white, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            formatCount(playlist.playCount),
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Play button
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            playlist.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            '${playlist.songCount}首',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
