import 'package:flutter/material.dart';
import 'package:skywalker/components/colored_chip.dart';

class LauncherListPage extends StatelessWidget {
  final List<Map<String, dynamic>> launchers = [
    {
      'name': 'Falcon 9',
      'manufacturer': 'SpaceX',
      'status': 'Available',
      'lastLaunch': 'March 10, 2025',
    },
    {
      'name': 'Electron',
      'manufacturer': 'Rocket Lab',
      'status': 'Busy',
      'lastLaunch': 'March 5, 2025',
    },
    {
      'name': 'New Shepard',
      'manufacturer': 'Blue Origin',
      'status': 'Offline',
      'lastLaunch': 'February 20, 2025',
    },
  ];

  LauncherListPage({super.key});

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
        child: Column(
          children: [
            // Placeholder illustration at the top
            Container(
              height: 150,
              decoration: BoxDecoration(
                color:
                    Theme.of(context)
                        .colorScheme
                        .secondaryContainer, // Material Design secondary container color
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
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      launcher['name'],
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),

                    const SizedBox(height: 8),
                    status_chip(context, launcher['status']),

                    const SizedBox(height: 16),
                    Text(
                      'Manufacturer: ${launcher['manufacturer']}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Last Launch: ${launcher['lastLaunch']}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    if (launcher['status'] == 'Available')
                      ElevatedButton(
                        onPressed: () {
                          // Handle connect action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(
                                context,
                              ).colorScheme.primary, // Primary color
                          foregroundColor:
                              Theme.of(context)
                                  .colorScheme
                                  .onPrimary, // Contrast color for primary
                        ),
                        child: const Text('Connect'),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
}
