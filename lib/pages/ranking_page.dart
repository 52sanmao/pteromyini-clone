import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  // Official ranking data
  static final List<Map<String, dynamic>> officialRankings = [
    {
      'name': '飙升榜',
      'gradient': [Color(0xFFE53935), Color(0xFFEF5350)],
      'songs': [
        {'rank': 1, 'title': '暮色回响', 'artist': 'TIGO'},
        {'rank': 2, 'title': '晚风心里吹', 'artist': 'LBI利比'},
        {'rank': 3, 'title': '把回忆拼好给你', 'artist': '王贰浪'},
      ],
    },
    {
      'name': '新歌榜',
      'gradient': [Color(0xFF1E88E5), Color(0xFF42A5F5)],
      'songs': [
        {'rank': 1, 'title': '在加纳共和国离婚', 'artist': '江辰'},
        {'rank': 2, 'title': '如果可以', 'artist': '韦礼安'},
        {'rank': 3, 'title': '我还记得', 'artist': '周兴哲'},
      ],
    },
    {
      'name': '原创榜',
      'gradient': [Color(0xFF43A047), Color(0xFF66BB6A)],
      'songs': [
        {'rank': 1, 'title': '孤雏', 'artist': 'AGA'},
        {'rank': 2, 'title': '若把你', 'artist': 'Kirsty刘瑾睿'},
        {'rank': 3, 'title': '可能', 'artist': '程响'},
      ],
    },
    {
      'name': '热歌榜',
      'gradient': [Color(0xFFEF6C00), Color(0xFFFFA726)],
      'songs': [
        {'rank': 1, 'title': '半生雪', 'artist': '是七叔呢'},
        {'rank': 2, 'title': '星辰大海', 'artist': '黄霄雲'},
        {'rank': 3, 'title': '踏山河', 'artist': '是七叔呢'},
      ],
    },
  ];

  // Category ranking data
  static final List<Map<String, dynamic>> categoryRankings = [
    {'name': '说唱榜', 'icon': Icons.music_note, 'color': Color(0xFF9C27B0)},
    {'name': '古典榜', 'icon': Icons.piano, 'color': Color(0xFF795548)},
    {'name': '电子榜', 'icon': Icons.electric_bolt, 'color': Color(0xFF00BCD4)},
    {'name': '民谣榜', 'icon': Icons.nature_people, 'color': Color(0xFF8BC34A)},
    {'name': 'R&B榜', 'icon': Icons.headphones, 'color': Color(0xFFE91E63)},
  ];

  // Global ranking data
  static final List<Map<String, dynamic>> globalRankings = [
    {'name': '欧美榜', 'emoji': '🇺🇸', 'count': '100首'},
    {'name': '日语榜', 'emoji': '🇯🇵', 'count': '100首'},
    {'name': '韩语榜', 'emoji': '🇰🇷', 'count': '100首'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('排行榜'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Official rankings header
            _sectionHeader('官方榜'),
            const SizedBox(height: 12),
            _buildOfficialGrid(context),
            const SizedBox(height: 24),
            // Category rankings header
            _sectionHeader('特色榜'),
            const SizedBox(height: 12),
            _buildCategoryScroll(),
            const SizedBox(height: 24),
            // Global rankings header
            _sectionHeader('全球榜'),
            const SizedBox(height: 12),
            _buildGlobalList(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildOfficialGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: officialRankings.length,
      itemBuilder: (context, index) {
        final ranking = officialRankings[index];
        return _buildOfficialCard(context, ranking);
      },
    );
  }

  Widget _buildOfficialCard(BuildContext context, Map<String, dynamic> ranking) {
    final gradient = ranking['gradient'] as List<Color>;
    final songs = ranking['songs'] as List<Map<String, dynamic>>;

    return GestureDetector(
      onTap: () {
        final demoSongs = PlayerProvider.demoSongs;
        final playlist = demoSongs.take(3).toList();
        context.read<PlayerProvider>().play(
              playlist.first,
              playlist: playlist,
              index: 0,
            );
        context.read<PlayerProvider>().showPlayer();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ranking['name'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.play_circle_fill, color: Colors.white70, size: 28),
              ],
            ),
            const SizedBox(height: 12),
            ...songs.map((song) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        '${song['rank']}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          song['title'] as String,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        song['artist'] as String,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryScroll() {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categoryRankings.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = categoryRankings[index];
          return Container(
            width: 90,
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: (cat['color'] as Color).withOpacity(0.2),
                  child: Icon(cat['icon'] as IconData, color: cat['color'] as Color),
                ),
                const SizedBox(height: 8),
                Text(
                  cat['name'] as String,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlobalList(BuildContext context) {
    return Column(
      children: globalRankings
          .map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Text(
                  item['emoji'] as String,
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(
                  item['name'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(item['count'] as String),
                trailing: const Icon(Icons.chevron_right),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
