

import 'package:flutter/material.dart';

class RestaurantRepository {
  Future<void> updateRestaurantData({
    required String name,
    required String street,
    required String houseNo,
    required String postId,
    required String city,
  }) async {

    debugPrint("Updating restaurant data: $name, $street, $houseNo, $postId, $city");
  }
}
