import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_app/data/repository/Repository.dart';
import 'package:music_app/ui/home/home.dart';

import 'firebase_options.dart';

Future<void>main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo Flutter đã sẵn sàng
  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MusicApp());
}
