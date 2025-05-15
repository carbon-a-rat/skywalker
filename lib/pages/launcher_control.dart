import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skywalker/server/providers/launcher_provider.dart';

class LauncherControlPage extends StatefulWidget {
  const LauncherControlPage({super.key, required this.launcherId});
  final String launcherId;

  @override
  State<LauncherControlPage> createState() => _LauncherControlPageState();
}

class _LauncherControlPageState extends State<LauncherControlPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LauncherProvider>(
      create: (context) => LauncherProvider(widget.launcherId),
      child: Consumer<LauncherProvider>(
        builder: (context, provider, child) {
          if (provider.launcher == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final launchers = provider.launcher;

          return Scaffold(
            // Placeholder
            appBar: AppBar(title: const Text('Launcher Control')),
            body: Center(
              child: Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.rocket_launch,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),

                      Text(
                        'Launcher: ${launchers!.name}',

                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        'Status: ${launchers.status}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
