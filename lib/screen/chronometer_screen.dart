import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sctimer/class/session_statics.dart';
import 'package:sctimer/control/scramble_control.dart';
import 'package:sctimer/screen/data_summary_screen.dart';

class ChronometerScreen extends StatefulWidget {
  const ChronometerScreen({Key? key}) : super(key: key);

  @override
  State<ChronometerScreen> createState() => _ChronometerScreenState();
}

class _ChronometerScreenState extends State<ChronometerScreen>
    with HooksMixin<ChronometerScreen> {
  final puzzles = ["2x2x2", "3x3x3", "4x4x4", "5x5x5", "6x6x6", "7x7x7"];
  int selectedIndex = 1;
  final _stopwatch = Stopwatch();
  final _stopwatchInspection = Stopwatch();
  bool inspectioning = false;
  bool solving = false;
  bool isPlusTwo = false;
  bool isDNF = false;
  bool gettingScramble = false;
  String scramble = "";
  String cubeType = "333";

  late final Stream<int> _timerStream;
  late final StreamSubscription<int> _timerSubscription;
  late final Stream<int> _timerInspectionStream;
  late final StreamSubscription<int> _timerInspectionSubscription;
  Color scaffoldColor = Colors.white; // Default scaffold background color

  void getScramble() async {
    gettingScramble = true;
    setState(() {});
    if (!ScrambleControl.running) {
      scramble = await ScrambleControl.getScramble(cubeType);
    }
    gettingScramble = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getScramble();
    _timerStream = Stream<int>.periodic(
        const Duration(milliseconds: 1), (i) => _stopwatch.elapsedMilliseconds);
    _timerSubscription = _timerStream.listen((elapsedTime) {
      setState(() {});
    });
    _timerInspectionStream = Stream<int>.periodic(
        const Duration(milliseconds: 1),
        (i) => _stopwatchInspection.elapsedMilliseconds);
    _timerInspectionSubscription = _timerInspectionStream.listen((elapsedTime) {
      if (elapsedTime >= 15000) {
        setState(() {
          isPlusTwo = true;
          scaffoldColor = Colors.orange;
        });
      } else if (elapsedTime > 0 && elapsedTime < 15000) {
        setState(() {
          isPlusTwo = false;
          scaffoldColor = Colors.blue;
        });
      } else {
        setState(() {
          isPlusTwo = false;
          scaffoldColor = Colors.white;
        });
      }
    });
  }

  @override
  void dispose() {
    _timerSubscription.cancel();
    _timerInspectionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget buildWithHooks(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(SessionStatics.user)],
        ),
      ),
      body: gettingScramble
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          onPressed: () {
                            getScramble();
                          },
                          icon: const Icon(Icons.replay)),
                      DropdownButton<String>(
                        value: puzzles[selectedIndex],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedIndex = puzzles.indexOf(newValue!);
                            switch (newValue) {
                              case "2x2x2":
                                cubeType = "222";
                                break;
                              case "4x4x4":
                                cubeType = "444";
                                break;
                              case "5x5x5":
                                cubeType = "555";
                                break;
                              case "6x6x6":
                                cubeType = "666";
                                break;
                              case "7x7x7":
                                cubeType = "777";
                                break;
                              default:
                                cubeType = "333";
                                break;
                            }
                            getScramble();
                          });
                        },
                        items: puzzles.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DataSummaryScreen(cubeType: cubeType)),
                            );
                          },
                          icon: const Icon(Icons.storage)),
                    ],
                  ),
                ),
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        scramble,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTapDown: (details) {
                      // Start the inspection timer when tapped down
                      setState(() {
                        if (!solving) {
                          _stopwatch.reset();
                          inspectioning = true;
                          _stopwatchInspection.start();
                        }
                      });
                    },
                    onTapUp: (details) {
                      // Stop the inspection timer when tapped up
                      setState(() {
                        inspectioning = false;
                        solving = !solving;
                        _stopwatchInspection.stop();
                        // Reset the inspection timer for the next tap down
                        _stopwatchInspection.reset();
                        // Start or stop the main stopwatch based on its current state
                        if (_stopwatch.isRunning) {
                          _stopwatch.stop();
                          getScramble();
                        } else {
                          _stopwatch.start();
                        }
                        // Reset the background color to default after stopping the inspection
                        scaffoldColor = Colors.white;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          formatDuration(Duration(
                              milliseconds: inspectioning
                                  ? _stopwatchInspection.elapsedMilliseconds
                                  : _stopwatch.elapsedMilliseconds)),
                          style: const TextStyle(fontSize: 60),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: Container(
                                  width: 100,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: isPlusTwo
                                          ? Colors.green
                                          : Colors.white,
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Text(
                                    '+2',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                )),
                            TextButton(
                                onPressed: () {},
                                child: Container(
                                  width: 100,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color:
                                          isDNF ? Colors.green : Colors.white,
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Text(
                                    'DNF',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
      backgroundColor:
          scaffoldColor, // Set the background color of the scaffold
    );
  }
}

mixin HooksMixin<T extends StatefulWidget> on State<T> {
  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) => buildWithHooks(context),
    );
  }

  Widget buildWithHooks(BuildContext context);
}

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String threeDigits(int n) => n.toString().padLeft(3, "0");

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  String threeDigitMilliseconds =
      threeDigits(duration.inMilliseconds.remainder(1000));
  if (int.parse(twoDigitMinutes) > 0) {
    return "$twoDigitMinutes:$twoDigitSeconds.$threeDigitMilliseconds";
  } else {
    return "${int.parse(twoDigitSeconds)}.$threeDigitMilliseconds";
  }
}
