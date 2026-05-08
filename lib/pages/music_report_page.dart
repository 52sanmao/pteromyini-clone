import 'package:flutter/material.dart';

class MusicReportPage extends StatelessWidget {
  const MusicReportPage({super.key});

  static const _accent = Color(0xFF1EC878);

  static const _topSongs = [
    ('夜曲', '周杰伦', 87),
    ('起风了', '买辣椒也用券', 64),
    ('孤勇者', '陈奕迅', 52),
    ('晴天', '周杰伦', 45),
    ('平凡之路', '朴树', 38),
  ];

  static const _weeklyData = [
    ('一', 2.1),
    ('二', 1.5),
    ('三', 3.2),
    ('四', 2.8),
    ('五', 1.9),
    ('六', 4.5),
    ('日', 3.8),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('听歌报告',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Top card
          _buildTopCard(),

          const SizedBox(height: 16),

          // Stats grid
          _buildStatsGrid(),

          const SizedBox(height: 24),

          // Top 5 songs
          _buildSectionTitle('本月热门歌曲 TOP 5'),
          const SizedBox(height: 12),
          _buildTopSongs(),

          const SizedBox(height: 24),

          // Weekly chart
          _buildSectionTitle('本周收听趋势'),
          const SizedBox(height: 12),
          _buildWeeklyChart(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTopCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _accent.withValues(alpha: 0.3),
            _accent.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart, color: _accent, size: 28),
              const SizedBox(width: 10),
              const Text('2026年5月',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
          const SizedBox(height: 6),
          const Text('听歌报告',
              style: TextStyle(fontSize: 15, color: Colors.white54)),
          const SizedBox(height: 16),
          const Text('本月你沉浸在 1234 首歌曲中，共度过了 86 小时的音乐时光。',
              style: TextStyle(fontSize: 13, color: Colors.white60)),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: [
        _buildStatCard(Icons.play_circle_outline, '总播放', '1234次'),
        _buildStatCard(Icons.access_time, '时长', '86小时'),
        _buildStatCard(Icons.person_outline, '最爱歌手', '周杰伦(128次)'),
        _buildStatCard(Icons.category_outlined, '最爱曲风', '流行'),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: _accent, size: 18),
              const SizedBox(width: 6),
              Text(label,
                  style:
                      const TextStyle(fontSize: 12, color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70));
  }

  Widget _buildTopSongs() {
    return Column(
      children: _topSongs.asMap().entries.map((entry) {
        final index = entry.key;
        final title = entry.value.$1;
        final artist = entry.value.$2;
        final count = entry.value.$3;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Text('${index + 1}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: index < 3 ? _accent : Colors.white38)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    Text(artist,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white38)),
                  ],
                ),
              ),
              Text('$count 次',
                  style: const TextStyle(fontSize: 12, color: Colors.white54)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeeklyChart() {
    const maxVal = 4.5;
    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: _weeklyData.map((entry) {
          final label = entry.$1;
          final value = entry.$2;
          final ratio = value / maxVal;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${value}h',
                      style:
                          const TextStyle(fontSize: 10, color: Colors.white38)),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    height: ratio * 100,
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: 0.6 + ratio * 0.4),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(6)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(label,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.white54)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
