// lib/screens/conversation_list_screen.dart

import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/chat_history_service.dart';

// A new screen to display a list of past conversations for an expert.
class ConversationListScreen extends StatelessWidget {
  final String expertName;

  const ConversationListScreen({super.key, required this.expertName});

  @override
  Widget build(BuildContext context) {
    // Get all conversation sessions for the expert.
    final conversations = ChatHistoryService.getConversations(expertName);

    return Scaffold(
      appBar: AppBar(
        title: Text('$expertName - History'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          // Show a summary of the conversation.
          final summary = conversation.isNotEmpty ? conversation.first.text : 'Empty Conversation';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text('Conversation ${index + 1}'),
              subtitle: Text(summary, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // When tapped, navigate to a read-only view of that specific conversation.
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReadOnlyChatView(
                    messages: conversation,
                    expertName: expertName,
                  ),
                ));
              },
            ),
          );
        },
      ),
    );
  }
}

// A simple, read-only widget to display the messages of a selected conversation.
class ReadOnlyChatView extends StatelessWidget {
  final List<ChatMessage> messages;
  final String expertName;

  const ReadOnlyChatView({super.key, required this.messages, required this.expertName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$expertName - Session'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          final isUser = message.role == 'user';
          return Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue : Colors.grey[700],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(message.text, style: const TextStyle(color: Colors.white)),
            ),
          );
        },
      ),
    );
  }
}
