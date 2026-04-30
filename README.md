# Pflanzenbox (eng. Plant Box) 🪴

Pflanzenbox is a Mobile Frontend for the [Trefle API](https://trefle.io/) 🌻

I made this litte App for University ([DHGE](https://www.dhge.de/))

# Requirements

* 🛠️ [Flutter](https://flutter.dev/)
* 🪻 [Trefle API Key](https://trefle.io/)
* 📡 http Package (Add to Project with `dart pub add http shared_preferences`)
* Run `flutter pub get`

# Storyboard 🧩

```mermaid
kanban
    columnSuchen[Suchen]
        task1[Texteingabe]
        task2[Scrollen durch Ergebnisse]
        task3[Ergebnisse mit Bild, Pflanzenname, Pflanzenfamilie]
        task4[Ergebnisse klickbar in Detailansicht]
    columnDetails[Details anzeigen]
        task1[Pflanzenfamilie]
        task2[Ort]
        task3[Bilder]
        task4[Gattung]
        task5[Art]
        task6[Essbar?]
        task7[Speichern]
        task8[Teilen]
    columnSpeichern[Speichern]
        task1[Scrollen durch gespeicherte Pflanzen]
        task2[Löschen von Pflanzen]
        task3[Ergebnisse mit Bild, Pflanzenname, Pflanzenfamilie]
    columnLöschen[Löschen]
        task1[Gespeicherte Pflanzen löschen]
    columnLight[Dark / Light Modus]
        task1[Light-Darkmodus setzen]
    columnApi[API-Key setzen]
        task1[Texteingabe für API-Schlüssel]
```

# Mockup

Mockup erstellt mit [Microsoft Copilot](https://copilot.cloud.microsoft/)

<img src="./Mockup/Mockup_Plant_Page.png" width="300"/>
<img src="./Mockup/Mockup_Favorites.png" width="300"/>
<img src="./Mockup/Mockup_Settings.png" width="300"/>
