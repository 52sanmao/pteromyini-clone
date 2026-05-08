import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  static const _green = Color(0xFF1EC878);

  final _problemTypes = ['功能异常', '体验问题', '功能建议', '其他'];
  String _selectedType = '功能异常';
  final _descriptionController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('意见反馈')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Problem type selector
          const Text('问题类型',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _problemTypes.map((type) {
              final selected = type == _selectedType;
              return GestureDetector(
                onTap: () => setState(() => _selectedType = type),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? _green.withValues(alpha: 0.15)
                        : Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? _green : Colors.grey.shade600,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      fontSize: 14,
                      color: selected ? _green : Colors.grey.shade300,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Description input
          const Text('问题描述',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            maxLines: 6,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: '请详细描述您遇到的问题...',
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade700),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade700),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _green),
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 24),

          // Screenshot upload
          const Text('截图上传',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('功能开发中'), duration: Duration(seconds: 1)),
              );
            },
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade700, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 36, color: Colors.grey.shade600),
                  const SizedBox(height: 8),
                  Text('添加截图',
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Contact info
          const Text('联系方式 (选填)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TextField(
            controller: _contactController,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: '请输入您的邮箱或手机号',
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade700),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade700),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _green),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 28),

          // Submit button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('反馈已提交，感谢您的反馈！'),
                      duration: Duration(seconds: 2)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                elevation: 0,
              ),
              child: const Text('提交反馈',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 36),

          // History section
          const Text('我的反馈 (2)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _feedbackItem(
            type: '功能异常',
            date: '2026-05-06',
            desc: '播放歌曲时偶尔会卡顿，切歌后恢复正常',
            status: '已处理',
          ),
          _feedbackItem(
            type: '功能建议',
            date: '2026-04-28',
            desc: '希望可以增加定时播放功能，设置每天早上自动播放音乐',
            status: '处理中',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _feedbackItem({
    required String type,
    required String date,
    required String desc,
    required String status,
  }) {
    final statusColor = status == '已处理' ? _green : Colors.orange;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(type,
                    style: const TextStyle(fontSize: 12, color: _green)),
              ),
              const Spacer(),
              Text(date,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text('状态: $status',
              style: TextStyle(fontSize: 13, color: statusColor)),
        ],
      ),
    );
  }
}
