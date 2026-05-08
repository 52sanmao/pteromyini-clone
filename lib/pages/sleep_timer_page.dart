import 'package:flutter/material.dart';
import 'dart:async';

class SleepTimerPage extends StatefulWidget {
  const SleepTimerPage({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const SleepTimerPage(),
    );
  }

  @override
  State<SleepTimerPage> createState() => _SleepTimerPageState();
}

class _SleepTimerPageState extends State<SleepTimerPage> {
  static const _green = Color(0xFF1EC878);

  static const _options = <_TimerOption>[
    _TimerOption(label: '不定时', minutes: 0),
    _TimerOption(label: '10分钟', minutes: 10),
    _TimerOption(label: '15分钟', minutes: 15),
    _TimerOption(label: '30分钟', minutes: 30),
    _TimerOption(label: '45分钟', minutes: 45),
    _TimerOption(label: '60分钟', minutes: 60),
    _TimerOption(label: '90分钟', minutes: 90),
  ];

  int _selectedMinutes = 30;
  bool _finishSong = false;
  bool _timerActive = false;
  Duration _remaining = Duration.zero;
  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_selectedMinutes == 0) {
      _ticker?.cancel();
      setState(() {
        _timerActive = false;
        _remaining = Duration.zero;
      });
      Navigator.pop(context);
      return;
    }

    setState(() {
      _remaining = Duration(minutes: _selectedMinutes);
      _timerActive = true;
    });

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds <= 0) {
        _ticker?.cancel();
        setState(() => _timerActive = false);
        return;
      }
      setState(() {
        _remaining -= const Duration(seconds: 1);
      });
    });

    Navigator.pop(context);
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) {
      return '${h}时${m}分${s}秒';
    }
    return '${m}分${s}秒';
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
                '定时关闭',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            if (_timerActive) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer, color: _green, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '剩余 ${_formatDuration(_remaining)}',
                      style: const TextStyle(
                        color: _green,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            ...List.generate(_options.length, (i) {
              final opt = _options[i];
              final selected = opt.minutes == _selectedMinutes;
              return RadioListTile<int>(
                value: opt.minutes,
                groupValue: _selectedMinutes,
                activeColor: _green,
                title: Text(
                  opt.label,
                  style: TextStyle(
                    fontSize: 15,
                    color: selected ? Colors.white : Colors.grey.shade300,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedMinutes = v);
                },
              );
            }),
            const Divider(height: 1),
            SwitchListTile(
              value: _finishSong,
              activeColor: _green,
              title: const Text(
                '播完整首歌再停止',
                style: TextStyle(fontSize: 15),
              ),
              onChanged: (v) => setState(() => _finishSong = v),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _timerActive ? '重设' : '确认',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerOption {
  final String label;
  final int minutes;
  const _TimerOption({required this.label, required this.minutes});
}
