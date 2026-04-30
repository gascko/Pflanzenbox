class Plant {
  final String plantId;
  String commonName;
  String slug;
  String genus;
  String scientificName;
  String previewImage;
  List<String> images;
  String bibliography;
  String author;
  String familyCommonName;
  String family;
  String observations;
  bool vegetable;
  bool edible;
  String status;

  Plant({
    required this.plantId,
    this.commonName = "N/A",
    this.slug = "N/A",
    this.genus = "N/A",
    this.scientificName = "N/A",
    this.previewImage = "",
    this.images = const [],
    this.bibliography = "N/A",
    this.author = "N/A",
    this.family = "N/A",
    this.familyCommonName = "N/A",
    this.observations = "N/A",
    this.vegetable = false,
    this.status = "",
    this.edible = false,
  });
}