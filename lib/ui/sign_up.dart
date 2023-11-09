import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/firebase_auth/firebase_auth_service.dart';
import 'package:weather_app/login/my_sign_up_button.dart';
import 'package:weather_app/login/text_fill.dart';
import 'package:weather_app/main.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatpasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatpasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),
                Text(
                  'Sign Up!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 25),
                // username textfield
                MyTextField(
                  controller: _emailController,
                  hintText: 'E-Mail',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                // password textfield
                MyTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                button_login(onTap: _signUp),
                const SizedBox(height: 50),
                ],
                )
            ),
          ),
        );
  }
  void _signUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    await FirebaseAuth.instance.
    createUserWithEmailAndPassword(email: email, password: password).then((value) {
      print(value);
      if (email != null && password != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
      else print("Error !!");
    }

    ).onError((error, stackTrace) {
      print("Error!! ${error.toString()}");
    });
    }
}

