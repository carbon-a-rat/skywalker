import 'package:flutter/material.dart';
import 'package:skywalker/components/pad.dart';
import 'package:skywalker/components/sizing.dart';

class LaunchSettings {
  double pressure = 0.0;
  double waterVolume = 0.0;
  bool recordData = true;
}

Future<LaunchSettings?> showLaunchSettings(BuildContext context) async {
  TextStyle style = Theme.of(context).textTheme.headlineLarge!;
  LaunchSettings result = LaunchSettings();
  return await showDialog<LaunchSettings>(
    context: context,
    builder: (context) {
      // values
      return StatefulBuilder(
        builder:
            (context, setState) => SizedBox(
              height: 500,
              child: Dialog(
                child: pad(
                  maxWProse(
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            pad(
                              Text(
                                "Create a launch",
                                style: style.apply(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                        pad(Text("Launch parameters")),
                        pad(
                          Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Pressure (psi)",
                                  border: OutlineInputBorder(),
                                  icon: Icon(Icons.speed),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  result.pressure =
                                      double.tryParse(value) ?? 0.0;
                                },
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                initialValue: "100",
                                decoration: InputDecoration(
                                  labelText: "Water Volume (ml)",
                                  border: OutlineInputBorder(),

                                  icon: Icon(Icons.water_drop),
                                ),

                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  result.waterVolume =
                                      double.tryParse(value) ?? 0.0;
                                },
                              ),
                              SizedBox(height: 16),
                              SwitchListTile(
                                title: Text("Record Data"),
                                value: result.recordData,
                                onChanged: (value) {
                                  setState(() {
                                    result.recordData = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        pad(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, result);
                                },
                                child: Text("Create Launch"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      );
    },
  );
}
