import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../models/song.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({super.key});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const String artistName = '周杰伦';
  static const String fans = '2847万';
  static const String songCount = '386';
  static const String albumCount = '15';

  static final List<Song> hotSongs = [
    const Song(id: 'a1', title: '晴天', artist: '周杰伦', album: '叶惠美', coverUrl: '', duration: Duration(minutes: 4, seconds: 29), source: 'netease'),
    const Song(id: 'a2', title: '稻香', artist: '周杰伦', album: '魔杰座', coverUrl: '', duration: Duration(minutes: 3, seconds: 43), source: 'netease'),
    const Song(id: 'a3', title: '夜曲', artist: '周杰伦', album: '十一月的萧邦', coverUrl: '', duration: Duration(minutes: 4, seconds: 35), source: 'netease'),
    const Song(id: 'a4', title: '七里香', artist: '周杰伦', album: '七里香', coverUrl: '', duration: Duration(minutes: 4, seconds: 59), source: 'netease'),
    const Song(id: 'a5', title: '青花瓷', artist: '周杰伦', album: '我很忙', coverUrl: '', duration: Duration(minutes: 3, seconds: 59), source: 'netease'),
    const Song(id: 'a6', title: '告白气球', artist: '周杰伦', album: '周杰伦的床边故事', coverUrl: '', duration: Duration(minutes: 3, seconds: 36), source: 'netease'),
    const Song(id: 'a7', title: '简单爱', artist: '周杰伦', album: '范特西', coverUrl: '', duration: Duration(minutes: 4, seconds: 31), source: 'netease'),
    const Song(id: 'a8', title: '东风破', artist: '周杰伦', album: '叶惠美', coverUrl: '', duration: Duration(minutes: 5, seconds: 13), source: 'netease'),
    const Song(id: 'a9', title: '搁浅', artist: '周杰伦', album: '七里香', coverUrl: '', duration: Duration(minutes: 4, seconds: 6), source: 'netease'),
    const Song(id: 'a10', title: '龙卷风', artist: '周杰伦', album: 'Jay', coverUrl: '', duration: Duration(minutes: 4, seconds: 10), source: 'netease'),
  ];

  static const List<Map<String, String>> albums = [
    {'name': 'Jay', 'year': '2000'},
    {'name': '范特西', 'year': '2001'},
    {'name': '八度空间', 'year': '2002'},
    {'name': '叶惠美', 'year': '2003'},
    {'name': '七里香', 'year': '2004'},
    {'name': '十一月的萧邦', 'year': '2005'},
    {'name': '依然范特西', 'year': '2006'},
    {'name': '我很忙', 'year': '2007'},
  ];

  static const List<String> playCounts = [
    '1285万', '963万', '854万', '742万', '698万',
    '651万', '612万', '589万', '534万', '478万',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: const Color(0xFF1EC878).withOpacity(0.3),
                          child: const Icon(Icons.person, size: 48, color: Color(0xFF1EC878)),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          artistName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '粉丝 $fans · 歌曲 $songCount · 专辑 $albumCount',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('已关注周杰伦')),
                            );
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('关注'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1EC878),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF1EC878),
                labelColor: const Color(0xFF1EC878),
                unselectedLabelColor: Colors.white60,
                tabs: const [
                  Tab(text: '热门歌曲'),
                  Tab(text: '专辑'),
                  Tab(text: '关于'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildHotSongsTab(),
            _buildAlbumsTab(),
            _buildAboutTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildHotSongsTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: hotSongs.length,
      itemBuilder: (context, index) {
        final song = hotSongs[index];
        return ListTile(
          leading: SizedBox(
            width: 36,
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: index < 3 ? const Color(0xFF1EC878) : Colors.white54,
                  fontSize: 16,
                  fontWeight: index < 3 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
          title: Text(song.title, style: const TextStyle(fontSize: 15)),
          subtitle: Text(
            '${song.album} · ${playCounts[index]}次播放',
            style: const TextStyle(fontSize: 12, color: Colors.white54),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white54),
            onPressed: () {},
          ),
          onTap: () {
            context.read<PlayerProvider>().play(song, playlist: hotSongs, index: index);
            context.read<PlayerProvider>().showPlayer();
          },
        );
      },
    );
  }

  Widget _buildAlbumsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.75,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1EC878).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.album, size: 48, color: Color(0xFF1EC878)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              album['name']!,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              album['year']!,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '艺人简介',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            '周杰伦（Jay Chou），1979年1月18日出生于台湾省新北市，中国台湾流行乐男歌手、音乐人、演员、导演、编剧。\n\n'
            '2000年发行首张个人专辑《Jay》出道。2001年发行的专辑《范特西》奠定其融合中西方音乐的风格。'
            '2002年举行"The One"世界巡回演唱会。2003年成为美国《时代周刊》封面人物。'
            '2004年获得世界音乐大奖中国区最畅销艺人奖。2005年凭借动作片《头文字D》获得台湾电影金马奖、香港电影金像奖最佳新人奖。'
            '2006年起连续三年获得世界音乐大奖中国区最畅销艺人奖。\n\n'
            '周杰伦的音乐融合了R&B、嘻哈、古典、中国风等多种元素，对华语乐坛产生了深远影响，'
            '被誉为"亚洲流行天王"。代表作品包括《双截棍》《七里香》《青花瓷》《稻香》等。',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}
