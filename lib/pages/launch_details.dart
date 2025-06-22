import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skywalker/components/chart.dart';
import 'package:skywalker/components/launch_detail_button.dart';
import 'package:skywalker/components/pad.dart';
import 'package:skywalker/components/sizing.dart';
import 'package:skywalker/pages/login_page.dart';
import 'package:skywalker/server/models/flight_data.dart';
import 'package:skywalker/server/pocketbase_controller.dart';
import 'package:skywalker/server/providers/flight_data_provider.dart';
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
  Widget showLaunchStats(BuildContext context, List<FlightDataPoint> points) {
    if (points.isEmpty) {
      return const Center(
        child: Text('No flight data available for this launch'),
      );
    }

    List<FlSpot> acc_x;
    List<FlSpot> acc_y;
    List<FlSpot> acc_z;
    List<FlSpot> gyro_x;
    List<FlSpot> gyro_y;
    List<FlSpot> gyro_z;

    List<FlSpot> altitude;
    List<FlSpot> pressure;
    List<FlSpot> temperature;

    acc_x =
        points
            .map((e) => FlSpot(e.timeRel.toDouble(), e.accX.toDouble()))
            .toList();
    acc_y =
        points
            .map((e) => FlSpot(e.timeRel.toDouble(), e.accY.toDouble()))
            .toList();
    acc_z =
        points
            .map((e) => FlSpot(e.timeRel.toDouble(), e.accZ.toDouble()))
            .toList();
    gyro_x =
        points
            .map((e) => FlSpot(e.timeRel.toDouble(), e.gyroX.toDouble()))
            .toList();
    gyro_y =
        points
            .map((e) => FlSpot(e.timeRel.toDouble(), e.gyroY.toDouble()))
            .toList();
    gyro_z =
        points
            .map((e) => FlSpot(e.timeRel.toDouble(), e.gyroZ.toDouble()))
            .toList();
    altitude =
        points
            .map((e) => FlSpot(e.timeRel.toDouble(), e.altitude.toDouble()))
            .toList();
    pressure =
        points
            .map((e) => FlSpot(e.timeRel.toDouble(), e.pressure.toDouble()))
            .toList();
    temperature =
        points
            .map((e) => FlSpot(e.timeRel.toDouble(), e.temperature.toDouble()))
            .toList();

    var chart_acc_x = Chart(
      spots: acc_x,
      title: 'Acceleration X',
      xTitle: 'Time (s)',
      yTitle: 'Acceleration (m/s²)',
      color: const Color.fromARGB(255, 230, 35, 35),
      icon: Icons.keyboard_double_arrow_right,
    );
    var chart_acc_y = Chart(
      spots: acc_y,
      title: 'Acceleration Y',
      xTitle: 'Time (s)',
      yTitle: 'Acceleration (m/s²)',

      color: const Color.fromARGB(255, 35, 230, 35),
      icon: Icons.keyboard_double_arrow_right,
    );

    var chart_acc_z = Chart(
      spots: acc_z,
      title: 'Acceleration Z',
      xTitle: 'Time (s)',
      yTitle: 'Acceleration (m/s²)',

      color: const Color.fromARGB(255, 35, 84, 230),
      icon: Icons.keyboard_double_arrow_right,
    );

    var chart_gyro_x = Chart(
      spots: gyro_x,
      title: 'Gyro X',
      xTitle: 'Time (s)',
      yTitle: 'Gyro (rad/s)',

      color: const Color.fromARGB(255, 230, 35, 35),
      icon: Icons.rotate_90_degrees_ccw,
    );

    var chart_gyro_y = Chart(
      spots: gyro_y,
      title: 'Gyro Y',
      xTitle: 'Time (s)',
      yTitle: 'Gyro (rad/s)',
      color: const Color.fromARGB(255, 35, 230, 35),
      icon: Icons.rotate_90_degrees_ccw,
    );

    var chart_gyro_z = Chart(
      spots: gyro_z,
      title: 'Gyro Z',
      xTitle: 'Time (s)',
      yTitle: 'Gyro (rad/s)',
      color: const Color.fromARGB(255, 35, 84, 230),
      icon: Icons.rotate_90_degrees_ccw,
    );

    var chart_altitude = Chart(
      spots: altitude,
      title: 'Altitude',
      xTitle: 'Time (s)',
      yTitle: 'Altitude (m)',
      color: const Color.fromARGB(255, 230, 35, 230),
      icon: Icons.cloud,
    );

    var chart_pressure = Chart(
      spots: pressure,
      title: 'Pressure',
      xTitle: 'Time (s)',
      yTitle: 'Pressure (Pa)',
      color: const Color.fromARGB(255, 35, 230, 230),
      icon: Icons.speed,
    );

    var chart_temperature = Chart(
      spots: temperature,
      title: 'Temperature',
      xTitle: 'Time (s)',
      yTitle: 'Temperature (°C)',
      color: const Color.fromARGB(255, 230, 136, 35),
      icon: Icons.thermostat_auto,
    );

    List<Chart> charts = [
      chart_acc_x,
      chart_acc_y,
      chart_acc_z,
      chart_gyro_x,
      chart_gyro_y,
      chart_gyro_z,
      chart_altitude,
      chart_pressure,
      chart_temperature,
    ];

    return GridView.builder(
      shrinkWrap: true,

      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 700,
        childAspectRatio: 1.5,
      ),
      itemCount: charts.length,
      itemBuilder: (context, index) {
        return SizedBox(
          child: Card.filled(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 2,
            child: padxsmall(charts[index]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var pbc = getIt<PocketbaseController>();
    // generate random values points from a seed

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

                        ChangeNotifierProvider<FlightDatasProvider>(
                          create:
                              (context) =>
                                  FlightDatasProvider(provider.launches!.id!),
                          child: Consumer<FlightDatasProvider>(
                            builder: (context, flightDataProvider, child) {
                              if (!flightDataProvider.ready) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (flightDataProvider.points.isEmpty) {
                                return const Center(
                                  child: Text('No data available'),
                                );
                              }
                              return showLaunchStats(
                                context,
                                flightDataProvider.points,
                              );
                            },
                          ),
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
