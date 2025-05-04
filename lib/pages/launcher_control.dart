import 'package:flutter/material.dart';

class LauncherControlPage extends StatefulWidget {
  const LauncherControlPage({super.key, required this.launcherId});
  final String launcherId;

  @override
  State<LauncherControlPage> createState() => _LauncherControlPageState();
}

class _LauncherControlPageState extends State<LauncherControlPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Placeholder
      appBar: AppBar(title: const Text('Launcher Control')),
      body: Center(child: Text('Launcher Control Page')),
    );
  }
}
