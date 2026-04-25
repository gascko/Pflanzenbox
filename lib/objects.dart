class Plant {
  final String id;
  final String commonName;
  final String imageUrl;
  final String scientificName;
  var plantData = {};

  Plant({required this.id, required this.commonName, required this.scientificName, required this.imageUrl});
}