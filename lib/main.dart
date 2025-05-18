import 'package:flutter/material.dart';
import 'package:skywalker/components/pad.dart';
import 'package:skywalker/components/sizing.dart';
import 'package:skywalker/pages/account.dart';
import 'package:skywalker/pages/launcher_list.dart';
import 'package:skywalker/pages/data_visualization.dart';
import 'package:skywalker/pages/login_page.dart';
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
        // dark mode
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),

      themeMode: ThemeMode.dark,
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
    NavigationItem(icon: Icons.account_circle, label: 'Account'),
  ];

  @override
  Widget build(BuildContext context) {
    // Define a shared list of navigation items

    var pbc = getIt<PocketbaseController>();
    var page =
        [
          LauncherListPage(), // 0
          DataVisualizationPage(), // 1
          AccountPage(),
        ][selectedIndex];

    if (pbc.loggedIn == false) {
      return Scaffold(
        body: maxWProseCentered(
          Container(
            // box shadow
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.5),
                  spreadRadius: 20,
                  blurRadius: 200,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: padbig(
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.rocket_launch,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  padsmall(
                    Text(
                      "Sky Walker",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  padsmall(Text("Please login to access the app")),
                  padtopbig(
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const LoginPage(title: "Login"),
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: const Text("connect"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isDesktopLayout(context)) {
          // Use NavigationRail for wider screens
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
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
              elevation: 10,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,

              currentIndex: selectedIndex,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(context).colorScheme.onSurface,
              showUnselectedLabels: false,
              showSelectedLabels: true,
              type: BottomNavigationBarType.fixed,
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
