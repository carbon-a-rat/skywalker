import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 400, // Adjust height for the carousel
        child: PageView.builder(
          controller: PageController(
            viewportFraction: 0.8,
          ), // Perspective effect
          itemCount: launchers.length,
          itemBuilder: (context, index) {
            final launcher = launchers[index];
            final statusColor =
                launcher['status'] == 'Available'
                    ? Colors.green
                    : launcher['status'] == 'Busy'
                    ? Colors.yellow
                    : Colors.red;

            return Transform.scale(
              scale: 0.9, // Slight scaling for perspective
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Status color point
                              Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color:
                                      statusColor, // Keep dynamic status color
                                  shape: BoxShape.circle,
                                ),
                              ),
                              // Status text
                              Text(
                                launcher['status'],
                                style: TextStyle(
                                  color:
                                      statusColor, // Keep dynamic status color
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            launcher['name'],
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Manufacturer: ${launcher['manufacturer']}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Last Launch: ${launcher['lastLaunch']}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
