// lib/screens/expert_selection_screen.dart

import 'package:flutter/material.dart';
import 'chat_screen.dart'; // Make sure this path is correct for your project structure

// The Expert class defines the data structure for each persona.
class Expert {
  final String name;
  final String description;
  final IconData icon;
  final String emoji;
  final String systemPrompt;

  const Expert({
    required this.name,
    required this.description,
    required this.icon,
    required this.emoji,
    required this.systemPrompt,
  });
}

// This list holds the initial set of experts.
List<Expert> initialExperts = [
  Expert(
    name: 'Plant Expert',
    description: 'Care, identification, and health',
    icon: Icons.eco,
    emoji: '🪴',
    systemPrompt: '''You are a friendly and encouraging Plant Expert.
* Your role is to specialize in house plants. This includes plant identification, care tips, and diagnosing plant health issues.
* Your tone should be patient and supportive.
* Be concise (2-4 sentences) and use plant-related emojis.
* If a question is completely unrelated to plants, politely state: "I can only help with questions about plants. Let's keep our focus on our leafy friends! 🪴"''',
  ),
  Expert(
    name: 'Fragrance Expert',
    description: 'Perfumes, colognes, and scents',
    icon: Icons.air,
    emoji: '👃',
    systemPrompt: '''You are an elegant and sophisticated Fragrance Expert.
* Your role is to specialize in the world of scents. This includes perfumes, colognes, scent notes, fragrance families, and providing recommendations.
* Your tone should be descriptive and knowledgeable.
* Be concise (2-4 sentences) and use relevant emojis.
* If a question is completely unrelated to fragrances, politely state: "I can only discuss the world of fragrances. 👃"''',
  ),
  Expert(
    name: 'Gym Expert',
    description: 'Workouts, fitness, and nutrition',
    icon: Icons.fitness_center,
    emoji: '💪',
    systemPrompt: '''You are a motivating and energetic Gym Expert.
* Your role is to specialize in fitness and exercise. This includes workout routines, exercise techniques, fitness equipment, and general nutrition for fitness.
* Your tone should be direct and encouraging.
* Be concise (2-4 sentences) and use empowering emojis.
* If a question is completely unrelated to fitness, politely state: "I'm here to help you crush your fitness goals! Let's talk workouts. 💪"''',
  ),
  Expert(
    name: 'Game Expert',
    description: 'Video games, hardware, and strategy',
    icon: Icons.gamepad,
    emoji: '🎮',
    systemPrompt: '''You are an enthusiastic and knowledgeable Game Expert.
* Your role is to specialize in video games. This includes gaming hardware (consoles, PCs), game genres, and gameplay strategies.
* Your tone should be helpful and passionate.
* Be concise (2-4 sentences) and use gaming-related emojis.
* If a question is completely unrelated to video games, politely state: "My expertise is in the world of gaming. Ask me anything about video games! 🎮"''',
  ),
  Expert(
    name: 'Coffee Expert',
    description: 'Beans, brewing, and equipment',
    icon: Icons.coffee,
    emoji: '☕',
    systemPrompt: '''You are a warm and artisanal Coffee Expert.
* Your role is to specialize in all things coffee. This includes coffee bean types, brewing methods, espresso drinks, and coffee-making equipment.
* Your tone should be detailed and welcoming.
* Be concise (2-4 sentences) and use coffee-related emojis.
* If a question is completely unrelated to coffee, politely state: "Let's talk about all things coffee. What's on your mind? ☕"''',
  ),
];

// The screen is a StatefulWidget because its content (the list of experts) can change.
class ExpertSelectionScreen extends StatefulWidget {
  const ExpertSelectionScreen({super.key});

  @override
  State<ExpertSelectionScreen> createState() => _ExpertSelectionScreenState();
}

class _ExpertSelectionScreenState extends State<ExpertSelectionScreen> {
  // The list of experts is now a state variable, initialized with the starting experts.
  final List<Expert> _experts = List.from(initialExperts);

  // This function now opens a dialog to get user input for the new expert.
  void _addNewExpert() async {
    // We 'await' for the dialog to close and see if it returned a new expert.
    final newExpert = await showDialog<Expert>(
      context: context,
      builder: (BuildContext context) {
        return const _AddExpertDialog();
      },
    );

    // If the user created an expert (i.e., didn't cancel), newExpert will not be null.
    if (newExpert != null) {
      // Calling setState() triggers a rebuild of the widget, which updates
      // the UI to show the newly added expert in the GridView.
      setState(() {
        _experts.add(newExpert);
      });

      // A SnackBar provides visual feedback that the action was successful.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${newExpert.name}" has been added!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose an Expert'),
        backgroundColor: Colors.blueGrey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create New Persona',
            onPressed: _addNewExpert, // The button now calls the updated function.
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.9,
        ),
        itemCount: _experts.length,
        itemBuilder: (context, index) {
          final expert = _experts[index];
          return Card(
            elevation: 4.0,
            color: Colors.blueGrey[700],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatScreen(expert: expert),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(expert.icon, size: 48, color: Colors.white70),
                    const SizedBox(height: 12),
                    Text(
                      expert.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      expert.description,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// A new StatefulWidget to manage the state of the input form within the dialog.
class _AddExpertDialog extends StatefulWidget {
  const _AddExpertDialog();

  @override
  State<_AddExpertDialog> createState() => _AddExpertDialogState();
}

class _AddExpertDialogState extends State<_AddExpertDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _systemPromptController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _systemPromptController.dispose();
    super.dispose();
  }

  void _createExpert() {
    // Validate the form. If it's valid, create the expert and close the dialog.
    if (_formKey.currentState!.validate()) {
      final newExpert = Expert(
        name: _nameController.text,
        description: _descriptionController.text,
        systemPrompt: _systemPromptController.text,
        // Using default values for icon and emoji for simplicity.
        // You could add fields for these in the dialog as well.
        icon: Icons.add_reaction,
        emoji: '✨',
      );
      // Pass the newly created expert back to the calling screen.
      Navigator.of(context).pop(newExpert);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Persona'),
      // Use a SingleChildScrollView to prevent overflow if the keyboard appears.
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Persona Name',
                  hintText: 'e.g., History Buff',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., An expert in world history',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _systemPromptController,
                decoration: const InputDecoration(
                  labelText: 'System Prompt',
                  hintText: 'e.g., You are a helpful history expert...',
                ),
                maxLines: 5, // Allow more space for the system prompt
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a system prompt';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            // Close the dialog without returning any data.
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: _createExpert,
          child: const Text('Create'),
        ),
      ],
    );
  }
}

