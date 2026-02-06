// lib/services/chat_history_service.dart

import '../models/chat_message.dart';

class ChatHistoryService {
  // ✨ --- DATA STRUCTURE CHANGE --- ✨
  // We now store a list of conversations for each expert.
  // Each conversation is a List<ChatMessage>.
  static final Map<String, List<List<ChatMessage>>> _history = {};

  /// Returns the list of all conversation sessions for an expert.
  /// Each item in the list is a separate conversation.
  static List<List<ChatMessage>> getConversations(String expertName) {
    return _history[expertName] ?? [];
  }

  /// Starts a new, empty conversation session for an expert.
  /// This is the key to separating conversations.
  static void startNewConversation(String expertName) {
    // Ensure the expert has an entry in the map.
    if (_history[expertName] == null) {
      _history[expertName] = [];
    }
    // Add a new empty list, which represents a new session.
    _history[expertName]!.add([]);
  }

  /// Adds a message to the most recent conversation session.
  static void addMessage(String expertName, ChatMessage message) {
    // If no conversations exist for this expert, or if the last one is somehow invalid, start a new one.
    if (_history[expertName] == null || _history[expertName]!.isEmpty) {
      startNewConversation(expertName);
    }
    // Add the message to the last (which is the current) conversation list.
    _history[expertName]!.last.add(message);
  }

  /// Checks if there is any history at all for an expert.
  static bool hasHistory(String expertName) {
    // History exists if the expert has a key and their list of conversations is not empty.
    return _history.containsKey(expertName) && _history[expertName]!.isNotEmpty;
  }
}
