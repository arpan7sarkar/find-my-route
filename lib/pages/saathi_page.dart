import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class SaathiPage extends StatefulWidget {
  const SaathiPage({super.key});

  @override
  SaathiPageState createState() => SaathiPageState();
}

class SaathiPageState extends State<SaathiPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'isAI': true, 'message': 'Hey, Team HexaNova', 'subtitle': 'How Can I Help You?'},
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Dispose method is already defined above // This comment is now redundant

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Find My Route'),
      backgroundColor: Color(0xFFE3F2FD), // Light blue background
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // AI Welcome Message
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Text(
                          'Hey, Team HexaNova',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'How Can I Help You?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Additional messages if any
                  if (_messages.length > 1)
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _messages.length - 1,
                        itemBuilder: (context, index) {
                          final message = _messages[index + 1];
                          return _buildMessageBubble(message);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Message input area
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Microphone button
                Container(
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // child: IconButton(
                  //   // icon: Icon(Icons.mic, color: Colors.blue[600], size: 20),
                  //   onPressed: () {
                  //     // Handle voice input
                  //   },
                  // ),
                ),

                // Message input field
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask Saathi AI',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),

                // Send button
                Container(
                  margin: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: () {
                      if (_messageController.text.trim().isNotEmpty) {
                        _sendMessage(_messageController.text);
                        _messageController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message['isAI'] == true
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Avatar (left side)
          if (message['isAI'] == true)
            Container(
              margin: EdgeInsets.only(right: 8, top: 4),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue,
                child: Icon(Icons.smart_toy, size: 18, color: Colors.white),
              ),
            ),

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                message['message'],
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          ),

          // User Avatar (right side)
          if (message['isAI'] != true)
            Container(
              margin: EdgeInsets.only(left: 8, top: 4),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 18, color: Colors.grey[600]),
              ),
            ),
        ],
      ),
    );
  }

  void _sendMessage(String message) {
    setState(() {
      // Add user message
      _messages.add({'isAI': false, 'message': message});

      // Simulate AI response
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          _messages.add({'isAI': true, 'message': _getAIResponse(message)});
        });
      });
    });
  }

  String _getAIResponse(String userMessage) {
    // Simple AI responses for route-related queries
    if (userMessage.toLowerCase().contains('route') ||
        userMessage.toLowerCase().contains('direction')) {
      return 'I can help you find the best route! Could you please tell me your starting point and destination?';
    } else if (userMessage.toLowerCase().contains('bus')) {
      return 'I have information about bus routes in Kolkata. Which area are you traveling from and to?';
    } else if (userMessage.toLowerCase().contains('metro')) {
      return 'The Kolkata Metro has several lines. Let me know your source and destination stations.';
    } else if (userMessage.toLowerCase().contains('traffic')) {
      return 'I can provide current traffic updates. Which route are you planning to take?';
    } else {
      return 'I\'m Saathi, your travel assistant! I can help you with routes, directions, traffic updates, and transportation options in Kolkata. What would you like to know?';
    }
  }
}
