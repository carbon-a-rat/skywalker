import 'package:flutter/material.dart';
import 'package:skywalker/components/pad.dart';
import 'package:skywalker/pages/launch_details.dart';
import 'package:skywalker/server/models/launch.dart';

class LaunchDetail extends StatelessWidget {
  final Launch launch;

  const LaunchDetail({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 2,
      child: padxsmall(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                title: Text(launch.rocketName),
                subtitle: Text(launch.created.toString()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => LaunchDetailsPage(launchId: launch.id),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


/* 

return ChangeNotifierProvider<LaunchListProvider>(
      create: (context) => LaunchListProvider(),
      child: Consumer<LaunchListProvider>(
        builder: (context, provider, child) {
          if (provider.ready == false) {
            return const Center(child: CircularProgressIndicator());
          }
          final launchs = provider.launches;
          if (launchs.isEmpty) {
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
*/