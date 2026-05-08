import 'package:flutter/material.dart';

/// A utility for showing styled toast messages (snackbars) in a dark-themed app.
class CustomToast {
  CustomToast._();

  /// Shows a green success toast.
  static void success(BuildContext context, String message) {
    _show(context, message, const Color(0xFF1EC878), Icons.check_circle);
  }

  /// Shows a red error toast.
  static void error(BuildContext context, String message) {
    _show(context, message, const Color(0xFFE74C3C), Icons.error);
  }

  /// Shows a neutral info toast.
  static void info(BuildContext context, String message) {
    _show(context, message, const Color(0xFF3498DB), Icons.info);
  }

  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
