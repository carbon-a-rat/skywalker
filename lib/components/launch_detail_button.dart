import 'package:flutter/material.dart';
import 'package:skywalker/components/pad.dart';
import 'package:skywalker/pages/launch_details.dart';
import 'package:skywalker/server/models/launch.dart';

class LaunchDetail extends StatelessWidget {
  final Launch launch;

  const LaunchDetail({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    return padxsmall(
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
                  builder: (context) => LaunchDetailsPage(launchId: launch.id!),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
