import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

class FireStorageService extends ChangeNotifier {
  FireStorageService._();
  FireStorageService();

  static Future<dynamic> loadFromStorage(
      BuildContext context, String matchId, String image) async {
    return await FirebaseStorage.instance
        .ref()
        .child('match_images')
        .child(matchId)
        .child(image)
        .getDownloadURL();
  }
}
