import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OverlayScreen extends StatelessWidget {
  const OverlayScreen(
      {super.key, required this.title, required this.subtitle, this.newHighScore});

  final String title;
  final String subtitle;
  final int? newHighScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, -0.15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
          ).animate().slideY(duration: 750.ms, begin: -3, end: 0),
          const SizedBox(height: 16),
          if (newHighScore != null)
            ...[
              Text(
                'New High Score: $newHighScore'.toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium,
              ).animate().slideY(duration: 750.ms, delay: 250.ms, begin: -2, end: 0),
              const SizedBox(height: 16),
            ],
          Text(subtitle, style: Theme.of(context).textTheme.headlineSmall)
              .animate(onPlay: (controller) => controller.repeat())
              .fadeIn(duration: 1.seconds)
              .then()
              .fadeOut(duration: 1.seconds),
        ],
      ),
    );
  }
}
