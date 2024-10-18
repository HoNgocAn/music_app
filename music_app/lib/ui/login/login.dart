
import 'package:flutter/material.dart';
import 'package:music_app/ui/home/home.dart';
import 'package:music_app/ui/login/sign_up.dart';

import '../utils/appvalidator.dart';
import '../../service/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}


class _LoginViewState extends State<LoginView> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var isLoader = false;
  var authService = AuthService();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;  // Bắt đầu hiển thị loader
      });

      var data = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };

      try {
        bool isSuccess = await authService.loginUser(data, context);

        if (isSuccess) {
          await Future.delayed(const Duration(seconds: 1));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        // Handle any exceptions here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          isLoader = false; // Ẩn loader sau khi hoàn tất
        });
      }
    }
  }

  final appValidator = AppValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252634),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 80.0),
                const SizedBox(
                  width: 250,
                  child: Text(
                    "Login Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(height: 50.0),
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("Email", Icons.email),
                  validator: appValidator.validateEmail,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("Password", Icons.password),
                  validator: appValidator.validatePassword,
                  obscureText: true,
                ),
                const SizedBox(height: 40.0),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoader ? null : () {
                      _submitForm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF15900), // Màu nền của nút
                      foregroundColor: Colors.white, // Màu chữ (foreground)
                      textStyle: const TextStyle(fontSize: 18), // Kích thước chữ
                    ),
                    child: isLoader
                        ? const Center(child: CircularProgressIndicator())
                        : const Text("Login",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> const SignUpView()));
                    },
                    child: const Text(
                      "Create New Account",
                      style: TextStyle(color: Color(0xFFF15900), fontSize: 22),
                    )),
                const SizedBox(height: 250.0),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> const MusicHomePage()));
                    },
                    child: const Text(
                      "Back",
                      style: TextStyle(color: Colors.blue, fontSize: 22),
                    )),
              ],
            )),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon) {
    return InputDecoration(
        fillColor: const Color(0xAA494A59),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x35949494))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        filled: true,
        labelStyle: const TextStyle(color: Color(0xFF949494)),
        labelText: label,
        suffixIcon: Icon(
          suffixIcon,
          color: const Color(0xFF949494),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)));
  }
}