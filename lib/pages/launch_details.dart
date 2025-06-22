import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skywalker/components/chart.dart';
import 'package:skywalker/components/launch_detail_button.dart';
import 'package:skywalker/components/pad.dart';
import 'package:skywalker/components/sizing.dart';
import 'package:skywalker/pages/login_page.dart';
import 'package:skywalker/server/pocketbase_controller.dart';
import 'package:skywalker/server/providers/launch_list_provider.dart';
import 'package:skywalker/server/providers/launch_provider.dart';
import 'package:skywalker/services.dart';

class LaunchDetailsPage extends StatefulWidget {
  const LaunchDetailsPage({super.key, required this.launchId});

  final String launchId;
  @override
  State<LaunchDetailsPage> createState() => _LaunchDetailsPage();
}

class _LaunchDetailsPage extends State<LaunchDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var pbc = getIt<PocketbaseController>();
    // generate random values points from a seed

    final random = Random(42);
    List<FlSpot> generatedRandomValues = [FlSpot(0, 0)];

    for (int i = 0; i < 100; i++) {
      generatedRandomValues.add(
        FlSpot(
          i.toDouble(),
          random.nextDouble() +
                  generatedRandomValues.lastOrNull!.y.toDouble() ??
              0,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Launch Details')),
      body: ChangeNotifierProvider<LaunchProvider>(
        create: (context) => LaunchProvider(widget.launchId),
        child: Consumer<LaunchProvider>(
          builder: (context, provider, child) {
            if (provider.launches == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return padbig(
              Card.outlined(
                child: SingleChildScrollView(
                  child: padbig(
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'rocket: ${provider.launches!.rocketName}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'created: ${provider.launches!.created}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'launcher: ${provider.launches!.launcherName ?? 'No description'}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),

                        GridView.builder(
                          shrinkWrap: true,

                          physics: const NeverScrollableScrollPhysics(),
                          primary: false,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 700,
                                childAspectRatio: 1.5,
                              ),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              child: Card.filled(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                elevation: 2,
                                child: padxsmall(
                                  Chart(spots: generatedRandomValues),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
