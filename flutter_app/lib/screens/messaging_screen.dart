import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// WhatsApp-style messaging with conversations
class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final List<ChatConversation> _conversations = [
    ChatConversation(
      name: 'CharityHero',
      avatar: '🦸',
      lastMessage: 'Thanks for your donation!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      unread: 2,
      online: true,
    ),
    ChatConversation(
      name: 'Impact DAO',
      avatar: '🌟',
      lastMessage: 'New campaign launched!',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      unread: 0,
      online: false,
    ),
    ChatConversation(
      name: 'Crypto Giver',
      avatar: '🎁',
      lastMessage: 'Let\'s collaborate on this',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      unread: 1,
      online: true,
    ),
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
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _conversations.length,
        itemBuilder: (context, index) {
          return _buildChatItem(_conversations[index], index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF10b981),
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildChatItem(ChatConversation chat, int index) {
    return GestureDetector(
      onTap: () => _openChat(chat),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10b981).withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(chat.avatar, style: const TextStyle(fontSize: 28)),
                  ),
                ),
                if (chat.online)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF0a0a0a), width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: chat.unread > 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      Text(
                        _formatTime(chat.timestamp),
                        style: TextStyle(
                          color: chat.unread > 0
                              ? const Color(0xFF10b981)
                              : Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.unread > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF10b981),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${chat.unread}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: -0.2, end: 0);
  }

  void _openChat(ChatConversation chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(conversation: chat),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d';
  }
}

class ChatDetailScreen extends StatefulWidget {
  final ChatConversation conversation;

  const ChatDetailScreen({super.key, required this.conversation});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hey! Thanks for your donation!',
      isSent: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    ChatMessage(
      text: 'You\'re welcome! Happy to help.',
      isSent: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
    ),
    ChatMessage(
      text: 'Your contribution will make a real difference',
      isSent: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a1a),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10b981).withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(widget.conversation.avatar,
                        style: const TextStyle(fontSize: 20)),
                  ),
                ),
                if (widget.conversation.online)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF1a1a1a), width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.conversation.name,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  widget.conversation.online ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[_messages.length - 1 - index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          gradient: message.isSent
              ? const LinearGradient(
                  colors: [Color(0xFF10b981), Color(0xFF059669)],
                )
              : null,
          color: message.isSent ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              _formatMessageTime(message.timestamp),
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: message.isSent ? 0.2 : -0.2, end: 0);
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF10b981), Color(0xFF059669)],
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (_messageController.text.isNotEmpty) {
                  setState(() {
                    _messages.add(ChatMessage(
                      text: _messageController.text,
                      isSent: true,
                      timestamp: DateTime.now(),
                    ));
                    _messageController.clear();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class ChatConversation {
  final String name;
  final String avatar;
  final String lastMessage;
  final DateTime timestamp;
  final int unread;
  final bool online;

  ChatConversation({
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.timestamp,
    required this.unread,
    required this.online,
  });
}

class ChatMessage {
  final String text;
  final bool isSent;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isSent,
    required this.timestamp,
  });
}
