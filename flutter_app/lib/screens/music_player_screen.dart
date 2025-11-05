import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Music player screen with playlist
class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool _isPlaying = false;
  double _progress = 0.3;

  final List<Song> _playlist = [
    Song(name: 'Charity Anthem', artist: 'ElysianChain', duration: '3:45', cover: '🎵'),
    Song(name: 'Hope Rising', artist: 'Impact Collective', duration: '4:12', cover: '🎶'),
    Song(name: 'Together We Can', artist: 'Unity Voices', duration: '3:28', cover: '🎤'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Now Playing',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),

          // Album Art
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFec4899), Color(0xFF8b5cf6)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFec4899).withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.music_note, size: 120, color: Colors.white),
            ),
          ).animate().scale(duration: 600.ms),

          const SizedBox(height: 40),

          // Song Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Text(
                  _playlist[0].name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 8),
                Text(
                  _playlist[0].artist,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 16,
                  ),
                ).animate().fadeIn(delay: 300.ms),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                    activeTrackColor: const Color(0xFFec4899),
                    inactiveTrackColor: Colors.white.withOpacity(0.2),
                    thumbColor: const Color(0xFFec4899),
                  ),
                  child: Slider(
                    value: _progress,
                    onChanged: (value) => setState(() => _progress = value),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '1:07',
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                    ),
                    Text(
                      '3:45',
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 20),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shuffle, color: Colors.white),
                iconSize: 28,
                onPressed: () {},
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                iconSize: 40,
                onPressed: () {},
              ),
              const SizedBox(width: 20),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFec4899), Color(0xFF8b5cf6)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFec4899).withOpacity(0.4),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                  iconSize: 36,
                  onPressed: () => setState(() => _isPlaying = !_isPlaying),
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                iconSize: 40,
                onPressed: () {},
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.repeat, color: Colors.white),
                iconSize: 28,
                onPressed: () {},
              ),
            ],
          ).animate().fadeIn(delay: 500.ms).scale(delay: 500.ms),

          const Spacer(),

          // Playlist
          Container(
            height: 200,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Up Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: _playlist.length,
                    itemBuilder: (context, index) {
                      final song = _playlist[index];
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFec4899), Color(0xFF8b5cf6)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(song.cover, style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                        title: Text(
                          song.name,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        subtitle: Text(
                          song.artist,
                          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                        ),
                        trailing: Text(
                          song.duration,
                          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ).animate().slideY(begin: 0.3, end: 0, delay: 600.ms),
        ],
      ),
    );
  }
}

class Song {
  final String name;
  final String artist;
  final String duration;
  final String cover;

  Song({
    required this.name,
    required this.artist,
    required this.duration,
    required this.cover,
  });
}
