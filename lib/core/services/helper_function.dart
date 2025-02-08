import 'dart:math';

class HelperFunction {
  static String generateString({
    int min = 10,
    int? max,
  }) {
    if (max == null || max < min) {
      max = min + 10;
    }
    Random random = Random();

    final length = min + random.nextInt(max - min + 1);
    final charCodes = List<int>.generate(length, (_) => 97 + random.nextInt(26));
    return String.fromCharCodes(charCodes);
  }

  static String generatePassword({
    String? firstName,
    String? lastName,
    String? email,
  }) {
    final random = Random();
    const specialChars = ['@', '#', '\$', '&', '*'];
    const digits = '0123456789';
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    String randomChar(List<String> list) => list[random.nextInt(list.length)];
    String randomDigit() => digits[random.nextInt(digits.length)];
    String randomCharFromChars() => chars[random.nextInt(chars.length)];

    // Create password based on input
    if (firstName != null && lastName != null) {
      final part1 = '${firstName[0].toUpperCase()}${firstName.substring(1, 2).toLowerCase()}';
      final part2 = '${randomChar(specialChars)}${lastName[0].toLowerCase()}${lastName.substring(1, 2).toUpperCase()}';
      final randomSuffix = List.generate(8 - part1.length - part2.length, (_) => randomCharFromChars()).join();
      return '$part1$part2$randomSuffix${randomDigit()}'; // Add a random digit at the end
    } else if (email != null) {
      final username = email.split('@').first;
      final part1 = '${username[0].toUpperCase()}${username.substring(1, min(3, username.length)).toLowerCase()}';
      final part2 = '${randomChar(specialChars)}${username[username.length - 1].toUpperCase()}';
      final randomSuffix = List.generate(8 - part1.length - part2.length, (_) => randomCharFromChars()).join();
      return '$part1$part2$randomSuffix${randomDigit()}'; // Add a random digit at the end
    }

    // Generate a random password if no input
    final passwordLength = 8 + random.nextInt(5); // Length between 8 and 12
    return List.generate(passwordLength, (_) => randomCharFromChars()).join() + randomDigit(); // Add a random digit at the end
  }

// static Future<BitmapDescriptor> getNetworkMarker(String url) async {
//   try {
//     // Create Dio instance
//     Dio dio = sl<APIClient>().baseDio();
//
//     // Download the image using Dio
//     final Response<Uint8List> response = await dio.get<Uint8List>(
//       url,
//       options: Options(responseType: ResponseType.bytes), // Ensure response is in bytes
//     );
//
//     if (response.statusCode == 200) {
//       // Convert the image to BitmapDescriptor
//       return BitmapDescriptor.bytes(response.data!, width: 47.0, height: 47.0);
//     } else {
//       // Return default marker if status code is not 200
//       return BitmapDescriptor.defaultMarker;
//     }
//   } catch (e) {
//     // Return default marker in case of any error
//     return BitmapDescriptor.defaultMarker;
//   }
// }
}
