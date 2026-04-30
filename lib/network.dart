import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'objects.dart';
import 'storage.dart' show loadApiKey;

Future<({List<Plant> plants, int totalPages})> searchPlants(String searchTerm, int page) async {
  String apiKey = await loadApiKey();
  List<Plant> plantList = [];
  final response = await http.get(
    Uri.parse('https://trefle.io/api/v1/plants/search?token=$apiKey&q=$searchTerm&page=$page'),
    headers: {'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    final trefleData = jsonDecode(response.body) as Map;
    for (int i = 0; i < trefleData['data'].length; i++) {
      plantList.add(
          Plant(
            plantId: trefleData['data'][i]['id'].toString(),
            commonName: trefleData['data'][i]['common_name'] ?? "N/A",
            slug: trefleData['data'][i]['slug'] ?? "N/A",
            genus: trefleData['data'][i]['genus'] ?? "N/A",
            scientificName: trefleData['data'][i]['scientific_name'] ?? "N/A",
            previewImage: trefleData['data'][i]['image_url'] ?? "",
            vegetable: trefleData['data'][i]['vegetable'] ?? false,
            status: trefleData['data'][i]['status'] ?? "N/A",
            family: trefleData['data'][i]['family'] ?? "N/A",
            familyCommonName: trefleData['data'][i]['family_common_name'] ?? "N/A",
          )
      );
    }

    return (plants: plantList, totalPages: int.parse(Uri.parse(trefleData['links']['last']).queryParameters['page'] ?? "1"));
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
    List<String> imageList = [];

    if (trefleData['data']['main_species']['images'] != null) {
      trefleData['data']['main_species']['images'].forEach((key, value) => {
        value.forEach((imageEntry) => {
          imageList.add(imageEntry['image_url'])
        })
      });
    }

    return Plant(
        plantId: trefleData['data']['id'].toString(),
        commonName: trefleData['data']['common_name'] ?? "N/A",
        slug: trefleData['data']['slug'] ?? "N/A",
        genus: trefleData['data']['genus']['name'] ?? "N/A",
        scientificName: trefleData['data']['scientific_name'] ?? "N/A",
        previewImage: trefleData['data']['image_url'] ?? "",
        images: imageList,
        bibliography: trefleData['data']['bibliography'] ?? "N/A",
        author: trefleData['data']['author'] ?? "N/A",
        status: trefleData['data']['status'] ?? "N/A",
        edible: trefleData['data']['main_species']['edible'] ?? false,
        familyCommonName: trefleData['data']['main_species']['family_common_name'] ?? "N/A",
        observations: trefleData['data']['observations'] ?? "N/A",
        vegetable: trefleData['data']['vegetable'] ?? false,
    );
  }
  else {
    throw Exception('Failed to load Plant from Trefle');
  }
}