import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _DemoComment {
  final String username;
  final String content;
  final String time;
  final int likes;
  final Color avatarColor;
  final bool pinned;

  const _DemoComment({
    required this.username,
    required this.content,
    required this.time,
    required this.likes,
    required this.avatarColor,
    this.pinned = false,
  });
}

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final _inputController = TextEditingController();

  static const _hotComments = [
    _DemoComment(
      username: '音乐旅人',
      content: '每次听到这首歌都会想起那个夏天，蝉鸣、晚风、还有你。音乐真的是时间的容器，装着我们所有来不及说出口的告别。',
      time: '2024-12-15',
      likes: 23456,
      avatarColor: Colors.red,
      pinned: true,
    ),
    _DemoComment(
      username: '深夜食堂老板',
      content: '凌晨三点，一个人戴着耳机听这首歌，突然就哭了。有些歌不是因为旋律好听，而是因为歌词写进了心里。',
      time: '2024-11-28',
      likes: 18923,
      avatarColor: Colors.blue,
      pinned: true,
    ),
    _DemoComment(
      username: '流浪猫收容所',
      content: '把这首歌推荐给了暗恋三年的人，ta说很好听，但是还是没能在一起。没关系，至少这首歌成了我们共同的回忆。',
      time: '2024-10-03',
      likes: 15678,
      avatarColor: Colors.purple,
      pinned: true,
    ),
  ];

  static const _latestComments = [
    _DemoComment(username: '星辰大海', content: '单曲循环中，太上头了！', time: '3分钟前', likes: 56, avatarColor: Colors.teal),
    _DemoComment(username: '小熊猫', content: '这编曲真的绝了，每一个音符都恰到好处', time: '15分钟前', likes: 128, avatarColor: Colors.orange),
    _DemoComment(username: '月光下的猫', content: '第一次听就爱上了，分享给了所有朋友', time: '28分钟前', likes: 89, avatarColor: Colors.indigo),
    _DemoComment(username: '柠檬不萌', content: '为什么我每次听都会起鸡皮疙瘩', time: '1小时前', likes: 234, avatarColor: Colors.green),
    _DemoComment(username: '北城以北', content: '有些歌，只适合一个人静静听', time: '2小时前', likes: 412, avatarColor: Colors.brown),
    _DemoComment(username: '云端漫步', content: '在地铁上听到这首歌，差点哭出来被旁边人看到', time: '3小时前', likes: 67, avatarColor: Colors.cyan),
    _DemoComment(username: '夏日限定', content: '已经连续听了100遍，不接受反驳', time: '5小时前', likes: 345, avatarColor: Colors.pink),
    _DemoComment(username: '老唱片', content: '经典就是经典，无论过了多少年再听依然感动', time: '8小时前', likes: 567, avatarColor: Colors.amber),
    _DemoComment(username: '窗外的雨', content: '下雨天配上这首歌，氛围感拉满', time: '12小时前', likes: 123, avatarColor: Colors.blueGrey),
    _DemoComment(username: '追光者', content: '谢谢这首歌陪我度过了最难的日子', time: '1天前', likes: 1024, avatarColor: Colors.deepPurple),
  ];

  String _formatLikes(int likes) {
    if (likes >= 10000) {
      return '${(likes / 10000).toStringAsFixed(1)}万';
    }
    return likes.toString();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('评论 (1286)', style: TextStyle(fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                // Hot comments
                _buildSectionHeader('热门评论', Icons.local_fire_department, Colors.orange),
                ..._hotComments.map((c) => _buildCommentTile(c, theme)),

                const Divider(height: 32, indent: 16, endIndent: 16),

                // Latest comments
                _buildSectionHeader('最新评论', Icons.access_time, Colors.grey),
                ..._latestComments.map((c) => _buildCommentTile(c, theme)),
              ],
            ),
          ),

          // Bottom input bar
          _buildInputBar(theme),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCommentTile(_DemoComment comment, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: comment.avatarColor.withOpacity(0.2),
            child: Text(
              comment.username[0],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: comment.avatarColor,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username + pinned badge
                Row(
                  children: [
                    Text(
                      comment.username,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    if (comment.pinned) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '置顶',
                          style: TextStyle(fontSize: 10, color: AppTheme.primaryColor),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),

                // Comment text
                Text(
                  comment.content,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),

                // Time + likes
                Row(
                  children: [
                    Text(
                      comment.time,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(Icons.thumb_up_off_alt, size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            _formatLikes(comment.likes),
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(ThemeData theme) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12, 8, 12, 8 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF16213E)
            : Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  hintText: '发表评论...',
                  hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              if (_inputController.text.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('评论发送成功！')),
                );
                _inputController.clear();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '发送',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
