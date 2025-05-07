import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skywalker/server/controllers/launcher_controller.dart';
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
              child: Row(
                children: [
                  Text('Launcher Control Page'),
                  Text('Launcher: ${launchers!.codename}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
