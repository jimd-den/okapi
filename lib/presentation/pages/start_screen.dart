import 'package:flutter/material.dart';
import '../widgets/simple_widgets.dart';
import 'app.dart';
import 'work_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: settingsService.settings,
          builder:
              (context, settings, child) => Text(
                settings.workTaskerLabel,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onBackground,
                ),
              ),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: settingsService.settings,
            builder:
                (context, settings, child) => IconButton(
                  icon: Icon(
                    settings.useHighContrast
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: theme.colorScheme.onBackground,
                  ),
                  onPressed: () {
                    final newSettings = settings.copyWith(
                      useHighContrast: !settings.useHighContrast,
                    );
                    settingsService.updateSettings(newSettings);
                  },
                  tooltip:
                      settings.useHighContrast
                          ? 'Switch to Light Mode'
                          : 'Switch to Dark Mode',
                ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.colorScheme.surface, theme.colorScheme.background],
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(32),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Ready to track your work?',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: SimpleButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WorkScreen(),
                          ),
                        );
                      },
                      child: const Text('Start Working'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
