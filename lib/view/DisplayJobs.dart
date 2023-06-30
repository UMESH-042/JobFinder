import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DisplayJobs extends StatefulWidget {
  const DisplayJobs({super.key});

  @override
  State<DisplayJobs> createState() => _DisplayJobsState();
}

class _DisplayJobsState extends State<DisplayJobs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Trending Jobs'),
      ),
    );
  }
}
