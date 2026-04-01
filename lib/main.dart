import 'package:flutter/material.dart';

import 'pages/settingsPage.dart';
import 'pages/plantsPage.dart';
import 'pages/searchPage.dart';
import 'pages/dhgePage.dart';

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

void main() => runApp(const mobapApp());

class mobapApp extends StatelessWidget {
  const mobapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        home: navigationBar());
  }
}

class navigationBar extends StatefulWidget {
  const navigationBar({super.key});

  @override
  State<navigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<navigationBar> {
  int currentPageIndex = 0;

  final List<Widget> pagesList = const [
    searchPage(),
    plantsPage(),
    settingsPage(),
    dhgePage(),
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
              NavigationDestination(
                selectedIcon: Icon(Icons.eleven_mp),
                icon: Icon(Icons.eleven_mp),
                label: 'DHGE',
              ),
            ]
        )
    );
  }
}