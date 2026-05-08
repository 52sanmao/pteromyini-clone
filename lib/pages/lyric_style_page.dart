import 'package:flutter/material.dart';

class LyricStylePage extends StatefulWidget {
  const LyricStylePage({super.key});

  @override
  State<LyricStylePage> createState() => _LyricStylePageState();
}

class _LyricStylePageState extends State<LyricStylePage> {
  static const _green = Color(0xFF1EC878);

  double _fontSize = 18;
  double _lineSpacing = 1.6;
  int _selectedColorIndex = 0;
  int _highlightColorIndex = 1;
  int _alignmentIndex = 0;

  final _colorOptions = [
    _ColorOption(label: '白色', color: Colors.white),
    _ColorOption(label: '绿色', color: const Color(0xFF1EC878)),
    _ColorOption(label: '黄色', color: const Color(0xFFFFD700)),
    _ColorOption(label: '蓝色', color: const Color(0xFF4FC3F7)),
    _ColorOption(label: '粉色', color: const Color(0xFFFF69B4)),
  ];

  final _sampleLyrics = [
    '窗外的麻雀 在电线杆上多嘴',
    '你说这一句 很有夏天的感觉',
    '手中的铅笔 在纸上来来回回',
    '我用几行字形容你是我的谁',
  ];

  void _resetDefaults() {
    setState(() {
      _fontSize = 18;
      _lineSpacing = 1.6;
      _selectedColorIndex = 0;
      _highlightColorIndex = 1;
      _alignmentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('歌词样式')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Preview section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: List.generate(_sampleLyrics.length, (i) {
                final isHighlight = i == 1;
                return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: _lineSpacing * 4 - 4),
                  child: Text(
                    _sampleLyrics[i],
                    textAlign: _alignmentIndex == 0
                        ? TextAlign.center
                        : TextAlign.left,
                    style: TextStyle(
                      fontSize: isHighlight ? _fontSize + 2 : _fontSize,
                      color: isHighlight
                          ? _colorOptions[_highlightColorIndex].color
                          : _colorOptions[_selectedColorIndex]
                              .color
                              .withValues(alpha: 0.6),
                      fontWeight:
                          isHighlight ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 28),

          // Font size slider
          _buildSliderSection(
            label: '字体大小',
            value: _fontSize,
            min: 12,
            max: 28,
            display: _fontSize.toStringAsFixed(0),
            onChanged: (v) => setState(() => _fontSize = v),
          ),
          const SizedBox(height: 16),

          // Line spacing slider
          _buildSliderSection(
            label: '行间距',
            value: _lineSpacing,
            min: 1.0,
            max: 3.0,
            display: _lineSpacing.toStringAsFixed(1),
            onChanged: (v) => setState(() => _lineSpacing = v),
          ),
          const SizedBox(height: 24),

          // Normal text color
          const Text('歌词颜色',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _buildColorPicker(
            selectedIndex: _selectedColorIndex,
            onChanged: (i) => setState(() => _selectedColorIndex = i),
          ),
          const SizedBox(height: 24),

          // Highlight color
          const Text('高亮颜色 (当前行)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _buildColorPicker(
            selectedIndex: _highlightColorIndex,
            onChanged: (i) => setState(() => _highlightColorIndex = i),
          ),
          const SizedBox(height: 24),

          // Alignment
          const Text('对齐方式',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildAlignmentOption('居中', 0),
              const SizedBox(width: 12),
              _buildAlignmentOption('左对齐', 1),
            ],
          ),
          const SizedBox(height: 32),

          // Reset button
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: _resetDefaults,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _green),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('恢复默认',
                  style: TextStyle(
                      color: _green,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSliderSection({
    required String label,
    required double value,
    required double min,
    required double max,
    required String display,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600)),
            Text(display,
                style: const TextStyle(fontSize: 14, color: _green)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _green,
            thumbColor: _green,
            inactiveTrackColor: Colors.grey.shade700,
            overlayColor: _green.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildColorPicker({
    required int selectedIndex,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      children: List.generate(_colorOptions.length, (i) {
        final opt = _colorOptions[i];
        final selected = i == selectedIndex;
        return GestureDetector(
          onTap: () => onChanged(i),
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: opt.color,
                    shape: BoxShape.circle,
                    border: selected
                        ? Border.all(color: _green, width: 3)
                        : null,
                  ),
                  child: selected
                      ? const Icon(Icons.check, color: Colors.black, size: 20)
                      : null,
                ),
                const SizedBox(height: 4),
                Text(opt.label,
                    style: TextStyle(
                        fontSize: 12,
                        color: selected ? _green : Colors.grey.shade500)),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAlignmentOption(String label, int index) {
    final selected = _alignmentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _alignmentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? _green.withValues(alpha: 0.15)
              : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? _green : Colors.grey.shade600,
          ),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 14,
              color: selected ? _green : Colors.grey.shade300,
            )),
      ),
    );
  }
}

class _ColorOption {
  final String label;
  final Color color;
  _ColorOption({required this.label, required this.color});
}
