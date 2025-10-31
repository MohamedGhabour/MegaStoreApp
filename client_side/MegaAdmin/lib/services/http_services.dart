import 'dart:convert';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:get/get_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/constants.dart';

class HttpService {
  final String baseUrl = MAIN_URL;

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      return {'Authorization': 'Bearer $token'};
    } else {
      return {};
    }
  }

  Future<Response> getItems({required String endpointUrl}) async {
    try {
      final headers = await _getHeaders();
      return await GetConnect().get('$baseUrl/$endpointUrl', headers: headers);
    } catch (e) {
      return Response(
          body: json.encode({'error': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> addItem(
      {required String endpointUrl, required dynamic itemData}) async {
    try {
      final headers = await _getHeaders();
      final response =
          await GetConnect().post('$baseUrl/$endpointUrl', itemData, headers: headers);
      if (kDebugMode) {
        print(response.body);
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> updateItem(
      {required String endpointUrl,
      required String itemId,
      required dynamic itemData}) async {
    try {
      final headers = await _getHeaders();
      return await GetConnect().put('$baseUrl/$endpointUrl/$itemId', itemData, headers: headers);
    } catch (e) {
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> deleteItem(
      {required String endpointUrl, required String itemId}) async {
    try {
      final headers = await _getHeaders();
      return await GetConnect().delete('$baseUrl/$endpointUrl/$itemId', headers: headers);
    } catch (e) {
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }
}
