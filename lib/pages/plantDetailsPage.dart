import 'package:flutter/material.dart';
import '../objects.dart' show Plant;
import '../network.dart' show searchPlant;
import '../storage.dart' show addPlant;

class plantDetailsPage extends StatefulWidget {
  final int id;
  const plantDetailsPage({super.key, required this.id});

  @override
  State<plantDetailsPage> createState() => plantDetailsPageState(plantId: this.id);
}

class plantDetailsPageState extends State<plantDetailsPage> {
  plantDetailsPageState({required this.plantId});

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
                        child: Image.network(plantRecieved.imageUrl, fit: BoxFit.cover),
                      )
                  ),
                  SizedBox(height: 20),
                  Row(
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            addPlant(plantId.toString());
                          },
                          shape: null,
                          child: const Icon(Icons.favorite)
                        ),
                        SizedBox(width: 10),
                        shareButton(),
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

class shareButton extends StatefulWidget {
  const shareButton({super.key});

  @override
  State<shareButton> createState() => shareButtonState();
}

class shareButtonState extends State<shareButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
      },
      shape: null,
      child: const Icon(Icons.share),
    );
  }
}