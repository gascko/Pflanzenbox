class previewPlant {
  final String id;
  final String commonName;
  final String family;
  final String genus;
  final String imageUrl;
  final String scientificName;

  const previewPlant({required this.id, required this.commonName, required this.family, required this.genus, required this.imageUrl, required this.scientificName});
  String getId() {
    return this.id;
  }
}

class Plant {
  final String id;
  final String commonName;
  final String scientificName;
  final String imageUrl;
  final int year;
  final String familyCommonName;
  final String familyName;
  final String observations;
  final bool edible;
  final String genus;
  final String speciesCommonName;
  final String speciesScientificName;

  Plant({required this.id, required this.commonName, required this.scientificName, required this.imageUrl, required this.year, required this.familyCommonName, required this.observations, required this.edible, required this.genus, required this.speciesCommonName, required this.speciesScientificName, required this.familyName});
}