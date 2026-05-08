import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
        body: ListenableBuilder(
            listenable: plantNotifier,
            builder: (BuildContext context, Widget? child) {
              if (plantNotifier.savedPlants.isEmpty) {
                return Center(
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height / 4),
                        Icon(Icons.bookmark, size: MediaQuery.of(context).size.width / 3),
                        Text("No Plants saved yet", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    )
                );
              }
              final List<String> values = plantNotifier.plants;
              return ListView.builder(
                  itemCount: values.length,
                  itemBuilder: (context, i) =>
                      FutureBuilder<Plant>(
                          future: searchPlant(values[i]),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Card(child: CircularProgressIndicator());
                            }
                            return Card(
                                clipBehavior: Clip.hardEdge,
                                child: InkWell(
                                    onTap: () => Navigator.push(context, MaterialPageRoute<void>(
                                      builder: (context) => PlantDetailsPage(plantId: values[i]))),
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
                                                  child: CachedNetworkImage(
                                                    imageUrl: snapshot.data!.previewImage,
                                                    fit: BoxFit.cover,
                                                    errorWidget: (context, url, error) {
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
                                                        Text(snapshot.data!.commonName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                        SizedBox(height: 3),
                                                        Text(snapshot.data!.scientificName, style: TextStyle(fontStyle: FontStyle.italic)),
                                                        SizedBox(height: 10),
                                                        Row(
                                                            children: [
                                                              Text(snapshot.data!.familyCommonName),
                                                              SizedBox(width: 10),
                                                            ]
                                                        )
                                                      ]
                                                  )
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    plantNotifier.removePlant(values[i]);
                                                  });
                                                },
                                                icon: const Icon(Icons.delete),
                                              ),
                                            ]
                                        )
                                    )
                                )
                            );
                          }
                      )
              );
            }
          )
    );
  }
}