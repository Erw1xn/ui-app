import 'package:flutter/material.dart';
import 'persona_edit_screen.dart';
import 'persona_model.dart';
import 'persona_service.dart';

class PersonaListScreen extends StatefulWidget {
  const PersonaListScreen({super.key});

  @override
  _PersonaListScreenState createState() => _PersonaListScreenState();
}

class _PersonaListScreenState extends State<PersonaListScreen> {
  final PersonaService _personaService = PersonaService();
  List<Persona> _personas = [];

  @override
  void initState() {
    super.initState();
    _loadPersonas();
  }

  Future<void> _loadPersonas() async {
    final personas = await _personaService.loadPersonas();
    setState(() {
      _personas = personas;
    });
  }

  void _savePersona(Persona persona) {
    final index = _personas.indexWhere((p) => p.id == persona.id);
    setState(() {
      if (index != -1) {
        _personas[index] = persona; // Update existing
      } else {
        _personas.add(persona); // Add new
      }
    });
    _personaService.savePersonas(_personas);
  }

  void _deletePersona(String id) {
    setState(() {
      _personas.removeWhere((p) => p.id == id);
    });
    _personaService.savePersonas(_personas);
  }

  // This method navigates to the screen where the user actually types the persona details
  void _navigateAndEditPersona({Persona? persona}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PersonaEditScreen(
          persona: persona,
          onSave: _savePersona,
        ),
      ),
    );
    // After returning from the edit screen, reload the personas
    // to ensure the list is up-to-date.
    _loadPersonas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Persona'),
        // The "+" button from the actions has been REMOVED.
      ),
      body: ListView.builder(
        // The item count is now the number of personas + 1 for the add button.
        itemCount: _personas.length + 1,
        itemBuilder: (context, index) {
          // If the index is the last item, show the "Add Persona" button.
          if (index == _personas.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add New Persona'),
                onPressed: () => _navigateAndEditPersona(), // This opens the edit screen
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          // Otherwise, build the persona tile as before.
          final persona = _personas[index];
          return ListTile(
            title: Text(persona.name),
            subtitle: Text(persona.prompt, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () {
              // You can define what happens when a user selects a persona here.
              // For now, we'll just go to the edit screen.
              _navigateAndEditPersona(persona: persona);
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deletePersona(persona.id),
            ),
          );
        },
      ),
    );
  }
}
