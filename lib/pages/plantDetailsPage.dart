import 'package:flutter/material.dart';
import '../objects.dart' show Plant;
import '../network.dart' show searchPlant;
import '../variables.dart';

class plantDetailsPage extends StatefulWidget {
  final String id;
  const plantDetailsPage({super.key, required this.id});

  @override
  State<plantDetailsPage> createState() => plantDetailsPageState(plantId: this.id);
}

class plantDetailsPageState extends State<plantDetailsPage> {
  plantDetailsPageState({required this.plantId});

  final String plantId;
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

    return
      Scaffold(
          appBar: AppBar(title: Text(plantRecieved.commonName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
          body: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          plantRecieved.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/placeholder.png', fit: BoxFit.cover);
                          },
                        ),
                      )
                  ),
                  SizedBox(height: 20),
                  Row(
                      children: [
                        plantNotifier.plants.contains(plantId) ?
                        FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              plantNotifier.removePlant(plantRecieved.id);
                            });
                            },
                          child: const Icon(Icons.favorite_border),
                        ) :
                        FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              plantNotifier.addPlant(plantRecieved.id);
                            });
                            },
                          child: const Icon(Icons.favorite),
                        )
                      ]
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        for (final values in plantRecieved.plantData.values)
                          DataCard(name: values['name'], value: values['value']),
                      ],
                    ),
                  ),
                ]
              )
          )
      );
  }
}

class DataCard extends StatelessWidget {
  const DataCard({super.key, required this.name, required this.value});

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Spacer(),
            Text(value, style: TextStyle(fontSize: 20)),
          ],
        )
    );
  }
}