import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/Song.dart';
import "package:http/http.dart" as http;

abstract interface class DataSource {
  Future<List<Song>?> loadData();
}

class RemoteDataSource implements DataSource {
  @override
  Future<List<Song>?> loadData() async {
    try {
      const url = "https://thantrieu.com/resources/braniumapis/songs.json";
      final uri = Uri.parse(url);
      final rs = await http.get(uri);
      if (rs.statusCode == 200) {
        final bodyContent = utf8.decode(rs.bodyBytes);
        var songWrapper = jsonDecode(bodyContent) as Map;
        var songList = songWrapper['songs'] as List;
        List<Song> songs = songList.map((song) => Song.fromMap(song)).toList();
        return songs;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

class LocalDataSource implements DataSource {
  @override
  Future<List<Song>?> loadData() async{
    final String rs = await rootBundle.loadString("assets/songs.json");
    final jsonBody = jsonDecode(rs) as Map;
    final songList = jsonBody['songs'] as List;
    List<Song> songs = songList.map((song) => Song.fromMap(song)).toList();
    return songs;
  }
}
