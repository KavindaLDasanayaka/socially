import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class UserStorage {
  // Upload image to Cloudinary
  Future<String?> uploadImageToCloudinary(File imageFile) async {
    const cloudName = 'dd6afzaus';
    const uploadPreset = 'profile-pictures';
    const uploadUrl = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

    final request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final jsonResponse = json.decode(resStr);
      return jsonResponse['secure_url'] as String;
    }
  }
}
