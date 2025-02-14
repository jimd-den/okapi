import 'package:flutter/material.dart';
import '../widgets/terminal_widgets.dart';
import 'app.dart';
import 'settings_screen.dart';
import 'work_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: settingsService.settings,
          builder:
              (context, settings, child) =>
                  Text(settings?.workTaskerLabel ?? 'Work Tasker'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: settingsService.settings,
              builder:
                  (context, settings, child) => Text(
                    settings?.readyToWorkLabel ?? 'Ready to get to work?',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder(
              valueListenable: settingsService.settings,
              builder:
                  (context, settings, child) => TerminalButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WorkScreen(),
                        ),
                      );
                    },
                    child: Text(
                      settings?.startWorkdayLabel ?? 'Start Workday!',
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
