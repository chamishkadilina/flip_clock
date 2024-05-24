import 'package:flip_clock/flip_clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _currentDateTime = DateTime.now();
  bool _isListening = false;

  // stream function
  final Stream<DateTime> _timer =
      Stream.periodic(const Duration(seconds: 1), (i) {
    return DateTime.now();
  });

  void _listenToTime() {
    _timer.listen((event) {
      setState(() {
        _currentDateTime = event;
      });
    });
    _isListening = true;
  }

  @override
  void initState() {
    super.initState();
    if (!_isListening) {
      _listenToTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: OrientationBuilder(
            builder: (context, layout) {
              if (layout == Orientation.landscape) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 2 - 124),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FlipClock(
                        onTime: _currentDateTime.hour,
                        timerDuration:
                            Duration(minutes: 60 - _currentDateTime.minute),
                        limit: 23,
                        start: 00,
                      ),
                      FlipClock(
                        onTime: _currentDateTime.minute,
                        timerDuration:
                            Duration(seconds: 60 - _currentDateTime.second),
                        limit: 59,
                        start: 00,
                      ),
                      FlipClock(
                        onTime: _currentDateTime.second,
                        timerDuration: const Duration(seconds: 1),
                        limit: 59,
                        start: 00,
                      ),
                    ],
                  ),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlipClock(
                      onTime: _currentDateTime.hour,
                      timerDuration:
                          Duration(minutes: 60 - _currentDateTime.minute),
                      limit: 23,
                      start: 00,
                    ),
                    FlipClock(
                      onTime: _currentDateTime.minute,
                      timerDuration:
                          Duration(seconds: 60 - _currentDateTime.second),
                      limit: 59,
                      start: 00,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
