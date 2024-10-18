import 'package:flutter/material.dart';

import '../utils/appvalidator.dart';
import 'login.dart';

import '../../service/auth_service.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  var authService = AuthService();
  var isLoader = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      var data = {
        "username": _userNameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "password": _passwordController.text,
      };

      try {
        bool isSuccess = await authService.createUser(data, context);

        if (isSuccess) {
          _userNameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _passwordController.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User created successfully!'),
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
        // Set isLoader to false in both success and failure cases
        setState(() {
          isLoader = false;
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
                  "Create New Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 50.0),
              TextFormField(
                controller: _userNameController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration("UserName", Icons.person),
                validator: appValidator.validateUser,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: _buildInputDecoration("Email", Icons.email),
                validator: appValidator.validateEmail,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: _buildInputDecoration("PhoneNumber", Icons.call),
                validator: appValidator.validatePhoneNumber,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration("Password", Icons.password),
                validator: appValidator.validatePassword,
                obscureText: true,
              ),
              const SizedBox(height: 40.0),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    isLoader ? debugPrint("Loading") :_submitForm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF15900),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                  child: isLoader
                      ? const Center(child: CircularProgressIndicator())
                      : const Text("Create"),
                ),
              ),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                  );
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Color(0xFFF15900), fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon) {
    return InputDecoration(
      fillColor: const Color(0xAA494A59),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0x35949494)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      filled: true,
      labelStyle: const TextStyle(color: Color(0xFF949494)),
      labelText: label,
      suffixIcon: Icon(
        suffixIcon,
        color: const Color(0xFF949494),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }
}