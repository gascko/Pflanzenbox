import 'dart:async';
import 'package:flutter/material.dart';
import '../network.dart' show searchPlants, searchPlant;
import '../objects.dart' show Plant, previewPlant;

class searchPage extends StatefulWidget {
  const searchPage({super.key});

  @override
  State<searchPage> createState() => searchPageState();
}

class searchPageState extends State<searchPage> {
  List<previewPlant> plantList = [];

  Future<void> reloadPlantCards(String searchQuery) async {
    final plants = await searchPlants(searchQuery);

    setState(() {
      plantList = plants;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Search for Plants 🌻')),
        body: Column(
            children: [
              Padding(padding: const EdgeInsets.all(16),
                  child: Container(
                      child: SearchTextField(onSubmitted: reloadPlantCards))),
              Expanded(
                child: ListView(
                  children: [
                    for (final plant in plantList)
                      plantCard(plant: plant),
                  ],
                ),
              ),

            ]
        )
    );
  }
}

class plantDialog extends StatefulWidget {
  const plantDialog({super.key, required this.id});

  final int id;

  @override
  State<plantDialog> createState() => plantDialogState(plantId: this.id);
}

class plantDialogState extends State<plantDialog> {
  plantDialogState({required this.plantId});

  final int plantId;
  Plant? plant;

  @override
  void initState() {
    super.initState();
    loadPlant();
  }

  Future<void> loadPlant() async {
    final plant = await searchPlant(plantId);
    if (!mounted) return;

    setState(() {
      this.plant = plant;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (plant == null) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.3,
        child: const Center(child: CircularProgressIndicator()),
      );

    }
    final plantRecieved = plant!;

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.3,
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(plantRecieved.imageUrl, fit: BoxFit.cover),
                  )
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.favorite),
                    SizedBox(width: 10),
                    Icon(Icons.share),
                    SizedBox(width: 30),
                    if (plantRecieved.edible)
                      Icon(Icons.restaurant)
                  ]
                ),
                SizedBox(height: 20),
                Text(plantRecieved.commonName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text("${plantRecieved.scientificName} (${plantRecieved.year})", style: TextStyle(fontStyle: FontStyle.italic)),
                SizedBox(height: 20),
                Text("Family", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Flexible(child: Text(plantRecieved.familyName, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic))),
                SizedBox(width: 10),
                if (plantRecieved.familyCommonName != "")
                  Flexible(child: Text("(${plantRecieved.familyCommonName})", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic))),
                SizedBox(height: 5),
                Text("Observations", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Flexible(child: Text(plantRecieved.observations, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic))),
                SizedBox(height: 5),
                Text("Genus", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text(plantRecieved.genus, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                SizedBox(height: 5),
                Text("Species", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text(plantRecieved.speciesScientificName, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                if (plantRecieved.speciesCommonName != "")
                  Text("(${plantRecieved.speciesCommonName})", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
              ],
          )
        )
    );
  }
}

// Pretotype
// Storyboard (Nutzer Sicht!)

class plantCard extends StatelessWidget {
  plantCard({super.key, required this.plant});

  final previewPlant plant;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () async => showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: plantDialog(id: plant.id),
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
                child: Image.network(plant.imageUrl, fit: BoxFit.cover)
              )
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plant.commonName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 3),
                  Text(plant.scientificName, style: TextStyle(fontStyle: FontStyle.italic)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(plant.family),
                      SizedBox(width: 10),
                      Text("(${plant.genus})")
                      ]
                    )
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
  final void Function(String value) onSubmitted;
  const SearchTextField({super.key, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 20,
      onSubmitted: (value) => onSubmitted(value.trim()),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: Icon(Icons.clear),
        hintText: 'Search for Plants',
        border: OutlineInputBorder(),
      ),
    );
  }
}