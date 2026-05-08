import 'package:flutter/material.dart';

/// A custom slider input with a label on the left and the current value on the right.
class InputSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double>? onChanged;
  final String Function(double)? valueFormatter;
  final Color activeColor;

  const InputSlider({
    super.key,
    required this.label,
    required this.value,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.onChanged,
    this.valueFormatter,
    this.activeColor = const Color(0xFF1EC878),
  });

  String _defaultFormatter(double v) => v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final displayValue = (valueFormatter ?? _defaultFormatter)(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            Text(
              displayValue,
              style: TextStyle(
                color: activeColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: activeColor,
            inactiveTrackColor: activeColor.withValues(alpha: 0.15),
            thumbColor: activeColor,
            overlayColor: activeColor.withValues(alpha: 0.12),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            trackHeight: 4,
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
