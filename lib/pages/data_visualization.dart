import 'package:flutter/material.dart';

class DataVisualizationPage extends StatelessWidget {
  const DataVisualizationPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.data_thresholding, size: 100),
          Text('Data Visualization', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
