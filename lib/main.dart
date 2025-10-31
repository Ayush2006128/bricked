import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/widgets/game_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('bricked');

  runApp(const GameApp());
}
