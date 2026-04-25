import 'dart:async';
import 'package:flutter/material.dart';
import '../network.dart' show searchPlants;
import '../objects.dart';
import 'plantDetailsPage.dart' show plantDetailsPage;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List<Plant> plantList = [];

  Future<void> reloadPlantCards(String searchQuery) async {
    final plants = await searchPlants(searchQuery);

    setState(() {
      plantList = plants;
    });
  }

  void clearPlantCards() {
    setState(() {
      plantList.clear();
    });
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

  final Plant plant;

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
                child: Image.network(
                  plant.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/placeholder.png', fit: BoxFit.cover);
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
  final void Function(String value) onSubmitted;
  final void Function() onClear;
  final fieldText = TextEditingController();
  SearchTextField({super.key, required this.onSubmitted, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 20,
      controller: fieldText,
      onSubmitted: (value) => onSubmitted(value.trim()),
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