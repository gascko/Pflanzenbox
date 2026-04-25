import 'package:flutter/material.dart';
import '../objects.dart' show Plant;
import '../variables.dart';
import '../network.dart' show searchPlant;
import 'plantDetailsPage.dart';

class SavedPlantsPage extends StatefulWidget {
  const SavedPlantsPage({super.key});

  @override
  State<SavedPlantsPage> createState() => SavedPlantsPageState();
}

class SavedPlantsPageState extends State<SavedPlantsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Plants", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
        body: AnimatedBuilder(
          animation: plantNotifier,
          builder: (context, _) {
            final plants = plantNotifier.plants;

            if (plants.isEmpty) {
              return Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 4),
                  Icon(Icons.bookmark, size: MediaQuery.of(context).size.width / 3),
                  Text("No Plants saved yet", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              );
            }

            return ListView.builder(
              itemCount: plants.length,
              itemBuilder: (context, i) =>
                  FutureBuilder<Plant>(
                    future: searchPlant(plants[i]),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Card(child: CircularProgressIndicator());
                      return PlantCard(plant: snapshot);
                    },
                  )
            );
          },
        ),
    );
  }
}

class PlantCard extends StatelessWidget {
  PlantCard({super.key, required this.plant});

  AsyncSnapshot<Plant> plant;

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => plantDetailsPage(id: plant.data!.id),
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
                            plant.data!.plantData['image_url']['value'],
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
                                Text(plant.data!.commonName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(height: 3),
                                Text(plant.data!.plantData['scientific_name']['value'], style: TextStyle(fontStyle: FontStyle.italic)),
                                SizedBox(height: 10),
                                Row(
                                    children: [
                                      Text(plant.data!.plantData['family_common_name']['value']),
                                      SizedBox(width: 10),
                                      Text("(${plant.data!.plantData['year']['value']})")
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