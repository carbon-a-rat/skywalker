import 'package:flutter/material.dart';
import 'package:skywalker/components/colored_chip.dart';
import 'package:skywalker/components/pad.dart';
import 'package:skywalker/pages/launcher_control.dart';
import 'package:skywalker/server/models/launcher.dart';
import 'package:skywalker/server/providers/launcher_list_provider.dart';
import 'package:skywalker/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';

class LauncherListPage extends StatefulWidget {
  const LauncherListPage({super.key});

  @override
  State<LauncherListPage> createState() => _LauncherListpage();
}

class _LauncherListpage extends State<LauncherListPage> {
  var loading = true;
  final PageController _pageController = PageController(
    viewportFraction: 0.9,
  ); // Add PageController

  Widget statusChip(BuildContext context, String status) {
    final statusColors = {
      'available': Colors.green.shade400,
      'busy': Colors.yellow.shade400,
      'offline': Colors.red.shade400,
      'unauthorized': Colors.red.shade400,
      'connected': Colors.blue.shade400,
    };
    return ColoredChipButton(
      name: status,
      color: statusColors[status] ?? Colors.grey.shade400,
      callback: () {},
    );
  }

  Widget launcherDescription(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }

  Widget launcherElt(BuildContext context, final Launcher launcher) {
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
                padbig(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Launcher name
                      pady(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              launcher.name,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),

                            // Status chip
                            statusChip(context, launcher.status),
                          ],
                        ),
                      ),

                      launcherDescription(
                        'Manufacturer: ',
                        launcher.manufacturerName,
                      ),

                      launcherDescription(
                        'Last Launch: ',
                        launcher.lastLaunchAt.toString(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if ( /*launcher.online*/ true)
              padbig(
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle connect action
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  LauncherControlPage(launcherId: launcher.id),
                        ),
                      ).then((value) {
                        setState(() {});
                      });
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

  Widget _buildWideLayout(BuildContext context, List<Launcher> launchers) {
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
                  width: 450,
                  child: launcherElt(context, launchers[index]),
                );
              },
              itemCount: launchers.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout(BuildContext context, List<Launcher> launchers) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 450, // Adjust height for the carousel
          child: PageView.builder(
            controller: _pageController, // Use the PageController
            itemCount: launchers.length,
            itemBuilder: (context, index) {
              return launcherElt(context, launchers[index]);
            },
          ),
        ),
        SmoothPageIndicator(
          controller: _pageController, // Bind the PageController
          count: launchers.length,
          effect: ExpandingDotsEffect(
            activeDotColor: Theme.of(context).colorScheme.primary,
            dotColor: Theme.of(context).colorScheme.onSurface.withAlpha(70),
            dotHeight: 10,
            dotWidth: 10,
            spacing: 10,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LauncherListProvider>(
      create: (context) => LauncherListProvider(),
      child: Consumer<LauncherListProvider>(
        builder: (context, provider, child) {
          if (provider.ready == false) {
            return const Center(child: CircularProgressIndicator());
          }
          final launchers = provider.launchers;
          if (launchers.isEmpty) {
            return Center(
              child: Text(
                "No launchers available.",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(title: const Text("Available Launchers")),
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (isDesktopLayout(context)) {
                  return _buildWideLayout(context, launchers);
                } else {
                  return _buildNarrowLayout(context, launchers);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
