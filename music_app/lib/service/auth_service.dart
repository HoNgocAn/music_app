import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/ui/home/home.dart';

import '../ui/login/login.dart';
import 'db.dart';

class AuthService {

  var db = Db();

  // Kiểm tra xem người dùng đã đăng nhập hay chưa
  User? checkUserLoggedIn() {
    return FirebaseAuth.instance.currentUser;
  }
  // Lấy email của người dùng đã đăng nhập
  String? getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email; // Trả về email nếu người dùng đã đăng nhập
  }

  Future<bool> createUser(data, context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data["email"],
        password: data["password"],
      );

      await db.addUser(data, context);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
      return true;

    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred: $e'), // Hiển thị lỗi
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }
  }
  Future<bool> loginUser(data, context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data["email"],
        password: data["password"],
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MusicHomePage()),
            (Route<dynamic> route) => false, // Xóa tất cả các route trước đó
      );
      return true;
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Email or password is incorrect, please check again'), // Hiển thị lỗi
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }
  }
}
