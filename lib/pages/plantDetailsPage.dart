import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../objects.dart' show Plant;
import '../variables.dart';
import '../network.dart' show searchPlant;

class PlantDetailsPage extends StatefulWidget {
  const PlantDetailsPage({super.key, required this.plantId});

  final String plantId;

  @override
  State<PlantDetailsPage> createState() => PlantDetailsPageState(plantId: plantId);
}

class PlantDetailsPageState extends State<PlantDetailsPage> {
  PlantDetailsPageState({required this.plantId});

  final String plantId;
  Plant? plant;

  @override
  void initState() {
    super.initState();
    loadPlant();
  }

  Future<void> loadPlant() async {
    final plant = await searchPlant(plantId);

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
    final plantReceived = plant!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
          appBar: AppBar(title: Text(plantReceived.commonName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
          bottomSheet: Row(
            children: [
              Spacer(),
              IconButton(
                icon: const Icon(Icons.info, color: Colors.grey),
                onPressed: () => showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (BuildContext context) {
                      return Container(
                          height: 120,
                          color: colorScheme.surface,
                          child: Center(
                              child: Column(
                                children: [
                                  SizedBox(height: 30),
                                  Row(
                                    children: [
                                      Icon(Icons.attribution),
                                      Text(plantReceived.author),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.bookmark),
                                      Text(plantReceived.bibliography),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.assignment_ind),
                                      Text("${plantReceived.plantId} : $plantId"),
                                    ],
                                  ),
                                ],
                              )
                          )
                      );
                    }
                ),
              ),
            ],
          ),
          body: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (plantReceived.images.isEmpty)
                    Center(child: Icon(Icons.broken_image, size: 64)),
                  if (plantReceived.images.isNotEmpty)
                    ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height / 3,
                      minHeight: MediaQuery.of(context).size.height / 3
                    ),
                    child: PageView.builder(
                        itemCount: plantReceived.images.length,
                        onPageChanged: (i) => setState(() => i),
                        itemBuilder: (context, i) {
                          return InteractiveViewer(
                            child: CachedNetworkImage(
                              imageUrl: plantReceived.images[i],
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return Center(child: Icon(Icons.broken_image, size: 64));
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ListenableBuilder(
                        listenable: plantNotifier,
                        builder: (BuildContext context, Widget? child) {
                          if (plantNotifier.savedPlants.contains(plantId)) {
                            return FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  plantNotifier.removePlant(plantId);
                                });
                              },
                              child: const Icon(Icons.favorite),
                            );
                          }
                          return FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                plantNotifier.addPlant(plantId);
                              });
                            },
                            child: const Icon(Icons.favorite_border),
                          );
                        },
                      ),
                      SizedBox(width: 10),
                      Spacer(),
                      if (plantReceived.status == 'accepted')
                        Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            border: Border.all(color: colorScheme.primary, width: 3.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          child: Icon(Icons.verified),
                        ),
                      if (plantReceived.vegetable)
                        Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color:  colorScheme.surface,
                            border: Border.all(color: colorScheme.primary, width: 3.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          child: Icon(Icons.restaurant),
                        ),
                      if (plantReceived.edible)
                        Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            border: Border.all(color: colorScheme.primary, width: 3.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          child: Icon(Icons.room_service),
                        ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Table(
                      columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                        TableRow(
                          children: <Widget>[
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  border: Border.all(color: Colors.transparent, width: 1.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text("Family Common Name"),
                              )
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text(plantReceived.familyCommonName, style: TextStyle(fontSize: 20)),
                            ),
                          ]
                        ),
                      TableRow(
                          children: <Widget>[
                            TableCell(
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  border: Border.all(color: Colors.transparent, width: 1.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text("Slug"),
                              )
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text(plantReceived.slug, style: TextStyle(fontSize: 20)),
                            ),
                          ]
                      ),
                      TableRow(
                          children: <Widget>[
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  border: Border.all(color: Colors.transparent, width: 1.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text("Genus"),
                              )
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text(plantReceived.genus, style: TextStyle(fontSize: 20)),
                            ),
                          ]
                      ),
                      TableRow(
                          children: <Widget>[
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  border: Border.all(color: Colors.transparent, width: 1.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text("Scientific Name"),
                              )
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text(plantReceived.scientificName, style: TextStyle(fontSize: 20)),
                            ),
                          ]
                      ),
                      TableRow(
                          children: <Widget>[
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  border: Border.all(color: Colors.transparent, width: 1.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text("Observations"),
                              )
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text(plantReceived.observations, style: TextStyle(fontSize: 20)),
                            ),
                          ]
                      ),
                    ]
                  )
                ]
              )
          )
      );
  }
}