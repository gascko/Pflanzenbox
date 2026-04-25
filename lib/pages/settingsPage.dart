import 'package:flutter/material.dart';
import '../variables.dart';
import '../storage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
        body:
        Padding(padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Erscheinungsbild", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const Center(child: ModeRadioSwitch()),
                SizedBox(height: 20),
                Text("Treffle API", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ApiKeyTextField(),
              ],
            )
        )
    );
  }
}

class ModeRadioSwitch extends StatefulWidget {
  const ModeRadioSwitch({super.key});

  @override
  State<ModeRadioSwitch> createState() => ModeRadioSwitchState();
}

class ModeRadioSwitchState extends State<ModeRadioSwitch> {

  ThemeMode? mode = themeNotifier.mode;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<ThemeMode>(
      groupValue: mode,
      onChanged: (ThemeMode? value) {
        themeNotifier.setMode(value ?? ThemeMode.system);
        setState(() {
          mode = value;
        });
      },
      child: const Column(
        children: <Widget>[
          ListTile(
            title: Text('Light'),
            leading: Radio<ThemeMode>(value: ThemeMode.light),
          ),
          ListTile(
            title: Text('Dark'),
            leading: Radio<ThemeMode>(value: ThemeMode.dark),
          ),
          ListTile(
            title: Text('System'),
            leading: Radio<ThemeMode>(value: ThemeMode.system),
          ),
        ],
      ),
    );
  }
}

class ApiKeyTextField extends StatefulWidget {
  const ApiKeyTextField({super.key});

  @override
  State<ApiKeyTextField> createState() => ApiKeyTextFieldState();
}

class ApiKeyTextFieldState extends State<ApiKeyTextField> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      onSubmitted: (value) => setApiKey(value.trim()),
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.clear),
        labelText: 'Your Treffle API-KEY',
        border: OutlineInputBorder(),
      ),
    );
  }
}