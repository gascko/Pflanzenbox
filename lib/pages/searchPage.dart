import 'dart:async';
import 'package:flutter/material.dart';
import '../network.dart' show searchPlants;
import '../objects.dart' show previewPlant;
import 'plantDetailsPage.dart' show plantDetailsPage;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
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
        appBar: AppBar(title: Text("Search", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
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

class plantCard extends StatelessWidget {
  plantCard({super.key, required this.plant});

  final previewPlant plant;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => plantDetailsPage(id: plant.id),
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