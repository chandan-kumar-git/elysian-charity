import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _effectPlayer = AudioPlayer();
  final AudioPlayer _bgMusicPlayer = AudioPlayer();
  
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _isInitialized = false;

  // Initialize sound service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Background music loops forever
      await _bgMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgMusicPlayer.setVolume(0.3);
      
      // Sound effects play once
      await _effectPlayer.setReleaseMode(ReleaseMode.stop);
      await _effectPlayer.setVolume(0.6);
      
      _isInitialized = true;
      
      // Don't start background music yet (browser requires user interaction)
    } catch (e) {
      print('Sound service initialization error: $e');
    }
  }

  // Play button click sound (one time only)
  Future<void> playButtonClick() async {
    if (!_soundEnabled) return;
    try {
      await _effectPlayer.stop(); // Stop previous sound
      await _effectPlayer.play(AssetSource('sounds/click.mp3'));
    } catch (e) {
      print('Click sound error: $e');
    }
  }

  // Play coin catch sound (one time only)
  Future<void> playCoinCatch() async {
    if (!_soundEnabled) return;
    try {
      // Use a separate player for coin sounds so they don't interrupt each other
      final coinPlayer = AudioPlayer();
      await coinPlayer.setReleaseMode(ReleaseMode.stop);
      await coinPlayer.setVolume(0.5);
      await coinPlayer.play(AssetSource('sounds/coin.mp3'));
      // Dispose after playing
      coinPlayer.onPlayerComplete.listen((_) {
        coinPlayer.dispose();
      });
    } catch (e) {
      print('Coin sound error: $e');
    }
  }

  // Play success sound (one time only)
  Future<void> playSuccess() async {
    if (!_soundEnabled) return;
    try {
      await _effectPlayer.stop();
      await _effectPlayer.play(AssetSource('sounds/success.mp3'));
    } catch (e) {
      print('Success sound error: $e');
    }
  }

  // Start background music (loops automatically)
  Future<void> startBackgroundMusic() async {
    if (!_musicEnabled) return;
    try {
      await _bgMusicPlayer.play(AssetSource('sounds/background.mp3'));
    } catch (e) {
      print('Background music error: $e');
    }
  }

  // Stop background music
  Future<void> stopBackgroundMusic() async {
    await _bgMusicPlayer.stop();
  }

  // Pause background music
  Future<void> pauseBackgroundMusic() async {
    await _bgMusicPlayer.pause();
  }

  // Resume background music
  Future<void> resumeBackgroundMusic() async {
    await _bgMusicPlayer.resume();
  }

  // Toggle sound effects
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }

  // Toggle background music
  void toggleMusic() {
    _musicEnabled = !_musicEnabled;
    if (_musicEnabled) {
      resumeBackgroundMusic();
    } else {
      pauseBackgroundMusic();
    }
  }

  // Dispose
  Future<void> dispose() async {
    await _effectPlayer.dispose();
    await _bgMusicPlayer.dispose();
  }

  // Getters
  bool get isSoundEnabled => _soundEnabled;
  bool get isMusicEnabled => _musicEnabled;
}
