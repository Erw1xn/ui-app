import 'package:flutter/material.dart';

class Persona {
  String id; // Not final, can be updated
  String name;
  String description;
  IconData icon;
  String emoji;
  String prompt; // This was 'systemPrompt' in your Expert class

  Persona({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.emoji,
    required this.prompt,
  });

  // Convert a Persona object into a Map for saving
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    // IconData can't be directly saved, so we save its code point
    'icon': icon.codePoint,
    'emoji': emoji,
    'prompt': prompt,
  };

  // Create a Persona object from a saved Map
  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '', // Handle missing description for older data
      // Recreate the IconData from its code point
      icon: IconData(json['icon'] ?? Icons.person.codePoint, fontFamily: 'MaterialIcons'),
      emoji: json['emoji'] ?? '👤', // Handle missing emoji
      prompt: json['prompt'],
    );
  }
}
