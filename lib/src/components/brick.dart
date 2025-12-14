import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../brick_breaker.dart';
import '../config.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Brick({required super.position, required Color color})
      : super(
          size: Vector2(brickWidth, brickHeight),
          anchor: Anchor.center,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
          children: [RectangleHitbox()],
        );

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) async {
    super.onCollisionStart(intersectionPoints, other);
    removeFromParent();
    game.score.value++;
    try {
      await game.brickCollision?.start();
    } catch (e) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 50, amplitude: 250);
      }
    }
    game.onBrickBroken();
  }
}
