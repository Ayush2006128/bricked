import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flame_audio/flame_audio.dart';

import 'src/widgets/game_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlameAudio.bgm.initialize();
  FlameAudio.audioCache.loadAll([
    "background.mp3",
    "collide-bat.wav",
    "collide-brick.wav",
    "win.wav",
    "game-over.wav",
  ]);

  await Hive.initFlutter();
  await Hive.openBox('bricked');

  runApp(const GameApp());
}
