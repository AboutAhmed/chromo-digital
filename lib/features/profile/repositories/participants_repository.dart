import 'package:flutter/material.dart';

class ParticipantRepository {
  Future<void> updateParticipantData({
    required String nameAndCompany,
  }) async {

    debugPrint("Updating participant data: $nameAndCompany");
  }
}
