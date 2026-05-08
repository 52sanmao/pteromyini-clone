import 'package:flutter/material.dart';

class PlaySpeedPage extends StatefulWidget {
  const PlaySpeedPage({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const PlaySpeedPage(),
    );
  }

  @override
  State<PlaySpeedPage> createState() => _PlaySpeedPageState();
}

class _PlaySpeedPageState extends State<PlaySpeedPage> {
  static const _green = Color(0xFF1EC878);

  static const _speedOptions = <_SpeedOption>[
    _SpeedOption(label: '0.5x', value: 0.5),
    _SpeedOption(label: '0.75x', value: 0.75),
    _SpeedOption(label: '1.0x\n正常', value: 1.0),
    _SpeedOption(label: '1.25x', value: 1.25),
    _SpeedOption(label: '1.5x', value: 1.5),
    _SpeedOption(label: '2.0x', value: 2.0),
  ];

  double _currentSpeed = 1.0;

  void _setSpeed(double speed) {
    setState(() {
      _currentSpeed = (speed * 100).round() / 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '播放速度',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            // Speed chip buttons
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: _speedOptions.map((opt) {
                final selected = _currentSpeed == opt.value;
                return GestureDetector(
                  onTap: () => _setSpeed(opt.value),
                  child: Container(
                    width: 72,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? _green : Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                      border: selected
                          ? null
                          : Border.all(color: Colors.grey.shade700, width: 0.5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      opt.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: selected ? Colors.white : Colors.grey.shade300,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                        height: 1.3,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            // Fine-tune slider
            Row(
              children: [
                const Text('0.5x', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                      activeTrackColor: _green,
                      inactiveTrackColor: Colors.grey.shade800,
                      thumbColor: _green,
                      overlayColor: _green.withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: _currentSpeed,
                      min: 0.5,
                      max: 3.0,
                      onChanged: _setSpeed,
                    ),
                  ),
                ),
                const Text('3.0x', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 4),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: _green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentSpeed.toStringAsFixed(_currentSpeed.truncateToDouble() == _currentSpeed ? 1 : 2)}x',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _green,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _SpeedOption {
  final String label;
  final double value;
  const _SpeedOption({required this.label, required this.value});
}
