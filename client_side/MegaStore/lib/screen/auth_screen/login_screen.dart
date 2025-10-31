import 'package:flutter/material.dart';
import 'package:mega_shop/screen/auth_screen/register_screen.dart';
import 'package:mega_shop/utility/extensions.dart';

import '../../utility/functions.dart';
import '../../utility/snack_bar_helper.dart';
import '../home_screen.dart';
import 'components/login_button.dart';
import 'components/login_textfield.dart';
import 'components/square_tile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 🟢 Sign user in
  Future<void> signUserIn() async {
    showLoadingDialog(context);
    final result = await context.userProvider.login();
    if (!mounted) return;
    Navigator.pop(context);
    if (result == null) {
      context.userProvider.emailController.clear();
      context.userProvider.passwordController.clear();
      context.userProvider.passwordController2.clear();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      SnackBarHelper.showErrorSnackBar(result);
    }
  }

  @override
  void initState() {
    super.initState();
    checkServerConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 249, 250, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // 👆 أي عناصر من Figma ممكن تتحط هنا مثل status bar أو decorations
              Column(
                children: [
                  const SizedBox(height: 128),
                  // العنوان الرئيسي
                  const Text(
                    'Hello Again!',
                    style: TextStyle(
                      color: Color.fromRGBO(26, 36, 47, 1),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome Back You’ve Been Missed!',
                    style: TextStyle(
                      color: Color.fromRGBO(112, 123, 129, 1),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // 🟢 Inputs
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        LoginTextField(
                          controller: context.userProvider.emailController,
                          hintText: 'Email',
                          obscureText: false,
                        ),
                        const SizedBox(height: 10),
                        LoginTextField(
                          controller: context.userProvider.passwordController,
                          hintText: 'Password',
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        LoginButton(
                          onTap: signUserIn,
                          buttonText: 'Sign In',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // google + apple sign in buttons
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(imagePath: 'assets/images/google.png'),
                      SizedBox(width: 25),
                      SquareTile(imagePath: 'assets/images/apple.png'),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
