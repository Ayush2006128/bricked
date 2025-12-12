import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    super.key,
    required this.score,
    required this.lives,
  });

  final ValueNotifier<int> score;
  final ValueNotifier<int> lives;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: score,
      builder: (context, score, child) {
        return ValueListenableBuilder<int>(
          valueListenable: lives,
          builder: (context, lives, child) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 18),
              child: Column(
                children: [
                  Text(
                    'Score: $score'.toUpperCase(),
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: index < lives
                                ? const Color(0xff1e6091)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xff1e6091),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}