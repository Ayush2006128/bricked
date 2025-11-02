import 'dart:async';

import 'package:flame/collisions.dart';                         // Add this import
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import 'bat.dart';

class PlayArea extends RectangleComponent
    with DragCallbacks, HasGameReference<BrickBreaker> {
  PlayArea()
      : super(
    paint: Paint()..color = const Color(0xfff2e8cf),
    children: [RectangleHitbox()],                          // Add this parameter
  );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    final bat = game.world.children.query<Bat>().first;
    bat.position.x = (bat.position.x + event.localDelta.x).clamp(0, game.width);
  }
}
