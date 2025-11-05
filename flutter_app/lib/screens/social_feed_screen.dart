import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/advanced_animation_service.dart';
import '../services/realtime_service.dart';

/// Social media feed with posts, stories, likes, comments
class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  final RealTimeService _realTimeService = RealTimeService();
  
  final List<Post> _posts = [
    Post(
      username: 'CharityHero',
      avatar: '🦸',
      content: 'Just donated 2 ETH to help flood victims! Every bit counts. 💙',
      likes: 342,
      comments: 45,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      image: '🌊',
    ),
    Post(
      username: 'CryptoGiver',
      avatar: '🎁',
      content: 'Matching all donations today up to 10 ETH! Let\'s make a difference together! 🚀',
      likes: 891,
      comments: 127,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Post(
      username: 'BlockchainForGood',
      avatar: '⛓️',
      content: 'Transparency update: 97% of funds reached beneficiaries this month! 📊',
      likes: 1245,
      comments: 203,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      image: '📈',
    ),
  ];

  final List<Story> _stories = [
    Story(username: 'You', avatar: '👤', viewed: false),
    Story(username: 'CharityHero', avatar: '🦸', viewed: false),
    Story(username: 'CryptoGiver', avatar: '🎁', viewed: true),
    Story(username: 'ImpactDAO', avatar: '🌟', viewed: false),
  ];

  @override
  void initState() {
    super.initState();
    _realTimeService.initialize();
    
    // Listen to real-time social posts
    _realTimeService.socialStream.listen((post) {
      if (mounted) {
        setState(() {
          _posts.insert(0, Post(
            username: post.username,
            avatar: post.avatar,
            content: post.content,
            likes: post.likes,
            comments: post.comments,
            timestamp: post.timestamp,
          ));
        });
      }
    });
  }

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
          'Social Feed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Stories
          _buildStories(),

          // Posts Feed
          Expanded(
            child: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return _buildPost(_posts[index], index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFe11d48),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStories() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _stories.length,
        itemBuilder: (context, index) {
          final story = _stories[index];
          return _buildStoryItem(story, index);
        },
      ),
    );
  }

  Widget _buildStoryItem(Story story, int index) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 70,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: story.viewed
                    ? null
                    : const LinearGradient(
                        colors: [Color(0xFFe11d48), Color(0xFF7c3aed)],
                      ),
                border: story.viewed
                    ? Border.all(color: Colors.grey, width: 2)
                    : null,
              ),
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF0a0a0a),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(story.avatar, style: const TextStyle(fontSize: 28)),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              story.username,
              style: const TextStyle(color: Colors.white, fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).scale(delay: (index * 50).ms);
  }

  Widget _buildPost(Post post, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7c3aed).withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(post.avatar, style: const TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatTimestamp(post.timestamp),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              post.content,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),

          // Image if exists
          if (post.image != null)
            Container(
              margin: const EdgeInsets.all(12),
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF7c3aed).withOpacity(0.3),
                    const Color(0xFFe11d48).withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(post.image!, style: const TextStyle(fontSize: 80)),
              ),
            ),

          // Actions
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                AdvancedAnimationService.pulse(
                  child: _buildActionButton(Icons.favorite_border, post.likes),
                ),
                const SizedBox(width: 20),
                _buildActionButton(Icons.chat_bubble_outline, post.comments),
                const SizedBox(width: 20),
                _buildActionButton(Icons.share, null),
                const Spacer(),
                _buildActionButton(Icons.bookmark_border, null),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildActionButton(IconData icon, int? count) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          if (count != null) ...[
            const SizedBox(width: 6),
            Text(
              count > 1000 ? '${(count / 1000).toStringAsFixed(1)}K' : '$count',
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class Post {
  final String username;
  final String avatar;
  final String content;
  final int likes;
  final int comments;
  final DateTime timestamp;
  final String? image;

  Post({
    required this.username,
    required this.avatar,
    required this.content,
    required this.likes,
    required this.comments,
    required this.timestamp,
    this.image,
  });
}

class Story {
  final String username;
  final String avatar;
  final bool viewed;

  Story({required this.username, required this.avatar, required this.viewed});
}
