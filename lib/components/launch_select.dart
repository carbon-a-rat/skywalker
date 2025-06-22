import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skywalker/server/providers/launch_list_provider.dart';
import 'package:skywalker/server/providers/launcher_list_provider.dart';
import 'package:skywalker/server/providers/launcher_provider.dart';

// FIXME: rework everything, this is just barebone code to get it working
class LaunchSelect extends StatefulWidget {
  const LaunchSelect({super.key});

  @override
  _LaunchSelectState createState() => _LaunchSelectState();
}

class _LaunchSelectState extends State<LaunchSelect> {
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LaunchListProvider>(
      create: (context) => LaunchListProvider(),
      child: Consumer<LaunchListProvider>(
        builder: (context, provider, child) {
          if (!provider.ready) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.launches.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final launchers = provider.launches;

          if (launchers.isEmpty) {
            return const Center(child: Text('No launchers available'));
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: launchers.length,
            itemBuilder: (context, index) {
              final launcher = launchers[index];
              return ListTile(
                title: Text(launcher.launcherName),
                subtitle: Text(launcher.rocketName),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (
                              context,
                            ) => ChangeNotifierProvider<LauncherProvider>(
                              create:
                                  (context) => LauncherProvider(launcher.id),
                              child: Column(
                                children: [
                                  Text(
                                    'Launcher: ${launcher.launcherName}\nRocket: ${launcher.rocketName}',
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.headlineSmall,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Back'),
                                  ),
                                ],
                              ),
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
