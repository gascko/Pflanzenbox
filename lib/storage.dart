import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

Future<String> loadApiKey() async {
  final storage = await SharedPreferences.getInstance();
  return storage.getString('apiKey') ?? '';
}

Future<void> setApiKey(String newApiKey) async {
  final storage = await SharedPreferences.getInstance();
  await storage.setString('apiKey', newApiKey);
}

class SavedColorSchemeModeNotifier with ChangeNotifier {
   ThemeMode themeMode = ThemeMode.system;
   ThemeMode get mode => themeMode;

   int themeModeToInt(ThemeMode mode) {
     switch(mode) {
       case ThemeMode.light:
         return 1;
       case ThemeMode.dark:
         return 2;
       case ThemeMode.system:
         return 0;
     }
   }

   ThemeMode intToThemeMode(int storageMode) {
     switch(storageMode) {
       case 1:
         return ThemeMode.light;
       case 2:
         return ThemeMode.dark;
       default:
         return ThemeMode.system;
     }
   }

  Future<void> loadMode() async {
     final storage = await SharedPreferences.getInstance();
     int storageMode = storage.getInt('themeMode') ?? 0;
     themeMode = intToThemeMode(storageMode);
     notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
     themeMode = mode;
     final storage = await SharedPreferences.getInstance();
     await storage.setInt('themeMode', themeModeToInt(mode));
     notifyListeners();
  }
}

class SavedPlantsListNotifier with ChangeNotifier {
  List<String> savedPlants = <String>[];
  List<String> get plants => savedPlants.toList();

  Future<void> addPlant(String plantId) async {
    final storage = await SharedPreferences.getInstance();
    final list = storage.getStringList('savedPlants') ?? [];

    if (!list.contains(plantId)) {
      list.add(plantId);
      await storage.setStringList('savedPlants', list);
    }
    savedPlants = list;
    notifyListeners();
    print(list);
    print(plantId);
  }

  Future<void> removePlant(String plantId) async {
    final storage = await SharedPreferences.getInstance();
    final list = storage.getStringList('savedPlants') ?? [];
    print(plantId);
    print(list);

    list.remove(plantId);
    await storage.setStringList('savedPlants', list);
    savedPlants = list;
    notifyListeners();
    print(list);
  }

  Future<void> loadPlants() async {
    final storage = await SharedPreferences.getInstance();
    savedPlants = storage.getStringList('savedPlants') ?? [];
    notifyListeners();
  }
}