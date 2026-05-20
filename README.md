# Pflanzenbox 🪴

Pflanzenbox ist ein mobile Frontend für die [Trefle API](https://trefle.io/) 🌻

<style>
th:nth-child(1) {
width: 300px;
}
th:nth-child(2) {
width: 300px;
}
th:nth-child(3) {
width: 300px;
}
th:nth-child(4) {
width: 300px;
}
</style>

|Detailansicht|Gespeicherte Pflanzen|Pflanzen Suche|Einstellungen|
|--|--|--|--|
|<img src="./Screenshots/Details_Light_Mode_Cover.png"/>|<img src="./Screenshots/Saved_Light_Mode.png"/>|<img src="./Screenshots/Search_Light_Mode.png"/>|<img src="./Screenshots/Settings_Light_Mode.png"/>|

# Anforderungen

* 🛠️ [Flutter](https://flutter.dev/)
* 🪻 [Trefle API Key](https://trefle.io/)
* 📡 http Package (zu Projekt hinzufügen mit `dart pub add http shared_preferences cached_network_image flutter_launcher_icons`)
* App starten mit `flutter pub get`

# Storyboard 🧩

> Aktuelles MVP: **3**

```mermaid
kanban
    columnSuchen[Suchen]
        task1[Texteingabe **1**]
        task2[Scrollen durch Ergebnisse **1**]
        task3[Ergebnisse mit Bild, Pflanzenname, Pflanzenfamilie **1**]
        task4[Ergebnisse klickbar in Detailansicht **2**]
        task5[Suche Filtern]
        task6[Favoriten schon in der Suche sehen]
    columnDetails[Details anzeigen]
        task1[Pflanzenfamilie **2**]
        task2[Ort mit kleiner Minimap?]
        task3[Bilder zum durchswipen **2**]
        task4[Gattung **2**]
        task5[Art **2**]
        task6[Essbar? **3**]
        task7[Bilder Großansicht]
        task8[Author Infos **3**]
    columnSpeichern[Speichern]
        task1[Notification bei Speichern]
        task2[Scrollen durch gespeicherte Pflanzen **2**]
        task3[Ergebnisse mit Bild, Pflanzenname, Pflanzenfamilie **2**]
        task4[Ergebnisse klickbar in Detailansicht **3**]
    columnLöschen[Löschen]
        task1[Gespeicherte Pflanzen löschen]
        task2[Notification bei löschen von Pflanze]
    columnLight[Dark / Light Modus]
        task1[Light-Darkmodus setzen **3**]
    columnApi[API-Key setzen]
        task1[Texteingabe für API-Schlüssel **3**]
    columnTeilen[Pflanze Teilen]
        task1[Pflanzen Infos als PDF oder Bild teilen?]
```
# Screenshots 📱

## Light Mode 🌞

|Detailansicht|Gespeicherte Pflanzen|Pflanzen Suche|Einstellungen|
|--|--|--|--|
|<img src="./Screenshots/Details_Light_Mode.png"/>|<img src="./Screenshots/Saved_Light_Mode.png"/>|<img src="./Screenshots/Search_Light_Mode.png"/>|<img src="./Screenshots/Settings_Light_Mode.png"/>|

## Dark Mode 🌚

|Detailansicht|Gespeicherte Pflanzen|Pflanzen Suche|Einstellungen|
|--|--|--|--|
|<img src="./Screenshots/Details_Dark_Mode.png"/>|<img src="./Screenshots/Saved_Dark_Mode.png"/>|<img src="./Screenshots/Search_Dark_Mode.png"/>|<img src="./Screenshots/Settings_Dark_Mode.png"/>|

# Mockup 🖼️

Mockup erstellt mit [Microsoft Copilot](https://copilot.cloud.microsoft/)

|Detailansicht|Gespeicherte Pflanzen|Einstellungen|
|--|--|--|
|<img src="./Mockup/Mockup_Plant_Page.png"/>|<img src="./Mockup/Mockup_Favorites.png"/>|<img src="./Mockup/Mockup_Settings.png"/>|
