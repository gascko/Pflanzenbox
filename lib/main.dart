import 'package:flutter/material.dart';
import 'package:pflanzenbox/storage.dart';
import 'pages/settingsPage.dart';
import 'pages/savedPlantsPage.dart';
import 'pages/searchPage.dart';
import 'variables.dart';

class AppTheme {
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
  runApp(const pflanzenboxApp());
}

class pflanzenboxApp extends StatelessWidget {
  const pflanzenboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
          animation: themeNotifier,
          builder: (context, _) {
            return MaterialApp(
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: themeNotifier.mode,
                home: navigationBar());
          });
  }
}

class navigationBar extends StatefulWidget {
  const navigationBar({super.key});

  @override
  State<navigationBar> createState() => NavigationBarState();
}

class NavigationBarState extends State<navigationBar> {
  int currentPageIndex = 0;

  final List<Widget> pagesList = const [
    SearchPage(),
    SavedPlantsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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