import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'persona_model.dart';

class PersonaService {
  static const _personasKey = 'personas';

  Future<void> savePersonas(List<Persona> personas) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> personasJson =
    personas.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(_personasKey, personasJson);
  }

  Future<List<Persona>> loadPersonas() async {
    final prefs = await SharedPreferences.getInstance();
    final personasJson = prefs.getStringList(_personasKey);
    if (personasJson == null) {
      return [];
    }
    return personasJson
        .map((jsonString) => Persona.fromJson(jsonDecode(jsonString)))
        .toList();
  }
}
