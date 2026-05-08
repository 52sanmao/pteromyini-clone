import 'package:flutter/material.dart';
import 'dart:math' as math;

class EqualizerPage extends StatefulWidget {
  const EqualizerPage({super.key});

  @override
  State<EqualizerPage> createState() => _EqualizerPageState();
}

class _EqualizerPageState extends State<EqualizerPage> {
  static const _green = Color(0xFF1EC878);

  static const _presets = <String>[
    '自定义', '流行', '摇滚', '古典', '爵士', '电子', '人声', '低音增强',
  ];

  static const _bands = <String>[
    '31', '62', '125', '250', '500', '1k', '2k', '4k', '8k', '16k',
  ];

  // Preset values in dB for each band (-12 to +12)
  static const _presetValues = <String, List<double>>{
    '自定义': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    '流行':   [2, 4, 3, 0, -1, 0, 2, 4, 5, 3],
    '摇滚':   [5, 4, 2, 0, -1, 1, 3, 5, 6, 5],
    '古典':   [3, 2, 0, 0, 0, 0, -1, -2, -1, 1],
    '爵士':   [3, 2, 1, 2, -1, -1, 0, 2, 3, 4],
    '电子':   [5, 4, 1, 0, -2, 1, 0, 3, 5, 6],
    '人声':   [-1, -2, 0, 3, 5, 5, 3, 0, -1, -2],
    '低音增强': [8, 7, 5, 2, 0, 0, 0, 0, 0, 0],
  };

  String _selectedPreset = '流行';
  late List<double> _values;

  @override
  void initState() {
    super.initState();
    _values = List<double>.from(_presetValues['流行']!);
  }

  void _selectPreset(String preset) {
    setState(() {
      _selectedPreset = preset;
      _values = List<double>.from(_presetValues[preset]!);
    });
  }

  void _reset() {
    _selectPreset('自定义');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('均衡器'),
        actions: [
          TextButton(
            onPressed: _reset,
            child: const Text(
              '重置',
              style: TextStyle(color: _green, fontSize: 15),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          // Preset selector
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _presets.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final preset = _presets[i];
                final selected = preset == _selectedPreset;
                return GestureDetector(
                  onTap: () => _selectPreset(preset),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: selected ? _green : Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      preset,
                      style: TextStyle(
                        fontSize: 13,
                        color: selected ? Colors.white : Colors.grey.shade400,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          // Frequency curve
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 100,
              child: CustomPaint(
                painter: _EqCurvePainter(
                  values: _values,
                  color: _green,
                ),
                size: const Size(double.infinity, 100),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // dB scale labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('+12dB', style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text('0dB', style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text('-12dB', style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Sliders
          Expanded(
            child: Row(
              children: List.generate(_bands.length, (i) {
                return Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${_values[i] > 0 ? '+' : ''}${_values[i].toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                              activeTrackColor: _green,
                              inactiveTrackColor: Colors.grey.shade800,
                              thumbColor: _green,
                              overlayColor: _green.withValues(alpha: 0.2),
                            ),
                            child: Slider(
                              value: _values[i],
                              min: -12,
                              max: 12,
                              onChanged: (v) {
                                setState(() {
                                  _values[i] = v;
                                  _selectedPreset = '自定义';
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '${_bands[i]}Hz',
                        style: const TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _EqCurvePainter extends CustomPainter {
  final List<double> values;
  final Color color;

  _EqCurvePainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final bgPaint = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    // Draw center line
    final centerY = size.height / 2;
    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      Paint()..color = Colors.grey.shade800..strokeWidth = 0.5,
    );

    // Map values to points
    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      // value range: -12 to +12, mapped to height (top = +12, bottom = -12)
      final y = centerY - (values[i] / 12) * (size.height / 2);
      points.add(Offset(x, y));
    }

    // Draw filled area with smooth curve
    final fillPath = Path()..moveTo(points.first.dx, size.height);
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final midX = (p0.dx + p1.dx) / 2;
      fillPath.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
      linePath.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
    }

    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);

    // Draw dots
    final dotPaint = Paint()..color = color..style = PaintingStyle.fill;
    for (final p in points) {
      canvas.drawCircle(p, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _EqCurvePainter old) =>
      old.values != values || old.color != color;
}
