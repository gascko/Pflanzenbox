import 'dart:async';
import 'package:flutter/material.dart';
import '../network.dart' show searchPlants;
import '../objects.dart';
import 'plantDetailsPage.dart' show PlantDetailsPage;

String searchQuery = "";
int currentPage = 1;
int maxPages = 1;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List<Plant> plantList = [];
  final ScrollController plantScrollController = ScrollController();
  bool showPageNavigation = false;

  Future<void> reloadPlantCards() async {
    final (:plants, :totalPages) = await searchPlants(searchQuery, currentPage);
    scrollToTop(context);

    setState(() {
      plantList = plants;
      maxPages = totalPages;
    });
  }

  void clearPlantCards() {
    setState(() {
      plantList.clear();
    });
  }


  void scrollToTop(BuildContext context) {
    final controller = PrimaryScrollController.of(context);
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Search", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
        body: Column(
            children: [
              Padding(padding: const EdgeInsets.all(16),
                  child: SearchTextField(onSubmitted: reloadPlantCards, onClear: clearPlantCards)),
              if (plantList.isEmpty)
                Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 4),
                    Icon(Icons.search, size: MediaQuery.of(context).size.width / 3),
                    Text("Search your favorite Plants", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
              if (plantList.isNotEmpty)
                Row(
                  children: [
                    if (currentPage > 1)
                      Expanded(
                          child: ElevatedButton(onPressed: () {
                            currentPage = 1;
                            reloadPlantCards();
                          },
                              child: const Icon(Icons.keyboard_double_arrow_left))
                      ),
                    if (currentPage > 1)
                      Expanded(
                          child: ElevatedButton(onPressed: () {
                            currentPage -= 1;
                            reloadPlantCards();
                          },
                              child: const Icon(Icons.keyboard_arrow_left))
                      ),
                    if (currentPage < maxPages)
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                  currentPage += 1;
                                  reloadPlantCards();
                              },
                              child: const Icon(Icons.keyboard_arrow_right))
                      ),
                    if (currentPage < maxPages)
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                currentPage = maxPages;
                                reloadPlantCards();
                              },
                              child: const Icon(Icons.keyboard_double_arrow_right))
                      )
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    primary: true,
                      itemCount: plantList.length,
                      itemBuilder: (context, index) {
                        return PlantCard(plant: plantList[index]);
                      }
                    )
                )
            ]
        )
    );
  }
}

class PlantCard extends StatelessWidget {
  const PlantCard({super.key, required this.plant});

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => PlantDetailsPage(plantId: plant.plantId),
        )),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
            borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 10,
                width: MediaQuery.of(context).size.width / 3,
                child: Image.network(
                  plant.previewImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Icon(Icons.broken_image, size: 64));
                  },
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plant.commonName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 3),
                  Text(plant.scientificName, style: TextStyle(fontStyle: FontStyle.italic)),
                  ]
                )
              )
            ]
          )
        )
      )
    );
  }
}

class SearchTextField extends StatelessWidget {
  final void Function() onSubmitted;
  final void Function() onClear;
  final fieldText = TextEditingController();
  SearchTextField({super.key, required this.onSubmitted, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: fieldText,
      onSubmitted: (value) => {
        searchQuery = value.trim(),
        currentPage = 1,
        onSubmitted()
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: onClear,
        ),
        hintText: 'Search for Plants',
        border: OutlineInputBorder(),
      ),
    );
  }
}