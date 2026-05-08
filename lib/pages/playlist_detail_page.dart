import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/player_provider.dart';

class PlaylistDetailPage extends StatelessWidget {
  final Playlist playlist;

  const PlaylistDetailPage({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final player = context.read<PlayerProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsing header
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(playlist.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.6),
                      theme.colorScheme.primary.withOpacity(0.2),
                      theme.scaffoldBackgroundColor,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              Colors.primaries[
                                  playlist.id.hashCode.abs() %
                                      Colors.primaries.length],
                              Colors.primaries[
                                      (playlist.id.hashCode.abs() + 5) %
                                          Colors.primaries.length]
                                  .withOpacity(0.7),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.queue_music,
                            color: Colors.white, size: 48),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        playlist.creator,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Action bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (playlist.songs.isNotEmpty) {
                          player.play(playlist.songs.first,
                              playlist: playlist.songs, index: 0);
                        }
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('播放全部'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.shuffle),
                    label: const Text('随机'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('下载'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Song count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                '共${playlist.songs.length}首',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),
          ),

          // Song list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = playlist.songs[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: SizedBox(
                    width: 24,
                    child: Text(
                      '${index + 1}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade500),
                    ),
                  ),
                  title: Text(
                    song.title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: theme.colorScheme.primary, width: 0.5),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(song.sourceLabel,
                            style: TextStyle(
                                fontSize: 9,
                                color: theme.colorScheme.primary)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${song.artist}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onPressed: () {},
                  ),
                  onTap: () {
                    player.play(song,
                        playlist: playlist.songs, index: index);
                  },
                );
              },
              childCount: playlist.songs.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}
