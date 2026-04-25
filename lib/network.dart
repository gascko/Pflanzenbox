import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'objects.dart';
import 'storage.dart' show loadApiKey;

Future<List <Plant>> searchPlants(String searchTerm) async {
  String apiKey = await loadApiKey();
  List<Plant> plantList = [];
  final response = await http.get(
    Uri.parse('https://trefle.io/api/v1/plants/search?token=$apiKey&filter[common_name,id,scientific_name,image_url]&q=$searchTerm&page=1'),
    headers: {'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    final trefleData = jsonDecode(response.body) as Map;
    for (int i = 0; i < 10; i++) {
      Plant newPlant = Plant(id: trefleData['data'][i]['id'].toString(), commonName: trefleData['data'][i]['common_name'], scientificName: trefleData['data'][i]['scientific_name'], imageUrl: trefleData['data'][i]['image_url'] ?? "");
      plantList.add(newPlant);
    }
    return plantList;
  }
  else {
    throw Exception('Failed to load Plants from Trefle');
  }
}

Future<Plant> searchPlant(String plantId) async {
  String apiKey = await loadApiKey();
  final response = await http.get(
    Uri.parse('https://trefle.io/api/v1/plants/$plantId?token=$apiKey'),
    headers: {'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    final trefleData = jsonDecode(response.body) as Map;
    var values = ['slug', 'scientific_name', 'year', 'author', 'bibliography', 'family_common_name', 'genus_id', 'observations', 'vegetable'];
    Plant newPlant = Plant(id: trefleData['data']['id'].toString(), commonName: trefleData['data']['common_name'], scientificName: trefleData['data']['scientific_name'], imageUrl: trefleData['data']['image_url'] ?? "");
    Map data = trefleData['data'] as Map;
    for (final key in data.keys) {
      if (values.contains(key)) {
        if (trefleData['data'][key] == null) {
          continue;
        }
        newPlant.plantData[key] = {'value' : '', 'name' : ''};
        newPlant.plantData[key]['value'] = trefleData['data'][key].toString();
        newPlant.plantData[key]['name'] = key.replaceAll('_', ' ').toUpperCase();
      }
    }
    return newPlant;
  }
  else {
    throw Exception('Failed to load Plants from Trefle');
  }
}