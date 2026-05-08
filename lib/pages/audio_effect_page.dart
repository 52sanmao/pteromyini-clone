import 'package:flutter/material.dart';

class AudioEffectPage extends StatefulWidget {
  const AudioEffectPage({super.key});

  @override
  State<AudioEffectPage> createState() => _AudioEffectPageState();
}

class _AudioEffectPageState extends State<AudioEffectPage> {
  static const _green = Color(0xFF1EC878);

  final _effects = <_AudioEffect>[
    _AudioEffect(
      icon: Icons.surround_sound,
      name: '虚拟环绕声',
      description: '模拟多声道环绕声效果',
      enabled: false,
      intensity: 3,
      maxIntensity: 5,
    ),
    _AudioEffect(
      icon: Icons.bolt,
      name: '低音增强',
      description: '增强低频表现力',
      enabled: true,
      intensity: 3,
      maxIntensity: 5,
    ),
    _AudioEffect(
      icon: Icons.volume_up,
      name: '响度均衡',
      description: '自动平衡音量差异',
      enabled: false,
      intensity: 3,
      maxIntensity: 5,
    ),
    _AudioEffect(
      icon: Icons.blur_circular,
      name: '混响',
      description: '添加空间感与混响效果',
      enabled: false,
      intensity: 2,
      maxIntensity: 5,
      hasPresets: true,
      currentPreset: '大厅',
    ),
    _AudioEffect(
      icon: Icons.threed_rotation,
      name: '3D音效',
      description: '增强立体声空间感',
      enabled: false,
      intensity: 3,
      maxIntensity: 5,
    ),
  ];

  static const _reverbPresets = ['房间', '大厅', '音乐厅'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('音效')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _effects.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
        itemBuilder: (context, i) {
          final effect = _effects[i];
          return _buildEffectTile(effect, i);
        },
      ),
    );
  }

  Widget _buildEffectTile(_AudioEffect effect, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: effect.enabled
                    ? _green.withValues(alpha: 0.15)
                    : Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                effect.icon,
                color: effect.enabled ? _green : Colors.grey.shade500,
                size: 22,
              ),
            ),
            title: Text(
              effect.name,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              effect.description,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            trailing: Switch(
              value: effect.enabled,
              activeColor: _green,
              onChanged: (v) {
                setState(() => _effects[index] = effect.copyWith(enabled: v));
              },
            ),
          ),
          if (effect.enabled) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(72, 0, 20, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '强度',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                      ),
                      const Spacer(),
                      Text(
                        '${effect.intensity}/${effect.maxIntensity}',
                        style: const TextStyle(fontSize: 12, color: _green),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                      activeTrackColor: _green,
                      inactiveTrackColor: Colors.grey.shade800,
                      thumbColor: _green,
                      overlayColor: _green.withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: effect.intensity.toDouble(),
                      min: 1,
                      max: effect.maxIntensity.toDouble(),
                      divisions: effect.maxIntensity - 1,
                      onChanged: (v) {
                        setState(() {
                          _effects[index] =
                              effect.copyWith(intensity: v.round());
                        });
                      },
                    ),
                  ),
                  if (effect.hasPresets)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _reverbPresets.map((preset) {
                        final selected = preset == effect.currentPreset;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(
                              preset,
                              style: TextStyle(
                                fontSize: 12,
                                color: selected ? Colors.white : Colors.grey.shade400,
                              ),
                            ),
                            selected: selected,
                            selectedColor: _green,
                            backgroundColor: Colors.white10,
                            onSelected: (_) {
                              setState(() {
                                _effects[index] =
                                    effect.copyWith(currentPreset: preset);
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AudioEffect {
  final IconData icon;
  final String name;
  final String description;
  final bool enabled;
  final int intensity;
  final int maxIntensity;
  final bool hasPresets;
  final String currentPreset;

  const _AudioEffect({
    required this.icon,
    required this.name,
    required this.description,
    required this.enabled,
    required this.intensity,
    required this.maxIntensity,
    this.hasPresets = false,
    this.currentPreset = '',
  });

  _AudioEffect copyWith({
    bool? enabled,
    int? intensity,
    String? currentPreset,
  }) {
    return _AudioEffect(
      icon: icon,
      name: name,
      description: description,
      enabled: enabled ?? this.enabled,
      intensity: intensity ?? this.intensity,
      maxIntensity: maxIntensity,
      hasPresets: hasPresets,
      currentPreset: currentPreset ?? this.currentPreset,
    );
  }
}
