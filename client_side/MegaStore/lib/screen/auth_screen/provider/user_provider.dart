
// ignore_for_file: unused_field

import 'dart:developer';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_shop/utility/snack_bar_helper.dart';

import '../../../core/data/data_provider.dart';
import '../../../models/user.dart';
import '../../../services/http_services.dart';
import '../../../utility/constants.dart';
import '../../../utility/functions.dart';
import '../login_screen.dart';

class UserProvider extends ChangeNotifier {
  final HttpService service = HttpService();
  final DataProvider _dataProvider;
  final box = GetStorage();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();

  UserProvider(this._dataProvider);

  // 🟢 Login
  Future<String?> login() async {
    final email = emailController.text.trim().toLowerCase();
    final pass = passwordController.text;

    final validate = _isEmailPasswordValid(email, pass);
    if (validate != null) return validate;

    try {
      final user = {'name': email, 'password': pass};
      final response =
      await service.addItem(endpointUrl: 'users/login', itemData: user);

      if (response.isOk) {
        final body = response.body;
        if (body?['success'] == true) {
          final data = body?['data'];
          final token = body?['token'];

          if (data != null) {
            final loggedUser = User.fromJson(data);
            await saveLoginInfo(loggedUser);
          }

          // لو عندك استخدام للـ token في باقي الريكوستات
          // _dataProvider.setToken(token);

          SnackBarHelper.showSuccessSnackBar(body?['message'] ?? 'Login successful!');
          log('✅ Login success');
          return null;
        } else {
          return 'Failed to login: ${body?['message'] ?? 'Unknown error'}';
        }
      } else {
        return 'Error: ${response.body?['message'] ?? response.statusText}';
      }
    } catch (e) {
      log('❌ Login error: $e');
      return 'An error occurred: $e';
    }
  }

  // 🟢 Register
  Future<String?> register() async {
    final email = emailController.text.trim().toLowerCase();
    final pass = passwordController.text;
    final pass2 = passwordController2.text;

    final validate = _isEmailPasswordValid(email, pass);
    if (validate != null) return validate;
    if (pass2.isEmpty) return 'Confirm password to proceed.';
    if (pass != pass2) return 'Passwords do not match!';

    try {
      final user = {'name': email, 'password': pass};
      final response =
      await service.addItem(endpointUrl: 'users/register', itemData: user);

      if (response.isOk) {
        final body = response.body;

        if (body?['success'] == true) {
          final data = body?['data'];
          final token = body?['token'];

          if (data != null) {
            final newUser = User.fromJson(data);
            await saveLoginInfo(newUser);
          }

          // _dataProvider.setToken(token);

          SnackBarHelper.showSuccessSnackBar(body?['message'] ?? 'Registered successfully!');
          log('✅ Register success');
          return null;
        } else {
          return 'Failed to register: ${body?['message'] ?? 'Unknown error'}';
        }
      } else {
        return 'Error: ${response.body?['message'] ?? response.statusText}';
      }
    } catch (e) {
      log('❌ Register error: $e');
      return 'An error occurred: $e';
    }
  }

  // 🟢 Save user info locally
  Future<void> saveLoginInfo(User? loginUser) async {
    await box.write(USER_INFO_BOX, loginUser?.toJson());
  }

  // 🟢 Get logged user
  User? getLoginUsr() {
    final userJson = box.read(USER_INFO_BOX);
    if (userJson == null) return null;
    return User.fromJson(Map<String, dynamic>.from(userJson));
  }

  // 🟢 Logout user
  void logOutUser() {
    box.remove(USER_INFO_BOX);
    Get.offAll(() => const LoginScreen());
  }

  // 🟢 Email/password validation
  String? _isEmailPasswordValid(String email, String password) {
    final isEmailEmpty = email.isEmpty;
    final isPasswordEmpty = password.isEmpty;
    final isValidEmail = EmailValidator.validate(email);
    final isStrongPassword = validatePassword(password);

    if (isEmailEmpty && isPasswordEmpty) {
      return 'Email and password cannot be empty!';
    } else if (isEmailEmpty) {
      return 'Email cannot be empty!';
    } else if (isPasswordEmpty) {
      return 'Password cannot be empty!';
    } else if (!isValidEmail) {
      return 'Email is not valid!';
    } else if (!isStrongPassword) {
      return 'Please use a stronger password!';
    }

    return null;
  }
}
