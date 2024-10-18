import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/ui/home/home.dart';

import '../ui/login/login.dart';
import 'db.dart';

class AuthService {

  var db = Db();

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
        MaterialPageRoute(builder: (context) => const HomeTabPage()),
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
