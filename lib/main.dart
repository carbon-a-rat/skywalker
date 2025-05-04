import 'package:flutter/material.dart';
import 'package:skywalker/pages/account.dart';
import 'package:skywalker/pages/launcher_list.dart';
import 'package:skywalker/pages/data_visualization.dart';
import 'package:skywalker/pages/login_page.dart';
import 'package:skywalker/pages/settings.dart';
import 'package:skywalker/server/pocketbase_controller.dart';
import 'package:skywalker/services.dart';
import 'package:skywalker/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocators();

  await getIt.allReady();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky Walker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
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
  final List<NavigationItem> navigationItems = [
    NavigationItem(icon: Icons.rocket_launch, label: 'Launchers'),
    NavigationItem(icon: Icons.data_thresholding, label: 'Data Analysis'),
    NavigationItem(icon: Icons.settings, label: 'Settings'),
    NavigationItem(icon: Icons.account_circle, label: 'Account'),
  ];

  @override
  Widget build(BuildContext context) {
    // Define a shared list of navigation items

    var pbc = getIt<PocketbaseController>();
    var page =
        <Widget>[
          LauncherListPage(), // 0
          DataVisualizationPage(), // 1
          SettingsPage(), // 2
          AccountPage(),
        ][selectedIndex];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isDesktopLayout(context)) {
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
                Expanded(child: Container(child: page)),
              ],
            ),
          );
        } else {
          // Use BottomNavigationBar for narrower screens
          return Scaffold(
            body: Container(child: page),
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
