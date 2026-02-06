import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'persona_model.dart';

class PersonaEditScreen extends StatefulWidget {
  final Persona? persona;
  final Function(Persona) onSave;

  const PersonaEditScreen({super.key, this.persona, required this.onSave});

  @override
  _PersonaEditScreenState createState() => _PersonaEditScreenState();
}

class _PersonaEditScreenState extends State<PersonaEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _promptController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.persona?.name ?? '');
    _descriptionController = TextEditingController(text: widget.persona?.description ?? '');
    _promptController = TextEditingController(text: widget.persona?.prompt ?? '');
  }

  void _savePersona() {
    if (_formKey.currentState!.validate()) {
      final persona = Persona(
        id: widget.persona?.id ?? const Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text,
        prompt: _promptController.text,
        // Provide default icon and emoji for custom personas
        icon: widget.persona?.icon ?? Icons.person,
        emoji: widget.persona?.emoji ?? '👤',
      );
      widget.onSave(persona);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.persona == null ? 'Create Persona' : 'Edit Persona'),
        backgroundColor: Colors.blueGrey[900],
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _savePersona)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView( // Use ListView to prevent overflow on small screens
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Persona Name', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Short Description', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _promptController,
                decoration: const InputDecoration(labelText: 'System Prompt', hintText: 'e.g., You are a helpful assistant.', border: OutlineInputBorder()),
                maxLines: 8,
                validator: (v) => (v == null || v.isEmpty) ? 'Please enter a prompt' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
