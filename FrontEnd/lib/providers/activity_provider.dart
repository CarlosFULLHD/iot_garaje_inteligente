import 'package:flutter/material.dart';
import 'package:smartpark/models/user_activity_model.dart';
import 'package:smartpark/services/services.dart';

class ActivityProvider with ChangeNotifier {
  final Services _services = Services();

  Future<List<UserActivityModel>> fetchUserActivity(String userId) async {
    try {
      return await _services.getUserActivity(userId);
    } catch (e) {
      print('Error en fetchUserActivity: $e');
      rethrow;
    }
  }
}
