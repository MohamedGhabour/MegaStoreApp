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

    final result = await context.userProvider.register();

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
      backgroundColor: const Color(0xFFF8F9FA), // لون قريب من Figma
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),

                  // logo
                  Image.asset(
                    'assets/images/LOGO2.png',
                    width: 250, // ممكن تعدل الحجم حسب الحاجة
                    height: 150,
                  ),

                  const SizedBox(height: 20),

                  // welcome message
                  const Text(
                    'Let\'s Join Mega Family!',
                    style: TextStyle(
                      color: Color(0xFF707B81),
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // email textfield
                  SizedBox(
                    height: 70,
                    child: LoginTextField(
                      controller: context.userProvider.emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // password textfield
                  SizedBox(
                    height: 70,
                    child: LoginTextField(
                      controller: context.userProvider.passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // confirm password textfield
                  SizedBox(
                    height: 70,
                    child: LoginTextField(
                      controller: context.userProvider.passwordController2,
                      hintText: 'Confirm Password',
                      obscureText: true,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // sign up button
                  SizedBox(
                    width: double.infinity,
                    height: 65,
                    child: LoginButton(
                      onTap: signUserUp,
                      buttonText: 'Sign Up',
                    ),
                  ),


                  const SizedBox(height: 60),

                  // already have an account? login now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Color(0xFF707B81),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(4),
                        splashColor: Colors.blue.withOpacity(0.2),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                          child: Text(
                            'Login now',
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
