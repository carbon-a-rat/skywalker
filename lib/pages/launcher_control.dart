import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skywalker/components/launch_detail_button.dart';
import 'package:skywalker/components/launch_settings.dart';
import 'package:skywalker/components/pad.dart';
import 'package:skywalker/components/sizing.dart';
import 'package:skywalker/server/models/launch.dart';
import 'package:skywalker/server/models/launcher.dart';
import 'package:skywalker/server/providers/launch_list_provider.dart';
import 'package:skywalker/server/providers/launcher_provider.dart';

class LauncherControlPage extends StatefulWidget {
  const LauncherControlPage({super.key, required this.launcherId});
  final String launcherId;

  @override
  State<LauncherControlPage> createState() => _LauncherControlPageState();
}

class _LauncherControlPageState extends State<LauncherControlPage> {
  Widget showCurrentLaunch(
    BuildContext context,
    Launcher launcher,
    bool showLaunched,
  ) {
    return Card.outlined(
      elevation: 0,
      child: padbig(
        ChangeNotifierProvider<LaunchListProvider>(
          create: (context) => LaunchListProvider(),
          child: Consumer<LaunchListProvider>(
            builder: (context, provider, child) {
              List<Launch> launches;

              if (provider.launches.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              launches =
                  provider.launches
                      .where(
                        (l) =>
                            l.launcherId == launcher.id &&
                            l.shouldLoad != showLaunched,
                      )
                      .toList();

              if (launches.isEmpty) {
                return FilledButton.icon(
                  onPressed: () => {showLaunchSettings(context)},
                  label: const Text('Launch'),
                  icon: const Icon(Icons.play_arrow),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: launches.length,
                itemBuilder: (context, index) {
                  final launch = launches[index];
                  return LaunchDetail(launch: launch);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Placeholder
      appBar: AppBar(title: const Text('Launcher Control')),
      body: Center(
        child: padbig(
          ChangeNotifierProvider<LauncherProvider>(
            create: (context) => LauncherProvider(widget.launcherId),
            child: Consumer<LauncherProvider>(
              builder: (context, provider, child) {
                if (provider.launcher == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final launchers = provider.launcher;

                return Card.outlined(
                  elevation: 1,
                  child: padbig(
                    padxbig(
                      maxWProse(
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            padbig(
                              Icon(
                                Icons.rocket_launch,
                                size: 64,
                                color: Theme.of(context).colorScheme.primary,
                              ),
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

                            Text(
                              'Launching: ',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),

                            padtopbig(
                              showCurrentLaunch(context, launchers, false),
                            ),
                            const SizedBox(height: 16),

                            Text(
                              'Old launch: ',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            padtopbig(
                              showCurrentLaunch(context, launchers, true),
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
          ),
        ),
      ),
    );
  }
}
