import 'package:flutter/material.dart';
import 'package:skywalker/components/filter_visualization.dart';
import 'package:skywalker/components/launch_select.dart';
import 'package:skywalker/components/pad.dart';
import 'package:skywalker/components/sizing.dart';

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
      body: padbig(
        maxWProseCentered(
          Card(
            surfaceTintColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            shadowColor: Theme.of(context).colorScheme.primary.withAlpha(100),
            elevation: 0.5,
            child: padbig(
              Column(
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
                  padtopbig(
                    Card.filled(
                      color: Theme.of(context).colorScheme.surface,
                      surfaceTintColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,

                      child: LaunchSelect(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
