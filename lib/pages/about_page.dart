import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  void _showSnack(BuildContext context) {
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
      appBar: AppBar(title: const Text('关于')),
      body: Column(
        children: [
          const SizedBox(height: 40),

          // App icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1EC878),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.music_note, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 12),

          // App name
          const Text('听你所爱',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('v1.0.2',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
          const SizedBox(height: 40),

          // Menu items
          _menuItem(
            context,
            icon: Icons.description_outlined,
            label: '用户协议',
            onTap: () => _showSnack(context),
          ),
          _menuItem(
            context,
            icon: Icons.privacy_tip_outlined,
            label: '隐私政策',
            onTap: () => _showSnack(context),
          ),
          _menuItem(
            context,
            icon: Icons.source_outlined,
            label: '开源许可',
            onTap: () => _showSnack(context),
          ),
          _menuItem(
            context,
            icon: Icons.system_update_outlined,
            label: '检查更新',
            onTap: () => _showSnack(context),
          ),

          const Spacer(),

          // Copyright
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Text(
              'Copyright 2026 Pteromyini\nAll Rights Reserved',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade400, size: 22),
      title: Text(label, style: const TextStyle(fontSize: 15)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 20),
      onTap: onTap,
    );
  }
}
