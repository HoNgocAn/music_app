

import 'dart:async';

import 'package:music_app/data/repository/Repository.dart';

import '../../data/model/Song.dart';

class MusicAppViewModel {
  StreamController<List<Song>> songStream = StreamController();

  // Đánh dấu phương thức là async
  Future<void> loadSong() async {
    final repository = DefaultRepository();
    try {
      // Sử dụng await để đợi dữ liệu từ loadData
      List<Song>? songs = await repository.loadData();
      // Thêm dữ liệu vào stream
      songStream.add(songs!);
    } catch (error) {
      // Xử lý lỗi nếu quá trình load dữ liệu gặp sự cố
      songStream.addError(error);
    }
  }
}