import 'package:flutter/material.dart';
import 'package:pteromyini_clone/models/song.dart';

/// A reusable music item tile showing song title, artist, source badge,
/// like button, and a more-options button.
class MusicItemTile extends StatelessWidget {
  final Song song;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onMore;
  final bool isLiked;
  final int? index;

  const MusicItemTile({
    super.key,
    required this.song,
    this.onTap,
    this.onLike,
    this.onMore,
    this.isLiked = false,
    this.index,
  });

  Color _sourceColor(String source) {
    switch (source) {
      case 'netease':
        return const Color(0xFFE72D2C);
      case 'kuwo':
        return const Color(0xFF2BA3F5);
      case 'qq':
        return const Color(0xFF31C27C);
      case 'kugou':
        return const Color(0xFF1EC878);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Track number
            if (index != null)
              SizedBox(
                width: 28,
                child: Text(
                  '$index',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 14,
                  ),
                ),
              ),
            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      // Source badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: _sourceColor(song.source).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          song.sourceLabel,
                          style: TextStyle(
                            color: _sourceColor(song.source),
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          song.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Like button
            IconButton(
              onPressed: onLike,
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? const Color(0xFF1EC878) : Colors.white38,
                size: 22,
              ),
            ),
            // More button
            IconButton(
              onPressed: onMore,
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white38,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
