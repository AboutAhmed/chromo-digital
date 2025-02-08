import 'package:flutter/material.dart';

class PurposeRepository {
  Future<void> updatePurposeData({
    required String purpose,
  }) async {

    debugPrint("Updating purpose data: $purpose");
  }
}
