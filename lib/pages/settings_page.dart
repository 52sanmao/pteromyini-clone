import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _playQuality = 'HQ';
  String _playMode = '顺序';
  String _downloadQuality = 'HQ';
  String _downloadPath = '/storage/Music';
  int _downloadTasks = 3;
  String _theme = '深色';
  String _language = '简体中文';
  bool _autoUpdate = true;
  bool _timerOn = false;

  void _showSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('功能开发中'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          _sectionHeader('播放设置'),
          _settingItem(
            icon: Icons.high_quality,
            label: '在线播放音质',
            trailing: Text(_playQuality,
                style: TextStyle(color: Colors.grey.shade400)),
            onTap: () => _showSelectDialog('在线播放音质', ['HQ', '标准'], (v) {
              setState(() => _playQuality = v);
            }),
          ),
          _settingItem(
            icon: Icons.repeat,
            label: '默认播放模式',
            trailing: Text(_playMode,
                style: TextStyle(color: Colors.grey.shade400)),
            onTap: () => _showSelectDialog('默认播放模式', ['顺序', '随机', '单曲'], (v) {
              setState(() => _playMode = v);
            }),
          ),
          _settingItem(
            icon: Icons.timer_outlined,
            label: '定时关闭',
            trailing: Text(_timerOn ? '已开启' : '未开启',
                style: TextStyle(color: Colors.grey.shade400)),
            onTap: _showSnack,
          ),
          _sectionHeader('下载设置'),
          _settingItem(
            icon: Icons.download_outlined,
            label: '下载音质选择',
            trailing: Text(_downloadQuality,
                style: TextStyle(color: Colors.grey.shade400)),
            onTap: () => _showSelectDialog('下载音质选择', ['HQ', '标准'], (v) {
              setState(() => _downloadQuality = v);
            }),
          ),
          _settingItem(
            icon: Icons.folder_outlined,
            label: '下载路径',
            trailing: Text(_downloadPath,
                style: TextStyle(color: Colors.grey.shade400)),
            onTap: _showSnack,
          ),
          _settingItem(
            icon: Icons.download_for_offline_outlined,
            label: '同时下载任务数',
            trailing: Text('$_downloadTasks个',
                style: TextStyle(color: Colors.grey.shade400)),
            onTap: () => _showSelectDialog(
                '同时下载任务数', ['1', '2', '3', '5'], (v) {
              setState(() => _downloadTasks = int.parse(v));
            }),
          ),
          _sectionHeader('通用设置'),
          _settingItem(
            icon: Icons.palette_outlined,
            label: '主题',
            trailing: Text(_theme,
                style: TextStyle(color: Colors.grey.shade400)),
            onTap: () => _showSelectDialog('主题', ['深色', '浅色'], (v) {
              setState(() => _theme = v);
            }),
          ),
          _settingItem(
            icon: Icons.language,
            label: '语言',
            trailing: Text(_language,
                style: TextStyle(color: Colors.grey.shade400)),
            onTap: _showSnack,
          ),
          _settingItem(
            icon: Icons.system_update_outlined,
            label: '自动更新',
            trailing: Switch(
              value: _autoUpdate,
              activeColor: const Color(0xFF1EC878),
              onChanged: (v) => setState(() => _autoUpdate = v),
            ),
            onTap: () {},
          ),
          _sectionHeader('关于'),
          _settingItem(
            icon: Icons.info_outline,
            label: '关于我们',
            onTap: _showSnack,
          ),
          _settingItem(
            icon: Icons.volunteer_activism_outlined,
            label: '感谢开源',
            onTap: _showSnack,
          ),
          _settingItem(
            icon: Icons.tag,
            label: '版本号',
            trailing: Text('v1.0.2',
                style: TextStyle(color: Colors.grey.shade400)),
            onTap: () {},
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1EC878),
        ),
      ),
    );
  }

  Widget _settingItem({
    required IconData icon,
    required String label,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade400, size: 22),
      title: Text(label, style: const TextStyle(fontSize: 15)),
      trailing: trailing ?? Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 20),
      onTap: onTap ?? _showSnack,
    );
  }

  void _showSelectDialog(
      String title, List<String> options, ValueChanged<String> onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              ...options.map((opt) => ListTile(
                    title: Text(opt),
                    onTap: () {
                      onSelected(opt);
                      Navigator.pop(ctx);
                    },
                  )),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
