import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../service/auth_service.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {

  User? currentUser;

  String? emailUser;

  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();

    // Kiểm tra người dùng đã đăng nhập hay chưa trong initState
    currentUser = authService.checkUserLoggedIn();

    emailUser = authService.getUserEmail();

    if (currentUser != null) {
      print("User is logged in: ${currentUser!.email}");
    } else {
      print("No user is logged in.");
    }
    // Nếu muốn cập nhật UI khi user thay đổi
    setState(() {
      currentUser = authService.checkUserLoggedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: currentUser != null ?  Text("Email ${emailUser}") : Text("You need login !")
      ),
    );
  }
}

