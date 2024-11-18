import 'package:famscreen/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'CameraPage.dart';
import 'RegisterPage.dart';
import '../utils/Colors.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State <LoginPage> {

  void _showButtonPressDialog(BuildContext context, String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider Button Pressed!'),
        backgroundColor: Colors.black26,
        duration: const Duration(milliseconds: 400),
      ),
    );
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Image.asset('assets/logo.png', height: 120),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Masuk',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Masukkan email dan password anda'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined, color: CustomColor.gray),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: CustomColor.primary),
                    borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: CustomColor.primary, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0)),
                labelText: 'Email',
                labelStyle: TextStyle(color: CustomColor.gray),
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outlined, color: CustomColor.gray),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: CustomColor.primary),
                    borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: CustomColor.primary, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0)),
                labelText: 'Password',
                labelStyle: TextStyle(color: CustomColor.gray),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25.0),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signin(
                  email: emailController.text,
                  password: passwordController.text,
                  context: context,
                );

                print('Loginn');
              },
              child: const Text('Login'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text('Atau'),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SignInButton.mini(
                  buttonSize: ButtonSize.medium,
                  buttonType: ButtonType.google,
                  onPressed: () {
                    _showButtonPressDialog(context, 'Google');
                  },
                ),
                SignInButton.mini(
                  buttonType: ButtonType.facebook,
                  buttonSize: ButtonSize.medium,
                  onPressed: () {
                    _showButtonPressDialog(context, 'Facebook');
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Belum punya akun?'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => RegisterPage()),
                    );
                    print('Daftar');
                  },
                  child: const Text('Daftar',
                      style: TextStyle(color: CustomColor.primary)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
