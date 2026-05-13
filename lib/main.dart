import 'package:flutter/material.dart';
import 'storage.dart';
import 'pages/settingsPage.dart';
import 'pages/savedPlantsPage.dart';
import 'pages/searchPage.dart';
import 'variables.dart';
import 'package:flutter/services.dart';

class AppTheme {
  /// Definition of primary color (Ascend colors will get auto generated)
  static const Color seed = Color(0xFF1B9721);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await plantNotifier.loadPlants();
  await themeNotifier.loadMode();
  await loadApiKey();
  runApp(const PflanzenboxApp());
}

class PflanzenboxApp extends StatelessWidget {
  const PflanzenboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return AnimatedBuilder(
          animation: themeNotifier,
          builder: (context, _) {
            return MaterialApp(
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: themeNotifier.mode,
                home: PflanzenboxAppState());
          });
  }
}

class PflanzenboxAppState extends StatefulWidget {
  const PflanzenboxAppState({super.key});

  @override
  State<PflanzenboxAppState> createState() => NavigationBarState();
}

class NavigationBarState extends State<PflanzenboxAppState> {
  int currentPageIndex = 0;

  final List<Widget> pagesList = const [
    SearchPage(),
    SavedPlantsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: currentPageIndex,
          children: pagesList,
        ),

        bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(Icons.search),
                icon: Icon(Icons.search_outlined),
                label: 'Search',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.spa_rounded),
                icon: Icon(Icons.spa_outlined),
                label: 'My Plants'
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.settings),
                icon: Icon(Icons.settings_outlined),
                label: 'Settings',
              ),
            ]
        )
    );
  }
}