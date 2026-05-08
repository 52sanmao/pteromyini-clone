import 'package:flutter/material.dart';

class LyricViewPage extends StatefulWidget {
  const LyricViewPage({super.key});

  @override
  State<LyricViewPage> createState() => _LyricViewPageState();
}

class _LyricViewPageState extends State<LyricViewPage> {
  static const _green = Color(0xFF1EC878);

  int _currentLine = 5;

  final _lyrics = [
    {'time': '00:00', 'text': '故事的小黄花'},
    {'time': '00:04', 'text': '从出生那年就飘着'},
    {'time': '00:08', 'text': '童年的荡秋千'},
    {'time': '00:12', 'text': '随记忆一直晃到现在'},
    {'time': '00:17', 'text': 'Re So So Si Do Si La'},
    {'time': '00:21', 'text': 'So La Si Si Si Si La Si La So'},
    {'time': '00:27', 'text': '吹着前奏 望着天空'},
    {'time': '00:31', 'text': '我想起花瓣试着掉落'},
    {'time': '00:37', 'text': '为你翘课的那一天'},
    {'time': '00:41', 'text': '花落的那一天'},
    {'time': '00:45', 'text': '教室的那一间'},
    {'time': '00:49', 'text': '我怎么看不见'},
    {'time': '00:53', 'text': '消失的下雨天'},
    {'time': '00:57', 'text': '我好想再淋一遍'},
    {'time': '01:02', 'text': '没想到 失去的勇气我还留着'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF0D0D1A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white70, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.more_horiz,
                          color: Colors.white70, size: 22),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('功能开发中'),
                              duration: Duration(seconds: 1)),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Song info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Text(
                      '晴天',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '周杰伦',
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Lyrics list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  itemCount: _lyrics.length,
                  itemBuilder: (context, index) {
                    final lyric = _lyrics[index];
                    final isCurrent = index == _currentLine;

                    return GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('跳转到 ${lyric['time']} - ${lyric['text']}'),
                              duration: const Duration(seconds: 1)),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(
                          vertical: isCurrent ? 14 : 10,
                          horizontal: 16,
                        ),
                        child: Text(
                          lyric['text']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isCurrent ? 18 : 15,
                            color: isCurrent
                                ? _green
                                : Colors.white.withValues(alpha: 0.45),
                            fontWeight:
                                isCurrent ? FontWeight.w600 : FontWeight.normal,
                            height: 1.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
