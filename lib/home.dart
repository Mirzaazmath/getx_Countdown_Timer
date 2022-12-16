import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class FinalView extends StatelessWidget {
  const FinalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var timerController = Get.find<TimerController>();
    var themeController = Get.find<ThemeController>();
    // var textTheme = Theme.of(context).textTheme;
    // var iconTheme = Theme.of(context).iconTheme;

    return Scaffold(
      appBar: const MyAppBar(),
      body: Container(
        margin: const EdgeInsets.all(10),
        width: Get.width,
        height: Get.height,
        child: GetBuilder<TimerController>(
            init: TimerController(),
            builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Center Circle
                  GetBuilder<ThemeController>(
                      id: 1,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode
                                ? const Color.fromARGB(255, 21, 21, 21)
                                : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10.0,
                                  offset: const Offset(5, 5),
                                  color: themeController.isDarkMode
                                      ? Colors.black
                                      : const Color.fromARGB(
                                      109, 144, 144, 144)),
                              BoxShadow(
                                  blurRadius: 10.0,
                                  offset: const Offset(-5, -5),
                                  color: themeController.isDarkMode
                                      ? const Color.fromARGB(255, 27, 27, 27)
                                      : const Color.fromARGB(
                                      255, 243, 243, 243))
                            ],
                          ),
                          width: 300,
                          height: 300,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: CircularProgressIndicator(
                                  strokeWidth: 20,
                                  valueColor: AlwaysStoppedAnimation(
                                      timerController.seconds == 60
                                          ? Colors.green
                                          : Colors.red),
                                  backgroundColor: themeController.isDarkMode
                                      ? const Color.fromARGB(255, 34, 34, 34)
                                      : const Color.fromARGB(
                                      255, 237, 237, 237),
                                  value: timerController.seconds /
                                      TimerController.maxSeconds,
                                ),
                              ),
                              Center(
                                child: Text(
                                  timerController.seconds.toString(),
                                  style: TextStyle(
                                    fontSize: 100,
                                    fontWeight: FontWeight.bold,
                                    color: timerController.isCompleted()
                                        ? const Color.fromARGB(255, 8, 123, 12)
                                        : const Color.fromARGB(255, 178, 14, 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  const SizedBox(
                    height: 50,
                  ),

                  /// Buttons
                  timerController.isTimerRuning() ||
                      !timerController.isCompleted()
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ButtonWidget(
                          onTap: () {
                            timerController.isTimerRuning()
                                ? timerController.stopTimer(rest: false)
                                : timerController.startTimer(rest: false);
                          },
                          text: timerController.isTimerRuning()
                              ? "Pause"
                              : "Resume",
                          color: timerController.isTimerRuning()
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.w400),
                      ButtonWidget(
                          onTap: () {
                            timerController.stopTimer(rest: true);
                          },
                          text: "Cancel",
                          color: Colors.red,
                          fontWeight: FontWeight.w600)
                    ],
                  )
                      : GetBuilder<ThemeController>(
                    init: ThemeController(),
                    id: 1,
                    initState: (_) {},
                    builder: (_) {
                      return ButtonWidget(
                        onTap: () {
                          timerController.startTimer();
                        },
                        text: "Start",
                        color: themeController.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w400,
                      );
                    },
                  ),
                ],
              );
            }),
      ),
    );
  }
}

/// MyApp Bar
class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeController = Get.find<ThemeController>();
    var textTheme = Theme.of(context).textTheme;
    var iconTheme = Theme.of(context).iconTheme;
    return AppBar(
      title: Text("Timer", style: textTheme.headline1),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        GetBuilder<ThemeController>(
          init: ThemeController(),
          id: 1,
          initState: (_) {},
          builder: (_) {
            return IconButton(
                onPressed: () {
                  themeController.changeThemeOfButtons();
                  themeController.isDarkMode
                      ? Get.changeThemeMode(ThemeMode.dark)
                      : Get.changeThemeMode(ThemeMode.light);
                },
                icon: Icon(
                  themeController.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: iconTheme.color,
                  size: iconTheme.size,
                ));
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}


class ThemeController extends GetxController {
  bool isDarkMode = Get.isDarkMode;

  void changeThemeOfButtons() {
    isDarkMode = !isDarkMode;
    update([1]);
  }
}
class TimerController extends GetxController {
  static const maxSeconds = 60;
  var seconds = maxSeconds;
  Timer? timer;

  /// Start Timer
  void startTimer({bool rest = true}) {
    if (rest) {
      resetTimer();
      update();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
        update();
      } else {
        stopTimer(rest: false);
        resetTimer();
      }
    });
  }

  /// Stop Timer
  void stopTimer({bool rest = true}) {
    if (rest) {
      resetTimer();
      update();
    }
    timer?.cancel();
    update();
  }

  /// Reset Timer
  void resetTimer() {
    seconds = maxSeconds;
    update();
  }

  /// is Timer Active?
  bool isTimerRuning() {
    return timer == null ? false : timer!.isActive;
  }

  /// is Timer Completed?
  bool isCompleted() {
    return seconds == maxSeconds || seconds == 0;
  }
}
class MyBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TimerController());
    Get.lazyPut(() => ThemeController());
  }
}
class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onTap,
    required this.color,
    required this.fontWeight,
  }) : super(key: key);
  final String text;
  final Color color;
  final VoidCallback onTap;
  final FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    var themeController = Get.find<ThemeController>();

    return GestureDetector(
      onTap: onTap,
      child: GetBuilder<ThemeController>(
          id: 1,
          builder: (context) {
            return Container(
              width: Get.width / 5,
              height: Get.height / 14,
              decoration: BoxDecoration(
                  color: themeController.isDarkMode
                      ? const Color.fromARGB(255, 21, 21, 21)
                      : Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10.0,
                        offset: const Offset(5, 5),
                        color: themeController.isDarkMode
                            ? Colors.black
                            : const Color.fromARGB(109, 144, 144, 144)),
                    BoxShadow(
                        blurRadius: 10.0,
                        offset: const Offset(-5, -5),
                        color: themeController.isDarkMode
                            ? const Color.fromARGB(255, 27, 27, 27)
                            : const Color.fromARGB(255, 243, 243, 243))
                  ],
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontSize: 19,
                    fontWeight: fontWeight,
                  ),
                ),
              ),
            );
          }),
    );
  }
}