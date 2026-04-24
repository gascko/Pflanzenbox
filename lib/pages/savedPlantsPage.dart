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
              return const Center(child: Text("Keine Pflanzen gespeichert."));
            }

            return ListView.builder(
              itemCount: plants.length,
              itemBuilder: (context, i) =>
                  FutureBuilder<Plant>(
                    future: searchPlant(plants[i]),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      return plantCard(plant: snapshot);
                    },
                  )
            );
          },
        ),
    );
  }
}

class plantCard extends StatelessWidget {
  plantCard({super.key, required this.plant});

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
                              child: Image.network(plant.data!.imageUrl, fit: BoxFit.cover)
                          )
                      ),
                      SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(plant.data!.commonName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(height: 3),
                                Text(plant.data!.scientificName, style: TextStyle(fontStyle: FontStyle.italic)),
                                SizedBox(height: 10),
                                Row(
                                    children: [
                                      Text(plant.data!.familyName),
                                      SizedBox(width: 10),
                                      Text("(${plant.data!.genus})")
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