import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class FlipClock extends StatefulWidget {
  final int onTime;
  final Duration timerDuration;
  final int limit;
  final int start;

  const FlipClock({
    super.key,
    required this.onTime,
    required this.timerDuration,
    required this.limit,
    required this.start,
  });

  @override
  State<FlipClock> createState() => _FlipClockState();
}

class _FlipClockState extends State<FlipClock>
    with SingleTickerProviderStateMixin {
  // data types
  late AnimationController _controller;
  late Animation _animation;
  late Timer _timer;
  late int _clockCount;

  @override
  void initState() {
    _clockCount = widget.onTime;
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    _animation =
        Tween<double>(end: math.pi, begin: math.pi * 2).animate(_controller);

    _animation.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  BoxDecoration _boxDecoration(bool top) {
    return BoxDecoration(
      color: const Color.fromRGBO(20, 20, 20, 1),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(top ? 10 : 0),
        topRight: Radius.circular(top ? 10 : 0),
        bottomLeft: Radius.circular(top ? 0 : 10),
        bottomRight: Radius.circular(top ? 0 : 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // 1st half container A
              children: [
                Container(
                  decoration: _boxDecoration(true),
                  height: 99,
                  width: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 28,
                        child: _clockTimerWidget(),
                      )
                    ],
                  ),
                ),

                // balance of 2.0 distance between clock
                const Divider(
                  height: 2,
                  color: Colors.transparent,
                ),

                // 2nd half container B
                Stack(
                  children: [
                    Container(
                      height: 99,
                      width: 200,
                      decoration: _boxDecoration(false),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            bottom: 28,
                            child: _clockTimerWidget(),
                          ),
                        ],
                      ),
                    ),
                    AnimatedBuilder(
                      // this container will have future sec
                      animation: _animation,
                      child: Container(
                        height: 99,
                        width: 200,
                        decoration: _boxDecoration(false),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            _animation.value > 4.71
                                ? Positioned(
                                    bottom: 30,
                                    child: _clockTimerWidget(),
                                  )
                                : Positioned(
                                    top: 72,
                                    child: Transform(
                                      transform: Matrix4.rotationX(math.pi),
                                      child: _clockTimerWidget(),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.topCenter,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.003)
                            ..rotateX(_animation.value),
                          child: child,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 99),
              child: Container(
                height: 2.0,
                width: 200,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _clockTimerWidget() {
    return Text(
      _clockCount.toString().padLeft(2, '0'),
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 100,
      ),
    );
  }

  void _startTimer() {
    Duration fliperDuration = widget.timerDuration;

    _timer = Timer.periodic(fliperDuration, (Timer timer) {
      if (mounted) {
        if (_clockCount != widget.limit) {
          _controller.reset();
          setState(() {
            _clockCount++;
          });
          _controller.forward();
        } else {
          setState(() {
            _clockCount = widget.onTime;
          });
        }
      }
    });
  }
}
