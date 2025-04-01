import 'package:flutter/material.dart';
import 'package:skywalker/components/colored_chip.dart';
import 'package:skywalker/components/waiting_component.dart';
import 'package:skywalker/server/launcher.dart';
import 'package:skywalker/server/pocketbase_controller.dart';
import 'package:skywalker/services.dart';
import 'package:skywalker/utils.dart';

class LauncherListPage extends StatefulWidget {
  const LauncherListPage({super.key});

  @override
  State<LauncherListPage> createState() => _LauncherListpage();
}

class _LauncherListpage extends State<LauncherListPage> {
  var loading = true;
  List<Launcher> launchers = [
    Launcher(
      name: 'Falcon 9',
      manufacturer: 'SpaceX',
      status: 'Available',
      lastLaunch: 'March 10, 2025',
    ),
    Launcher(
      name: 'Electron',
      manufacturer: 'Rocket Lab',
      status: 'Busy',
      lastLaunch: 'March 5, 2025',
    ),
    Launcher(
      name: 'New Shepard',
      manufacturer: 'Blue Origin',
      status: 'Offline',
      lastLaunch: 'February 20, 2025',
    ),
  ];

  Widget status_chip(BuildContext context, String status) {
    final statusColors = {
      'Available': Colors.green.shade400,
      'Busy': Colors.yellow.shade400,
      'Offline': Colors.red.shade400,
    };
    return ColoredChipButton(
      name: status,
      color: statusColors[status] ?? Colors.grey.shade400,
      callback: () {},
    );
  }

  Widget launcher_elt(BuildContext context, int index) {
    final launcher = launchers[index];
    return Transform.scale(
      scale: 0.9, // Slight scaling for perspective
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder illustration at the top
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.rocket_launch,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Launcher name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            launcher.name,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),

                          // Status chip
                          status_chip(context, launcher.status),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Manufacturer and last launch
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Manufacturer: ',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              launcher.manufacturer,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last Launch: ',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              launcher.lastLaunch,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (launcher.status == 'Available')
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle connect action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: const Text(
                      'Connect',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return SizedBox(
      height: 450,
      child: Row(
        // Use Row instead of Column for horizontal scrolling
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            // Ensure ListView.builder takes available space
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 450,
                  width: 350,
                  child: launcher_elt(context, index),
                );
              },
              itemCount: launchers.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 450, // Adjust height for the carousel
          child: PageView.builder(
            controller: PageController(
              viewportFraction: 0.9,
            ), // Perspective effect
            itemCount: launchers.length,
            itemBuilder: (context, index) {
              return launcher_elt(context, index);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var pbc = getIt<PocketbaseController>();

    return waitFor(
      waiting_for: () => pbc.get_rocket_list(),
      executed: (data) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (isDesktopLayout(context)) {
              return _buildWideLayout(context);
            } else {
              return _buildNarrowLayout(context);
            }
          },
        );
      },
    );
  }
}
