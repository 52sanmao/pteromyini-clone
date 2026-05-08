import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/player_provider.dart';
import '../models/song.dart';
import 'playlist_detail_page.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final player = context.read<PlayerProvider>();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('我的音乐',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: Icon(themeProvider.isDark
                    ? Icons.light_mode
                    : Icons.dark_mode),
                onPressed: () => themeProvider.toggleTheme(),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {},
              ),
            ],
          ),

          // User card
          SliverToBoxAdapter(child: _buildUserCard(context)),

          // Quick actions
          SliverToBoxAdapter(child: _buildQuickActions(context, player)),

          // My playlists
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('我的歌单',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 22),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final pl = PlayerProvider.demoPlaylists[index];
                return _PlaylistTile(
                  playlist: pl,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PlaylistDetailPage(playlist: pl),
                      ),
                    );
                  },
                );
              },
              childCount: PlayerProvider.demoPlaylists.length,
            ),
          ),

          // Recent played
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: const Text('最近播放',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: PlayerProvider.demoSongs.length,
                itemBuilder: (context, index) {
                  final song = PlayerProvider.demoSongs[index];
                  return GestureDetector(
                    onTap: () => player.play(song,
                        playlist: PlayerProvider.demoSongs, index: index),
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.primaries[
                                      index % Colors.primaries.length],
                                  Colors.primaries[
                                          (index + 4) % Colors.primaries.length]
                                      .withOpacity(0.7),
                                ],
                              ),
                            ),
                            child: const Icon(Icons.music_note,
                                color: Colors.white, size: 30),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            song.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.8),
            theme.colorScheme.tertiary.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '音乐爱好者',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'LV.8 | 听歌 1,234 首',
                  style:
                      TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text('会员',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, PlayerProvider player) {
    final items = [
      (Icons.download, '本地下载', '12首'),
      (Icons.history, '最近播放', '${PlayerProvider.demoSongs.length}首'),
      (Icons.favorite_border, '我喜欢', '56首'),
      (Icons.cloud_upload, '云同步', '已同步'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: items.map((item) {
          return Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(item.$1, size: 22, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 6),
                    Text(item.$2, style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(item.$3,
                        style: TextStyle(
                            fontSize: 10, color: Colors.grey.shade500)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PlaylistTile extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback onTap;

  const _PlaylistTile({required this.playlist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              Colors.primaries[playlist.id.hashCode.abs() % Colors.primaries.length],
              Colors.primaries[(playlist.id.hashCode.abs() + 5) % Colors.primaries.length]
                  .withOpacity(0.7),
            ],
          ),
        ),
        child: const Icon(Icons.queue_music, color: Colors.white, size: 24),
      ),
      title: Text(playlist.name,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      subtitle: Text(
        '${playlist.songs.length}首 · ${playlist.creator}',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
