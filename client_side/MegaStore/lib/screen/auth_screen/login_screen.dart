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
                  const SizedBox(height: 45),
                  // العنوان الرئيسي
                  Image.asset(
                    'assets/images/LOGO2.png',
                    width: 250, // ممكن تعدل الحجم حسب الحاجة
                    height: 150,
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Welcome Back You’ve Been Missed!',
                    style: TextStyle(
                      color: Color.fromRGBO(112, 123, 129, 1),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

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
                        LoginButton(onTap: signUserIn, buttonText: 'Sign In'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

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

                  const SizedBox(height: 35),

                  // google + apple sign in buttons
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(imagePath: 'assets/images/google.png'),
                      SizedBox(width: 25),
                      SquareTile(imagePath: 'assets/images/apple.png'),
                    ],
                  ),

                  const SizedBox(height: 35),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(4),
                        splashColor: Colors.blue.withOpacity(0.2),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 2,
                          ),
                          child: Text(
                            'Register now',
                            style: TextStyle(
                              color: Color(0xFF1976D2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
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
