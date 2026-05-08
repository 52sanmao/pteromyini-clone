import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';

class SearchDetailPage extends StatefulWidget {
  final String query;

  const SearchDetailPage({super.key, required this.query});

  @override
  State<SearchDetailPage> createState() => _SearchDetailPageState();
}

class _SearchDetailPageState extends State<SearchDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = ['单曲', '歌手', '专辑', '歌单'];

  // Demo data
  static final List<_DemoSongResult> _songs = [
    _DemoSongResult(title: '夜曲', artist: '周杰伦', album: '十一月的萧邦', source: 'netease'),
    _DemoSongResult(title: '起风了', artist: '买辣椒也用券', album: '起风了', source: 'kuwo'),
    _DemoSongResult(title: '孤勇者', artist: '陈奕迅', album: '孤勇者', source: 'qq'),
    _DemoSongResult(title: '稻香', artist: '周杰伦', album: '魔杰座', source: 'kugou'),
    _DemoSongResult(title: '光年之外', artist: '邓紫棋', album: '光年之外', source: 'netease'),
    _DemoSongResult(title: '平凡之路', artist: '朴树', album: '猎户星座', source: 'kuwo'),
    _DemoSongResult(title: '晴天', artist: '周杰伦', album: '叶惠美', source: 'netease'),
    _DemoSongResult(title: '海阔天空', artist: 'Beyond', album: '乐与怒', source: 'qq'),
  ];

  static const List<_DemoArtist> _artists = [
    _DemoArtist(name: '周杰伦', songCount: 486, color: Colors.red),
    _DemoArtist(name: '陈奕迅', songCount: 312, color: Colors.blue),
    _DemoArtist(name: '邓紫棋', songCount: 198, color: Colors.purple),
    _DemoArtist(name: '朴树', songCount: 87, color: Colors.green),
  ];

  static const List<_DemoAlbum> _albums = [
    _DemoAlbum(name: '十一月的萧邦', artist: '周杰伦', year: '2005', color: Colors.indigo),
    _DemoAlbum(name: '叶惠美', artist: '周杰伦', year: '2003', color: Colors.brown),
    _DemoAlbum(name: '孤勇者', artist: '陈奕迅', year: '2021', color: Colors.red),
    _DemoAlbum(name: '猎户星座', artist: '朴树', year: '2017', color: Colors.teal),
  ];

  static const List<_DemoPlaylistItem> _playlistItems = [
    _DemoPlaylistItem(name: '周杰伦精选合集', songCount: 128, playCount: '256.3万', color: Colors.red),
    _DemoPlaylistItem(name: '华语流行金曲', songCount: 200, playCount: '189.7万', color: Colors.orange),
    _DemoPlaylistItem(name: '90后的回忆', songCount: 156, playCount: '134.2万', color: Colors.blue),
    _DemoPlaylistItem(name: '深夜独处必备', songCount: 88, playCount: '98.5万', color: Colors.purple),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _sourceLabel(String source) {
    switch (source) {
      case 'netease': return '网易云';
      case 'kuwo': return '酷我';
      case 'qq': return 'QQ音乐';
      case 'kugou': return '酷狗';
      default: return '未知';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.query, style: const TextStyle(fontSize: 18)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSongsTab(theme),
          _buildArtistsTab(theme),
          _buildAlbumsTab(theme),
          _buildPlaylistsTab(theme),
        ],
      ),
    );
  }

  Widget _buildSongsTab(ThemeData theme) {
    final player = context.read<PlayerProvider>();
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: _songs.length,
      itemBuilder: (context, index) {
        final s = _songs[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  Colors.primaries[index % Colors.primaries.length].withOpacity(0.7),
                  Colors.primaries[(index + 3) % Colors.primaries.length].withOpacity(0.7),
                ],
              ),
            ),
            child: const Icon(Icons.music_note, color: Colors.white, size: 20),
          ),
          title: Text(s.title, style: const TextStyle(fontSize: 15)),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primaryColor, width: 0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(_sourceLabel(s.source),
                    style: const TextStyle(fontSize: 9, color: AppTheme.primaryColor)),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${s.artist} - ${s.album}',
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
          onTap: () {
            final song = Song(
              id: 'search_$index',
              title: s.title,
              artist: s.artist,
              album: s.album,
              coverUrl: '',
              duration: Duration(minutes: 3 + index % 3, seconds: 15 + index * 7),
              source: s.source,
            );
            final allSongs = List.generate(_songs.length, (i) {
              final x = _songs[i];
              return Song(
                id: 'search_$i',
                title: x.title,
                artist: x.artist,
                album: x.album,
                coverUrl: '',
                duration: Duration(minutes: 3 + i % 3, seconds: 15 + i * 7),
                source: x.source,
              );
            });
            player.play(song, playlist: allSongs, index: index);
          },
        );
      },
    );
  }

  Widget _buildArtistsTab(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: _artists.length,
      itemBuilder: (context, index) {
        final a = _artists[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: a.color.withOpacity(0.2),
            child: Text(
              a.name[0],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: a.color),
            ),
          ),
          title: Text(a.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          subtitle: Text('共${a.songCount}首歌曲',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        );
      },
    );
  }

  Widget _buildAlbumsTab(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: _albums.length,
      itemBuilder: (context, index) {
        final a = _albums[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [a.color, a.color.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.album, color: Colors.white, size: 28),
          ),
          title: Text(a.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          subtitle: Text('${a.artist} · ${a.year}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        );
      },
    );
  }

  Widget _buildPlaylistsTab(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: _playlistItems.length,
      itemBuilder: (context, index) {
        final p = _playlistItems[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [p.color, p.color.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.queue_music, color: Colors.white, size: 28),
          ),
          title: Text(p.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          subtitle: Text('${p.songCount}首 · 播放${p.playCount}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        );
      },
    );
  }
}

// Demo data classes

class _DemoSongResult {
  final String title;
  final String artist;
  final String album;
  final String source;
  const _DemoSongResult({required this.title, required this.artist, required this.album, required this.source});
}

class _DemoArtist {
  final String name;
  final int songCount;
  final Color color;
  const _DemoArtist({required this.name, required this.songCount, required this.color});
}

class _DemoAlbum {
  final String name;
  final String artist;
  final String year;
  final Color color;
  const _DemoAlbum({required this.name, required this.artist, required this.year, required this.color});
}

class _DemoPlaylistItem {
  final String name;
  final int songCount;
  final String playCount;
  final Color color;
  const _DemoPlaylistItem({required this.name, required this.songCount, required this.playCount, required this.color});
}
