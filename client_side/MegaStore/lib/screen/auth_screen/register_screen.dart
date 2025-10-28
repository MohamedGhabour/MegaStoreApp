import 'package:flutter/material.dart';
import 'package:mega_shop/screen/auth_screen/login_screen.dart';
import 'package:mega_shop/utility/extensions.dart';

import '../../utility/functions.dart';
import '../../utility/snack_bar_helper.dart';
import 'components/login_button.dart';
import 'components/login_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  // 🟢 Sign user up
  Future<void> signUserUp() async {
    showLoadingDialog(context);

    // تسجيل المستخدم
    final result = await context.userProvider.register();

    // التحقق من أن الـ widget ما زالت موجودة قبل استخدام context
    if (!mounted) return;

    Navigator.pop(context); // إغلاق شاشة التحميل

    if (result == null) {
      // تسجيل ناجح
      context.userProvider.emailController.clear();
      context.userProvider.passwordController.clear();
      context.userProvider.passwordController2.clear();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } else {
      // حدث خطأ
      SnackBarHelper.showErrorSnackBar(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                const Icon(
                  Icons.ac_unit_rounded,
                  size: 100,
                  color: Colors.black87,
                ),

                const SizedBox(height: 25),

                // welcome message
                Text(
                  'Let\'s join nexara family!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 50),

                // email textfield
                LoginTextField(
                  controller: context.userProvider.emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                LoginTextField(
                  controller: context.userProvider.passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // confirm password textfield
                LoginTextField(
                  controller: context.userProvider.passwordController2,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // sign up button
                LoginButton(
                  onTap: signUserUp,
                  buttonText: 'Sign Up',
                ),

                const SizedBox(height: 50),

                // already have an account? login now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
