import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/chat_message.dart';
import '../services/gemini_service.dart';
import '../services/chat_history_service.dart';
import 'expert_selection_screen.dart'; // This should be correct now
import 'conversation_list_screen.dart';

class ChatScreen extends StatefulWidget {
  final Expert expert;

  const ChatScreen({super.key, required this.expert});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<ChatMessage> _currentMessages = [];
  bool _isLoading = false;
  bool _isNewSession = true;

  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initVoice();
  }

  void _initVoice() async {
    await Permission.microphone.request();
    await _speechToText.initialize();
  }

  void _viewHistory() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ConversationListScreen(expertName: widget.expert.name),
    ));
  }

  void _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  void _startListening() async {
    if (await _speechToText.initialize()) {
      setState(() => _isListening = true);
      _speechToText.listen(onResult: (result) {
        _controller.text = result.recognizedWords;
      });
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    if (_isNewSession) {
      ChatHistoryService.startNewConversation(widget.expert.name);
      _isNewSession = false;
    }

    final userMessage = ChatMessage(role: 'user', text: _controller.text, timestamp: DateTime.now());
    setState(() {
      _currentMessages.add(userMessage);
      _isLoading = true;
    });

    ChatHistoryService.addMessage(widget.expert.name, userMessage);
    _controller.clear();

    final allConversations = ChatHistoryService.getConversations(widget.expert.name);
    final flattenedHistory = allConversations.expand((list) => list).toList();

    final response = await GeminiService.sendMultiTurnMessage(
      conversationHistory: flattenedHistory,
      systemPrompt: widget.expert.systemPrompt,
    );

    final modelMessage = ChatMessage(role: 'model', text: response, timestamp: DateTime.now());
    ChatHistoryService.addMessage(widget.expert.name, modelMessage);

    setState(() {
      _currentMessages.add(modelMessage);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasHistory = ChatHistoryService.hasHistory(widget.expert.name);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.expert.emoji} ${widget.expert.name}'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_edu_outlined),
            tooltip: 'View Conversation History',
            onPressed: hasHistory ? _viewHistory : null,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _currentMessages.length,
              itemBuilder: (context, index) {
                final message = _currentMessages[_currentMessages.length - 1 - index];
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            message.text,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        if (!isUser)
                          IconButton(
                            icon: const Icon(Icons.volume_up, color: Colors.white70, size: 20),
                            onPressed: () => _speak(message.text),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    // ✨ THIS IS THE FIX ✨
                    // This forces the typed text to be black, making it visible.
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Ask ${widget.expert.name}...',
                      // You can also make the hint text darker if you want
                      hintStyle: const TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                  onPressed: _sendMessage,
                ),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                  color: _isListening ? Colors.red : Theme.of(context).primaryColor,
                  onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _speechToText.stop();
    _flutterTts.stop();
    _controller.dispose();
    super.dispose();
  }
}
