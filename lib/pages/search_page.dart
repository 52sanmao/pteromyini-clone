import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/player_provider.dart';
import 'search_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  List<Song> _searchResults = [];

  final List<String> _hotSearches = [
    '周杰伦', '起风了', '孤勇者', '海阔天空',
    '晴天', '稻香', '邓紫棋', '平凡之路',
    '告白气球', '七里香', '夜曲', '倒带',
  ];

  final List<String> _searchHistory = [
    '周杰伦 晴天',
    '起风了',
    '陈奕迅',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }
    setState(() {
      _isSearching = true;
      _searchResults = PlayerProvider.demoSongs
          .where((s) =>
              s.title.contains(query) ||
              s.artist.contains(query) ||
              s.album.contains(query))
          .toList();
      // If no match, show all as demo
      if (_searchResults.isEmpty) {
        _searchResults = PlayerProvider.demoSongs;
      }
    });
  }

  void _submitSearch(String query) {
    if (query.isEmpty) return;
    setState(() {
      if (!_searchHistory.contains(query)) {
        _searchHistory.insert(0, query);
      }
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchDetailPage(query: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final player = context.read<PlayerProvider>();

    return SafeArea(
      child: Column(
        children: [
          // Search header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _performSearch,
                      onSubmitted: _submitSearch,
                      decoration: InputDecoration(
                        hintText: '搜索歌曲、歌手、专辑',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade500, fontSize: 14),
                        prefixIcon:
                            Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  _performSearch('');
                                },
                              )
                            : null,
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                if (_isSearching) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      _performSearch('');
                    },
                    child: const Text('取消'),
                  ),
                ],
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isSearching ? _buildSearchResults(player) : _buildBrowseContent(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(PlayerProvider player) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final song = _searchResults[index];
        return ListTile(
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  Colors.primaries[index % Colors.primaries.length]
                      .withOpacity(0.7),
                  Colors.primaries[(index + 3) % Colors.primaries.length]
                      .withOpacity(0.7),
                ],
              ),
            ),
            child: const Icon(Icons.music_note, color: Colors.white, size: 20),
          ),
          title: Text(song.title, style: const TextStyle(fontSize: 15)),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primary, width: 0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(song.sourceLabel,
                    style: TextStyle(
                        fontSize: 9,
                        color: Theme.of(context).colorScheme.primary)),
              ),
              const SizedBox(width: 6),
              Text('${song.artist} - ${song.album}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert, size: 20),
            onPressed: () {},
          ),
          onTap: () {
            player.play(song,
                playlist: _searchResults, index: index);
          },
        );
      },
    );
  }

  Widget _buildBrowseContent(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search history
          if (_searchHistory.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('搜索历史',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () {
                      setState(() => _searchHistory.clear());
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _searchHistory.map((q) {
                  return GestureDetector(
                    onTap: () {
                      _searchController.text = q;
                      _submitSearch(q);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(q, style: const TextStyle(fontSize: 13)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          // Hot searches
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Row(
              children: [
                const Text('热搜榜',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 6),
                Icon(Icons.local_fire_department,
                    color: Colors.orange.shade400, size: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _hotSearches.asMap().entries.map((entry) {
                final i = entry.key;
                final q = entry.value;
                return GestureDetector(
                  onTap: () {
                    _searchController.text = q;
                    _submitSearch(q);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: i < 3
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : theme.brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.black.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: i < 3
                          ? Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.3))
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (i < 3) ...[
                          Text('${i + 1}',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary)),
                          const SizedBox(width: 4),
                        ],
                        Text(q, style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Source tabs
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: const Text('音乐平台',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildSourceChip('网易云', Colors.red, theme),
                const SizedBox(width: 8),
                _buildSourceChip('酷我', Colors.blue, theme),
                const SizedBox(width: 8),
                _buildSourceChip('QQ音乐', Colors.green, theme),
                const SizedBox(width: 8),
                _buildSourceChip('酷狗', Colors.orange, theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceChip(String label, Color color, ThemeData theme) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('已选择 $label 音乐源'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(Icons.music_note, color: color, size: 24),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(fontSize: 12, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
