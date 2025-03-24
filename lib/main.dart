import 'package:flutter/material.dart';
import 'package:skywalker/pages/launcher_list.dart';
import 'package:skywalker/pages/data_visualization.dart';
import 'package:skywalker/pages/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky Walker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Define a shared list of navigation items
    final List<NavigationItem> navigationItems = [
      NavigationItem(icon: Icons.rocket_launch, label: 'Launchers'),
      NavigationItem(icon: Icons.data_thresholding, label: 'Data Analysis'),
      NavigationItem(icon: Icons.settings, label: 'Settings'),
    ]; // TODO: Move this outside of the build method for better performance (once the list is finalized)

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = LauncherListPage();
        break;
      case 1:
        page = DataVisualizationPage();
        break;
      case 2:
        page = SettingsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          // Use NavigationRail for wider screens
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: false,
                    destinations:
                        navigationItems
                            .map(
                              (item) => NavigationRailDestination(
                                icon: Icon(item.icon),
                                label: Text(
                                  item.label,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            )
                            .toList(),
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
                ),
              ],
            ),
          );
        } else {
          // Use BottomNavigationBar for narrower screens
          return Scaffold(
            body: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              items:
                  navigationItems
                      .map(
                        (item) => BottomNavigationBarItem(
                          icon: Icon(item.icon),
                          label: item.label,
                        ),
                      )
                      .toList(),
            ),
          );
        }
      },
    );
  }
}

// Helper class to define navigation items
class NavigationItem {
  final IconData icon;
  final String label;

  NavigationItem({required this.icon, required this.label});
}
