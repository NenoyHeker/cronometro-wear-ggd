import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

//////  Cronometro
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cronometro Cool',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.compact,
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return TimerScreen(mode);
          },
        );
      },
    );
  }
}

class TimerScreen extends StatefulWidget {
  // const TimerScreen({super.key});

  final WearMode mode;

  const TimerScreen(this.mode, {super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  late int _count;
  late String _strCount;
  late String _status;

  @override
  void initState() {
    _count = 0;
    _strCount = "00:00:00";
    _status = "Start";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.mode == WearMode.active ? Colors.black : Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10.0),
            const Center(
              child: Icon(
                Icons.timelapse,
                color: Color.fromARGB(255, 177, 0, 189),
                size: 50.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Center(
              child: Text(
                _strCount,
                style: TextStyle(
                    color: widget.mode == WearMode.active
                        ? Color.fromARGB(255, 177, 0, 189)
                        : Color.fromARGB(255, 130, 130, 130),
                    fontSize: widget.mode == WearMode.active ? 28.0 : 45.0),
              ),
            ),
            SizedBox(height: 4.0),
            _buildWidgetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetButton() {
    return Ink(
        color: widget.mode == WearMode.active
            ? Color.fromARGB(255, 24, 24, 24)
            : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent),
              onPressed: () {
                if (_status == "Start") {
                  _startTimer();
                } else if (_status == "Stop") {
                  _timer.cancel();
                  setState(() {
                    _status = "Continue";
                  });
                } else if (_status == "Continue") {
                  _startTimer();
                }
              },
              child: Text(_status,
                  style: TextStyle(
                      color: widget.mode == WearMode.active
                          ? Color.fromARGB(255, 177, 0, 189)
                          : Color.fromARGB(255, 130, 130, 130))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent),
              onPressed: () {
                if (_timer != null) {
                  _timer.cancel();
                  setState(() {
                    _count = 0;
                    _strCount = "00:00:00";
                    _status = "Start";
                  });
                }
              },
              child: Text("Reset",
                  style: TextStyle(
                      color: widget.mode == WearMode.active
                          ? Color.fromARGB(255, 177, 0, 189)
                          : Color.fromARGB(255, 130, 130, 130))),
            ),
          ],
        ));
  }

  void _startTimer() {
    _status = "Stop";
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _count += 1;
        int hour = _count ~/ 3600;
        int minute = (_count % 3600) ~/ 60;
        int second = (_count % 3600) % 60;
        _strCount = hour < 10 ? "0$hour" : "$hour";
        _strCount += ":";
        _strCount += minute < 10 ? "0$minute" : "$minute";
        _strCount += ":";
        _strCount += second < 10 ? "0$second" : "$second";
      });
    });
  }
}
