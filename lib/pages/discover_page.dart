import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/player_provider.dart';
import 'playlist_detail_page.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.read<PlayerProvider>();
    final theme = Theme.of(context);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            floating: true,
            title: Row(
              children: [
                Icon(Icons.music_note, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                const Text('发现音乐',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {},
              ),
            ],
          ),

          // Banner
          SliverToBoxAdapter(
            child: _buildBanner(context),
          ),

          // Quick access row
          SliverToBoxAdapter(
            child: _buildQuickAccess(context),
          ),

          // Recommend playlists
          SliverToBoxAdapter(
            child: _buildSectionHeader(context, '推荐歌单', '查看更多'),
          ),
          SliverToBoxAdapter(
            child: _buildRecommendPlaylists(context),
          ),

          // Hot songs
          SliverToBoxAdapter(
            child: _buildSectionHeader(context, '热门歌曲', '播放全部'),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = PlayerProvider.demoSongs[index];
                return _SongTile(
                  song: song,
                  index: index,
                  onTap: () {
                    player.play(song,
                        playlist: PlayerProvider.demoSongs, index: index);
                  },
                );
              },
              childCount: PlayerProvider.demoSongs.length,
            ),
          ),

          // Bottom padding for mini player
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.6),
            theme.colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.play_circle_fill,
              size: 120,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '每日推荐',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '根据你的口味生成\n每日更新30首',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text('立即播放'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: theme.colorScheme.primary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccess(BuildContext context) {
    final items = [
      (_QuickItem(Icons.radio, '私人FM', Colors.orange)),
      (_QuickItem(Icons.leaderboard, '排行榜', Colors.red)),
      (_QuickItem(Icons.album, '歌单', Colors.blue)),
      (_QuickItem(Icons.mic, '歌手', Colors.purple)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          return GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.icon, color: item.color, size: 24),
                ),
                const SizedBox(height: 6),
                Text(
                  item.label,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(action,
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.withOpacity(0.8))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendPlaylists(BuildContext context) {
    final playlists = PlayerProvider.recommendPlaylists;
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final pl = playlists[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PlaylistDetailPage(playlist: pl),
                ),
              );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Colors.primaries[
                              index % Colors.primaries.length],
                          Colors.primaries[
                              (index + 3) % Colors.primaries.length]
                              .withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(Icons.music_note,
                              size: 40, color: Colors.white.withOpacity(0.5)),
                        ),
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black26,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow,
                                color: Colors.white, size: 20),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Row(
                            children: [
                              const Icon(Icons.play_arrow,
                                  color: Colors.white, size: 14),
                              Text(
                                '${pl.songs.length * 1234}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    pl.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuickItem {
  final IconData icon;
  final String label;
  final Color color;
  const _QuickItem(this.icon, this.label, this.color);
}

class _SongTile extends StatelessWidget {
  final Song song;
  final int index;
  final VoidCallback onTap;

  const _SongTile({
    required this.song,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '${index + 1}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: index < 3 ? FontWeight.bold : FontWeight.normal,
                color: index < 3
                    ? theme.colorScheme.primary
                    : Colors.grey.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  Colors.primaries[(index * 2) % Colors.primaries.length]
                      .withOpacity(0.7),
                  Colors.primaries[(index * 2 + 5) % Colors.primaries.length]
                      .withOpacity(0.7),
                ],
              ),
            ),
            child: const Icon(Icons.music_note, color: Colors.white, size: 20),
          ),
        ],
      ),
      title: Text(
        song.title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.primary, width: 0.5),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              song.sourceLabel,
              style: TextStyle(fontSize: 9, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '${song.artist} - ${song.album}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert, size: 20),
        onPressed: () {},
      ),
      onTap: onTap,
    );
  }
}
