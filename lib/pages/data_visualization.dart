import 'package:flutter/material.dart';
import 'package:skywalker/components/filter_visualization.dart';
import 'package:skywalker/components/launch_select.dart';

class DataVisualizationPage extends StatefulWidget {
  const DataVisualizationPage({super.key});

  @override
  State<DataVisualizationPage> createState() => _DataVisualizationPageState();
}

class _DataVisualizationPageState extends State<DataVisualizationPage> {
  bool filter = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Visualization'),
        actions: [
          IconButton(
            icon: Icon(filter ? Icons.filter_alt : Icons.filter_alt_off),
            onPressed: () {
              setState(() {
                showChartFilter(context);
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.data_usage,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text(
                  'Data Visualization',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  'Visualize your data here',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Latest launcher data:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                LaunchSelect(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
