import 'package:flutter/material.dart';
import '../objects.dart' show Plant;
import '../variables.dart';
import '../network.dart' show searchPlant;

class PlantDetailsPage extends StatefulWidget {
  final String plantId;
  const PlantDetailsPage({super.key, required this.plantId});

  @override
  State<PlantDetailsPage> createState() => PlantDetailsPageState(plantId: this.plantId);
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
    final colorScheme = Theme.of(context).colorScheme;

    return
      Scaffold(
          appBar: AppBar(title: Text(plantRecieved.commonName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
          bottomSheet: Row(
            children: [
              Spacer(),
              IconButton(
                icon: const Icon(Icons.info, color: Colors.grey),
                onPressed: () => showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (BuildContext context) {
                      return Container(
                          height: 150,
                          color: colorScheme.surface,
                          child: Center(
                              child: Column(
                                children: [
                                  SizedBox(height: 30),
                                  Row(
                                    children: [
                                      Icon(Icons.attribution),
                                      Text(plantRecieved.author),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.bookmark),
                                      Text(plantRecieved.bibliography),
                                    ],
                                  )
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
                  if (plantRecieved.images.isEmpty)
                    Center(child: Icon(Icons.broken_image, size: 64)),
                  if (plantRecieved.images.isNotEmpty)

                  ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height / 3,
                    minHeight: MediaQuery.of(context).size.height / 3
                  ),
                  child: PageView.builder(
                      itemCount: plantRecieved.images.length,
                      onPageChanged: (i) => setState(() => i),
                      itemBuilder: (context, i) {
                        return InteractiveViewer(
                          minScale: 1,
                          maxScale: 4,
                          child: Image.network(
                            plantRecieved.images[i],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (_, __, ___) =>
                            const Center(child: Icon(Icons.broken_image, size: 64)),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            plantNotifier.addPlant(plantRecieved.plantId);
                          });
                        },
                        child: const Icon(Icons.favorite),
                      ),
                      SizedBox(width: 10),
                      Spacer(),
                      if (plantRecieved.status == 'accepted')
                        Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            border: Border.all(
                              color: colorScheme.primary,
                              width: 3.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          child: Icon(Icons.verified),
                        ),
                      if (plantRecieved.vegetable)
                        Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color:  colorScheme.surface,
                            border: Border.all(
                              color:  colorScheme.primary,
                              width: 3.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          child: Icon(Icons.restaurant),
                        ),
                      if (plantRecieved.edible)
                        Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            border: Border.all(
                              color: colorScheme.primary,
                              width: 3.0,
                            ),
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
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text("Family Common Name"),
                              )
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text(plantRecieved.familyCommonName, style: TextStyle(fontSize: 20)),
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
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text("Slug"),
                              )
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text(plantRecieved.slug, style: TextStyle(fontSize: 20)),
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
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text("Genus"),
                              )
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text(plantRecieved.genus, style: TextStyle(fontSize: 20)),
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
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text("Scientific Name"),
                              )
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text(plantRecieved.scientificName, style: TextStyle(fontSize: 20)),
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
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text("Observations"),
                              )
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text(plantRecieved.observations, style: TextStyle(fontSize: 20)),
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