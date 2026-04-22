import 'package:shared_preferences/shared_preferences.dart';
import 'variables.dart';
import 'network.dart';
import 'objects.dart' show Plant;

Future<void> loadPlants() async {
  final storage = await SharedPreferences.getInstance();
  savedPlants = storage.getStringList('savedPlants') ?? [];
  for (int i = 0; i < savedPlants.length; i++) {
    Plant newPlant = await searchPlant(int.parse(savedPlants[i]));
    savedPlantObjects.add(newPlant);
  }
  print("loaded Plants");
}

Future<void> addPlant(String plantId) async {
  final storage = await SharedPreferences.getInstance();
  savedPlants.add(plantId);
  await storage.setStringList('savedPlants', savedPlants);
  Plant newPlant = await searchPlant(int.parse(plantId));
  savedPlantObjects.add(newPlant);
  print("Saved plant");
}

Future<void> removePlant(String plantId) async {
  final storage = await SharedPreferences.getInstance();
  savedPlants.remove(plantId);
  await storage.setStringList('savedPlants', savedPlants);
  for (int i = 0; i < savedPlantObjects.length; ++i) {
    if (savedPlantObjects[i].id.toString() == plantId) {
      savedPlantObjects.removeAt(i);
    }
  }
  await storage.setStringList('savedPlants', savedPlants);
  print("removed Plant");
}

clearStorage() async {
  final storage = await SharedPreferences.getInstance();
  await storage.clear();
}

clearPlants() async {
  final storage = await SharedPreferences.getInstance();
  await storage.setStringList('savedPlants', []);
  print("cleared Plants");
}