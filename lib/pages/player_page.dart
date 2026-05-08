import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  bool _showLyrics = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    final player = context.read<PlayerProvider>();
    if (player.isPlaying) {
      _rotationController.repeat();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final player = context.watch<PlayerProvider>();
    if (player.isPlaying && !_rotationController.isAnimating) {
      _rotationController.repeat();
    } else if (!player.isPlaying && _rotationController.isAnimating) {
      _rotationController.stop();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final song = player.currentSong;
    final theme = Theme.of(context);

    if (song == null) {
      return const Scaffold(body: Center(child: Text('暂无播放')));
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.3),
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              _buildTopBar(context, song),

              // Main content
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _showLyrics = !_showLyrics),
                  child: _showLyrics
                      ? _buildLyricsView(context, song)
                      : _buildCoverView(context, song),
                ),
              ),

              // Song info
              _buildSongInfo(context, song),

              // Progress bar
              _buildProgressBar(context, player),

              // Controls
              _buildControls(context, player),

              // Bottom actions
              _buildBottomActions(context),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, song) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, size: 32),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  song.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  song.artist,
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCoverView(BuildContext context, song) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        width: 280,
        height: 280,
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: RotationTransition(
          turns: _rotationController,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.tertiary,
                  theme.colorScheme.primary.withOpacity(0.5),
                  theme.colorScheme.primary,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.primaries[
                          int.tryParse(song.id) ?? 0 % Colors.primaries.length],
                      Colors.primaries[
                              (int.tryParse(song.id) ?? 0 + 4) %
                                  Colors.primaries.length]
                          .withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.scaffoldBackgroundColor,
                    ),
                    child: Icon(Icons.music_note,
                        color: theme.colorScheme.primary, size: 30),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLyricsView(BuildContext context, song) {
    final lyrics = [
      '夜曲 - 周杰伦',
      '',
      '一群嗜血的蚂蚁 被腐肉所吸引',
      '我面无表情 看孤独的风景',
      '失去你 爱恨开始模糊',
      '失去你 还有什么事好关心',
      '',
      '当鸽子不再象征和平',
      '我终于被提醒',
      '广场上喂食的是秃鹰',
      '我用漂亮的押韵',
      '形容被掠夺一空的爱情',
      '',
      '啊 乌云开始遮蔽 夜幕低垂',
      '大地 被月光染成了银',
      '像是在嘲笑 我孤独一人的身影',
      '',
      '为你弹奏萧邦的夜曲',
      '纪念我死去的爱情',
      '跟夜风一样的声音',
      '心碎的很好听',
      '手在键盘敲很轻',
      '我给的思念很小心',
      '你埋葬的爱情 是我的回忆',
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      itemCount: lyrics.length,
      itemBuilder: (context, index) {
        final isHighlight = index == 3; // simulate active line
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            lyrics[index],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isHighlight ? 18 : 15,
              fontWeight:
                  isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.withOpacity(0.6),
              height: 1.5,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSongInfo(BuildContext context, song) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${song.artist} · ${song.album}',
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey.shade500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, PlayerProvider player) {
    String formatTime(Duration d) {
      final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
            ),
            child: Slider(
              value: player.duration.inMilliseconds > 0
                  ? player.position.inMilliseconds /
                      player.duration.inMilliseconds
                  : 0,
              onChanged: (value) {
                player.seek(Duration(
                    milliseconds:
                        (value * player.duration.inMilliseconds).toInt()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(player.position),
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade500)),
                Text(formatTime(player.duration),
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, PlayerProvider player) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(player.playModeIcon, size: 24),
            onPressed: () => player.togglePlayMode(),
            tooltip: player.playModeLabel,
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous, size: 36),
            onPressed: () => player.previous(),
          ),
          GestureDetector(
            onTap: () => player.togglePlay(),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                player.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, size: 36),
            onPressed: () => player.next(),
          ),
          IconButton(
            icon: const Icon(Icons.queue_music, size: 24),
            onPressed: () => _showPlayQueue(context, player),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.comment_outlined, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.timer_outlined, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.equalizer, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void _showPlayQueue(BuildContext context, PlayerProvider player) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          maxChildSize: 0.8,
          minChildSize: 0.3,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('播放列表 (${player.playlist.length}首)',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(player.playModeIcon, size: 20),
                              onPressed: () => player.togglePlayMode(),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: player.playlist.length,
                      itemBuilder: (context, index) {
                        final song = player.playlist[index];
                        final isCurrent = index == player.currentIndex;
                        return ListTile(
                          leading: isCurrent
                              ? Icon(Icons.play_circle,
                                  color:
                                      Theme.of(context).colorScheme.primary)
                              : const SizedBox(width: 24),
                          title: Text(
                            song.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isCurrent
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isCurrent
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            '${song.artist} - ${song.sourceLabel}',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade500),
                          ),
                          trailing: isCurrent
                              ? Text('正在播放',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary))
                              : null,
                          onTap: () {
                            player.play(song,
                                playlist: player.playlist, index: index);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
