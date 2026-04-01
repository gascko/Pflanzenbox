import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'objects.dart' show previewPlant, Plant;

Future<List <previewPlant>> searchPlants(String searchTerm) async {
  List<previewPlant> plantList = [];
  final response = await http.get(
    Uri.parse('https://trefle.io/api/v1/plants/search?token=***REMOVED***&q=$searchTerm&page=1'),
    headers: {'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    final trefleData = jsonDecode(response.body);
    for (int i = 0; i < 10; i++) {
      previewPlant newPreviewPlant = previewPlant(
          id:(trefleData['data'][i]['id']).toInt(),
          commonName: trefleData['data'][i]['common_name'] ?? "",
          family: trefleData['data'][i]['family'] ?? "",
          genus: trefleData['data'][i]['genus'] ?? "",
          imageUrl: trefleData['data'][i]['image_url'] ?? "",
          scientificName: trefleData['data'][i]['scientific_name'] ?? ""
      );
      plantList.add(newPreviewPlant);
    }
    return plantList;
  }
  else {
    throw Exception('Failed to load Plants from Trefle');
  }
}

Future<Plant> searchPlant(int plantId) async {
  final response = await http.get(
    Uri.parse('https://trefle.io/api/v1/plants/$plantId?token=***REMOVED***'),
    headers: {'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    final trefleData = jsonDecode(response.body);
    Plant newPlant = Plant(
      id: (trefleData['data']['id']).toInt(),
      commonName: trefleData['data']['common_name'] ?? "",
      scientificName: trefleData['data']['scientific_name'] ?? "",
      imageUrl: trefleData['data']['image_url'],
      year: (trefleData['data']['year']).toInt(),
      familyCommonName: trefleData['data']['family']['common_name'] ?? "",
      familyName: trefleData['data']['family']['name'] ?? "",
      observations: trefleData['data']['observations'] ?? "",
      edible: trefleData['data']['main_species']['edible'] ?? "",
      genus: trefleData['data']['genus']['name'] ?? "",
      speciesCommonName: trefleData['data']['main_species']['common_name'] ?? "",
      speciesScientificName: trefleData['data']['main_species']['scientific_name'] ?? "",
    );
    return newPlant;
  }
  else {
    throw Exception('Failed to load Plants from Trefle');
  }
}