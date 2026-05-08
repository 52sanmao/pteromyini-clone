import 'package:flutter/material.dart';
import '../models/song.dart';

enum PlayMode { sequence, shuffle, single }

class PlayerProvider extends ChangeNotifier {
  Song? _currentSong;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  PlayMode _playMode = PlayMode.sequence;
  List<Song> _playlist = [];
  int _currentIndex = -1;
  bool _showFullPlayer = false;

  // Demo data
  static final List<Song> demoSongs = [
    const Song(
      id: '1',
      title: '夜曲',
      artist: '周杰伦',
      album: '十一月的萧邦',
      coverUrl: '',
      duration: Duration(minutes: 4, seconds: 35),
      source: 'netease',
    ),
    const Song(
      id: '2',
      title: '起风了',
      artist: '买辣椒也用券',
      album: '起风了',
      coverUrl: '',
      duration: Duration(minutes: 5, seconds: 14),
      source: 'kuwo',
    ),
    const Song(
      id: '3',
      title: '孤勇者',
      artist: '陈奕迅',
      album: '孤勇者',
      coverUrl: '',
      duration: Duration(minutes: 4, seconds: 16),
      source: 'qq',
    ),
    const Song(
      id: '4',
      title: '稻香',
      artist: '周杰伦',
      album: '魔杰座',
      coverUrl: '',
      duration: Duration(minutes: 3, seconds: 43),
      source: 'kugou',
    ),
    const Song(
      id: '5',
      title: '光年之外',
      artist: '邓紫棋',
      album: '光年之外',
      coverUrl: '',
      duration: Duration(minutes: 3, seconds: 56),
      source: 'netease',
    ),
    const Song(
      id: '6',
      title: '平凡之路',
      artist: '朴树',
      album: '猎户星座',
      coverUrl: '',
      duration: Duration(minutes: 4, seconds: 46),
      source: 'kuwo',
    ),
    const Song(
      id: '7',
      title: '晴天',
      artist: '周杰伦',
      album: '叶惠美',
      coverUrl: '',
      duration: Duration(minutes: 4, seconds: 29),
      source: 'netease',
    ),
    const Song(
      id: '8',
      title: '海阔天空',
      artist: 'Beyond',
      album: '乐与怒',
      coverUrl: '',
      duration: Duration(minutes: 5, seconds: 24),
      source: 'qq',
    ),
  ];

  static final List<Playlist> demoPlaylists = [
    Playlist(
      id: 'p1',
      name: '华语经典',
      coverUrl: '',
      creator: '官方推荐',
      songs: demoSongs.sublist(0, 4),
    ),
    Playlist(
      id: 'p2',
      name: '今日热门',
      coverUrl: '',
      creator: '官方推荐',
      songs: demoSongs.sublist(2, 6),
    ),
    Playlist(
      id: 'p3',
      name: '安静听歌',
      coverUrl: '',
      creator: '官方推荐',
      songs: demoSongs.sublist(4, 8),
    ),
    Playlist(
      id: 'p4',
      name: '周杰伦精选',
      coverUrl: '',
      creator: '粉丝整理',
      songs: [demoSongs[0], demoSongs[3], demoSongs[6]],
    ),
  ];

  static final List<Playlist> recommendPlaylists = [
    Playlist(
      id: 'r1',
      name: '每日推荐',
      coverUrl: '',
      creator: '根据你的喜好生成',
      songs: demoSongs,
    ),
    Playlist(
      id: 'r2',
      name: '新歌速递',
      coverUrl: '',
      creator: '最新发行',
      songs: demoSongs.reversed.toList(),
    ),
    Playlist(
      id: 'r3',
      name: '经典老歌',
      coverUrl: '',
      creator: '怀旧金曲',
      songs: demoSongs.sublist(0, 5),
    ),
  ];

  // Getters
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  PlayMode get playMode => _playMode;
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  bool get showFullPlayer => _showFullPlayer;
  bool get hasSong => _currentSong != null;

  void play(Song song, {List<Song>? playlist, int? index}) {
    _currentSong = song;
    _isPlaying = true;
    _position = Duration.zero;
    _duration = song.duration;
    if (playlist != null) {
      _playlist = playlist;
      _currentIndex = index ?? playlist.indexOf(song);
    }
    notifyListeners();
  }

  void togglePlay() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void seek(Duration position) {
    _position = position;
    notifyListeners();
  }

  void next() {
    if (_playlist.isEmpty) return;
    if (_playMode == PlayMode.shuffle) {
      _currentIndex =
          (_currentIndex + 1 + (_playlist.length ~/ 3)) % _playlist.length;
    } else {
      _currentIndex = (_currentIndex + 1) % _playlist.length;
    }
    _currentSong = _playlist[_currentIndex];
    _position = Duration.zero;
    _duration = _currentSong!.duration;
    notifyListeners();
  }

  void previous() {
    if (_playlist.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    _currentSong = _playlist[_currentIndex];
    _position = Duration.zero;
    _duration = _currentSong!.duration;
    notifyListeners();
  }

  void togglePlayMode() {
    final modes = PlayMode.values;
    _playMode = modes[(_playMode.index + 1) % modes.length];
    notifyListeners();
  }

  void showPlayer() {
    _showFullPlayer = true;
    notifyListeners();
  }

  void hidePlayer() {
    _showFullPlayer = false;
    notifyListeners();
  }

  // Simulate playback progress
  void simulateProgress() {
    if (!_isPlaying) return;
    _position += const Duration(seconds: 1);
    if (_position >= _duration) {
      next();
    }
    notifyListeners();
  }

  IconData get playModeIcon {
    switch (_playMode) {
      case PlayMode.sequence:
        return Icons.repeat;
      case PlayMode.shuffle:
        return Icons.shuffle;
      case PlayMode.single:
        return Icons.repeat_one;
    }
  }

  String get playModeLabel {
    switch (_playMode) {
      case PlayMode.sequence:
        return '顺序播放';
      case PlayMode.shuffle:
        return '随机播放';
      case PlayMode.single:
        return '单曲循环';
    }
  }
}
