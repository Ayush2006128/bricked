import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

import 'components/components.dart';
import 'config.dart';

enum PlayState { welcome, playing, gameOver, won }

class BrickBreaker extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapCallbacks {
  BrickBreaker()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<int> highScore = ValueNotifier(0);
  final ValueNotifier<int> lives = ValueNotifier(3);
  int bricksRemaining = 0;
  bool newHighScoreAchieved = false;
  final rand = math.Random();
  double get width => size.x;
  double get height => size.y;

  AudioPool? batCollision;
  AudioPool? brickCollision;
  AudioPool? gameOver;
  AudioPool? gameWin;

  late PlayState _playState;
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
        if (score.value > highScore.value) {
          highScore.value = score.value;
          Hive.box('bricked').put('highScore', highScore.value);
          newHighScoreAchieved = true;
        }
        overlays.add(playState.name);
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());

    highScore.value = Hive.box('bricked').get('highScore', defaultValue: 0);

    FlameAudio.bgm.initialize();

    try {
      await FlameAudio.audioCache.loadAll([
        'background.mp3',
        'collide-bat.wav',
        'collide-brick.wav',
        'game-over.wav',
        'win.wav',
      ]);

      batCollision = await FlameAudio.createPool(
        'collide-bat.wav',
        minPlayers: 1,
        maxPlayers: 4,
      );
      brickCollision = await FlameAudio.createPool(
        'collide-brick.wav',
        minPlayers: 1,
        maxPlayers: 4,
      );
      gameOver = await FlameAudio.createPool(
        'game-over.wav',
        minPlayers: 1,
        maxPlayers: 2,
      );
      gameWin = await FlameAudio.createPool(
        'win.wav',
        minPlayers: 1,
        maxPlayers: 2,
      );
    } catch (e) {
      // Sounds failed to load
    }

    playState = PlayState.welcome;
  }

  void startGame() {
    if (playState == PlayState.playing) return;

    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());

    playState = PlayState.playing;
    score.value = 0;
    lives.value = 3;
    newHighScoreAchieved = false;
    bricksRemaining = brickColors.length * 5;
    FlameAudio.bgm.play("background.mp3", volume: 0.7);
    world.add(
      Ball(
        difficultyModifier: difficultyModifier,
        radius: ballRadius,
        position: size / 2,
        velocity: Vector2(
          (rand.nextDouble() - 0.5) * width,
          height * 0.2,
        ).normalized()
          ..scale(height / 4),
      ),
    );

    world.add(
      Bat(
        size: Vector2(batWidth, batHeight),
        cornerRadius: const Radius.circular(ballRadius / 2),
        position: Vector2(width / 2, height * 0.95),
      ),
    );

    world.addAll([
      for (var i = 0; i < brickColors.length; i++)
        for (var j = 1; j <= 5; j++)
          Brick(
            position: Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickGutter,
              (j + 2.0) * brickHeight + j * brickGutter,
            ),
            color: brickColors[i],
          ),
    ]);
  }

  void onBallLost() {
    lives.value--;
    if (lives.value > 0) {
      world.add(
        Ball(
          difficultyModifier: difficultyModifier,
          radius: ballRadius,
          position: size / 2,
          velocity: Vector2(
            (rand.nextDouble() - 0.5) * width,
            height * 0.2,
          ).normalized()
            ..scale(height / 4),
        ),
      );
    } else {
      playState = PlayState.gameOver;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    startGame();
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        world.children.query<Bat>().first.moveBy(-batStep);
      case LogicalKeyboardKey.arrowRight:
        world.children.query<Bat>().first.moveBy(batStep);
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        startGame();
    }
    return KeyEventResult.handled;
  }

  @override
  Color backgroundColor() => const Color(0xfff2e8cf);

  Future<void> onBrickBroken() async {
    bricksRemaining--;
    if (bricksRemaining <= 0) {
      playState = PlayState.won;
      try {
        await gameWin?.start();
      } catch (e) {
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate(preset: VibrationPreset.doubleBuzz);
        }
      }
      world.removeAll(world.children.query<Ball>());
      world.removeAll(world.children.query<Bat>());
    }
  }
}
