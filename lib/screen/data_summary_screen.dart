import 'package:flutter/material.dart';

class DataSummaryScreen extends StatefulWidget {
  final String cubeType;
  const DataSummaryScreen({Key? key, required this.cubeType}) : super(key: key);

  @override
  State<DataSummaryScreen> createState() => _DataSummaryScreenState();
}

class _DataSummaryScreenState extends State<DataSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('DataSummaryScreen'),
      ),
    );
  }
}
