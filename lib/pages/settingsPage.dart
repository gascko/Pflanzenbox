import 'package:flutter/material.dart';
import '../storage.dart' show clearPlants;

class settingsPage extends StatelessWidget {
  const settingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Settings ⚙️", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
        body: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Text("Light-/ Darkmode", style: TextStyle(fontSize: 10)),
                modeSwitch()
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                //apiTextField()
              ],
            ),
            SizedBox(height: 20),
            clearLocalPlantStorageButton(),
          ],
        )
      );
  }
}

class modeSwitch extends StatefulWidget {
  const modeSwitch({super.key});

  @override
  State<modeSwitch> createState() => modeSwitchState();
}

class modeSwitchState extends State<modeSwitch> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: light,
      activeThumbColor: Colors.red,
      onChanged: (bool value) {
        setState(() {
          light = value;
        });
      },
    );
  }
}

class apiTextField extends StatelessWidget {
  const apiTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: Icon(Icons.clear),
        labelText: 'API KEY',
        hintText: 'Enter your Treffle API KEY',
        helperText: 'You can get your API KEY on treffle',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class clearLocalPlantStorageButton extends StatefulWidget {
  const clearLocalPlantStorageButton({super.key});

  @override
  State<clearLocalPlantStorageButton> createState() => clearLocalPlantStorageButtonState();
}

class clearLocalPlantStorageButtonState extends State<clearLocalPlantStorageButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {clearPlants();},
      shape: null,
      child: const Icon(Icons.delete),
    );
  }
}