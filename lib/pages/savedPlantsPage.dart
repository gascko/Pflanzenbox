import 'package:flutter/material.dart';
import '../objects.dart' show Plant;
import '../variables.dart' show savedPlantObjects;

class savedPlantsPage extends StatefulWidget {
  const savedPlantsPage({super.key});

  @override
  State<savedPlantsPage> createState() => savedPlantsPageState();
}

class savedPlantsPageState extends State<savedPlantsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('My Plants 🌲', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
        body: Column(
            children: [
              for (final plant in savedPlantObjects)
                plantCard(plant: plant),
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
                                      Text(plant.familyName),
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