import 'dart:io';

import 'package:bricked/src/brick_breaker.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  testWidgets('Winning the game sets PlayState to won', (WidgetTester tester) async {
    // Initialize Hive
    final path = Directory.systemTemp.path;
    if (!Hive.isBoxOpen('bricked')) {
      Hive.init(path);
      await Hive.openBox('bricked');
    }

    final game = BrickBreaker();

    await tester.pumpWidget(
      GameWidget(
        game: game,
        overlayBuilderMap: {
          'won': (context, game) => Container(),
          'gameOver': (context, game) => Container(),
          'welcome': (context, game) => Container(),
        },
      ),
    );
    
    // Wait for onLoad (which happens on attach)
    await tester.pump();

    // Manually set state to playing to reset any welcome state
    game.playState = PlayState.playing;
    
    // Simulate being near win
    game.bricksRemaining = 1;

    // Trigger brick broken
    await game.onBrickBroken();

    expect(game.playState, PlayState.won);
    expect(game.bricksRemaining, 0);
    
    // Cleanup handled by teardown usually, but box closing is manual
    // await Hive.box('bricked').close(); // Avoid closing if reused in other tests in same suite
  });

  testWidgets('Breaking brick decreases count but does not win if bricks remain', (WidgetTester tester) async {
     // Initialize Hive
    final path = Directory.systemTemp.path;
    if (!Hive.isBoxOpen('bricked')) {
        Hive.init(path);
        await Hive.openBox('bricked');
    }

    final game = BrickBreaker();
    
     await tester.pumpWidget(
      GameWidget(
        game: game,
        overlayBuilderMap: {
          'won': (context, game) => Container(),
          'gameOver': (context, game) => Container(),
          'welcome': (context, game) => Container(),
        },
      ),
    );
    await tester.pump();
    
    game.playState = PlayState.playing;
    game.bricksRemaining = 2;
    
    await game.onBrickBroken();
    
    expect(game.playState, PlayState.playing);
    expect(game.bricksRemaining, 1);
  });
}